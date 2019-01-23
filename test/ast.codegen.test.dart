import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:test/test.dart';

import 'package:astMacro/src/ast.codegen.dart';
import 'package:astMacro/src/ast.utils.dart';
import 'package:common/src/common.dart';

typedef TVoid = void Function();

/*import 'package:analyzer/dart/ast/ast_factory.dart';
import 'package:analyzer/dart/ast/standard_ast_factory.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'package:colorize/colorize.dart'           show color, Colorize, Styles;
import 'package:front_end/src/scanner/token.dart' show KeywordToken, SimpleToken, StringToken;
import 'package:path/path.dart'                   show join, dirname;
import 'package:quiver/collection.dart'           show DelegatingMap;
*/


Iterable<ClassDeclarationImpl>
getClasses(CompilationUnitImpl node) {
   return node.declarations.where((d) => d is ClassDeclarationImpl).whereType();
}

Iterable<T>
getClassMembers<T extends ClassMember>(ClassDeclarationImpl node) {
   return node.members.where((member) => member is T).whereType();
}


class TempIdent {
   final String id;
   
   TempIdent(this.id);
   
   String toString() {
      return id;
   }
}


main() {
   group('general ast generating tests - int, string, list, map, propertyAccess', () {
      test('astIdent', () {
         var res = astIdent('ArbiraryIdentity');
         print(dumpAst(res));
         expect(res.name, equals('ArbiraryIdentity'));
      });
      
      test('astInt', () {
         var res = astInt(13);
         print(dumpAst(res));
         expect(res.value, equals(13));
      });
      
      test('astString', () {
         var res = astString('helloWorld');
         print(dumpAst(res));
         expect(res.toString(), equals("'helloWorld'"));
      });
      
      test('astDouble', () {
         var res = astDouble(13.371);
         print(dumpAst(res));
         expect(res.value, equals(13.371));
      });
      
      test('creating astList via non-ast elements as a uniform String typed list', () {
         var res = astList(['hello', 'world']);
         print(dumpAst(res));
         expect(
            res.elements.map((e) => e.toString()).toList(),
            equals(["'hello'", "'world'"])
         );
         expect(
            res.typeArguments.arguments.map((a) => a.toString()).toList(),
            equals([STRING]),
            reason: 'expect an untyped String List inferred to be List<String>'
         );
      });
      
      test('creating astList via non-ast elements as a dynamic list', () {
         var res = astList(['hello', 'world', TempIdent('TestCaseClass'), 123, 12.3]);
         print(dumpAst(res));
         expect(
            res.elements.map((e) => e.toString()).toList(),
            equals(["'hello'", "'world'", 'TestCaseClass', '123', '12.3'])
         );
         expect(
            res.typeArguments.arguments.map((a) => a.toString()).toList(),
            equals([DYNAMIC]),
            reason: 'expect an untyped dynamic list inferred to be List<dynamic>'
         );
         expect(res.toSource(), equals("<dynamic> ['hello', 'world', TestCaseClass, 123, 12.3]"));
      });
      
      test('creating astMap via non-ast elements which impliclit declared as untyped Map, '
         'and expect to be inferred into an uniform typed Map as Map<String, int>', () {
         var res = astMap({'hello': 0, 'world': 3});
         print(dumpAst(res));
         expect(
            res.entries.map((MapLiteralEntry e) => [e.key.toString(), e.value.toString()]).toList(),
            equals([
               ["'hello'", '0'], ["'world'", '3']
            ])
         );
         expect(
            res.typeArguments.arguments.map((a) => a.toString()).toList(),
            equals(['String', 'int']),
            reason: 'expect an untyped Map inferred to be Map<String, int>'
         );
         expect(res.toSource(), equals("<String, int> {'hello' : 0, 'world' : 3}"));
      });
      
      test('creating astMap via non-ast elements which impliclit declared as untyped Map, '
         'and expect to be inferred into an uniform typed Map as MapS<tring, dynamic>', () {
         var res = astMap({'hello': 0, 'world': 12.45});
         print(dumpAst(res));
         print(res);
         
         expect(
            res.entries.map((MapLiteralEntry e) => [e.key.toString(), e.value.toString()]).toList(),
            equals([
               ["'hello'", '0'], ["'world'", '12.45']
            ])
         );
         expect(
            res.typeArguments.arguments.map((a) => a.toString()).toList(),
            equals(['String', 'dynamic']),
            reason: 'expect an untyped Map inferred to be Map<String, dynamic>'
         );
         expect(res.toSource(), equals("<String, dynamic> {'hello' : 0, 'world' : 12.45}"));
      });
      
      test('property access expression', () {
         var res = astPropAccs('this.obj.name'.split('.'));
         print(dumpAst(res));
         expect(res.toSource(), equals('this.obj.name'));
      });

      test('prefix identifier expression', () {
         var res = astPropAccs('TestCase.obj.name'.split('.'));
         print(dumpAst(res));
         expect(res.toSource(), equals('TestCase.obj.name'));
      });
      
      test('TType for generating common used type definitions - namedType', (){
         var type = TType(name:'List', namedType_params: ['String']).named_type;
         expect(type.toSource(), equals('List<String>'));
      });
      
      test('Invalid usage of TType for generating common used type definitions - namedType', (){
         expect((){
            TType(name:'List', namedType_params: ['String'], func_name: 'funcname');
         }, throwsException );
      });

      test('TType for generating common used type definitions - genericType', (){
         var func_retType = TType.namedType(name: 'void');
         var list       = [
            TArg(arg_typ: TType(name:'T'), arg_name: 'name'),
            TArg(arg_typ: TType(name:'int'), arg_name: 'id')
         ];
         var arguments    = TArgList(list);
         var tuple_list  =  <Tuple<String,String>>[Tuple ('T')] ;
         var type = TType.genericFuncType(
            funcType_params: tuple_list , //func_name: 'Function',
            arguments:  arguments, func_retType: func_retType
         ).generic_functype;
         expect(type.toSource(), equals('void Function<T>(T name, int id)'));
         
         var type2 = astType(
            funcType_params: tuple_list , //func_name: 'Function',
            arguments:  arguments, func_retType: func_retType
         );
         expect(type2.toSource(), equals('void Function<T>(T name, int id)'));
         
      });

      test('TType for generating common used type definitions - inlineParamFunc', (){
         var func_retType = TType.namedType(name: 'bool');
         var list       = [
            TArg(arg_typ: TType(name:'T'), arg_name: 'name'),
            TArg(arg_typ: TType(name:'int'), arg_name: 'id')
         ];
         var arguments    = TArgList(list);
         var tuple_list  = <Tuple<String,String>>[Tuple('T')];
         var type = TType.paramType(
            func_name: 'condition', funcType_params: tuple_list,
            arguments:  arguments, func_retType: func_retType
         ).param_functype;
         expect(type.toSource(), equals('bool condition<T>(T name, int id)'));
         var type2 = astType(
            func_name: 'condition', funcType_params: tuple_list,
            arguments:  arguments, func_retType: func_retType
         );
         expect(type2.toSource(), equals('bool condition<T>(T name, int id)'));
      });
      
      test('generating VariableDeclaration', (){
         var decl = astVarDecl('var_name', value: 13);
         expect(decl.toSource(), equals('var_name = 13'));
      });
      
      test('generating VariableDeclarationListA', (){
         var typ = TType(name: 'int');
         var decl_list = astVarDeclList(['FinalA', 'FinalB'], keyword: 'final', values:[1, 2], type:typ);
         expect(decl_list.toSource(), equals('final int FinalA = 1, FinalB = 2'));
      });

      test('generating VariableDeclarationListB', (){
         var typ = TType(name: 'int');
         var decl_list = astVarDeclList( ['FinalA', 'FinalB'],  type:typ);
         expect(decl_list.toSource(), equals('int FinalA, FinalB'));
      });
      
      test('generating functions with positional arguments-A', (){
         var expected_source = "bool Function(String a, [int b, int c])";
         var node = astTypeFunc(
            func_name:'Function', func_retType: TType(name:'bool'),
            arguments: TArgList([
               TArg(arg_name: 'a', arg_typ: TType(name:'String')),
               TArg(arg_name: 'b', arg_typ: TType(name:'int'), position_optional: true),
               TArg(arg_name: 'c', arg_typ: TType(name:'int'), position_optional: true)
            ])
         );
         expect(node.toSource(), equals(expected_source));
      });
      
      test('generating functions with positional arguments-B', (){
         var expected_source = "bool Function(String a, {int b, int c})";
         var node = astTypeFunc(
            func_name:'Function', func_retType: TType(name:'bool'),
            arguments: TArgList([
               TArg(arg_name: 'a', arg_typ: TType(name:'String')),
               TArg(arg_name: 'b', arg_typ: TType(name:'int'), named_optional: true),
               TArg(arg_name: 'c', arg_typ: TType(name:'int'), position_optional: true)
            ])
         );
         expect(node.toSource(), equals(expected_source));
      });
      test('generating functions with positional arguments-C', (){
         var expected_source = """E hybriArgMethod(String name, {Map<String> setting = DSETTING})""";
         var node = astTypeFunc(
            func_name: 'hybriArgMethod', func_retType: TType(name:'E'),
            arguments: TArgList([
               TArg(arg_name: 'name', arg_typ: TType(name:'String')),
               TArg(arg_name: 'setting', arg_typ: TType(name:'Map',
                    namedType_params: ['String']), named_optional: true,
                    arg_value: astIdent('DSETTING'))
            ])
         );
         print(dumpAst(node));
         expect(node.toSource(), equals(expected_source));
      });
      
      test('generating class method', (){
         var expected_source = """static E hybriArgMethod(String name, {Map<String> setting = DSETTING}) {return null;}""";
         var result = MethodGen()
            ..addName('hybriArgMethod')
            ..addRetType(TType(name: 'E'))
            ..addArguments(TArgList([
                  TArg(arg_name: 'name', arg_typ: TType(name:'String')),
                  TArg(arg_name: 'setting', arg_typ: TType(
                        name: 'Map', namedType_params: ['String']),
                        arg_value: astIdent('DSETTING'), named_optional: true
                  )
               ]))
            ..addKeywords(['static'])
            ..addStatement([
                  astReturnStatement( astIdent('null') )
               ])
            ..result;
         expect(result.toString(), equals(expected_source));
      });
      
      test ('generating class', (){
         //fixme:...
         var expected_source = """class ABC<E extends AstNodeImpl> extends Printable<E> with ClassKeyword<E>, _Generatable<E> implements BaseCodegen<FieldDeclarationImpl> {}""";
         var result = ClassGen()
            ..addName("ABC")
            ..addTypeParam(['E'], ['AstNodeImpl'])
            ..addClauses(
               extends_clause: TType(name: 'Printable', namedType_params: ['E']),
               mixin_names: [TType(name: 'ClassKeyword', namedType_params: ['E']), TType(name: '_Generatable', namedType_params: ['E'])],
               implements_clause: [TType(name: 'BaseCodegen', namedType_params: ['FieldDeclarationImpl'])]
            )
            ..result;
         expect(expected_source, equals(result.toString()));
      });
   });

   var sources = r'''
      class Temp<E> {
         static var                            no_type_speicified_static_field;
         static String                         pure_static_field;
         static List<String>                   static_fields_with_default_value     = ['s_hello'];
         static void Function<E>(String a)     static_pure_fn_fields;
         static bool Function(String a, int b) static_fn_fields_with_default_value  = (a, b) => false;
         static bool Function(String a, int b) static_fn_fields_with_default_valueB = (a, b) { return false; };
         static TVoid                          static_pure_typedef_fields;
         
         var                            no_type_speicified_field;
         List<E>                        pure_generic_fieldB;
         E                              pure_generic_field;
         E                              generic_field_with_typecasted_value = '13' as E;
         String                         pure_field;
         String                         fields_with_default_value = 'hello';
         bool Function(String a, {int b}) pure_fn_fields;
         bool Function(String a, [int b]) fn_fields_with_default_value = (a, [b]) => false;
         TVoid                          pure_typedef_fields;
         
         TestForMethods({this.refname, this.refid});
         void pureDefinition(String name);
         void pureDefinitionWithArgs(String name, [int a, int b]);
         void noArgMethod() {
            refid += 1;
            return null;
         }
         Map<String, String>
         noArgWithReturnType() {
            num a = 10;
            num b = 10.1;
            int c = 10;
            double d = 10.12;
            var ternary_assignemnt = (a == 10) && b == 10.1
                  ? 'hello'
                  : 'world';
            hybriArgMethod('hello', setting: {'a': 1});
         }
         E hybriArgMethod(String name,{Map<String> setting = DSETTING}) {
            return null;
         }
         List<E> namedArgsMethod({bool condition(a), void Function(a) name}) {
            return [this.refname, TestForMethods.temp.ok, this.obj.main, TestForMethods.obj];
         }
         listOptionalArgsMethodWithNoReturnType<T>([T name]) {
            return this.refid;
         }
         get getterMethodWithoutReturnType{
            return '$refid $refname';
         }
         String
         get getterMethodWithReturnType{
            return refname;
         }
         String
         get getterSetter{
            return null;
         }
         set getterSetter(String v){
            return null;
         }
         /*
                           S t a t i c
                     */
         
         static void pureDefinitionStatic;
         static void noArgMethodStatic() {
            return null;
         }
         static Map<String, String>
         noArgWithReturnTypeStatic() {
            return null;
         }
         static hybriArgMethodStatic(String name,{Map setting}) {
            return null;
         }
         static List namedArgsMethodStatic({Map setting, String name}) {
            return null;
         }
         static listOptionalArgsMethodWithNoReturnTypeStatic([String name]) {
            return null;
         }
         static get getterMethodWithoutReturnTypeStatic{
            return null;
         }
         static String
         get getterMethodWithReturnTypeStatic{
            return null;
         }
         static String
         get getterSetterStatic{
            return null;
         }
         static set getterSetterStatic(String v){
            return null;
         }
      }
   ''';
   var AST = parseCompilationUnit(sources);
   var members = (AST.declarations.first as ClassDeclarationImpl).members;
   group('generating ast of class methods', (){
      test('general method', (){
         var expected_source = 'E hybriArgMethod(String name, {Map<String> setting = DSETTING}) {return null;}';
         var ret_type = TType(name:'E');
         var name = 'hybriArgMethod';
         var type_params = null;
         var arguments = TArgList([
            TArg(arg_name:'name', arg_typ:TType(name:'String')),
            TArg(
               arg_name:'setting', arg_typ: TType(name: 'Map', namedType_params: ['String']),
               arg_value: astIdent('DSETTING'), named_optional: true
            )
         ]);
         var statements = [
           astReturnStatement( astIdent('null') )
         ];
         var metadata      = null;
         var keywords      = <String>[];
         var result        = astMethodFunc(
            ret_type, name, type_params, arguments,
            statements : statements ,  keywords: keywords
            , metadata     : metadata
         );
         
         expect(result.toSource(), expected_source);
      });

      test('getter method', (){
         var expected_source = 'E get hybriArgMethod {return null;}';
         var ret_type = TType(name:'E');
         var name = 'hybriArgMethod';
         var type_params = null;
         var arguments = null;
         var statements = [
            astReturnStatement( astIdent('null') )
         ];
         var keywords      = <String>[];
         var metadata      = null;
         var result        = astMethodFunc_GetDecl(
            ret_type, name, type_params, arguments,
            statements : statements ,keywords: keywords,
            metadata   : metadata
         );
         
         expect(result.toSource(), expected_source);
      });

      test('static getter method', (){
         var expected_source = 'static E get hybriArgMethod {return null;}';
         var ret_type = TType(name:'E');
         var name = 'hybriArgMethod';
         var type_params = null;
         var arguments = null;
         var statements = [
            astReturnStatement( astIdent('null') )
         ];
         var keywords      = ['static'];
         var metadata      = null;
         var result        = astMethodFunc_GetDecl(
            ret_type, name, type_params, arguments,
            statements : statements ,keywords: keywords,
             metadata  : metadata
         );
         expect(result.toSource(), expected_source);
      });
      
      test('generating method by using MethodGenerator', (){
      
      });
   });
   group('generating ast of class fields', () {
      print(dumpAst(AST));
      test('generating generic_field_with_typecasted_value;', () {
         var expected_source = "E generic_field_with_typecasted_value = '13' as E;";
         var is_async = false, is_yieldable = false;
         var field = FieldGen()
            ..addNames(['generic_field_with_typecasted_value'])
            ..addType(TType(name: 'E'))
            ..addDefault(astAsExp(astElement('13'), 'E'))
            ..result;
         expect(field.toString(), equals(expected_source));
      });
      
      test('generating static_fn_fields_with_default_valueB;', () {
         var expected_source = "static bool Function(String a, int b) static_fn_fields_with_default_valueB = (a, b) {return false;};";
         var is_async = false, is_yieldable = false;
         var arguments = TArgList([
            TArg(arg_name: 'a', arg_typ:TType(name:'String')),
            TArg(arg_name: 'b', arg_typ:TType(name:'int')),
         ]);
   
         var argumentsB = TArgList([
            TArg(arg_name: 'a' ),
            TArg(arg_name: 'b' ),
         ]);
         var default_value = astClosureFunc(
            argumentsB, null,
            is_async: is_async, is_yieldable: is_yieldable,
            is_terminated: false, statements: [
               States.Return( astBool(false) )
            ]
         );
         var field = FieldGen()
            ..addNames(['static_fn_fields_with_default_valueB'])
            ..addKeywords(['static'])
            ..addType(
               TType(
                  func_name      :'Function',
                  func_retType   : TType(name:'bool'),
                  arguments      : arguments
               ))
            ..addDefault(default_value)
            ..result;
         expect(field.toString(), equals(expected_source));
      });
      
      test('generating static_fn_fields_with_default_value;', () {
         var expected_source = "static bool Function(String a, int b) static_fn_fields_with_default_value = (a, b) => false;";
         var is_async = false, is_yieldable = false;
         var arguments = TArgList([
            TArg(arg_name: 'a', arg_typ:TType(name:'String')),
            TArg(arg_name: 'b', arg_typ:TType(name:'int')),
         ]);
         
         var argumentsB = TArgList([
            TArg(arg_name: 'a' ),
            TArg(arg_name: 'b' ),
         ]);
         var default_value = astExpFunc(
            argumentsB, null,
            is_async: is_async, is_yieldable: is_yieldable,
            single_exp: astBool(false), is_terminated: false
         );
         var field = FieldGen()
            ..addNames(['static_fn_fields_with_default_value'])
            ..addKeywords(['static'])
            ..addType(
               TType(
                  func_name      :'Function',
                  func_retType   : TType(name:'bool'),
                  arguments      : arguments
               ))
            ..addDefault(default_value)
            ..result;
         expect(field.toString(), equals(expected_source));
      });
      
      test('generating static_pure_fn_fields;', () {
         var expected_source = "static void Function<E>(String a) static_pure_fn_fields;";
         List<Tuple<String, String>> tuple_list = [Tuple('E')];
         var field = FieldGen()
            ..addNames(['static_pure_fn_fields'])
            ..addKeywords(['static'])
            ..addType(
               TType(
                  func_name      :'Function',
                  func_retType   : TType(name:'void'),
                  funcType_params: tuple_list,
                  arguments      : TArgList([TArg(arg_name:'a', arg_typ: TType(name:'String'))])
               ))
            ..result;
         expect(field.toString(), equals(expected_source));
      });
      
      test('generating no_type_speicified_static_field;', () {
         var expected_source = 'static var no_type_speicified_static_field;';
         var field = FieldGen()
            ..addNames(['no_type_speicified_static_field'])
            ..addKeywords(['static', 'var'])
            ..result;
         expect(field.toString(), equals(expected_source));
      });

      test('generating pure_static_field;', () {
         var expected_source = 'static String pure_static_field;';
         var field = FieldGen()
            ..addNames(['pure_static_field'])
            ..addType(TType(name:'String'))
            ..addKeywords(['static'])
            ..result;
         expect(field.toString(), equals(expected_source));
      });

      test('generating static_fields_with_default_value;', () {
         var expected_source = "static List<String> static_fields_with_default_value = <String> ['s_hello'];";
         var field = FieldGen()
            ..addNames(['static_fields_with_default_value'])
            ..addKeywords(['static'])
            ..addType(TType(name:'List', namedType_params: ['String']))
            ..addDefault(['s_hello'])
            ..result;
         expect(field.toString(), equals(expected_source));
      });
   });
}






















