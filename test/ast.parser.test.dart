
import 'dart:io';

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:astMacro/src/ast.parsers.dart';
import 'package:astMacro/src/ast.transformers.dart';
import 'package:astMacro/src/ast.utils.dart';
import 'package:common/src/common.dart' as _;
import 'package:test/test.dart';
import 'package:IO/src/io.dart' as io;


typedef TVoid = void Function();

CompilationUnit compile(String s) {
   var ast = parseCompilationUnit(s, parseFunctionBodies: true);
   ast.visitChildren(Visitor());
   return ast;
}

Iterable<ClassDeclarationImpl>
getClasses(CompilationUnitImpl node) {
   return node.declarations.where((d) => d is ClassDeclarationImpl).whereType();
}

Iterable<T>
getClassMembers<T extends ClassMember>(ClassDeclarationImpl node) {
   return node.members.where((member) => member is T).whereType();
}

TestCase_astParserFileParserTest(){
   var file_path = io.Path.join( io.getScriptPath(Platform.script) , 'sampleCode.dart');
   print('file_path: $file_path');
   var file_string = File(file_path).readAsStringSync();
   var code = parseCompilationUnit(file_string);
   var file_parser = DartFileParser(code: code, uri: Uri.file(file_path));
   var import_parsers = file_parser.imp_divs;

   group("Test ImportParser", (){
      const
         P1 = 'package:colorize/colorize.dart',
         P2 = 'dart:io',
         P3 = 'package:js/js.dart';
      const
         F1 = 'C:\\Users\\gordianknot\\AppData\\Roaming\\Pub\\Cache\\hosted\\pub.dartlang.org\\colorize-2.0.0\\lib\\colorize.dart',
         F2 = 'C:\\Users\\gordianknot\\AppData\\Roaming\\Pub\\Cache\\hosted\\pub.dartlang.org\\io-0.3.3\\lib\\io.dart',
         F3 = 'C:\\Users\\gordianknot\\AppData\\Roaming\\Pub\\Cache\\hosted\\pub.dartlang.org\\js-0.6.1+1\\lib\\js.dart';
      
      
      test('check import string literal path', (){
         expect(import_parsers[0].path, P1);
         expect(import_parsers[1].path, P2);
         expect(import_parsers[2].path, P3);
      });
   
      test('check parsing real path from import clause', (){
         var file1 = import_parsers[0].getImportFile(P1);
         expect(file1.path, F1);
      
         var file2 = import_parsers[1].getImportFile(P2);
         expect(file2, null);
      
         var file3 = import_parsers[2].getImportFile(P3);
         expect(file3.path, F3);
      });
   
      test('check path', (){
         expect(import_parsers[0].path, P1);
         expect(import_parsers[1].path, P2);
         expect(import_parsers[2].path, P3);
      });
   
      test('check source_file', (){
         expect(import_parsers[0].source_file.path, F1);
         expect(import_parsers[1].source_file     , null);
         expect(import_parsers[2].source_file.path, F3);
      });
   
      test('check members in show clause', (){
         expect(import_parsers[0].shows.map((s) => s.name),
            ['color', 'Colorize', 'Styles']);
      });
   
      test('check member in as clause', (){
         expect(import_parsers[3].decl_as.name, '_');
      });
   
      test('get file content of colorize from importParser', (){
         var c = import_parsers[0].content;
         var expected = _.ignoreWhiteSpace("""
            library colorize;
            
            part "src/styles.dart";
            part "src/colorize.dart";
            part "src/color.dart";
            """);
         print(c);
         expect(_.ignoreWhiteSpace(c), expected);
      });

      test('preFilterReference in colorize import clause', (){
         var tobe_sought = import_parsers[0].preFilterReferece(['Vue.hello', 'world', 'color']).toList();
         expect(tobe_sought, ['color']);
   
         tobe_sought = import_parsers[3].preFilterReferece(['Vue.hello', '_.world']);
         expect(tobe_sought, ['_.world']);
      });
   });
   
   group("Test ClassDeclParser for super fetching", (){
      var cls  = file_parser.cls_decls.firstWhere((cls) => cls.name.name == 'PropertiesDefinition');
      var cls2 = file_parser.cls_decls.firstWhere((cls) => cls.name.name == 'OriginalComponentA');
      var cls3 = file_parser.cls_decls.firstWhere((cls) => cls.name.name == 'ClsExtendFromImport');
      var cls4 = file_parser.cls_decls.firstWhere((cls) => cls.name.name == 'ClsExtendFromDeclAs');
      test("validate super_names", (){
         expect(cls.super_names, ['IPropertiesDefinition' ,'PropertyValidation']);
         expect(cls2.super_names, ['VueApp' ,'IVue']);
         expect(cls3.super_names, ['Colorize' ,'SampleApp']);
         expect(cls4.super_names, ['_.FN' ,'SampleApp']);
      });

      test('fetching super classes extends within file', (){
         var super_names = <String>[]..addAll(cls.super_names);
         var super_cls = ClassifiedDeclParser.getSupersDefinedInFile
            (cls.file, super_names).map((cls) => cls.name.name).toList();
         expect(super_cls, ['IPropertiesDefinition' ,'PropertyValidation']);
         
         super_names = <String>[]..addAll(cls2.super_names);
         var super_cls2 = ClassifiedDeclParser.getSupersDefinedInFile
            (cls2.file, super_names).map((cls) => cls.name.name).toList();
         expect(super_cls2, ['VueApp' ,'IVue']);
         
      });
      
      test('A - fetching super classes extends either within file or external import', (){
         var super_names = <String>[]..addAll(cls3.super_names);
         var super_cls = ClassifiedDeclParser.getSupersDefinedInFile
            (cls.file, super_names).map((cls) => cls.name.name).toList();
         
         expect(super_cls, ['SampleApp']);
      });

      test('B - fetching super classes extends either within file or external import', (){
         var super_cls = ClassifiedDeclParser.getSupersDefinedWithinImports
            (cls.file, ['Colorize']).map((cls) => cls.name.name).toList();
         
         expect(super_cls, ['Colorize']);
      });
      
      test('C - fetching super classes extends either within file or external import', (){
         var super_cls = cls3.supers.map((cls) => cls.name.name).toList();
         expect(super_cls, unorderedEquals(['Colorize', 'SampleApp']));
      });
      
      test('fetching root classes', (){
         var root_cls = cls2.roots.map((cls) => cls.name.name).toList();
         expect(root_cls, ['VueApp', 'Empty']);
      });
      
      test('get supers from class which inherited from import as clause', (){
         var super_cls = cls4.supers.map((cls) => cls.name.name).toList();
         expect(super_cls, ['SampleApp', 'FN']);
      });
   });
   
}

TestCase_astParserTest() {
   var CODE       = r'''
      abstract class TestForMethods<E extends String> {
         static var                             no_type_speicified_static_field;
         static String                          pure_static_field;
         static List<String>                    static_fields_with_default_value = ['s_hello'];
         static bool Function(String a, int b)  static_pure_fn_fields;
         static bool Function(String a, int b)  static_fn_fields_with_default_value = (a, b) => false;
         static TVoid                           static_pure_typedef_fields;
         
         var                            no_type_speicified_field;
         List<E>                        pure_generic_fieldB;
         E                              pure_generic_field;
         E                              generic_field_with_value = '13' as E;
         String                         pure_field;
         String                         fields_with_default_value = 'hello';
         bool Function(String a, int b) pure_fn_fields;
         bool Function(String a, int b) fn_fields_with_default_value = (a, b) => false;
         TVoid                          pure_typedef_fields;
         
         static var temp;
         String   refname;
         Object   obj;
         int      refid;
         Object   iforyou;
         
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
            hybriArgMethod('hello', setting: {'a': 1});
         }
         E hybriArgMethod(String name,{Map<String> setting = DSETTING}) {
            return null;
         }
         List<E> namedArgsMethod({bool condition(a), void Function(a) name}) {
            return [
               this.refname,
               TestForMethods.temp.ok,
               this.obj.main,
               this.hybriArgMethod,
               refid,
               prefix.com,
               this.listOptionalArgsMethodWithNoReturnType(this.refname + pure_field + fnCall())
            ];
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
         
         refParsingTest(){
            if (syn is AssignmentExpressionImpl){
               assignments.add(Refs(context: context, ref: syn));
            }
            num a = 10;
            num b = 10.1;
            refid += 1;
            var operator, best;
            var a = Object();
            Object another;
            best     = this.iforyou;
            another  = this.iforyou.youforme;
            this.iforyou.youforme += 'Hello World';
            best['assign'] = operator.op_assign;
            best['prop_assign'] = operator.prop_assign['hello'];
            overrides.add(syn.declaredElement.name, a.b.c + some, this.best);
            this.listOptionalArgsMethodWithNoReturnType(this.refname + pure_field + fnCall());
            return this.refid;
            return best = this.iforyou + someCall(in_call, in_call.subA, in_call.subA.subAB);
         }
      }
      ''';
   var AST        = parseCompilationUnit(CODE, parseFunctionBodies: true);
   var cls_decls  = AST.declarations.where((d) => d is ClassDeclarationImpl);
   var cls        = cls_decls.first as ClassDeclarationImpl;
   var cls_parser = ClassDeclParser(cls);
   var fields     = cls_parser.fields;
   
   group("Learning ast of class methods", () {
      print(dumpAst(AST));
      void testMethod({String name, bool publicv, bool staticv, bool getterv, bool setterv, String ret_type,
                       List type_params, List body_refs, List params, List default_params, List ret_type_args,
                       List ref_methods, List ref_fields}) {
         var method_targets = cls_parser.getMethod(name);
         var method_first   = method_targets.first;
         var _body_refs     = method_first.refs_in_body?.map((ref) => ref.refs?.map((r) => r.name)?.toList())?.toList();
         var _ret_type_args = method_first.ret_type?.namedType?.typeargs?.arguments?.map((a) => (a as TypeNameImpl).name.name);
         var _type_params   = method_first.type_params?.typeParameters?.map((t) => t.name.name);
         var _ret_type      = method_first.ret_type?.namedType?.typename?.name;
         //---------------------------------
         
         void _test() {
            expect(method_first.name.name, equals(name         ), reason: 'name expect to be $name');
            expect(method_first.is_public, equals(publicv      ), reason: 'method expect to be public:$publicv');
            expect(method_first.is_static, equals(staticv      ), reason: 'method expect to be static:$publicv');
            expect(method_first.is_getter, equals(getterv      ), reason: 'method expect to be getter:$getterv');
            expect(method_first.is_setter, equals(setterv      ), reason: 'method expect to be setter:$setterv');
            expect(_ret_type       , equals(ret_type     ), reason: 'return type expect to be $ret_type');
            expect(_ret_type_args  , equals(ret_type_args), reason: 'return type arguments expect to be $ret_type_args');
            expect(_type_params    , equals(type_params  ), reason: 'type parameters expect to be $type_params');
            expect(_body_refs      , equals(body_refs    ), reason: 'references expect to be $body_refs');
            
            //note: check params
            expect(method_first.params.params?.params?.map(
               (s) => [
                  s.named_type?.name?.name,
                  s.name?.name,
                  s.func_type?.toString(),
                  s.defaults?.toString(),
                  s.is_thisRef]
            )?.toList(),
               equals(params),
               reason: 'params expect to be $params'
            );
            
            //note: check default params
            expect(method_first.params.params?.default_params?.map(
               (s) => [
                  s.named_type?.name?.name, s.name?.name,
                  s.func_type == null ? null : '${s.func_type.retType?.name?.name} ${s.func_type.ident?.name}${s.func_type.arguments}',
                  s.defaults?.toString(), s.is_thisRef
               ]
            )?.toList(),
               equals(default_params),
               reason: 'default params expect to be $default_params'
            );
            
            if (ref_methods != null){
               var methods = method_first.getReferencedClassMethods().map((m) => m.name.name).toList();
               expect(
                  methods,
                  unorderedEquals(ref_methods),
                  reason: 'referencedClassMethods expect to be: $ref_methods'
               );
            }
            if (ref_fields != null){
               var fields = method_first.getReferencedClassFields().fold(<String>[], (initial, f) => initial + f.names);
               expect(
                  fields,
                  unorderedEquals(ref_fields),
                  reason: 'referencedClassFields expect to be: $ref_fields'
               );
            }
         }
         if (method_targets.length == 1) {
            print('test for target.name: ${method_first.name}\n$method_first');
            _test();
         } else {
            //expect getter and setter.
            method_first = method_targets.where((t) => t.is_setter).first;
            print('####getter and setter, target: ${method_first.is_setter}');
            print('test for target.name: ${method_first.name}\n$method_first');
            _body_refs     = method_first.refs_in_body?.map((ref) => ref.refs?.map((r) => r.name)?.toList())?.toList();
            _ret_type_args = method_first.ret_type?.namedType?.typeargs?.arguments?.map((a) => (a as TypeNameImpl).name.name);
            _type_params   = method_first.type_params?.typeParameters?.map((t) => t.name.name);
            _ret_type      = method_first.ret_type?.namedType?.typename?.name;
            _test();
         };
      };
      //@fmt:off
      group('Generating ast of methods', (){
      
      });
      group("Parsing members in methods", () {
         test('pureDefinition', () {
            var name = 'pureDefinition';
            var ret_type = 'void';
            var ret_type_args = null;
            var type_params = null;
            var publicv = true;
            var staticv = false;
            var getterv = false;
            var setterv = false;
            var body_refs = [];
            var params = [['String', 'name', null, null, false]]; //note: type, name, functype, defaults, this_ref
            var default_params = [];
            //---------------------------------
            testMethod(
               name: name, publicv: publicv, staticv: staticv, getterv: getterv,
               params: params, body_refs: body_refs, ret_type: ret_type, setterv: setterv,
               type_params: type_params, default_params: default_params, ret_type_args: ret_type_args
            );
         });
         test('pureDefinitionWithArgs', () {
            var name           = 'pureDefinitionWithArgs';
            var ret_type       = 'void';
            var ret_type_args  = null;
            var type_params    = null;
            var publicv        = true;
            var staticv        = false;
            var getterv        = false;
            var setterv        = false;
            var body_refs      = [];
            //void pureDefinitionWithArgs(String name, [int a, int b]);
            var params         = [['String', 'name', null, null, false]];
            var default_params = [['int', 'a', null, null, false],
                                    ['int', 'b', null, null, false]
                                  ];
            //---------------------------------
            testMethod(
               name: name, publicv: publicv, staticv: staticv, getterv: getterv,
               params: params, body_refs: body_refs, ret_type: ret_type, setterv: setterv,
               type_params: type_params, default_params: default_params, ret_type_args: ret_type_args
            );
         });
         test('noArgMethod', () {
            var name           = 'noArgMethod';
            var ret_type       = 'void';
            var ret_type_args  = null;
            var type_params    = null;
            var publicv        = true;
            var staticv        = false;
            var getterv        = false;
            var setterv        = false;
            var body_refs      = [['refid']];
            var params         = [];
            var default_params = [];
            //---------------------------------
            testMethod(
               name: name, publicv: publicv, staticv: staticv, getterv: getterv,
               params: params, body_refs: body_refs, ret_type: ret_type, setterv: setterv,
               type_params: type_params, default_params: default_params, ret_type_args: ret_type_args
            );
         });
         test('noArgWithReturnType', () {
            var name          = 'noArgWithReturnType';
            var ret_type      = 'Map';
            var ret_type_args = ['String', 'String'];
            var type_params   = null;
            var publicv       = true;
            var staticv       = false;
            var getterv       = false;
            var setterv       = false;
            // note: a, b, c, d declared within local scope, setting is a label
            var body_refs      = [['hybriArgMethod']]; // ['a', 'b', 'c', 'd', 'hybriArgMethod', 'setting'];
            var ref_methods    = ['hybriArgMethod'];
            var ref_fields     = [];
            var params         = [];
            var default_params = [ ];
            //note: type, name, functype, defaults, this_ref
            //---------------------------------
            testMethod(
               name: name, publicv: publicv, staticv: staticv, getterv: getterv,
               params: params, body_refs: body_refs, ret_type: ret_type, setterv: setterv,
               type_params: type_params, default_params: default_params, ret_type_args: ret_type_args,
               ref_methods: ref_methods, ref_fields: ref_fields,
            );
         });
         test('hybriArgMethod', () {
            var name          = 'hybriArgMethod';
            var ret_type      = 'E';
            var ret_type_args = null;
            var type_params   = null;
            var publicv       = true;
            var staticv       = false;
            var getterv       = false;
            var setterv       = false;
            var body_refs      = [ ];
            var ref_methods    = [ ];
            var ref_fields     = [ ];
            var params         = [['String', 'name', null, null, false]];
            var default_params = [['Map', 'setting', null, 'DSETTING', false]];
            //---------------------------------
            testMethod(
               name: name, publicv: publicv, staticv: staticv, getterv: getterv,
               params: params, body_refs: body_refs, ret_type: ret_type, setterv: setterv,
               type_params: type_params, default_params: default_params, ret_type_args: ret_type_args,
               ref_methods: ref_methods, ref_fields: ref_fields,
            );
         });
         test('namedArgsMethod', () {
            var name          = 'namedArgsMethod';
            var ret_type      = 'List';
            var ret_type_args = ['E'];
            var type_params   = null;
            var publicv       = true;
            var staticv       = false;
            var getterv       = false;
            var setterv       = false;
            var body_refs     = [
               /*'refname', 'TestForMethods', 'obj', 'hybriArgMethod',
               'refid', 'listOptionalArgsMethodWithNoReturnType' ,
               'refname', 'pure_field', 'fnCall'*/
               ['this', 'refname'],
               ['TestForMethods', 'temp', 'ok'],
               ['this', 'obj', 'main'],
               ['this', 'hybriArgMethod'],
               ['refid'],
               ['prefix', 'com'],
               ['listOptionalArgsMethodWithNoReturnType'],
               //['this', 'refname'],  <- duplicate
               ['pure_field'],
               ['fnCall']
            ];
            var ref_methods    = [ 'hybriArgMethod', 'listOptionalArgsMethodWithNoReturnType'];
            var ref_fields     = [
               'refname',
               'obj',
               'refid',
               //'refname', < - duplicate
               'pure_field'
            ];
            var params         = [ ];
            var default_params = [[null, 'condition', 'bool condition(a)', null, false],
                                  [null, 'name', 'void Function(a)', null, false]];
            /* return [
               this.refname,
               TestForMethods.temp.ok,
               this.obj.main,
               this.hybriArgMethod,
               refid,
               this.listOptionalArgsMethodWithNoReturnType(this.refname + pure_field + fnCall())
            ]; */
            //---------------------------------
            var method = cls_parser.getMethod(name).first;
            print('#######');
            print(dumpAst(method.origin));;
            //fixme:
            
            
            testMethod(
               name: name, publicv: publicv, staticv: staticv, getterv: getterv,
               params: params, body_refs: body_refs, ret_type: ret_type, setterv: setterv,
               type_params: type_params, default_params: default_params, ret_type_args: ret_type_args,
               ref_methods: ref_methods, ref_fields: ref_fields,
            );
         });
         test('listOptionalArgsMethodWithNoReturnType', () {
            var name          = 'listOptionalArgsMethodWithNoReturnType';
            var ret_type      = 'dynamic';
            var ret_type_args = null;
            var type_params   = ['T'];
            var publicv       = true;
            var staticv       = false;
            var getterv       = false;
            var setterv       = false;
            var body_refs      = [['this', 'refid']];
            var ref_methods    = [ ];
            var ref_fields     = ['refid'];
            var params         = [];
            var default_params = [['T', 'name', null, null, false]];
            //note: type, name, functype, defaults, this_ref
            //---------------------------------
            testMethod(
               name: name, publicv: publicv, staticv: staticv, getterv: getterv,
               params: params, body_refs: body_refs, ret_type: ret_type, setterv: setterv,
               type_params: type_params, default_params: default_params, ret_type_args: ret_type_args,
               ref_methods: ref_methods, ref_fields: ref_fields,
            );
         });
         test('getterMethodWithoutReturnType', () {
            var name          = 'getterMethodWithoutReturnType';
            var ret_type      = 'dynamic';
            var ret_type_args = null;
            var type_params   = null;
            var publicv       = true;
            var staticv       = false;
            var getterv       = true;
            var setterv       = false;
            var body_refs      = [['refid'], ['refname']];
            var ref_methods    = [ ];
            var ref_fields     = ['refid', 'refname' ];
            var params         = null;
            var default_params = null;
            //note: type, name, functype, defaults, this_ref
            //---------------------------------
            testMethod(
               name: name, publicv: publicv, staticv: staticv, getterv: getterv,
               params: params, body_refs: body_refs, ret_type: ret_type, setterv: setterv,
               type_params: type_params, default_params: default_params, ret_type_args: ret_type_args,
               ref_methods: ref_methods, ref_fields: ref_fields,
            );
         });
         test('getterMethodWithReturnType', () {
            var name          = 'getterMethodWithReturnType';
            var ret_type      = 'String';
            var ret_type_args = null;
            var type_params   = null;
            var publicv       = true;
            var staticv       = false;
            var getterv       = true;
            var setterv       = false;
            var body_refs      = [['refname']];
            var ref_methods    = [];
            var ref_fields     = ['refname'];
            var params         = null;
            var default_params = null;
            //note: type, name, functype, defaults, this_ref
            //---------------------------------
            testMethod(
               name: name, publicv: publicv, staticv: staticv, getterv: getterv,
               params: params, body_refs: body_refs, ret_type: ret_type, setterv: setterv,
               type_params: type_params, default_params: default_params, ret_type_args: ret_type_args,
               ref_methods: ref_methods, ref_fields: ref_fields,
            );
         });
         test('getterSetter for setter method', () {
            var name          = 'getterSetter';
            var ret_type      = 'dynamic';
            var ret_type_args = null;
            var type_params   = null;
            var publicv       = true;
            var staticv       = false;
            var getterv       = false;
            var setterv       = true;
            var body_refs      = [  ];
            var ref_methods    = [ ];
            var ref_fields     = [  ];
            var params         = [['String', 'v', null, null, false]];
            var default_params = [];
            //note: type, name, functype, defaults, this_ref
            //---------------------------------
            testMethod(
               name: name, publicv: publicv, staticv: staticv, getterv: getterv,
               params: params, body_refs: body_refs, ret_type: ret_type, setterv: setterv,
               type_params: type_params, default_params: default_params, ret_type_args: ret_type_args,
               ref_methods: ref_methods, ref_fields: ref_fields,
            );
         });
      });
      //@fmt:on
   });
   group('parsing references in function body', (){
      /*
         * refParsingTest(){
            if (syn is AssignmentExpressionImpl){
               assignments.add(Refs(context: context, ref: syn));
            }
            num a = 10;
            num b = 10.1;
            refid += 1;
            var operator, best;
            var a = Object();
            Object another;
            best     = this.iforyou;
            another  = this.iforyou.youforme;
            this.iforyou.youforme += 'Hello World';
            best['assign'] = operator.op_assign;
            best['prop_assign'] = operator.prop_assign['hello'];
            overrides.add(syn.declaredElement.name, a.b.c + some, this.best);
            this.listOptionalArgsMethodWithNoReturnType(this.refname + pure_field + fnCall());
            return this.refid;
            return best = this.iforyou + someCall(in_call, in_call.subA, in_call.subA.subAB);
         }
         *
         * */
      var method            = cls_parser.getMethod('refParsingTest').first;
      /*test('test genIdents', (){
         var idents = Refs.genIdentsBottomUp(method.origin.body).map((s) => s.name).toList();
         expect(idents, unorderedEquals([
         
         ]));
      });*/
      test('validating assinment references fetched via enRefsUpDown', (){
         var refs_asn_excluded = <_.Tuple<AstNode, List<SimpleIdentifierImpl>>>[];
         var overrides         = <String>[];
         var assinments        = <_.Tuple<AstNode,
            List<_.Tuple<AstNode, List<SimpleIdentifierImpl>>>>>[];
         var cache      = <Object, List<_.Tuple<AstNode, List<SimpleIdentifierImpl>>>>{};
         Refs.genRefsUpDown(method.origin.body, refs_asn_excluded, overrides, assinments, cache);
         var result = assinments.map((r) => [r.key.toString(), r.value.toString()]).toList();
         expect(result, equals([
            ['refid += 1', '[[refid += 1, [refid]]]'],
            ['best = this.iforyou', '[[this.iforyou, [this, iforyou]]]'],
            [
               'another = this.iforyou.youforme',
               '[[this.iforyou.youforme, [this, iforyou, youforme]]]'
            ],
            [
               'this.iforyou.youforme += \'Hello World\'',
               '[[this.iforyou.youforme, [this, iforyou, youforme]]]'
            ],
            [
               'best[\'assign\'] = operator.op_assign',
               '[[best[\'assign\'] = operator.op_assign, []]]'
            ],
            [
               'best[\'prop_assign\'] = operator.prop_assign[\'hello\']',
               '[[best[\'prop_assign\'] = operator.prop_assign[\'hello\'], []]]'
            ],
            [
               'best = this.iforyou + someCall(in_call, in_call.subA, in_call.subA.subAB)',
               '[[this.iforyou, [this, iforyou]], [someCall(in_call, in_call.subA, in_call.subA.subAB), [someCall]], [(in_call, in_call.subA, in_call.subA.subAB), [in_call]], [in_call.subA, [in_call, subA]], [in_call.subA.subAB, [in_call, subA, subAB]]]'
            ]
         ]));
         
      });
      
      test('validating references fetched via getRefsInBody', (){
         var refs = method.getRefsInBody().key.map((r) => [r.context.toString(), r.refs.toString()]).toList();
         // note: no duplicate refs
         expect(refs, equals([
            ['syn is AssignmentExpressionImpl', '[syn]'],
            ['assignments.add(Refs(context: context, ref: syn))', '[assignments, add]'],
            ['Refs(context: context, ref: syn)', '[Refs]'],
            ['context: context', '[context]'],
            ['refid += 1', '[refid]'],
            ['a = Object()', '[Object]'],
            ['this.iforyou', '[this, iforyou]'],
            ['this.iforyou.youforme', '[this, iforyou, youforme]'],
            [
               'overrides.add(syn.declaredElement.name, a.b.c + some, this.best)',
               '[overrides, add]'
            ],
            ['syn.declaredElement.name', '[syn, declaredElement, name]'],
            ['a.b.c + some', '[some]'],
            ['this.best', '[this, best]'],
            [
               'this.listOptionalArgsMethodWithNoReturnType(this.refname + pure_field + fnCall())',
               '[listOptionalArgsMethodWithNoReturnType]'
            ],
            ['this.refname', '[this, refname]'],
            ['this.refname + pure_field', '[pure_field]'],
            ['fnCall()', '[fnCall]'],
            ['this.refid', '[this, refid]'],
            ['someCall(in_call, in_call.subA, in_call.subA.subAB)', '[someCall]'],
            ['(in_call, in_call.subA, in_call.subA.subAB)', '[in_call]'],
            ['in_call.subA', '[in_call, subA]'],
            ['in_call.subA.subAB', '[in_call, subA, subAB]']
         ]));
      });
      
      test('validating references fetched via genRefsUpDown', (){
         var refs_asn_excluded = <_.Tuple<AstNode, List<SimpleIdentifierImpl>>>[];
         var overrides         = <String>[];
         var assinments        = <_.Tuple<AstNode,
            List<_.Tuple<AstNode, List<SimpleIdentifierImpl>>>>>[];
         var cache      = <Object, List<_.Tuple<AstNode, List<SimpleIdentifierImpl>>>>{};
   
         Refs.genRefsUpDown(method.origin.body, refs_asn_excluded, overrides, assinments, cache);
         var result = refs_asn_excluded.map((r) => [r.key.toString(), r.value.toString()]).toList();
         print('result: $result');
         expect(result.take(15), unorderedEquals([
            ['syn is AssignmentExpressionImpl', '[syn]'],
            ['assignments.add(Refs(context: context, ref: syn))', '[assignments, add]'],
            ['Refs(context: context, ref: syn)', '[Refs]'],
            ['context: context', '[context]'],
            ['ref: syn', '[syn]'],
            ['refid += 1', '[refid]'],
            ['a = Object()', '[Object]'],
            // 'best' not included since declared as local var
            ['this.iforyou', '[this, iforyou]'],
            // 'another' not included since declared as local var
            ['this.iforyou.youforme', '[this, iforyou, youforme]'],
            // += helloworld not included since string literal is not to be considered
            ['this.iforyou.youforme', '[this, iforyou, youforme]'],
            // following two lines are ignored since declared as local var
            ['best[\'assign\'] = operator.op_assign', '[]'],
            ['best[\'prop_assign\'] = operator.prop_assign[\'hello\']', '[]'],
            [
               'overrides.add(syn.declaredElement.name, a.b.c + some, this.best)',
               '[overrides, add]'
            ],
            ['syn.declaredElement.name', '[syn, declaredElement, name]'],
            ['a.b.c + some', '[some]']
         ]));
         
         expect(result.sublist(15), unorderedEquals([
            ['this.best', '[this, best]'],
            // -----------------------------
            [
               'this.listOptionalArgsMethodWithNoReturnType(this.refname + pure_field + fnCall())',
               '[listOptionalArgsMethodWithNoReturnType]'
            ],
            ['this.refname', '[this, refname]'],
            ['this.refname + pure_field', '[pure_field]'],
            ['fnCall()', '[fnCall]'],
            // -----------------------------
            ['this.refid', '[this, refid]'],
            // -----------------------------
            ['this.iforyou', '[this, iforyou]'],
            ['someCall(in_call, in_call.subA, in_call.subA.subAB)', '[someCall]'],
            ['(in_call, in_call.subA, in_call.subA.subAB)', '[in_call]'],
            ['in_call.subA', '[in_call, subA]'],
            ['in_call.subA.subAB', '[in_call, subA, subAB]']
         ]));
      });
      
      test('Validating field references fetchin via getReferencedClassFields',(){
         var fields = method.getReferencedClassFields();
         expect(fields.fold([], (initial, f) => initial + f.names), [
            'refid', 'iforyou', 'refname', 'pure_field'
         ]);
      });

      test('Validating method references fetchin via getReferencedClassMethods',(){
         var m = method.getReferencedClassMethods();
         expect(m.map((f) => f.name.name).toList(), [
            'listOptionalArgsMethodWithNoReturnType'
         ]);
      });
   });
   
   group("Learning ast of class fields", () {
      group('parsing class fields', () {
         void testField({FieldsParser target, String fieldname, bool pub, bool con,
                           bool fi, bool sta, bool dyn, String typ, String ftyp,
                           List ann, String defaults}) {
            print('target field$fieldname: $target');
            expect(target.names, equals([fieldname]));
            expect(target.is_public, pub);
            expect(target.is_const, con);
            expect(target.is_final, fi);
            expect(target.is_static, sta);
            expect(target.named_type?.toString(), equals(typ));
            expect(target.func_type?.origin?.toString(), equals(ftyp));
            expect(target.annotations, equals(ann));
            expect(target.assigned_value.toString(), equals(defaults));
         }
         
         test('no_type_speicified_static_field', () {
            var target = cls_parser.getField('no_type_speicified_static_field');
            var public = true,
               constv = false,
               finalv = false,
               staticv = true,
               dynamicv = true,
               named_type = null,
               func_type = null,
               meta = [],
               defaults = 'null',
               name = 'no_type_speicified_static_field';
            testField(
               target: target, fieldname: name, pub: public, con: constv, fi: finalv,
               sta: staticv, dyn: dynamicv, typ: named_type, ftyp: func_type,
               ann: meta, defaults: defaults
            );
         });
         
         test('pure_static_field', () {
            var target = fields.firstWhere((field) => field.names.any((name) => name == 'pure_static_field'));
            var public = true,
               constv = false,
               finalv = false,
               staticv = true,
               dynamicv = false,
               named_type = 'String',
               func_type = null,
               meta = [],
               defaults = 'null',
               name = 'pure_static_field';
            testField(
               target: target, fieldname: name, pub: public, con: constv, fi: finalv,
               sta: staticv, dyn: dynamicv, typ: named_type, ftyp: func_type,
               ann: meta, defaults: defaults
            );
         });
         
         test('static_fields_with_default_value', () {
            var name = 'static_fields_with_default_value';
            var target = cls_parser.getField(name);
            var public = true,
               constv = false,
               finalv = false,
               staticv = true,
               dynamicv = false,
               named_type = 'List<String>',
               func_type = null,
               meta = [],
               defaults = "['s_hello']";
            testField(
               target: target, fieldname: name, pub: public, con: constv, fi: finalv,
               sta: staticv, dyn: dynamicv, typ: named_type, ftyp: func_type,
               ann: meta, defaults: defaults
            );
         });
         
         test('static_pure_fn_fields', () {
            var name = 'static_pure_fn_fields';
            var target = cls_parser.getField(name);
            var public = true,
               constv = false,
               finalv = false,
               staticv = true,
               dynamicv = false,
               named_type = null,
               func_type = 'bool Function(String a, int b)',
               meta = [],
               defaults = "null";
            testField(
               target: target, fieldname: name, pub: public, con: constv, fi: finalv,
               sta: staticv, dyn: dynamicv, typ: named_type, ftyp: func_type,
               ann: meta, defaults: defaults
            );
         });
         
         test('static_fn_fields_with_default_value', () {
            var name = 'static_fn_fields_with_default_value';
            var target = cls_parser.getField(name);
            var public = true,
               constv = false,
               finalv = false,
               staticv = true,
               dynamicv = false,
               named_type = null,
               func_type = 'bool Function(String a, int b)',
               meta = [],
               defaults = "(a, b) => false";
            testField(
               target: target, fieldname: name, pub: public, con: constv, fi: finalv,
               sta: staticv, dyn: dynamicv, typ: named_type, ftyp: func_type,
               ann: meta, defaults: defaults
            );
         });
         
         test('static_pure_typedef_fields', () {
            var name = 'static_pure_typedef_fields';
            var target = cls_parser.getField(name);
            var public = true,
               constv = false,
               finalv = false,
               staticv = true,
               dynamicv = false,
               named_type = 'TVoid',
               func_type = null,
               meta = [],
               defaults = "null";
            testField(
               target: target, fieldname: name, pub: public, con: constv, fi: finalv,
               sta: staticv, dyn: dynamicv, typ: named_type, ftyp: func_type,
               ann: meta, defaults: defaults
            );
         });
         
         
         test('no_type_speicified_field', () {
            var name = 'no_type_speicified_field';
            var target = cls_parser.getField(name);
            var public = true,
               constv = false,
               finalv = false,
               staticv = false,
               dynamicv = true,
               named_type = null,
               func_type = null,
               meta = [],
               defaults = "null";
            testField(
               target: target, fieldname: name, pub: public, con: constv, fi: finalv,
               sta: staticv, dyn: dynamicv, typ: named_type, ftyp: func_type,
               ann: meta, defaults: defaults
            );
         });
         
         test('pure_generic_fieldB', () {
            var name = 'pure_generic_fieldB';
            var target = cls_parser.getField(name);
            var public = true,
               constv = false,
               finalv = false,
               staticv = false,
               dynamicv = false,
               named_type = 'List<E>',
               func_type = null,
               meta = [],
               defaults = "null";
            testField(
               target: target, fieldname: name, pub: public, con: constv, fi: finalv,
               sta: staticv, dyn: dynamicv, typ: named_type, ftyp: func_type,
               ann: meta, defaults: defaults
            );
         });
         
         test('pure_generic_field', () {
            var name = 'pure_generic_field';
            var target = cls_parser.getField(name);
            var public = true,
               constv = false,
               finalv = false,
               staticv = false,
               dynamicv = false,
               named_type = 'E',
               func_type = null,
               meta = [],
               defaults = "null";
            testField(
               target: target, fieldname: name, pub: public, con: constv, fi: finalv,
               sta: staticv, dyn: dynamicv, typ: named_type, ftyp: func_type,
               ann: meta, defaults: defaults
            );
         });
         
         
         
         test('generic_field_with_value', () {
            var name = 'generic_field_with_value';
            var target = cls_parser.getField(name);
            var public = true,
               constv = false,
               finalv = false,
               staticv = false,
               dynamicv = false,
               named_type = 'E',
               func_type = null,
               meta = [],
               defaults = "'13' as E";
            testField(
               target: target, fieldname: name, pub: public, con: constv, fi: finalv,
               sta: staticv, dyn: dynamicv, typ: named_type, ftyp: func_type,
               ann: meta, defaults: defaults
            );
         });
         
         test('pure_field', () {
            var name = 'pure_field';
            var target = cls_parser.getField(name);
            var public = true,
               constv = false,
               finalv = false,
               staticv = false,
               dynamicv = false,
               named_type = 'String',
               func_type = null,
               meta = [],
               defaults = "null";
            testField(
               target: target, fieldname: name, pub: public, con: constv, fi: finalv,
               sta: staticv, dyn: dynamicv, typ: named_type, ftyp: func_type,
               ann: meta, defaults: defaults
            );
         });
         
         test('fields_with_default_value', () {
            var name = 'fields_with_default_value';
            var target = cls_parser.getField(name);
            var public = true,
               constv = false,
               finalv = false,
               staticv = false,
               dynamicv = false,
               named_type = 'String',
               func_type = null,
               meta = [],
               defaults = "'hello'";
            testField(
               target: target, fieldname: name, pub: public, con: constv, fi: finalv,
               sta: staticv, dyn: dynamicv, typ: named_type, ftyp: func_type,
               ann: meta, defaults: defaults
            );
         });
         
         test('pure_fn_fields', () {
            var name = 'pure_fn_fields';
            var target = cls_parser.getField(name);
            var public = true,
               constv = false,
               finalv = false,
               staticv = false,
               dynamicv = false,
               named_type = null,
               func_type = 'bool Function(String a, int b)',
               meta = [],
               defaults = "null";
            testField(
               target: target, fieldname: name, pub: public, con: constv, fi: finalv,
               sta: staticv, dyn: dynamicv, typ: named_type, ftyp: func_type,
               ann: meta, defaults: defaults
            );
         });
         
         test('fn_fields_with_default_value', () {
            var name = 'fn_fields_with_default_value';
            var target = cls_parser.getField(name);
            var public = true,
               constv = false,
               finalv = false,
               staticv = false,
               dynamicv = false,
               named_type = null,
               func_type = 'bool Function(String a, int b)',
               meta = [],
               defaults = "(a, b) => false";
            testField(
               target: target, fieldname: name, pub: public, con: constv, fi: finalv,
               sta: staticv, dyn: dynamicv, typ: named_type, ftyp: func_type,
               ann: meta, defaults: defaults
            );
         });
         
         test('pure_typedef_fields', () {
            var name = 'pure_typedef_fields';
            var target = cls_parser.getField(name);
            var public = true,
               constv = false,
               finalv = false,
               staticv = false,
               dynamicv = false,
               named_type = 'TVoid',
               func_type = null,
               meta = [],
               defaults = "null";
            testField(
               target: target, fieldname: name, pub: public, con: constv, fi: finalv,
               sta: staticv, dyn: dynamicv, typ: named_type, ftyp: func_type,
               ann: meta, defaults: defaults
            );
         });
      });
      
   });
}

































