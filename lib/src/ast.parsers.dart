//ignore_for_file: unused_shown_name, unused_import
import 'dart:io';

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/ast.dart';

import 'package:front_end/src/scanner/token.dart'
   show BeginToken, KeywordToken, SimpleToken, StringToken;
import 'package:quiver/collection.dart' show DelegatingMap;
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:path/path.dart' as Path;

import 'package:astMacro/src/ast.codegen.dart';
import 'package:common/src/common.dart' as _;

import 'package:astMacro/src/ast.utils.dart';
import 'package:IO/src/io.dart' as io;

import 'package:common/src/common.log.dart' show Logger, ELevel;
final _log = Logger(name: "ast.parsers", levels: [ELevel.critical, ELevel.error, ELevel.warning, ELevel.sys]);

const SELF = 'self';


bool
isPublic(String name) {
   return !name.startsWith('_');
}

bool
isUnderAnnotation(String name, [List<String> data]) {
   return data.contains(name);
}

class Nullable {
   const Nullable();
}
const nullable = Nullable();

class PrintableDelegation extends DelegatingMap {
   final delegate = {};
   String toString() {
      return _.FN.stringPrettier(delegate);
   }
}

T getNode<T extends SyntacticEntity>(AstNode node) {
   if (node == null) return null;
   return node.childEntities.firstWhere((syn) => syn is T,
      orElse: () => null);
}

List<T> getNodes<T extends SyntacticEntity>(AstNode node) {
   if (node == null) return [];
   return List<T>.from(node.childEntities.where((syn) {
      return syn is T;
   })) ?? [];
}

class SearchableNodes {
   /*
   [Description]
      walk children(childEntities) recursively and fetch what it walk through
      into a Ref object by user defined condition. The condition takes two
      arguments, one represents for current node the other for parent node context.
   */
   fetchChildrenWhere
      (dynamic ctx, bool condition(context, syn), [List<Refs<AstNode, SimpleIdentifierImpl>> ret]) {
      if (ctx == null) return [];
      if (ctx is! Token) {
         AstNode _context = ctx;
         _.FN.forEach(_context.childEntities.toList(), (syn, [i]) {
            var continuum = condition(_context, syn);
            if (continuum == true) {
               ret.add(Refs(context: _context, refs: syn));
               return true;
            }
            if (continuum == null) return false;
            if (syn is AstNode && syn != _context)
               fetchChildrenWhere(syn, condition, ret);
            return true;
         });
         
         /*_context.childEntities.forEach((SyntacticEntity syn) {
            if (condition(_context, syn)) {
               ret.add(Refs(context: _context, ref: syn));
               return;
            }
            if (syn is AstNode && syn != _context)
               fetchChildrenWhere(syn, condition, ret);
            return;
         });*/
      }
   }
   
   
}

//@fmt:off
class BaseDeclParser<E extends DeclarationImpl, P extends AstNode>
         extends PrintableDelegation with SearchableNodes  {
   P parent;
   E origin;
   E transformed;
   List<AnnotationImpl> annotations;
   bool is_public = false;
   bool is_static = false;
   
   BaseDeclParser.parentInit(E node){
      if (node == null)
         throw Exception("node couldn't be null");
      parent      = node.parent;
      annotations  = getNodes<AnnotationImpl>(node) ?? [];
      origin      = node;
      delegate['annotation'] = annotations;
   }
   
   List<String>
   get annotationNames{
      return annotations?.map((a) => getNode<SimpleIdentifierImpl>(a)?.name)
                ?.where((x) => x != null)?.toList()
             ?? [];
   }
   
   bool
   get isAnnotated => annotations != null;
   
   String toSource() => origin.toString();
   
}//@fmt:on

class ArgUtil{
   ExpressionImpl value;
   
   String
   get stringValue => value is SimpleStringLiteralImpl ? value.toSource() : null;
   
   String
   get identValue  => value is SimpleIdentifierImpl    ? (value as SimpleIdentifierImpl).name  : null;
   
   bool
   get boolValue   => value is BooleanLiteralImpl     ? (value as BooleanLiteralImpl).value : null;
   
   ListLiteralImpl
   get listValue => value is ListLiteralImpl ? (value as ListLiteralImpl) : null;
   
   MapLiteralImpl
   get mapValue => value is MapLiteralImpl ? (value as MapLiteralImpl) : null;
   
}

class NamedArgParser extends PrintableDelegation with SearchableNodes, ArgUtil {
   SimpleIdentifierImpl    name;
   ExpressionImpl          value;
   
   NamedArgParser.init(NamedExpressionImpl node){
      name = node.name.label;
      value = node.expression;
      delegate['name'] = name;
      delegate['value'] = value;
   }
   
   factory NamedArgParser(NamedExpressionImpl node){
      if (node == null) return null;
      return NamedArgParser.init(node);
   }
}


/*
* MethodDeclarationImpl: [
      AnnotationImpl, //
      TypeNameImpl, // [Map<T, S>] funcName(){...}
         TypeParameterListImpl, // Map[<T, S>] function(){}
         
      GenericFunctionTypeImpl, // [void FUnction(...)] funcName(){...}
      DeclaredSimpleIdentifier, // retType [funcName] (){...}
      FormalParameterListImpl, //
      BlockFunctionBodyImpl, //
      KeywordToken, // [static|external] funcName(){...}
      ExpressionFunctionBodyImpl, // funcName [=> value];
   
   ],
*/
/*
     represents function calling argumentlist
*/
class ArgumentListParser extends PrintableDelegation with SearchableNodes {
   Map<String, NamedExpressionImpl> named_args;
   List<SyntacticEntity> args;
   ArgumentListImpl origin;
   
   _isListArgMembers(SyntacticEntity node, SyntacticEntity parent) {
      return parent is ArgumentListImpl
             && node is! BeginToken
             && node is! SimpleToken
             && node is! NamedExpressionImpl;
   }
   
   List<PropertyAccessImpl>
   get referencedThis {
      var retA = args?.where((arg) => arg is PropertyAccessImpl) ?? [];
      var retB = named_args?.values?.where((NamedExpressionImpl value) =>
         value.childEntities.any((child) => child is PropertyAccessImpl)) ?? [];
      return retA.toList() + retB.toList();
   }
   
   List<String>
   get referencedThisProperties {
      return referencedThis.map((prop) => prop.propertyName.toString()).toList();
   }
   
   ArgumentListParser_init(ArgumentListImpl node) {
      origin    = node;
      named_args = {};
      args      = [];
      List<NamedExpressionImpl> _namedArgs = getNodes<NamedExpressionImpl>(node) ?? [];
      _namedArgs.forEach((syn) {
         var key = syn.name.label.name;
         if (named_args.containsKey(key))
            throw Exception('Uncaught Exception! duplicate NameArg key??');
         //_log.debug('ArgumentListParser_init:$key,  ${dump(syn)}');
         named_args[key] = syn; //.childEntities.firstWhere((s) => s is! LabelImpl, orElse: () => null);
      });
      args = node.childEntities.where((s) => _isListArgMembers(s, node)).toList();
      delegate['namedArgs'] = named_args;
      delegate['args'] = args;
   }
   
   ArgumentListParser(ArgumentListImpl node) {
      ArgumentListParser_init(node);
   }

   List<TArg>
   toList(){
      if (args != null)
         return args.map((p) =>
            TArg(arg_name: p.toString())
         ).toList();
      if (named_args != null)
         return named_args.keys.map((key) =>
            TArg(arg_name: key, arg_value: named_args[key], named_optional: true)
         ).toList();
      return [];
   }
}

class FormalParameterParser<E extends AstNode> extends PrintableDelegation with SearchableNodes {
   DeclaredSimpleIdentifier name;
   FuncTypeParser func_type;
   TypeNameImpl named_type;
   AstNode origin;
   Expression defaults;
   
   bool is_default_param = false;
   bool is_funcType = false;
   bool is_thisRef = false;
   
   _simpleTypeInit(SimpleFormalParameterImpl node) {
      //[EX] ..., String param
      node.childEntities.forEach((syn) {
         if (syn is TypeNameImpl) {
            named_type = syn;
         } else if (syn is DeclaredSimpleIdentifier) {
            name = syn;
         } else if (syn is GenericFunctionTypeImpl) {
            func_type = FuncTypeParser(syn);
         }
      });
   }
   
   
   _defaultTypeInit(DefaultFormalParameterImpl node) {
      //[EX] ..., [String optional]
      /*is_default_param = true;
      name = getNode<DeclaredSimpleIdentifier>(
         getNode<SimpleFormalParameterImpl>(node)
      );
      defaults = node.defaultValue;*/
      node.childEntities.forEach((syn) {
         if (syn is SimpleFormalParameterImpl) {
            name ??= getNode<DeclaredSimpleIdentifier>(syn);
            var ntype = getNode<TypeNameImpl>(syn);
            var ftype = getNode<GenericFunctionTypeImpl>(syn);
            named_type = ntype ?? null;
            func_type = ftype != null ? FuncTypeParser(ftype) : null;
            is_funcType = func_type != null;
         } else if (syn is FunctionTypedFormalParameterImpl) {
            name ??= getNode<DeclaredSimpleIdentifier>(syn);
            func_type ??= FuncTypeParser(syn);
            is_funcType = func_type != null;
         } else if (syn is FieldFormalParameterImpl) {
            var ref = getNode<KeywordToken>(syn)?.lexeme;
            is_thisRef = ref == THIS;
            name = is_thisRef ? getNode<SimpleIdentifierImpl>(syn) : null;
            named_type = null;
            func_type = null;
         } else if (syn is SimpleToken) {
            is_default_param = true;
            defaults = syn.lexeme == '='
                       ? getNode<SimpleIdentifierImpl>(node)
                       : null;
         }
      });
   }
   
   _thisFieldTypeInit(FieldFormalParameterImpl node, ClassifiedDeclParser classOwner) {
      //[EX] ..., this.prop
      var ref = getNode<KeywordToken>(node)?.lexeme;
      is_thisRef = ref == THIS;
      name = is_thisRef ? getNode<SimpleIdentifierImpl>(node) : null;
      defaults = null;
      var field_or_m = classOwner.getField(name.name) ?? classOwner.getMethod(name.name);
      if (field_or_m != null) {
         if (field_or_m is FieldsParser) {
            named_type = field_or_m.named_type;
            func_type = field_or_m.func_type;
         } else if (field_or_m is MethodsParser) {
            named_type = null;
            func_type = FuncTypeParser.generate(field_or_m);
         } else {
            throw Exception('Uncaught Error');
         }
      }
   }
   
   _formalFuncTypeInit(FunctionTypedFormalParameterImpl node) {
      //[EX] ..., bool condition(a)
      is_funcType = true;
      named_type = null;
      func_type = FuncTypeParser(node);
   }
   
   _genericFuncTypeInit(GenericFunctionTypeImpl node) {
      //[EX] ..., bool Function(String a, String b)
      is_funcType = true;
      named_type = null;
      func_type = FuncTypeParser(node);
   }
   
   FormalParameterParser(AstNode node, [ClassifiedDeclParser classOwner]) {
      origin = node;
      if (node is SimpleFormalParameterImpl) {
         _simpleTypeInit(node);
      } else if (node is DefaultFormalParameterImpl) {
         _defaultTypeInit(node);
      } else if (node is FieldFormalParameterImpl) {
         _thisFieldTypeInit(node, classOwner);
      } else if (node is FunctionTypedFormalParameterImpl) {
         _formalFuncTypeInit(node);
      } else if (node is GenericFunctionTypeImpl) {
         _genericFuncTypeInit(node);
      } else {
         throw Exception('Invalid Usage');
      }
      if (func_type == null && named_type == null)
         named_type = astNamedType('dynamic');
      delegate['name']       = name;
      delegate['func_type']  = func_type;
      delegate['named_type'] = named_type;
   }
}

/*
*
   Represents Definitions of Function Parameters

   FormalParameterListImpl: [
      BeginToken, // call [(] ... )
      SimpleFormalParameterImpl, // call( [simpleArg] )
         TypeNameImpl: String
         DeclaredSimpleIdentifier: String [name]
      SimpleToken, // call( ... [)]
      DefaultFormalParameterImpl, // call( ... [i] )
      FieldFormalParameterImpl, // call( [this.key], ...)  ---- only applied in constructor
         KeywordToken: this
         SimpleIdentifierImpl this.[name]
      FunctionTypedFormalParameterImpl // call( [bool search(arg] )
   ],*/
class FormalParameterListParser extends PrintableDelegation with SearchableNodes {
   Iterable<FormalParameterParser> params;
   Iterable<FormalParameterParser> default_params;
   FormalParameterListImpl origin;
   
   bool
   _isDefaultParams(SyntacticEntity syn) {
      return syn is DefaultFormalParameterImpl;
   }
   
   bool
   _isNonDefaultParams(SyntacticEntity syn) {
      return syn is! DefaultFormalParameterImpl
             && syn is! BeginToken
             && syn is! SimpleToken;
   }
   
   List<DeclaredSimpleIdentifier>
   get referencedThis {
      var refA = params.where((parser) => parser.is_thisRef).map((parser) => parser.name);
      var refB = default_params.where((parser) => parser.is_thisRef).map((parser) => parser.name);
      return refA.toList() + refB.toList();
   }
   
   List<String>
   get referencedThisProperties {
      return referencedThis.map((ref) => ref.name).toList();
   }
   
   FormalParameterListParser(FormalParameterListImpl node) {
      origin = node;
      
      params = node.childEntities.where((child) => _isNonDefaultParams(child))
         .map((child) => FormalParameterParser(child));
      default_params = node.childEntities.where((child) => _isDefaultParams(child))
         .map((child) => FormalParameterParser(child));
      
      delegate['params'] = params ?? [];
      delegate['defaultParams'] = default_params ?? [];
   }
   
   List<TArg>
   toList(){
      var ret = <TArg>[];
      if (params != null)
         ret += params.map((p) =>
            TArg(
               arg_typ: TType.namedType(
                  name: p.named_type.name.name,
                  namedType_params: p.named_type.typeArguments?.arguments?.map((arg) => arg.type.name)?.toList()
               ),
               arg_value: null
            )
         ).toList();
      if (default_params != null)
         ret += params.map((p) =>
            TArg(
               arg_typ: TType.namedType(
                  name: p.named_type.name.name,
                  namedType_params: p.named_type.typeArguments?.arguments?.map((arg) => arg.type.name)?.toList()
               ),
               arg_value: p.defaults
            )
         ).toList();
      return ret;
   }
}

//incompleted
class ParameterListParser<E extends AstNode> extends PrintableDelegation with SearchableNodes {
   FormalParameterListParser params;
   ArgumentListParser args;
   AstNode origin;
   
   bool isFormalParams() {
      return params != null;
   }
   
   bool isArgList() {
      return args != null;
   }
   
   ParameterListParser(AstNode node) {
      origin = node;
      if (node == null) return;
      if (node is FormalParameterListImpl) {
         params = FormalParameterListParser(node  );
         delegate['params'] = params.delegate;
      } else if (node is ArgumentListImpl) {
         args = ArgumentListParser(node );
         delegate['args'] = args.delegate;
      } else {
         throw Exception("Uncaught exception, encounter unexpected type during initializing ParameterParser!");
      }
   }
   
   toList(){
      if (params != null)
         return params.toList();
      if (args != null)
         return args.toList();
   }
}

class MethodInvokeParser extends PrintableDelegation with SearchableNodes {
   ArgumentListParser   arguments;
   SimpleIdentifier     name;
   MethodInvocationImpl origin;
   
   MethodInvokeParser(MethodInvocationImpl node) {
      origin = node;
      name = node.methodName;
      arguments = ArgumentListParser(getNode<ArgumentListImpl>(node));
   }
}

class AnnInvokeParser extends PrintableDelegation with SearchableNodes {
   ArgumentListParser arguments;
   SimpleIdentifier   name;
   AnnotationImpl     origin;

   AnnInvokeParser(AnnotationImpl node) {
      origin = node;
      name = node.name;
      arguments = ArgumentListParser(getNode<ArgumentListImpl>(node));
   }
}


/*
*     1) represents a refetchChildrenWhereturnType of general type of MethodDeclarationImpl
*     2) represents a general typename declared parameter list
*     3) represents a general typename in variable declaration
* */
class TypeNameParser extends PrintableDelegation with SearchableNodes {
   SimpleIdentifierImpl typename;
   TypeArgumentListImpl typeargs;
   TypeNameImpl origin;
   
   TypeNameParser(TypeNameImpl node) {
      origin = node;
      typename = node == null
                 ? SimpleIdentifierImpl(KeywordToken(Keyword.DYNAMIC, 0)) //ex [Map]  <S, T>
                 : getNode<SimpleIdentifierImpl>(node);
      typeargs = getNode<TypeArgumentListImpl>(node); //ex  Map  [<S, T>]
      delegate['typename'] = this.typename;
      delegate['typeargs'] = this.typeargs;
   }
}


/*
GenericFunctionTypeImpl: [
   TypeNameImpl,
   KeywordToken,
   FormalParameterListImpl
],

     1) represents a returnType of a MethodDeclarationImpl
     2) represents a function type declared in parameter list
     3) represents a function type in variable declaration
     
*/ //@fmt:off
class FuncTypeParser extends PrintableDelegation with SearchableNodes {
   SimpleIdentifier ident;
   TypeNameImpl retType;
   FormalParameterListImpl arguments;
   TypeParameterListImpl type_params;
   AstNode origin;
   
   static FuncTypeParser
   generate<E>( MethodsParser m){
      return FuncTypeParser(GenericFunctionTypeImpl(
         m.origin.returnType, KeywordToken(Keyword.FUNCTION, 0), m.origin.typeParameters, m.origin.parameters
      ));
   }
   
   FuncTypeParser(AstNode node) {
      origin = node;
      if (node == null) return;
      if (node is FunctionTypedFormalParameterImpl){
         //[EX] ..., bool condition(a)
         var _node = node  ;
         ident     = _node.identifier;
         retType   = _node.returnType ?? astNamedType(Keyword.DYNAMIC.lexeme); //SimpleIdentifierImpl(KeywordToken(Keyword.DYNAMIC, 0));
         arguments = _node.parameters;
         type_params = _node.typeParameters;
      } else if (node is GenericFunctionTypeImpl) {
         //[EX] ..., bool Function(String a, String b)
         var _node = node ;
         retType   = _node.returnType ?? astNamedType(Keyword.DYNAMIC.lexeme); //SimpleIdentifierImpl(KeywordToken(Keyword.DYNAMIC, 0));
         arguments = _node.parameters;
         type_params = _node.typeParameters;
         ident     =  SimpleIdentifierImpl(KeywordToken(Keyword.FUNCTION, 0));
      }
      delegate['retType']     = retType;
      delegate['arguments']   = arguments;
      delegate['ident']       = ident;
   }
   
} //@fmt:on
/*
*
* */
class AType<E extends AstNode> extends PrintableDelegation with SearchableNodes {
   FuncTypeParser funcType;
   TypeNameParser namedType;
   AstNode origin;
   
   bool
   get isNamedType => namedType != null;
   
   bool
   get isFuncType => funcType != null;
   
   AType(AstNode node, [String name]) {
      origin = node;
      if (node == null) {
         //dynamic namedType
         namedType = TypeNameParser(node as TypeNameImpl);
         delegate['namedType'] = namedType.delegate;
         _log.debug ('AType $name: convert null node into dynamic node, namedType:$namedType');
      };
      if (node is GenericFunctionTypeImpl) {
         funcType = FuncTypeParser(node);
         delegate['funcType'] = funcType.delegate;
         _log.debug ('AType $name: funcType:${funcType.retType}, node:$node');
      } else if (node is TypeNameImpl) {
         namedType = TypeNameParser(node  );
         delegate['namedType'] = namedType.delegate;
         _log.debug ('AType $name: namedType:${namedType.typename}, node:$node');
      }
   }
   
   String toSource() => origin.toString();
}

abstract class FieldsContainer{
   bool is_public;
   bool is_const;
   bool is_final;
   bool is_static;
   bool is_dynamic;
   ClassifiedDeclParser            classOwner;
   TypeNameImpl               named_type;
   FuncTypeParser             func_type;
   List<SimpleIdentifier>     variables;
   List<String>               names;
   Expression                 assigned_value;
}

//tested: ok:
//@fmt:off
class FieldsParser extends BaseDeclParser<FieldDeclarationImpl, ClassOrMixinDeclarationImpl> implements FieldsContainer{
   bool is_public;
   bool is_const;
   bool is_final;
   bool is_static;
   bool is_dynamic;
   ClassifiedDeclParser            classOwner;
   TypeNameImpl               named_type;
   FuncTypeParser             func_type;
   List<SimpleIdentifier>     variables;
   List<String>               names;
   
   //untested:
   Expression get assigned_value {
      return origin.fields.variables.first.initializer;
   }
   
   void set assigned_value(Expression v){
      origin.fields.variables.first.initializer = v;
      delegate['assigned_value'] = v;
   }
   
   
   bool
   hasField(String name) => variables.any((ident) => ident.name == name);
   
   FieldsParser(FieldDeclarationImpl node, this.classOwner) : super.parentInit(node) {
      var contains_private, all_private ;
      
      is_static        = node.isStatic;
      variables        = node.fields.variables.map((v) => v.name).toList();
      names            = variables.map((v) => v.name).toList();
      named_type             = getNode<TypeNameImpl>(
                           getNode<VariableDeclarationListImpl>(node)
                         );
      
      func_type        = named_type == null
                           ? FuncTypeParser(getNode<GenericFunctionTypeImpl>(
                              getNode<VariableDeclarationListImpl>(node)
                            ))
                           : null;
      is_dynamic       = named_type == null;
      is_const         = node.fields.isConst;
      is_final         = node.fields.isFinal;
      contains_private = variables.any((v) => v.name.startsWith('_'));
      all_private      = variables.every((v) => v.name.startsWith('_'));
      is_public        = all_private == true
                           ? false
                           : contains_private == false
                              ? true
                              : null;
      /*assigned_value =
         getNode<VariableDeclarationImpl>(
            getNode<VariableDeclarationListImpl>(node)
         ).initializer;*/
      
      
      if(is_public == null)
         _log.sys (StackTrace.fromString('WARNING: found hybrid variables of private fields and public fields declaration'));
      
      delegate['is_dynamic'] = is_dynamic;
      delegate['is_public'] = is_public;
      delegate['is_static'] = is_static;
      delegate['variables'] = variables;
      delegate['named_type']      = named_type;
      delegate['func_type']      = func_type;
      delegate['is_const']  = is_const;
      delegate['is_final']  = is_final;
      delegate['names']  = names;
      delegate['assigned_value']  = assigned_value;
   }
} //@fmt:on
//@fmt:off





class Refs<P, R> {
   P context;
   R refs;
   
   Refs({this.context, this.refs});
   
   bool get is_this {
      if (refs is SimpleIdentifierImpl)
         return (refs as SimpleIdentifierImpl).name == THIS;
      if (refs is List){
         var _ref = refs as List<SimpleIdentifierImpl>;
         return _ref.length > 0 && _ref.first.name == THIS;
      }
      return false;
   }
   
   bool get has_noref =>
      refs == null || (refs is List && (refs as List).length == 0);
   
   bool get has_ref => !has_noref;
   
   String getTargetRef([List<String> reference_host]){
      reference_host ??= [THIS];
      if (refs is List){
         var r = refs as List;
         var l = r.length;
         if (l > 1)
            return is_this && r[0].name == THIS
               ? r[1].name
               : reference_host.contains(r[0].name)
                  ? r[1].name
                  : r[0].name;
         return r[0].name;
      }else
         return refs is SimpleIdentifierImpl
            ? (refs as SimpleIdentifierImpl).name
            : (){
                  throw Exception('Uncaught Error, refs: ${refs.runtimeType} ${refs}');
               }();
   }
   
   /*
   *     experimental, not tested, keep for reference
   * */
   static List<SimpleIdentifierImpl>
   fetchOriginBottomUp(AstNode node){
      var p = node.parent;
      var ignored =
         p is LabelImpl || node is LabelImpl || node is TypeNameImpl || p is TypeNameImpl;
      if (ignored)
         return null;
      var stop_fetching =
         (p is TryStatementImpl || p is SwitchStatement || p is ForStatementImpl
             || p is IfStatementImpl || p is ReturnStatementImpl || p is WhileStatementImpl
             || p is AssertStatementImpl || p is DoStatement || p is ContinueStatementImpl
             || p is YieldStatementImpl || p is ForEachStatementImpl || p is IndexExpressionImpl)
         || (p is BinaryExpressionImpl || p is AssignmentExpressionImpl || p is ConditionalExpressionImpl
             || p is ParenthesizedExpressionImpl || p is IsExpressionImpl || p is NamedExpressionImpl)
         || (node is PropertyAccessImpl && p is! PropertyAccessImpl)
         || (p is MethodInvocationImpl)
         || (node is DeclaredSimpleIdentifier || p is VariableDeclarationImpl)
         || (p is VariableDeclarationListImpl)
         || (p is ArgumentListImpl)
         || (p is FunctionBodyImpl);
      if (stop_fetching){
         if (node is PropertyAccessImpl){
            var is_this = node.toString().split('.')[0] == THIS;
            var this_ref = is_this ? [astIdent('this')] : <SimpleIdentifierImpl>[];
            return this_ref + getNodes<SimpleIdentifierImpl>(node.realTarget) + [node.propertyName];
         }else if (node is PrefixedIdentifierImpl){
            var is_this = node.toString().split('.')[0] == THIS;
            var this_ref = is_this ? [astIdent('this')] : <SimpleIdentifierImpl>[];
            return this_ref + [node.prefix, node.identifier];
         } else if (node is SimpleIdentifierImpl){
            return [node];
         }
         return getNodes<SimpleIdentifierImpl>(p);
      }
      return fetchOriginBottomUp(node.parent);
   }
   
   
   /*
   *  Experimental, Not Tested, keep for reference
   *
   *  display tree nodes from top to specific tree node at the bottom.
   *  for debug.
   */
   static List<String>
   genTreeBottomUp<T>(AstNode node, [List<String> ret]){
      ret ??= <String>[];
      if (node is FunctionBody)
         return ret;
      ret.add(node.runtimeType.toString());
      return genTreeBottomUp(node.parent, ret);
   }
   
   static List<SimpleIdentifierImpl>
   genIdentsBottomUp(AstNode node, [List<SimpleIdentifier> ret]){
      ret ??= <SimpleIdentifierImpl>[];
      node.childEntities.forEach( (SyntacticEntity nd) {
         if (nd is SimpleIdentifierImpl){
            return ret.add(nd);
         }else if (nd is AstNode){
            genIdentsBottomUp(nd, ret);
            return;
         };
      });
      return ret;
   }
   
   /*
   *  [fixme:] If there's time...
   *
   *  I tried refine following type of definition to make B extends
   *  List<List<SimpleIdentifierImpl but failed with some type cast error.
   *  Can't find a solution still.
   *
   */
   static void
   genRefsUpDown<A extends AstNode, B extends List<SimpleIdentifierImpl>, T extends _.Tuple<A, B>>(
         A context, [List<T> ret, List<String> overrides,
         List<_.Tuple<A, List<T>>> assignments,
         Map<Object, List<T>> cache])
   {
      overrides   ??= []; // declaration overrides detection
      assignments ??= []; // assignment statement detection
      ret         ??= [];
      cache       ??= {};
      
      void addToCache(AstNode ckey, AstNode ctx, SimpleIdentifierImpl syn) {
         if  (cache[ckey].length > 0) cache[ckey][0].value.add(syn);
         else cache[ckey].add(
            _.Tuple<A, B>(ctx, syn is DeclaredSimpleIdentifier
               ? <List<SimpleIdentifierImpl>>[]
               : [syn]) as T
         );
      }
      
      PropertyAccessImpl
      getProcRoot(PropertyAccessImpl node){
         if (node.parent is PropertyAccessImpl) return getProcRoot(node.parent);
         return node;
      }
      
      bool declared(String first){
         return overrides.contains(first);
      }
      
      
      // [NOTE] in case any nodes that has no children properties may missed here...
      if (context is SimpleIdentifier){
         // under some circumstances that we should pass it's parent node as input
         // since some node like SimpleIdentifiers which children, is StringToken
         // ,expected not to be considered as reference node.
         context = context.parent;
      }
      var childEntities = context.childEntities;
      
//      _log.debug('  genRefsUpDown ${context}, ${context.runtimeType}');
      childEntities.forEach((syn){
//         _log.debug('     $syn, ${syn.runtimeType}');
         /*
         *  [NOTE] following symbols represents
         *
         *  [++]  walk through whole sub tree recursively.
         *  [+]   walk through sub tree.
         *  [-]   to be ignored
         *  [:]   to be added into overrides
         *
         *
         *  -        + PropertyAccessImpl          -
         *
         */
         if (syn is PropertyAccessImpl){
            var node = getProcRoot(syn);
            var key = node.toString();
            var first    = key.split('.')[0];
            if (cache[key] != null)
               return ret.add(cache[key].first);
            if (declared(first))
               return null;
            var is_this  = first == THIS;
            var this_ref = is_this ? [astIdent('this')] : <SimpleIdentifierImpl>[];
            var result   = this_ref + getNodes<SimpleIdentifierImpl>(node.realTarget) + [node.propertyName];
            
            cache[key] = [_.Tuple<A, B>(node as A, result) as T];//  [[node, result]];
            return ret.add(cache[key][0]);
         /*
         *          + PrefixedIdentifierImpl          -
         */
         }else if (syn is PrefixedIdentifierImpl){
            var key     = syn.toString();
            var first   = key.split('.')[0];
            if (declared(first))
               return null;
            var is_this  = first == THIS;
            var this_ref = is_this ? [astIdent('this')] : <SimpleIdentifierImpl>[];
            var result   = this_ref + [syn.prefix, syn.identifier];
            
            return ret.add(_.Tuple<A, B>(syn as A, result) as T);
         
         /*
         *      | 'final' [TypeName]?
         *      | 'const' [TypeName]?
         *      | 'var'
         *      | [TypeName]
         */
         } else if (syn is VariableDeclarationListImpl){
            syn.variables.forEach((v) => overrides.add(v.name.name));
            return genRefsUpDown<A, B, T>(syn as A, ret, overrides, assignments, cache);
         /*
         *           ++ MethodInvocationImpl          -
         *           ++ NamedExpressionImpl
         *           +: VariableDeclarationImpl
         */
         }else if (syn is MethodInvocationImpl || syn is VariableDeclarationImpl
                || syn is NamedExpressionImpl   )
         {
            //if (syn is VariableDeclarationImpl) overrides.add(syn.name.name);
            //else if (syn is VariableDeclarationListImpl) overrides.addAll(syn.variables.map((v) => v.name.name).toList());
            var result = <T>[];
            if (cache[syn] == null)
               cache[syn] = result;
            
            if (cache[context] == null){
               genRefsUpDown<A, B, T>(syn, result, overrides, assignments, cache);
               ret.addAll(result);
               return null;
            }else{
               return addToCache(context, context, getNode<SimpleIdentifierImpl>(syn));
            }
         
         /*
         *           ++ SimpleIdentifierImpl          -
         *            - PropertyAccessImpl
         *            - PrefixedIdentifierImpl
         */
         }else if (syn is SimpleIdentifierImpl){
            if(context is PropertyAccessImpl || context is PrefixedIdentifierImpl) return null;
            if (declared(syn.name))
               return null;
            
            if (cache[context] == null)
               return ret.add(_.Tuple<A, B>(context, [syn] as B) as T);
            
            return addToCache(context, context, syn);
         
         /*
         *          -: DeclaredSimpleIdentifier        -
         */
         }else if (syn is DeclaredSimpleIdentifier ){
            overrides.add(syn.toString());
            //_log.debug('overrides: $overrides');
            throw Exception(overrides);
         
         /*
         *        ++ AssignmentExpressionImpl         -
         *
         */
         } else if (syn is AssignmentExpressionImpl  ){
            var left  = <T>[];
            var right = <T>[];
            var all   = <T>[];
            AstNode left_op;
            AstNode right_op;
            
            left_op  = syn.leftHandSide ;
            right_op = syn.rightHandSide ;
            
            if (left_op is! SimpleIdentifierImpl){
               genRefsUpDown<A, B, T>(left_op.parent , left, overrides, assignments, cache);
            } else {
               if (!declared(left_op.toString()) && left_op != null){
                  left.add( _.Tuple(syn as A, [left_op as SimpleIdentifierImpl]) as T );
               }
            }
            
            if (right_op is! SimpleIdentifierImpl){
               genRefsUpDown<A, B, T>(right_op.parent, right, overrides, assignments, cache);
            } else {
               if (!declared(right_op.toString()) && right_op != null)
                  right.add(_.Tuple(syn as A, [right_op as SimpleIdentifierImpl]  ) as T);
            }
            
            all.addAll(left);
            var already_in_r = false;
            for (var i = 0; i < right.length; ++i) {
               var r_member = right[i];
               already_in_r = left.any((l_member) => l_member.key == r_member.key);
               //already_in_r = r_member.value.every((ref) =>
               //      left.any((l_member) => l_member.value.map((l) => l.name).contains(ref.name)));
               if (already_in_r){
               }else{
                  all.add(r_member);
               };
            }
            
            assignments.add(_.Tuple(syn as A, all));
            
            if (all.length == 0)
               all.add(_.Tuple(syn as A, <SimpleIdentifierImpl>[]) as T);
            
            all.forEach((a){
               ret.add(a);
               /*if (cache[syn] == null){
                  cache[syn] = [_.Tuple(a.key  , a.value) as T];
                  ret.add(cache[syn][0]);
               } else {
                  var cached = cache[syn].first;
                  cached.value += a.value;
               }*/
            });
            
            /*right.forEach((r){
               ret.add(_.Tuple(left_op as A, r.value) as T);
            });*/
            /*ret.add(_.Tuple<A, B>(syn as A,
               (left.map((l) => l.value).expand((list) => list).toList()
               + right.map((r) => r.value).expand((list) => list).toList()).toSet().toList()
            ) as T );*/
            
            _log.log('left : $left_op, $left, ${left_op.runtimeType}');
            _log.log('right: $right_op, $right, ${right_op.runtimeType}');
            _log.log('all  : $all');
         /*
         *             - LabelImpl         -
         */
         } else if ( syn is LabelImpl || syn is TypeNameImpl ){
            // note: ignored
            return null;
         /*
         *            ++ AstNode           -
         */
         } else if ( syn is AstNode && syn != context){
            genRefsUpDown<A, B, T>(syn, ret, overrides, assignments, cache);
         }
      });
   }
   
   
   /*
      [DESCRIPTION]
      - get real target of references from reference_hosts
         - default of reference_host is 'this' which indicates host_cls
      - filter which references belongs to which reference_host by accessing getField/getMethod
   */
   static Refs<AstNodeImpl, List<SimpleIdentifierImpl>>
   filterReferencesByRoot<Type>(
      ClassifiedDeclParser                               host_cls,
      Refs<AstNodeImpl, List<SimpleIdentifierImpl>> tuple_ref,
      [Map<String, List<ClassifiedDeclParser>>           reference_host ])
   {
      reference_host  ??= {THIS: [host_cls]};
         if (tuple_ref.refs == null || (tuple_ref.refs != null && tuple_ref.refs.length == 0))
            return null;
         var refs       = tuple_ref.refs;
         var root_refs  = reference_host[refs.first.name] ?? [host_cls];
         var ctx        = tuple_ref.context;
         var prop_target= tuple_ref.is_this || reference_host.containsKey(refs.first.name)
            ? refs[1]
            : refs.first;
         var ref_found = root_refs.any((root_ref) =>
               Type == MethodsParser
                  ? root_ref.isMethodMatched(ctx, prop_target)
                  : Type == FieldsParser
                     ? root_ref.isFieldMatched(ctx, prop_target)
                     : (){throw Exception('Uncaught Exception');}()
         );
         if (ref_found)
            _log.debug ('reference found! accessor: ${refs.first.name}, context: ${ctx}, cls: ${host_cls.name}');
         else
            _log.debug ('refnc not found! accessor: ${refs.first.name}, context: ${ctx}, cls: ${host_cls.name}');
         
         if (!ref_found)  return null;
         return tuple_ref;
   }
}



class MethodsParser extends BaseDeclParser<MethodDeclarationImpl, ClassOrMixinDeclarationImpl> {
   AType                 ret_type;
   FunctionBody          body;
   ClassifiedDeclParser        classOwner;
   SimpleIdentifierImpl  name;
   ParameterListParser   params;
   TypeParameterListImpl type_params; // [EX] Map<S, E, ...>
   
   Token       kw_external ;  //
   Token       kw_modified ;  //abstract or static
   Token       kw_operator ;  //
   Token       kw_property ;
   bool        is_operator;
   bool        is_abstract;
   bool        is_getter;
   bool        is_setter;
   bool        is_public;
   bool        is_static;
   
   _.Tuple<
      List<Refs<AstNodeImpl, List<SimpleIdentifierImpl>>>,
      List<Refs<AstNodeImpl, List<List<SimpleIdentifierImpl>>>> >
   _refs_in_body;
   
   List<Refs<AstNodeImpl, List<SimpleIdentifierImpl>>>
   get refs_in_body {
      if (_refs_in_body != null)
         return _refs_in_body.key;
      _refs_in_body = getRefsInBody();
      return _refs_in_body.key;
   }
   
   List<Refs<AstNodeImpl, List<List<SimpleIdentifierImpl>>>>
   get assignment_refs_in_body {
      if (_refs_in_body != null)
         return _refs_in_body.value;
      _refs_in_body = getRefsInBody();
      return _refs_in_body.value;
   }
   
   /*
   [NOTE] about reference_host
    ----------------------------------------------------------
    For searching referenced target from reference_host
    while users want to access properties through any target
    other than 'this'.

    [NOTE] why list type of ClassDeclParser as type definition.
    ----------------------------------------------------------
    To consider type inheritance, for user to access class
    members from different levels of inheritance.
    
      [EX]
         {self: [host, inheritance1, ... inheritanceN]}                     */
   
   List<MethodsParser>
   getReferencedClassMethods([Map<String, List<ClassifiedDeclParser>> reference_host]){
      reference_host ??= {THIS: [classOwner]};
      var cache = <MethodsParser>[];
      return getReferencedMethods(reference_host).map<MethodsParser>(
         (method_ref) {
            var acc_name    = method_ref.refs.first.name;
            var acc_refcls  = reference_host[acc_name] ?? [classOwner];
            var method_name = method_ref.getTargetRef(reference_host.keys.toList());
            
            _log.debug('## acc_name:$acc_name ,method:${method_name} acc_refcls: ${acc_refcls.map((cls) => cls.name.name)}');
            for (var i = 0; i < acc_refcls.length; ++i) {
               var cls     = acc_refcls[i];
               var methods = cls.getMethod(method_name);
               var m_lenth = methods.length;
               if (m_lenth > 0 && !cache.any((m) => methods.contains(m))){
                  cache.addAll(methods);
                  return m_lenth > 1
                     ? methods.firstWhere((m) => m.is_getter, orElse: () => null) ?? methods.first
                     : methods.first;
               }
               
            }
         }
      ).where((m) => m != null).toList();
   }
   
   List<FieldsParser>
   getReferencedClassFields([Map<String, List<ClassifiedDeclParser>> reference_host]){
      reference_host ??= {THIS: [classOwner]};
      var cache = <FieldsParser>[];
      return getReferencedFields(reference_host).map<FieldsParser>(
         (field_ref){
            var acc_name   = field_ref.refs.first.name;
            var acc_refcls = reference_host[acc_name] ?? [classOwner];
            var prop_name  = field_ref.getTargetRef(reference_host.keys.toList());
            _log.debug('## acc_name:$acc_name ,prop:${prop_name}, acc_refcls: ${acc_refcls.map((cls) => cls.name.name)}');
            for (var i = 0; i < acc_refcls.length; ++i) {
               var cls   = acc_refcls[i];
               var field = cls.getField(prop_name);
               
               if (field != null && !cache.contains(field)){
                  cache.add(field);
                  return field;
               }
            }
         }
         
      ).where((field) => field != null).toList();
   }
   
   List<Refs<AstNodeImpl, List<SimpleIdentifierImpl>>>
   getReferencedFields([Map<String, List<ClassifiedDeclParser>> reference_host]) {
      reference_host ??= {THIS: [classOwner]};
      if (classOwner != null)
         return refs_in_body.map((ref) =>
            Refs.filterReferencesByRoot<FieldsParser>(classOwner, ref, reference_host)
         ).where((ref) => ref != null && ref.has_ref).toList();
      return null;
   }

   List<Refs<AstNodeImpl, List<SimpleIdentifierImpl>>>
   getReferencedMethods([Map<String, List<ClassifiedDeclParser>> reference_host]) {
      reference_host ??= {THIS: [classOwner]};
      if (classOwner != null)
         return refs_in_body.map((ref) =>
            Refs.filterReferencesByRoot<MethodsParser>(classOwner, ref, reference_host)
         ).where((ref) => ref != null && ref.has_ref).toList();
      return null;
   }
   
   MethodsParser(MethodDeclarationImpl node, this.classOwner) : super.parentInit(node) {
      //@fmt:off
      name        = node.name;
      ret_type    = AType(getNode<TypeNameImpl>(node) ?? getNode<GenericFunctionTypeImpl>(node), name.name);
      //params      = ParameterListParser(getNode<FormalParameterListImpl>(node));
      params      = ParameterListParser(node.parameters);
      kw_external = node.externalKeyword;  //
      kw_modified = node.modifierKeyword;  //abstract or static
      kw_operator = node.operatorKeyword;  //
      kw_property = node.propertyKeyword;
      is_getter   = node.isGetter;
      is_setter   = node.isSetter;
      is_static   = node.isStatic;
      is_public   = isPublic(name.name);
      is_operator = node.isOperator;
      is_abstract = node.isAbstract;
      body        = node.body;
      type_params = node.typeParameters;
      
      if (node.isGetter || node.isSetter)
         delegate['property']  = kw_property;
      if (node.isStatic)
         delegate['static']    = kw_modified;
      if (node.isOperator)
         delegate['operator']  = kw_operator;
      if (kw_external != null)
         delegate['external']  = kw_external;
         
      delegate['ret_type']    = ret_type;
      delegate['name']        = name;
      delegate['params']      = params;
      delegate['body']        = body;
      delegate['is_public']   = is_public;
      delegate['is_static']   = is_static;
      delegate['is_setter']   = is_setter;
      delegate['is_getter']   = is_getter;
   }


   // [note] about return type refs
   //    Refs - 1) a tuple liked object records; references as value and parent context as key
   //         - 2) access tuple members through refs.context ,refs.ref
   _.Tuple< List<Refs<A, B>>, List<Refs<A, List<B>>> >
   getRefsInBody<
      A extends AstNode, B extends List<SimpleIdentifierImpl>,
      T extends _.Tuple<A,B>> ([A context])
   {
      var ret         = <T>[];
      var assignments = <_.Tuple<A, List<T>>>[];
      
      context ??= body as A;
      Refs.genRefsUpDown<A, B ,T>(context, ret, null, assignments, null);
      
      List<Refs<A, B>>       result;
      List<Refs<A, List<B>>> assignments_result;
      
      A       ctx;
      B       refs;        // List<Simple>
      List<B> left_refs;   // List<List<Simple
      
      result = ret.map((ctx_ref_pairs){
         ctx = ctx_ref_pairs.key;
         refs = List<SimpleIdentifierImpl>.from(ctx_ref_pairs.value); //expect to be SimpleIdentifier instead of SyntacticEntity
         return Refs(context: ctx, refs: refs);
      }).toList();
      
      bool contains(B source, B tar){
         return tar.every((_s) =>
            source.map((s) => s.name).toList().contains(_s.name)
         );
      }
      // unique it, no duplicates
      result = _.FN.unique<Refs<A, B>>(result,
         (_result, rec_ref){
            return !_result.any((res_ref) =>
               contains(res_ref.refs, rec_ref.refs)
            );
         });
      
      assignments_result = assignments.map((ctx_ref_pairs){
         ctx         = ctx_ref_pairs.key;
         left_refs   = ctx_ref_pairs.value.map((ret) => ret.value).toList() ;
         return Refs(context: ctx, refs: left_refs);
      }).toList();
      
      // unique it, no duplicates
      assignments_result = _.FN.unique<Refs<A, List<B>>>(assignments_result,
         (_result, rec_ref) {
            return !_result.any((res_ref) => res_ref.refs.any(
               (_res_ref) => rec_ref.refs.any((_rec_ref) =>
                  contains(_res_ref, _rec_ref))
            ))
            ;
         });
      return _.Tuple(result, assignments_result);
   }
   
   referenceInitialize() {
      if (classOwner != null) {
         delegate['referencedClassFields']  = getReferencedClassFields();
         delegate['referencedClassMethods'] = getReferencedClassMethods();
      }
   }
   
   GenericFunctionTypeImpl
   toFuncDef(){
      var retType = ret_type.namedType != null
         ? TType(
               name:ret_type.namedType.typename.name,
               namedType_params: ret_type.namedType.typeargs?.arguments?.map((arg) => arg.toString())
            )
         : ret_type.funcType != null
            ? TType.astNodeInit(ret_type.funcType)
            : TType(name: 'void');
      
      //mod:
      var arguments = params?.params?.params?.map((c){
         return TArg(
            arg_typ: TType.astNodeInit(c.named_type ?? c.func_type),
            arg_name: c.name.name);
      })?.toList();
      //original:
      //var arguments = params?.args?.toList();
      /*_log.debug ('-----');
      _log.debug (dumpAst(type_params));*/
      List funcType_params = type_params?.typeParameters?.map(
         (p) => _.Tuple(p.name.name, p.bound.type.name ) // e.g. :: E extends SomeClass
      )?.toList();
      
      return astGenericTypeFunc(
         func_retType: retType,
         funcType_params: funcType_params,
         arguments: TArgList(arguments)
      );
   }
}//@fmt:on



//@fmt:off


// -------------------------------------------
// todo:
// 0) search import clauses whereas super class within.
// 1) read class from specific import clause
// 2) combine class members from super classes into current one
//
class InheritedClassDeclParser extends ClassDeclParser{
  InheritedClassDeclParser(ClassDeclarationImpl node) : super(node);
}

mixin ClassifiedDeclParser<E extends ClassOrMixinDeclarationImpl> on BaseDeclParser<E, CompilationUnitImpl> {
   _.Triple<ExtendsClauseImpl, WithClauseImpl, ImplementsClauseImpl>  _cls_ext;
   _.Triple<ExtendsClauseImpl, WithClauseImpl, OnClauseImpl>  _mixin_ext;
   
   List<String>             _super_names;
   DartFileParser           file;
   ImplementsClauseImpl     impl;
   Iterable<FieldsParser>   fields;
   Iterable<MethodsParser>  methods;
   DeclaredSimpleIdentifier name;
   List<AnnotationImpl>     _methodsAnnotations;
   List<AnnotationImpl>     _fieldsAnnotations;
   Iterable<ClassifiedDeclParser> _supers;
   Iterable<ClassifiedDeclParser> _roots;
   
   bool get is_public => !name.name.startsWith('_');
   bool get is_abstract;
   bool get is_mixin;
   
   List<AnnotationImpl>
   get methodsAnnotations {
      if (_methodsAnnotations != null) return _methodsAnnotations;
      return _methodsAnnotations = methods.fold([], (all, m) => all + m.annotations);
   }

   void
   set methodsAnnotations(List<AnnotationImpl> v) {
      _methodsAnnotations = v;
   }

   List<AnnotationImpl>
   get fieldsAnnotations {
      if (_fieldsAnnotations != null) return _fieldsAnnotations;
      _fieldsAnnotations = fields.fold([], (all, f) => all + f.annotations);
      return _fieldsAnnotations;
   }

   void
   set fieldsAnnotations(List<AnnotationImpl> v) {
      _fieldsAnnotations = v;
   }
   _.Triple<ExtendsClauseImpl, WithClauseImpl, dynamic>
   get ext{
      if (this is ClassDeclParser) return _cls_ext;
      return _mixin_ext;
   }
   
   List<String>
   get super_names {
      if (_super_names != null) return _super_names;
      var s = [ext.father?.superclass?.name?.name].where((x) => x != null).toList();
      var withs = ext.mother?.mixinTypes?.map((t) => t?.name?.name)?.toList() ?? [];
      var imp_or_on = this is ClassDeclParser
          ? _cls_ext.child?.interfaces?.map((t) => t?.name?.name)?.toList() ?? []
          : _mixin_ext.child?.superclassConstraints?.map((t) => t?.name?.name)?.toList() ?? [];
      return _super_names = s + withs + imp_or_on;
   }
   
   List<ClassifiedDeclParser>
   get supers {
      if (_supers != null) return _supers;
      var _super_names = <String>[]..addAll(super_names);
      return _supers = getSupers(file, _super_names);
   }
   
   List<ClassifiedDeclParser>
   get roots {
      if (_roots != null) return _roots;
      _roots ??= [];
      _getRootsByClasses(supers, _roots);
      return _roots;
   }
   
   _getRootsByClasses(List<ClassifiedDeclParser> cls_decls, [List<ClassifiedDeclParser> ret]){
      for (var i = 0; i < cls_decls.length; ++i) {
         var cls = cls_decls[i];
         if (cls.super_names.length == 0){
            ret.add(cls);
            continue;
         }else{
            _getRootsByClasses(cls.supers, ret);
         }
      }
   }
   
   static List<ClassifiedDeclParser>
   getSupers(DartFileParser file, List<String> _super_names){
      return DartFileParser.getRefClsFromFile(file, _super_names);
   }
   
   static List<ClassifiedDeclParser>
   getSupersDefinedWithinImports(DartFileParser file,  List<String> remained_supers){
      return DartFileParser.getRefClsViaImports(file.imp_divs, remained_supers);
   }
   
   static List<ClassifiedDeclParser>
   getSupersDefinedInFile(DartFileParser file, List<String> _super_names) {
      return DartFileParser.getClsFromFile(file, _super_names);
   }
   
   
   
   List<FieldDeclarationImpl>
   _getFieldNodes() {
      return getNodes<FieldDeclarationImpl>(origin) ?? [];
   }

   List<MethodDeclarationImpl>
   _getMethodNodes() {
      return getNodes<MethodDeclarationImpl>(origin) ?? [];
   }
   
   /*
    * [NOTE] about return type here.
    *
    * Always return a iterable MethodParser, while fetching method by name
    * ,instead of type of MethodParser; Since getter and setter both
    * have the same method name, so it's natural that an unique method
    * name stands for two methods.
    * */
   Iterable<MethodsParser>
   getMethod(String name) {
      return methods.where((method) => method.name.name == name);
   }

   FieldsParser
   getField(String name) {
      return fields.firstWhere((field) => field.names.any((fname) => fname == name), orElse: () => null);
   }
   
   

   /*
   *  [NOTE]
   *     Detect if specific field/Identifier can be fetched from
   *     class field, hence not considering DeclaredSimpleIdentifier
   *     to be included.
   */
   bool
   isFieldMatched(AstNode context, SimpleIdentifierImpl field) {
      if (context is DeclaredSimpleIdentifier) return false;
      return origin.getField(field.name) != null ? true : false;
   }

   /*
   *  [NOTE]
   *     Detect if specific method/Identifier can be fetched from
   *     class method.
   */
   bool
   isMethodMatched(AstNode context, SimpleIdentifierImpl method) {
      return methods.any((m) => m.name.name == method.name);
   }
}
class MixinDeclParser extends BaseDeclParser<MixinDeclarationImpl, CompilationUnitImpl> with ClassifiedDeclParser {
   get ext => _mixin_ext;
   bool get is_abstract => false;
   bool get is_mixin => true;
   
   MixinDeclParser(MixinDeclarationImpl node, [DartFileParser file]) : super.parentInit(node) {
      _mixin_ext = _.Triple(
         getNode<ExtendsClauseImpl>(node),
         getNode<WithClauseImpl>(node),
         getNode<OnClauseImpl>(node)
      );
      
      impl      = getNode<ImplementsClauseImpl>(node);
      fields    = _getFieldNodes().map((f) => FieldsParser(f, this)).toList();
      methods   = _getMethodNodes().map((m) => MethodsParser(m, this)).toList();
      name      = getNode<DeclaredSimpleIdentifier>(node);
      this.file = file;
      
      methods.forEach((m) => m.referenceInitialize());
      delegate['ext']     = ext;
      delegate['fields']  = fields;
      delegate['impl']    = impl;
      delegate['name']    = name;
      delegate['methods'] = methods;
   }
}

class ClassDeclParser extends BaseDeclParser<ClassDeclarationImpl, CompilationUnitImpl> with ClassifiedDeclParser {
   bool get is_abstract => origin.isAbstract;
   bool get is_mixin => false;
   get ext => _cls_ext;
   
   /*
   *  [NOTE]
   *     find class fields that are union between class fields and
   *     provided fields with a custom filter.
   *
   *     Let's say we have a set of field names, and want to see if
   *     how many of them are matched within class fields that are
   *     annotated with some specific annotation. With a custom
   *     filter to have a further checking that make sure which
   *     specific field are under specific annotation.
   */
   ClassDeclParser(ClassDeclarationImpl node, [DartFileParser file]) : super.parentInit(node) {
      _cls_ext = _.Triple(
         getNode<ExtendsClauseImpl>(node),
         getNode<WithClauseImpl>(node),
         getNode<ImplementsClauseImpl>(node)
      );
      impl      = getNode<ImplementsClauseImpl>(node);
      fields    = _getFieldNodes().map((f) => FieldsParser(f, this)).toList();
      methods   = _getMethodNodes().map((m) => MethodsParser(m, this)).toList();
      name      = getNode<DeclaredSimpleIdentifier>(node);
      this.file = file;
      
      methods.forEach((m) => m.referenceInitialize());
      delegate['ext']     = ext;
      delegate['fields']  = fields;
      delegate['impl']    = impl;
      delegate['name']    = name;
      delegate['methods'] = methods;
   }
}


/*
* TopLevelVariableDeclarationImpl: [
   AnnotationImpl,
   VariableDeclarationListImpl,
   SimpleToken
],*/
class TopVarDeclParser extends BaseDeclParser<TopLevelVariableDeclarationImpl, CompilationUnitImpl> {
   List<VariableDeclaration> variables;
   TypeAnnotation type;
   bool is_final;
   bool is_const;
   
   TopVarDeclParser(TopLevelVariableDeclarationImpl node) : super.parentInit(node) {
      variables = node.variables.variables.toList();
      type      = node.variables.type;
      is_final  = node.variables.isFinal;
      is_const  = node.variables.isConst;
      delegate['is_static'] = is_static;
      delegate['variables'] = variables;
      delegate['type']      = type;
      delegate['is_const']  = is_const;
      delegate['is_final']  = is_final;
   }
}

/*
FunctionDeclarationImpl: [
   AnnotationImpl,
   TypeNameImpl,
   DeclaredSimpleIdentifier,
   FunctionExpressionImpl
]
*/
class TopFuncDeclParser extends BaseDeclParser<FunctionDeclarationImpl, CompilationUnitImpl> {
   DeclaredSimpleIdentifier   name;
   TType                      ret_type;
   ParameterListParser     params;
   FunctionBodyImpl      body;
   
   TopFuncDeclParser(FunctionDeclarationImpl node) : super.parentInit(node) {
      name                 = node.name;
      ret_type             = TType.astNodeInit(node.returnType);
      params               = ParameterListParser(node.functionExpression.parameters);
      body                 = node.functionExpression.body;
      delegate['name']     = name;
      delegate['ret_type'] = ret_type;
      delegate['params']   = params;
      delegate['body']     = body;
   }
}


mixin ImportOrExportParser on PrintableDelegation, SearchableNodes {
   static Map<String, ImportOrExportParser> cache = {};
   static Map<String, String> package_cfg = _.Dict<String, String>(
      File(io.Path.rectifyPath(Platform.packageConfig))
         .readAsStringSync().trim().split('\n')
         .map((line){
            var package_name = line.substring(0, line.indexOf(':'));
            var package_path = line.substring(package_name.length + 1);
            return MapEntry(package_name, package_path);
         }
      ).toList()
   );
   DartFileParser host_parser;
   DartFileParser _content_parser;

   List<SimpleIdentifierImpl> shows;
   DeclaredSimpleIdentifier   decl_as;
   ImportDirectiveImpl        _import_origin;
   ExportDirectiveImpl        _export_origin;
   String  _content;
   String  path;
   File    source_file;
   
   NamespaceDirectiveImpl
   get origin => _import_origin ?? _export_origin;
   
   bool get is_import_directive => _import_origin != null;
   bool get is_export_directive => _export_origin != null;
   
   @nullable String
   get content{
      if (source_file == null) return null;
      if (_content != null) return _content;
      if (source_file.existsSync())
         return _content = source_file.readAsStringSync();
      else
         source_file = null;
      return null;
   }
   
   /*
      [NOTE]
         get file parser by import path.
   */
   @nullable DartFileParser
   get content_parser{
      if (source_file == null) return null;
      if (_content_parser != null) return _content_parser;
      var message = 'parsing dart file failed :${source_file.uri}\nwhile parsing content_parser of import clause "$path"\n';
      _.guard((){
         var code    = parseCompilationUnit(content, parseFunctionBodies: false);
         var parser  = DartFileParser(code:  code, uri: source_file.uri);
         _content_parser = parser;
      }, message);
      return _content_parser;
   }
   
   bool isFilePath(String path){
      var lib_ptn = RegExp('[a-zA-Z_]+[:]');
      return !path.startsWith(lib_ptn);
   }
   
   bool isBuildinPath(String path){
      var buildin_path = RegExp('dart:');
      return path.startsWith(buildin_path);
   }
   
   /*
   
   [NOTE]
      Filter Out References While There's As Clause or Show Clause
      Define in ImportClause.
      ------------------------------------------------------------
   [EX]
      to search references called ['hello', 'Vue.world', 'another_ref']
      in following import clauses
      1) import 'abc.dart' show hello;
      2) import 'efg.dart' as Vue;
      
      In Example one:
      it will filter out 'Vue.world' and 'another_ref', since Vue.world implies
      it's referenced by importAs clauses, and another_ref implies not a
      member of 'show hello'.
      
      In Example tow:
      It will filter out 'hello' and 'another_ref', since 'hello' and 'another_ref'
      implies it's not referenced by importAs clauses.
   */
   List<String>
   preFilterReferece(List<String> ref_names){
      if (decl_as != null){
         return  ref_names.where((name) =>
            name.contains('.') && name.split(".").first == decl_as.name
         ).toList();
         
      }else if (shows != null){
         return ref_names.where((name){
            return shows.any((ident) =>
               !name.contains('.') && name == ident.name
            );
         }).toList();
      }else{
         return ref_names.where((ref_name) => !ref_name.contains('.')).toList();
      }
   }
   
   @nullable String
   _getImportPath(String import_path){
      if (isBuildinPath(import_path)) return null;
      if (isFilePath(import_path)){
         return io.Path.join(
            io.Path.dirname(host_parser.file_path) ,
            import_path
         );
      }else{
         //parsing from package file is not supported
         var segs = _.FN.split(import_path, ":", 2);
         var package_paths = _.FN.split(segs[1], '/', 1);
         var package_name  = package_paths[0];
         var base_path = package_cfg[package_name];
         if (base_path == null){
            _.raise('Cannot find package path:${segs.join(':')}.\n'
            'parsing file from package path is not supported\n'
            'segs: $segs, package_paths: $package_paths, import_path:$import_path');
            return null;
         }
         
         if (package_paths.length > 1)
            return io.Path.join(package_cfg[package_name], package_paths[1]);
         return io.Path.join(package_cfg[package_name], '${package_paths[0]}.dart');
         //return io.Path.rectifyPath(package_cfg[package_name]);
      }
   }
   
   @nullable File
   getImportFile(String import_path){
      String path;
      File file;
      var message = 'Unable to open path:$import_path\nwhile parsing import clause';
      _.guard((){
         path = _getImportPath(import_path);
         if (path == null) return;
         file =  File(path);
         file.exists().then((is_exist){
            if (!is_exist)
               throw Exception("cannot get imported file by path: $path");
         }, onError: (obj, stacktrace){
            print('import clause: $import_path');
            print('file path: $path');
         });
      }, message);
      return file;
   }
   
   _init(NamespaceDirectiveImpl node){
      if (node is ImportDirectiveImpl)       _import_origin  = node;
      else if (node is ExportDirectiveImpl)  _export_origin  = node;
      else                                   throw Exception('Uncaught Exception');
      
      var combinator  = getNode<ShowCombinatorImpl>(node);
      var combinators = getNodes<SimpleIdentifierImpl>(combinator);
      decl_as         = getNode<DeclaredSimpleIdentifier>(node);
      shows           = combinators.length == 0 ? null : combinators;
      source_file     = getImportFile(path);
      
      delegate['path']  = path;
      delegate['shows'] = shows;
      delegate['decl']  = decl_as;
      delegate['content'] = content != null
         ? content.substring(0, 80) + ' ...'
         : null;
      var pth = this is ImportParser
         ? 'imp:$path'
         : 'exp:$path';
      ImportOrExportParser.cache[pth] = this;
   }
}


/*ImportDirectiveImpl: [
   SimpleStringLiteralImpl,
   ShowCombinatorImpl,
   SimpleToken
],*/
class ImportParser extends PrintableDelegation with SearchableNodes, ImportOrExportParser {
   String         path;
   DartFileParser host_parser;
   
   static ImportDirectiveImpl
   partDivToImportDiv (PartDirectiveImpl part){
      var metadata = part.metadata;
      var keyword = tok_imp;
      var libraryUri = part.uri;
      var configurations = <Configuration>[];
      return ImportDirectiveImpl(null, metadata, keyword, libraryUri,
         configurations, null, null, null, null, tok_semi);
   }
   
   
   ImportParser.init(ImportDirectiveImpl node, this.host_parser, this.path) {
      _init(node);
   }
   
   factory ImportParser(ImportDirectiveImpl node, DartFileParser host_parser){
      var path = getNode<SimpleStringLiteralImpl>(node).stringValue;
      var parser = ImportOrExportParser.cache['imp:$path'];
      if (parser != null){
         if (parser is ExportParser){
            _.raise("failed to initialize ImportParser for path:$path, node:$node");
         }
         return parser;
      }
      return ImportParser.init(node, host_parser, path);
   }
}

class ExportParser extends PrintableDelegation with SearchableNodes, ImportOrExportParser {
   String         path;
   DartFileParser host_parser;
   ExportParser.init(ExportDirectiveImpl node, this.host_parser, this.path) {
      _init(node);
   }
   
   factory ExportParser(ExportDirectiveImpl node, DartFileParser host_parser){
      var path = getNode<SimpleStringLiteralImpl>(node).stringValue;
      if (ImportOrExportParser.cache['exp:$path'] != null)
         return ImportOrExportParser.cache['exp:$path'];
      return ExportParser.init(node, host_parser, path);
   }
}

class DartFileParser extends PrintableDelegation with SearchableNodes {
   static Map<String, DartFileParser> cache = {};
   static DartFileParser
   openSync(File file) {
      return DartFileParser(code: parseCompilationUnit(file.readAsStringSync()), uri: file.uri);
   }
   
   static Future<DartFileParser>
   open(File file) {
      return file.readAsString().then((str) {
         return DartFileParser(code: parseCompilationUnit(str), uri: file.uri);
      });
   }
   
   static List<ClassifiedDeclParser>
   getRefClsFromFile(DartFileParser file, List<String> _super_names){
      var in_file = getClsFromFile(file, _super_names);
      if (_super_names.length == 0)
         return in_file;
      
      var imports = getRefClsViaImports(file.imp_divs, _super_names);
      if (_super_names.length == 0)
         return in_file + imports;
      
      throw Exception(
         "super class not found: $_super_names\n"
         "filtered_names:\n"
         "${file.imp_divs.map((imp) => imp.preFilterReferece(_super_names))}"
         "\nhas_show_or_as:\n"
         "${file.imp_divs.map((imp) => imp.shows != null || imp.decl_as != null)}"
      );
   }
   
   static List<ClassifiedDeclParser>
   getRefClsViaImports(List<ImportOrExportParser> imp_divs, List<String> remained_supers){
      var ret = <ClassifiedDeclParser>[];
      if (imp_divs == null) return ret;
      for (var i = 0; i < imp_divs.length; ++i) {
         var imp = imp_divs[i];
         if (imp.source_file == null)
            continue;
         // preFilterReferece: Filter Out References While There's As Clause or
         // Show Clause Define in ImportClause.
         var tobe_sought = imp.preFilterReferece(remained_supers);
         if (tobe_sought.length == 0)
            continue;
         var has_show_or_as = imp.shows != null || imp.decl_as != null;
         if (has_show_or_as){
            for (var j = 0; j < tobe_sought.length; ++j) {
               var sought_name = tobe_sought[j];
               if(remained_supers.contains(sought_name)){
                  remained_supers.remove(sought_name);
                  // de-target
                  tobe_sought[j] = tobe_sought[j].split('.').last;
               }
            }
         }else{
            tobe_sought = remained_supers;
         }
         ret.addAll(getClsFromDecls(imp.content_parser.cls_decls, tobe_sought));
         ret.addAll(getClsFromDecls(imp.content_parser.mixin_decls, tobe_sought));
         ret.addAll(_getRefClsViaNamespace(imp.content_parser.exp_divs, tobe_sought));
         ret.addAll(_getRefClsViaNamespace(imp.content_parser.part_divs, tobe_sought));
      }
      return ret;
   }
   
   static List<ClassifiedDeclParser>
   _getRefClsViaNamespace(List<ImportOrExportParser> divs, List<String> remained_supers){
      var ret = <ClassifiedDeclParser>[];
      if (divs != null){
         for (var j = 0; j < divs.length; ++j) {
            var exp = divs[j];
            if (exp.source_file == null)
               continue;
            ret.addAll(getClsFromDecls(exp.content_parser.cls_decls, remained_supers));
            ret.addAll(getClsFromDecls(exp.content_parser.mixin_decls, remained_supers));
            if (remained_supers.length == 0)
               return ret;
         }
      }
      return ret;
   }
   
   static List<ClassifiedDeclParser>
   getClsFromFile(DartFileParser file,  List<String> _super_names) {
      var target_names = _super_names.where((name) => name.contains('.')).toList();
      // temporary remove and added back later on.
      for (var i = 0; i < target_names.length; ++i) {
        var target_name = target_names[i];
         _super_names.remove(target_name);
      }
      var ret = getClsFromDecls(file.cls_decls, _super_names) +
             getClsFromDecls(file.mixin_decls, _super_names);
      _super_names.addAll(target_names);
      return ret;
   }
   
   static List<ClassifiedDeclParser>
   getClsFromDecls(List<ClassifiedDeclParser> cls_decls, List<String> remained_supers) {
      var ret = <ClassifiedDeclParser>[];
      if (cls_decls == null) return ret;
      var target_names = remained_supers.where((name) => name.contains('.')).toList();
      // temporary remove and added back later on.
      for (var i = 0; i < target_names.length; ++i) {
        var target_name = target_names[i];
         remained_supers.remove(target_name);
      }
      for (var j = 0; j < cls_decls.length; ++j) {
         var cls = cls_decls[j];
         for (var k = 0; k < remained_supers.length; ++k) {
            var super_name = remained_supers[k];
            if (super_name.endsWith(cls.name.name)){
               ret.add(cls);
               remained_supers.remove(super_name);
               if (remained_supers.length == 0)
                  return ret;
            }
         }
      }
      remained_supers.addAll(target_names);
      return ret;
   }
   
   String                     file_path;
   List<TopFuncDeclParser>    func_decls;
   List<TopVarDeclParser>     var_decls;
   List<ClassifiedDeclParser> cls_decls;
   List<ClassifiedDeclParser> mixin_decls;
   List<TypeAlias>            def_decls;
   List<EnumDeclarationImpl>  enum_decls;
   List<ImportOrExportParser> imp_divs;
   List<ImportOrExportParser> exp_divs;
   
   List<ImportParser>         part_divs;
   List<PartOfDirectiveImpl>  partof_divs;
   LibraryDirectiveImpl       lib;
   Iterable<SyntacticEntity>  members;
   CompilationUnitImpl        origin;
   
   List<String>
   get exported_references{
      var vars    = var_decls?.fold<List<String>>([], (initial, d) => initial + d.variables.map((v) => v.name.name).toList()) ?? [];
      var enums   = enum_decls?.map((e) => e.name.name)?.toList() ?? [];
      var classes = cls_decls?.map((c) => c.name.name)?.toList() ?? [];
      var funcs   = func_decls?.map((f) => f.name.name)?.toList() ?? [];
      var defs    = def_decls?.map((d) => d.name.name)?.toList() ?? [];
      return vars + enums + classes + funcs + defs;
   }

   String get file_dir =>
      Path.dirname(file_path);
   
   String get file_name =>
      Path.basename(file_path);
   
   
   
   DartFileParser
   getImportFileByClsName(String name){
      var imp = imp_divs.firstWhere((imp) => imp.content_parser.cls_decls.any((cls) => cls.name.name == name), orElse: ()=>null);
      return imp?.content_parser;
   }
   
   factory DartFileParser({CompilationUnitImpl code, Uri uri, DartFileParser file}){
      if (file == null){
         if (cache[uri.toFilePath()] != null) return cache[uri.toFilePath()];
         return cache[uri.toFilePath()] = DartFileParser.init(code, uri.toFilePath(), uri);
      }
      return cache[file.file_path] = file;
   }
   
   DartFileParser.fileInit(DartFileParser file){
      file.delegate.entries.forEach((e){
         delegate[e.key] = e.value;
      });
      origin = file.origin;
      file_path = file.file_path;
      func_decls = file.func_decls;
      var_decls = file.var_decls;
      cls_decls = file.cls_decls;
      def_decls = file.def_decls;
      mixin_decls = file.mixin_decls;
      enum_decls = file.enum_decls;
      imp_divs = file.imp_divs;
      exp_divs = file.exp_divs;
      part_divs = file.part_divs;
      partof_divs = file.partof_divs;
      lib = file.lib;
      members = file.members;
 
   }
   
   DartFileParser.init(CompilationUnitImpl code, String file_path, Uri uri) {
      file_path ??= uri?.toFilePath();
      if (file_path == null)
         throw Exception('file_path cannot be null');
      code      ??= parseCompilationUnit(File(file_path).readAsStringSync(), parseFunctionBodies: true);
      origin = code;
      this.file_path = file_path;
      
      code.childEntities.forEach((syn) {
         if (syn is FunctionDeclarationImpl) {
            func_decls ??= [];
            func_decls.add(TopFuncDeclParser(syn));
         } else if (syn is TopLevelVariableDeclarationImpl) {
            var_decls ??= [];
            var_decls.add(TopVarDeclParser(syn));
         } else if (syn is ClassDeclarationImpl) {
            cls_decls ??= [];
            cls_decls.add(ClassDeclParser(syn, this));
         } else if (syn is LibraryDirectiveImpl) {
            lib = syn;
         } else if (syn is ImportDirectiveImpl) {
            imp_divs ??= [];
            imp_divs.add(ImportParser(syn, this));
         } else if (syn is ExportDirectiveImpl) {
            exp_divs ??= [];
            exp_divs.add(ExportParser(syn, this));
         } else if (syn is GenericTypeAliasImpl || syn is FunctionTypeAliasImpl) {
            def_decls ??= [];
            def_decls.add(syn);
         } else if (syn is EnumDeclarationImpl) {
            enum_decls ??= [];
            enum_decls.add(syn);
         } else if (syn is PartDirectiveImpl){
            part_divs ??= [];
            var imp = ImportParser.partDivToImportDiv(syn);
            part_divs.add(ImportParser(imp, this));
         } else if (syn is PartOfDirectiveImpl){
            partof_divs ??= [];
            partof_divs.add(syn);
         } else if (syn is MixinDeclarationImpl){
            mixin_decls ??= [];
            mixin_decls.add(MixinDeclParser(syn, this));
         } else {
            throw Exception(
               '\nUncaught exception, encountered unexpected runtimeType:'
               '${syn.runtimeType} during initializing TopDeclParser'
            );
         }
      });
      members   = code.childEntities;
      delegate['var_decls']  = var_decls;
      delegate['cls_decls']  = cls_decls;
      delegate['def_decls']  = def_decls;
      delegate['imp_divs']   = imp_divs;
      delegate['enum_decls'] = enum_decls;
      delegate['lib']        = lib;
      delegate['members']    = members;
      delegate['file_path']  = file_path;
   }
   
   
}


