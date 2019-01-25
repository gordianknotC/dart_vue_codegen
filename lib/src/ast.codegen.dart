//ignore_for_file: unused_shown_name, unused_import
/*
info: The name SimpleToken is shown, but not used. (unused_shown_name at [astMacro] lib\src\ast.codegen.dart:8)
info: Unused import: 'package:quiver/collection.dart'. (unused_import at [astMacro] lib\src\ast.codegen.dart:14)
*/
//@fmt:off

import 'package:analyzer/analyzer.dart' show AstNode, CommentReference, ParameterKind, Statement, TypeAnnotation;
import 'package:analyzer/dart/ast/standard_ast_factory.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:front_end/src/scanner/token.dart'
   show BeginToken, CommentToken, KeywordToken, SimpleToken, StringToken;
import 'package:meta/meta.dart';
import 'package:quiver/collection.dart' show DelegatingMap;
import 'package:analyzer/src/dart/ast/ast.dart';

import 'package:astMacro/src/ast.parsers.dart';
import 'package:astMacro/src/ast.utils.dart';
import 'package:common/src/common.log.dart' show Logger, ELevel;
import 'package:common/src/common.dart' show FN, Tuple, guard, IS;

final _log = Logger(name: "ast.codgen", levels: [ELevel.critical, ELevel.error, ELevel.warning ]);


final KEYWORDS = Keyword.values.map((k) => k.lexeme).toList();

final DYNAMIC = Keyword.DYNAMIC.lexeme;
final THIS    = Keyword.THIS.lexeme;
final LIST    = 'List';
final MAP     = 'Map';
final STRING  = 'String';
final INT     = 'int';
final DOUBLE  = 'double';
final NUM     = 'num';

final _tok_ident     = TokenType.IDENTIFIER;
final tok_eq         = Token(TokenType.EQ, 0);
final tok_lsb        = Token(TokenType.OPEN_SQUARE_BRACKET, 0);
final tok_rsb        = Token(TokenType.CLOSE_SQUARE_BRACKET, 0);
final tok_lb         = Token(TokenType.OPEN_CURLY_BRACKET, 0);
final tok_rb         = Token(TokenType.CLOSE_CURLY_BRACKET, 0);
final tok_lt         = Token(TokenType.LT, 0);
final tok_gt         = Token(TokenType.GT, 0);
final tok_castl      = Token(TokenType.LT, 0);
final tok_castr      = Token(TokenType.GT, 0);
final tok_dot        = Token(TokenType.PERIOD, 0);
final tok_lp         = Token(TokenType.OPEN_PAREN, 0);
final tok_rp         = Token(TokenType.CLOSE_PAREN, 0);
final tok_at         = Token(TokenType.AT, 0);
final tok_semi       = Token(TokenType.SEMICOLON, 0);
final tok_fn         = Token(TokenType.FUNCTION, 0);
final tok_star       = Token(TokenType.STAR, 0);
final tok_star_eq    = Token(TokenType.STAR_EQ, 0);
final tok_plus       = Token(TokenType.PLUS, 0);
final tok_plus_eq    = Token(TokenType.PLUS_EQ, 0);
final tok_pp         = Token(TokenType.PLUS_PLUS, 0);
final tok_q          = Token(TokenType.QUESTION, 0);
final tok_qdot       = Token(TokenType.QUESTION_PERIOD, 0);
final tok_qq         = Token(TokenType.QUESTION_QUESTION, 0);
final tok_qq_eq      = Token(TokenType.QUESTION_QUESTION_EQ, 0);
final tok_minus      = Token(TokenType.MINUS, 0);
final tok_minus_eq   = Token(TokenType.MINUS_EQ, 0);
final tok_mm         = Token(TokenType.MINUS_MINUS, 0);
final tok_percent    = Token(TokenType.PERCENT, 0);
final tok_percent_eq = Token(TokenType.PERCENT_EQ, 0);
final tok_slash      = Token(TokenType.SLASH, 0);
final tok_slash_eq   = Token(TokenType.SLASH_EQ, 0);
final tok_tilde      = Token(TokenType.TILDE, 0);
final tok_tilde_slash= Token(TokenType.TILDE_SLASH, 0);
final tok_comma      = Token(TokenType.COMMA, 0);
final tok_colon      = Token(TokenType.COLON, 0);
final tok_tilde_slash_eq = Token(TokenType.TILDE_SLASH_EQ, 0);
final tok_null = Token(Keyword.NULL, 0);
final tok_imp  = Token(Keyword.IMPORT, 0);
final tok_this = Token(Keyword.THIS, 0);


class UnsupportedArgumentsException implements Exception {
   final List<String> supported;
   final dynamic provided;
   
   UnsupportedArgumentsException({this.supported, this.provided});
   
   String toString() {
      return 'Invalid type of arguemtns, only support for $supported, you provide:${provided.runtimeType}';
   }
}


class TAstInfer {
   String output;
   AstNode node;
   
   TAstInfer({this.output, this.node});
}

class TArg {
   TType   arg_typ ;
   String  arg_name;
   dynamic arg_value;
   bool    position_optional;
   bool    named_optional;
   int     offset;
   
   TArg({this.arg_typ, this.arg_name, this.position_optional,
         this.named_optional, this.offset, this.arg_value}){
      if(arg_value != null){
         if (position_optional != true && named_optional != true)
            position_optional = true;
      }
   }
}

class TArgList {
   List<TArg> list;
   int optional_offset_l;
   int optional_offset_r;
   
   TArgList([this.list]){
      this.list ??= [];
      init();
   }
   
   init(){
      var length = list.length;
      var offset = 0;
      for (var i = 0; i < length; ++i) {
         var lst = list[i];
         offset ++;
         if (lst.position_optional == true || lst.named_optional == true){
            optional_offset_l ??= offset;
            offset++;
         }
         lst.offset ??= offset;
      }
      if (optional_offset_l != null)
         optional_offset_r = offset + 1;
   }
   
   add(TArg arg){
      list.add(arg);
   }
}

//pass:
/*
   Represents:
      1) named type                     :: String, int, TestCase, ...
      2) generic function type          :: void Function, bool Function(String a, int b), ...
      3) inline parameter function type :: bool condition(a), bool inlineTest(condition), ...

*/
class TType<E>  {
   TypeNameImpl                     named_type;             // List<String>
   //TypeParameterListImpl            clause_type;            // <E extends String>
   GenericFunctionTypeImpl          generic_functype;       // bool Function<String> (int a, int b)
   FunctionTypedFormalParameterImpl param_functype;         // bool condition(a, b)
   
   /*
         String, int, bool ,TestCase...
   */
   TType_namedTypeInit({String name, List<String> namedType_params}){
         named_type = astNamedType(name, namedType_params);
   }
   /*
         void Function(String a, int b)
   */
   TType_genericFuncTypeInit({List<Tuple<String, String>> funcType_params ,
                              TArgList arguments, TType func_retType}){
      generic_functype = astGenericTypeFunc(
         funcType_params: funcType_params ,
         arguments      : arguments, func_retType   : func_retType
      );
   }
   /*
         bool condition(a, b, c, ...)
   */
   TType_formalParamInit({String func_name,   List<Tuple<String, String>> funcType_params,
                          TArgList arguments, TType func_retType}){
      param_functype = astInlineParamTypeFunc(
         func_name,
         funcType_params : funcType_params,
         arguments       : arguments,
         func_retType    : func_retType
      );
   }
   /*
         main constructor
   */
   TType({String name, List<String> namedType_params, String func_name,
          List<Tuple<String, String>> funcType_params, TArgList arguments, TType func_retType}){
      var is_all_args_null  = ((name ?? namedType_params ?? func_name ?? funcType_params ?? arguments ?? func_retType) == null);
      var is_named_type     = name != null || is_all_args_null;
      var is_unset_funcname_Or_kw_function       = (func_name == 'Function' || func_name == null);
      var is_setted_funcname_and_not_kw_function = (func_name != 'Function' && func_name != null);
      //  ----------------------------------------------------------------------
      var is_generic_type   = !is_named_type  && is_unset_funcname_Or_kw_function;
      var is_inline_type    = !is_named_type  && is_setted_funcname_and_not_kw_function;
      var is_fuzzy_functype = is_generic_type && is_inline_type;
      var is_fuzzy_usage    = is_named_type   && is_fuzzy_functype;
      //  ----------------------------------------------------------------------
      if (is_fuzzy_usage)
         throw Exception('Obscure usage');
      
      if (is_named_type){
         TType_namedTypeInit(name: name, namedType_params: namedType_params);
         if (func_name != null || funcType_params != null || arguments != null)
            throw Exception('Obscure usage');
      }else{
         func_name ??= 'Function';
         if (is_generic_type )
            TType_genericFuncTypeInit(funcType_params: funcType_params, arguments: arguments, func_retType: func_retType);
         else if (is_inline_type)
            TType_formalParamInit(func_name: func_name, funcType_params: funcType_params, arguments: arguments, func_retType: func_retType);
         else
            (){}; // pass
      }
   }
   TType.astNodeInit(dynamic namedOrFuncParser){
      guard((){
         if (namedOrFuncParser is FuncTypeParser){
            var func_retType = TType.astNodeInit(namedOrFuncParser.retType);
               var funcType_params = namedOrFuncParser.type_params?.typeParameters?.map((t) => Tuple(t.name.name))?.toList();
               var arguments = namedOrFuncParser.arguments.length > 0
                   ?  TArgList(namedOrFuncParser.arguments.parameters.map(
                        (p) => TArg(
                           arg_typ: TType.astNodeInit(p as FormalParameterImpl),
                           arg_name: p.declaredElement?.name
                        )
                      ).toList())
                   :  null;
               
            if (namedOrFuncParser.ident.name == 'Function'){
               //generic Formal func
               TType_genericFuncTypeInit(
                  funcType_params: funcType_params,
                  arguments      : arguments      , func_retType: func_retType
               );
            }else{
               // inline formal func
               var func_name = namedOrFuncParser.ident.name;
               TType_formalParamInit(
                  func_name: func_name, funcType_params: funcType_params,
                  arguments: arguments, func_retType   : func_retType
               );
            }
         } else if (namedOrFuncParser is TypeNameParser){
            var name = namedOrFuncParser.typename.name;
            var namedType_params = namedOrFuncParser.typeargs?.arguments?.map((arg) => arg.toString());
            TType_namedTypeInit(name: name, namedType_params: namedType_params);
         } else if (namedOrFuncParser is TypeNameImpl){
            var name = namedOrFuncParser.name.name;
            var namedType_params =
               namedOrFuncParser.typeArguments?.arguments?.map((x) => x.type?.name)
                  ?.where((x) => x!=null)
                  ?.toList();
            TType_namedTypeInit(name: name, namedType_params: namedType_params);
         } else if (namedOrFuncParser is SimpleFormalParameterImpl) {
            var name = namedOrFuncParser.type.toSource();
            TType.namedType(
               name: name
            );
         } else if (namedOrFuncParser is FormalParameterImpl) {
            var name = namedOrFuncParser.declaredElement.type.name;
            var namedType_params = namedOrFuncParser.declaredElement.typeParameters?.map((x) => x.name)?.toList();
            TType.namedType(
               name: name,
               namedType_params: namedType_params
            );
         } else if (namedOrFuncParser is MethodsParser){
            TType.astNodeInit(
               FuncTypeParser(namedOrFuncParser.toFuncDef())
            );
         } else if (namedOrFuncParser is FieldsParser){
            TType.astNodeInit(
               namedOrFuncParser.func_type ?? namedOrFuncParser.named_type
            );
         } else if (namedOrFuncParser == null || namedOrFuncParser == Null) {
             TType_namedTypeInit(name: 'void');
         } else if (namedOrFuncParser is GenericFunctionTypeImpl) {
            generic_functype = namedOrFuncParser;
         }else {
            throw Exception('type not supported: ${namedOrFuncParser.runtimeType}');
         }
      }, 'Some error occured while initializing TType with astNode: ${namedOrFuncParser.runtimeType}: $namedOrFuncParser'
      ,raiseOnly: false
      ,error: 'astNodeInitError');
      
      
   }
   
   TType.namedType({String name, List<String> namedType_params}){
      TType_namedTypeInit(name: name, namedType_params: namedType_params);
   }
   
   TType.genericFuncType({String func_name, List<Tuple<String, String>> funcType_params,
                          TArgList arguments, TType func_retType}){
      TType_genericFuncTypeInit( funcType_params: funcType_params,
                                 arguments: arguments, func_retType: func_retType);
   }
   
   TType.paramType({String func_name, List<Tuple<String, String>> funcType_params,
                      TArgList arguments, TType func_retType}){
      TType_formalParamInit(
         func_name: func_name, funcType_params: funcType_params,
         arguments: arguments, func_retType   : func_retType
      );
   }
}








/*



          A S T    S T A T E M E N T S    A N D    E X P R E S S I O N S        :



--------------------------------------------------------------------------------
 * A node that represents a statement.
 *
 *    statement ::=
 *        [Block]
 *      | [VariableDeclarationStatement]
 *      | [ForStatement]
 *      | [ForEachStatement]
 *      | [WhileStatement]
 *      | [DoStatement]
 *      | [SwitchStatement]
 *      | [IfStatement]
 *      | [TryStatement]
 *      | [BreakStatement]
 *      | [ContinueStatement]
 *      | [ReturnStatement]
 *      | [ExpressionStatement]
 *      | [FunctionDeclarationStatement]
*/
class Exps {
   static ConditionalExpressionImpl
   condition(ExpressionImpl condition, ExpressionImpl then, ExpressionImpl Else){
      return astConditionExp(condition, then, Else);
   }
   
   static BinaryExpressionImpl
   binary(ExpressionImpl left, ExpressionImpl right, Token op){
      return astBinaryExp(left, right, op);
   }
   
   static ParenthesizedExpressionImpl
   parenthesized(ExpressionImpl expression){
      return astParenthesizedExp(expression);
   }
   
   static NamedExpressionImpl
   namedArg(String arg_name, ExpressionImpl arg_value){
      return astNamedArgExp( arg_name,  arg_value);
   }
   
   static ThisExpressionImpl
   This(){
      return ThisExpressionImpl(astKeyword('this'));
   }
   
   static ExpressionFunctionBodyImpl
   funcBody(ExpressionImpl expression, bool is_async){
      return astExpFunc_Body(expression, is_async: is_async);
   }
   
   static FunctionExpressionImpl
   func(TArgList arguments, List<Tuple> type_params, {ExpressionImpl single_exp,
        bool is_async, bool is_yieldable, bool is_terminated}){
      return astExpFunc(
         arguments, type_params,
         is_async: is_async, is_yieldable: is_yieldable,
         single_exp: single_exp, is_terminated: is_terminated
      );
   }
   
   static AsExpressionImpl
   As(ExpressionImpl expression, String type){
      return astAsExp( expression,  type);
   }
   
   static AssignmentExpressionImpl
   assign(String left, String right, Token op){
      return astAssignExp( left,  right,  op);
   }
}

class States {
   static ExpressionStatementImpl
   exp(ExpressionImpl expression, {bool is_terminated}){
      var semicolon = is_terminated == true ? tok_semi : null;
      return ExpressionStatementImpl(expression, semicolon);
   }
   
   static EmptyStatementImpl
   empty(){
      return EmptyStatementImpl(tok_semi);
   }
   
   static ReturnStatementImpl
   Return(ExpressionImpl expression){
      return astReturnStatement( expression);
   }
   
   static AssertStatementImpl
   Assert({String msg, ExpressionImpl condition}){
      var kw = astKeyword('assert');
      var message = astString(msg);
      return AssertStatementImpl(kw, tok_lp, condition, tok_comma, message, tok_rp, tok_semi);
   }
   
   static VariableDeclarationStatementImpl
   varDecl(List<String> varnames, {String keyword, TType type, List<dynamic> values}){
      return astVar_DeclStatement(
         varnames,
         keyword: keyword, type: type, values: values
      );
   }
   
   static IfStatementImpl
   If(ExpressionImpl condition, StatementImpl then, StatementImpl Else){
      return astIfStatement(condition, then, Else);
   }
   
   static StatementImpl
   block(List<Statement> statements){
      return astBlockStatement(statements);
   }
   
   static TryStatementImpl
   Try(List<Statement> body, List<Statement> finally_body, List<CatchClauseImpl> catch_clause){
      return astTryStatement(body, finally_body, catch_clause);
   }
   
   static ForEachStatementImpl
   forIn(String varname, ExpressionImpl iterator, StatementImpl body, {bool is_await}){
      return astForInStatement(varname, iterator, body, is_await: is_await);
   }
   
   static ForStatementImpl
   forLoop(ExpressionImpl initialization, ExpressionImpl condition, ExpressionImpl updater, StatementImpl body){
      return astForLoopStatement(initialization, condition, updater, body);
   }
   
   static SwitchStatementImpl
   Switch(){
      throw Exception('not Implemented yet');
   }
   
   static LabeledStatementImpl
   label(){
      throw Exception('not Implemented yet');
   }
   
   static YieldStatementImpl
   yield(){
      throw Exception('not Implemented yet');
   }
}

/* [EX]
     '13' as int*/
AsExpressionImpl
astAsExp(ExpressionImpl expression, String type){
   var as_kw   = astKeyword('as');
   var as_type = astNamedType(type);
   return AsExpressionImpl(expression, as_kw, as_type);
}

AssignmentExpressionImpl
astAssignExp(String left, String right, Token op){
   var lnode = astElement(left);
   var rnode = astElement(right);
   return AssignmentExpressionImpl(lnode, op, rnode);
}

NamedExpressionImpl
astNamedArgExp(String arg_name, ExpressionImpl arg_value){
   var name = LabelImpl(astIdent(arg_name), tok_colon);
   return NamedExpressionImpl(name, arg_value);
}

ParenthesizedExpressionImpl
astParenthesizedExp(ExpressionImpl expression){
   return ParenthesizedExpressionImpl(tok_lp, expression, tok_rp);
}

BinaryExpressionImpl
astBinaryExp(ExpressionImpl left, ExpressionImpl right, Token op){
   return BinaryExpressionImpl(left, op, right);
}

ConditionalExpressionImpl
astConditionExp(ExpressionImpl condition, ExpressionImpl then, ExpressionImpl Else){
   return ConditionalExpressionImpl(condition, tok_q, then, tok_colon, Else);
}

ForEachStatementImpl
astForInStatement(String varname, ExpressionImpl iterator, StatementImpl body, {bool is_await}){
   var await_kw = is_await == true
                  ? astKeyword('await')
                  : null;
   var ident    = astIdent(varname);
   return ForEachStatementImpl.withReference(
      await_kw, astKeyword('for'), tok_lp, ident, astKeyword('in'), iterator, tok_rp, body
   );
}

ForStatementImpl
astForLoopStatement(ExpressionImpl initialization, ExpressionImpl condition,
                    ExpressionImpl updater, StatementImpl body){
   var for_kw = astKeyword('for');
   var variableList = null;
   var updaters = [updater];
   return ForStatementImpl(
      for_kw, tok_lp, variableList, initialization, tok_semi, condition,
      tok_semi, updaters, tok_rp, body
   );
}

ReturnStatementImpl
astReturnStatement(ExpressionImpl expression){
   return ReturnStatementImpl(astKeyword('return'), expression, tok_semi);
}

astStatement(){
   /*
   AssertStatementImpl                 (assertKeyword, leftParenthesis, condition, comma, message, rightParenthesis, semicolon)
   BreakStatementImpl                  (breakKeyword, label, semicolon)
   ContinueStatementImpl               (continueKeyword, label, semicolon)
   DoStatementImpl                     (doKeyword, body, whileKeyword, leftParenthesis, condition, rightParenthesis, semicolon)
   ExpressionStatementImpl             (expression, semicolon)
   ForEachStatementImpl.withDeclaration(awaitKeyword, forKeyword, leftParenthesis, loopVariable, inKeyword, iterator, rightParenthesis, body)
   ForStatementImpl                    (forKeyword, leftParenthesis, variableList, initialization, leftSeparator, condition, rightSeparator, updaters, rightParenthesis, body)
   FunctionDeclarationStatementImpl    (functionDeclaration)
   IfStatementImpl                     (ifKeyword, leftParenthesis, condition, rightParenthesis, thenStatement, elseKeyword, elseStatement)
   LabeledStatementImpl                (labels, statement)
   ReturnStatementImpl                 (returnKeyword, expression, semicolon);
   SwitchStatementImpl                 (switchKeyword, leftParenthesis, expression, rightParenthesis, leftBracket, members, rightBracket)
   TryStatementImpl                    (tryKeyword, body, catchClauses, finallyKeyword, finallyBlock)
   VariableDeclarationStatementImpl    (variableList, semicolon)
   WhileStatementImpl                  (whileKeyword, leftParenthesis, condition, rightParenthesis, body)
   YieldStatementImpl                  (yieldKeyword, star, expression, semicolon)
   */
}

VariableDeclarationStatementImpl
astVar_DeclListStatement({String keyword, List<String> varnames, TType type, List<dynamic> values}){
   var var_list = astVarDeclList(varnames, keyword: keyword, type: type, values: values);
   return VariableDeclarationStatementImpl(var_list, tok_semi);
}


FunctionDeclarationStatementImpl
_astFunc_DeclStatement(TType ret_type,  String name, List<Tuple> type_params, TArgList arguments,
                       {List<Statement> statements, bool is_get, bool is_set,
                       bool is_yieldable, bool is_async, ExpressionImpl single_exp}){
   var func_decl = _astFunc_Decl(
      ret_type , name, type_params, arguments,
      //--------------------------------------
      statements: statements, is_yieldable: is_yieldable,
      is_async: is_async, single_exp: single_exp, is_get: is_get, is_set: is_set
   );
   return FunctionDeclarationStatementImpl(func_decl);
}


FunctionDeclarationStatementImpl
astFunc_SetDeclStatement(TType ret_type,  String name, List<Tuple> type_params, TArgList arguments,
                       {List<Statement> statements,
                       bool is_yieldable, bool is_async, ExpressionImpl single_exp}){
   return _astFunc_DeclStatement(
      ret_type , name, type_params, arguments,
      statements: statements,  is_get: false , is_set: true,
      is_yieldable: is_yieldable, is_async: is_async, single_exp: single_exp
   );
}

FunctionDeclarationStatementImpl
astFunc_GetDeclStatement(TType ret_type,  String name, List<Tuple> type_params, TArgList arguments,
                        {List<Statement> statements,
                         bool is_yieldable, bool is_async, ExpressionImpl single_exp}){
   return _astFunc_DeclStatement(
      ret_type , name, type_params, arguments,
      statements: statements,  is_get: true , is_set: false,
      is_yieldable: is_yieldable, is_async: is_async, single_exp: single_exp
   );
}

FunctionDeclarationStatementImpl
astFunc_DeclStatement(TType ret_type,  String name, List<Tuple> type_params, TArgList arguments,
                       {List<Statement> statements,
                       bool is_yieldable, bool is_async, ExpressionImpl single_exp}){
   return _astFunc_DeclStatement(
      ret_type , name, type_params, arguments,
      statements: statements,  is_get: false , is_set: false,
      is_yieldable: is_yieldable, is_async: is_async, single_exp: single_exp
   );
}

VariableDeclarationStatementImpl
astVar_DeclStatement(List<String> varnames, {String keyword, TType type, List<dynamic> values}){
   var variableList = astVarDeclList(varnames, keyword: keyword, type: type, values: values);
   return VariableDeclarationStatementImpl(variableList, tok_semi);
}

IfStatementImpl
astIfStatement(ExpressionImpl condition, StatementImpl then, StatementImpl Else){
   return IfStatementImpl (
      astKeyword('if'), tok_lp, condition, tok_rp, then, astKeyword('else'), Else
   );
}

StatementImpl
astBlockStatement(List<Statement> statements){
   return BlockImpl(tok_lb, statements, tok_rb);
}

CatchClauseImpl
astCatchClause(String exception_name , List<Statement> body){
   //incompleted:
   var on_kw = astKeyword('on');
   var catch_kw = astKeyword('catch');
   var exception_type = astNamedType(exception_name);
   var body_main = astBlockStatement(body);
   var exception_params = null;  //note:  what's this ??
   var stacktrace_params = null; //note:  what's this ??
   return CatchClauseImpl(on_kw, exception_type, catch_kw, tok_lp, exception_params, tok_comma, stacktrace_params, tok_rp, body_main);
}

TryStatementImpl
astTryStatement(List<Statement> body, List<Statement> finally_body, List<CatchClauseImpl> catch_clause){
   var try_kw = astKeyword('try');
   var final_kw = astKeyword('finally');
   var body_main = astBlockStatement(body);
   var body_finally = astBlockStatement(finally_body);
   return TryStatementImpl(try_kw, body_main, catch_clause, final_kw, body_finally);
}

class Typedef {

}

class Func {

}

/*
                                                                                ;
                                                                                ;
                                                                                ;
                              A S T    C L A S S                                ;
                                                                                ;
                                                                                ;
                                                                                ;
--------------------------------------------------------------------------------
*/

ExtendsClauseImpl
astExtendsClause(TType super_class){
   return ExtendsClauseImpl(astKeyword('extends'), super_class.named_type);
}

WithClauseImpl
astWithClause<T>(List<T> mixin_names){
   var mixins = T == String
         ? mixin_names.map((name) => astNamedType(name as String) ).toList()
         : T == TType
            ? mixin_names.map((type) => (type as TType).named_type ).toList()
            : (){throw Exception('Invalid Usage');}();
   return WithClauseImpl(astKeyword('with'), mixins);
}

ImplementsClauseImpl
astImplementClause<T>(List<T> interface_names){
   var interfaces = T == String
         ? interface_names.map((name) => astNamedType(name as String)).toList()
         : T == TType
            ? interface_names.map((type) => (type as TType).named_type ).toList()
            : (){throw Exception('Invalid Usage');}();
   return ImplementsClauseImpl(astKeyword('implements'), interfaces);
}

ClassDeclarationImpl
astClass<T>(String name,
        {List<Tuple<String, String>> type_params, CommentImpl comment, List<AnnotationImpl> metadata,
         String keyword, TType extends_clause, List<T> mixin_names, List<T> implements_clauses,
         List<FieldDeclarationImpl> fields, List<MethodDeclarationImpl> methods}){
   var ident = astIdent(name);
   var abstract_kw = (keyword == 'abstract')
         ? astKeyword('abstract')
         : null;
   var class_kw = astKeyword('class');
   var type_parameter = astTypeParams(type_params);
   var extends_ = extends_clause != null
         ? astExtendsClause(extends_clause)
         : null;
   var with_clause = mixin_names != null
         ? astWithClause(mixin_names)
         : null;
   var implements_ = implements_clauses != null
         ? astImplementClause(implements_clauses)
         : null;
   List<ClassMemberImpl> members = ((fields ?? methods) != null)
         ? List<ClassMemberImpl>.from(fields ?? []) + List<ClassMemberImpl>.from(methods ?? [])
         : null;
   return ClassDeclarationImpl(
      comment, metadata, abstract_kw, class_kw, ident, type_parameter, extends_,
      with_clause, implements_, tok_lb, members, tok_rb
   );
}


/*
                                                                                ;
                                                                                ;
                                                                                ;
                A S T    M E T H O D S    A N D    F U N C                      ;
                                                                                ;
                                                                                ;
                                                                                ;
--------------------------------------------------------------------------------
*/

AstNodeImpl
astRetType(TType ret_type){
   return ret_type != null
      ? ret_type.named_type ?? ret_type.generic_functype ?? ret_type.param_functype
      : null;
}

FunctionDeclarationImpl
_astFunc_Decl(TType ret_type, String name, List<Tuple> type_params, TArgList arguments,
             {List<Statement> statements, bool is_yieldable, bool is_async,
              ExpressionImpl single_exp, bool is_get, bool is_set, CommentImpl comment}){
   var metadata    = null;
   var extra_kw    = null;
   var prop_kw     = astPropKw(is_get:is_get, is_set:is_set);
   var return_type = astRetType(ret_type);
   var func_name   = astIdent(name);
   var body        = astClosureFunc(
      arguments, type_params,
      statements   : statements, single_exp   : single_exp,
      is_yieldable : is_yieldable, is_async   : is_async
   );
   return FunctionDeclarationImpl(
      comment, metadata, extra_kw, return_type, prop_kw,
      func_name, body
   );
}

FunctionDeclarationImpl
astExpFunc_GetDecl(TType ret_type, String name, List<Tuple> type_params, TArgList arguments,
                   {ExpressionImpl single_exp, bool is_yieldable, bool is_async}){
   return _astFunc_Decl(
      ret_type , name, type_params, arguments,
      single_exp: single_exp, is_yieldable: is_yieldable, is_async: is_async, is_get: true, is_set: false
   );
}
FunctionDeclarationImpl
astExpFunc_SetDecl(TType ret_type, String name, List<Tuple> type_params, TArgList arguments,
                   {ExpressionImpl single_exp, bool is_yieldable, bool is_async}){
   return _astFunc_Decl(
      ret_type , name, type_params, arguments,
      single_exp: single_exp, is_yieldable: is_yieldable, is_async: is_async, is_get: false, is_set: true
   );
}
FunctionDeclarationImpl
astFunc_GetDecl(TType ret_type, String name, TArgList arguments, List<Tuple> type_params,
                 {List<Statement> statements, bool is_yieldable, bool is_async}){
   return _astFunc_Decl(
      ret_type , name, type_params, arguments,
      statements: statements, is_yieldable: is_yieldable, is_async: is_async, is_get: true, is_set: false
   );
}

FunctionDeclarationImpl
astFunc_SetDecl(TType ret_type, String name, TArgList arguments, List<Tuple> type_params,
                 {List<Statement> statements, bool is_yieldable, bool is_async}){
   return _astFunc_Decl(
      ret_type , name, type_params, arguments,
      statements: statements, is_yieldable: is_yieldable, is_async: is_async, is_get: false, is_set: true
   );
}

FunctionDeclarationImpl
astFunc_Decl(TType ret_type, String name, TArgList arguments, List<Tuple> type_params,
              {List<Statement> statements, bool is_yieldable, bool is_async}){
   return _astFunc_Decl(
      ret_type , name, type_params, arguments,
      statements: statements, is_yieldable: is_yieldable, is_async: is_async, is_get: false, is_set: false
   );
}


ExpressionFunctionBodyImpl
astExpFunc_Body(ExpressionImpl expression, {bool is_async, bool is_terminated}){
   var kw = is_async == true
            ? astKeyword('async')
            : null;
   var def = tok_fn;
   var semicolon = is_terminated == true
                   ? tok_semi
                   : null;
   var body = ExpressionFunctionBodyImpl(kw, def, expression, semicolon);
   return body;
}

FunctionExpressionImpl
astExpFunc(TArgList arguments, List<Tuple<String, String>> type_params, {bool is_async,
           bool is_yieldable , ExpressionImpl single_exp, List<AnnotationImpl> metadata, bool is_terminated}){
   var body =  single_exp != null
               ? astExpFunc_Body(single_exp, is_terminated: is_terminated, is_async: is_async)
               : null;
   var parameters = astParamList(arguments, metadata: metadata);
   var type_parameter = astTypeParams(type_params);
   return FunctionExpressionImpl(type_parameter, parameters, body);
}

BlockFunctionBodyImpl
astFunc_Body(List<Statement> statements, {bool is_async, bool is_yieldable}){
   var kw = is_async == true
            ? astKeyword('async')
            : null;
   var star = kw == null
            ? null
            : is_yieldable == true
               ? tok_star
               : null;
   var block = BlockImpl(tok_lb, statements, tok_rb);
   return BlockFunctionBodyImpl(kw, star, block);
}

FunctionExpressionImpl
astClosureFunc(TArgList arguments, List<Tuple<String, String>> type_params, {ExpressionImpl single_exp,
               List<Statement> statements, bool is_async, bool is_yieldable,
               List<AnnotationImpl> metadata, bool is_terminated}){
   if (single_exp != null)
      return astExpFunc(
         arguments, type_params,
         is_async: is_async, is_yieldable: is_yieldable,
         single_exp: single_exp, is_terminated: is_terminated
      );
   
   if (statements != null){
      var body =   astFunc_Body(
         statements,
         is_yieldable: is_yieldable,
         is_async    : is_async
      );
      var parameters = astParamList(arguments, metadata: metadata);
      var type_parameter = astTypeParams(type_params);
      
      return FunctionExpressionImpl(type_parameter, parameters, body);
   }
   throw Exception('Invalid Usage, either expression or statements is required');
}

MethodDeclarationImpl
_astMethodFunc(TType ret_type, String name, List<Tuple<String, String>> type_params, TArgList arguments,
               {bool is_get, bool is_set, List<Statement> statements, bool is_yieldable, CommentImpl comment,
               bool is_async, bool is_static, bool is_abstract, List<AnnotationImpl> metadata}){
   var extra_kw        = null;
   var operator_kw     = null;
   var return_type     = astRetType(ret_type);
   var prop_kw         = astPropKw(is_get: is_get, is_set: is_set);
   var func_name       = astIdent(name);
   var type_parameters = astTypeParams(type_params);
   var parameters      = astParamList(arguments);
   var mod_kw          = is_static == true
         ? astKeyword('static')
         : is_abstract == true
            ? astKeyword('abstract')
            : null;
   
   var body = astFunc_Body(
      statements,
      is_async: is_async, is_yieldable: is_yieldable,
   );
   
   return MethodDeclarationImpl(
      comment, metadata, extra_kw, mod_kw, return_type, prop_kw, operator_kw,
      func_name, type_parameters, parameters, body
   );
}

MethodDeclarationImpl
astMethodFunc_SetDecl(TType ret_type, String name, List<Tuple> type_params, TArgList arguments,
                     {List<Statement> statements, List<String> keywords, List<AnnotationImpl> metadata}){
   var kws = _parseMethodDeclKWs(['set'] + keywords);
   return _astMethodFunc(
      ret_type   , name, type_params, arguments,
      //----------------------------------------
      is_get       : false      , is_set        : true       ,
      statements   : statements , is_yieldable  : kws.is_yield,
      is_async     : kws.is_async   , is_static : kws.is_static,
      is_abstract  : kws.is_abstract
   );
}

MethodDeclarationImpl
astMethodFunc_GetDecl(TType ret_type, String name, List<Tuple> type_params, TArgList arguments,
                     {List<Statement> statements, List<String> keywords, List<AnnotationImpl> metadata}){
   var kws = _parseMethodDeclKWs(['get'] + keywords);
   return _astMethodFunc(
      ret_type   , name, type_params, arguments,
      //----------------------------------------
      is_get       : true       , is_set        : false       ,
      statements   : statements , is_yieldable  : kws.is_yield,
      is_async     : kws.is_async   , is_static : kws.is_static,
      is_abstract  : kws.is_abstract
   );
}

MethodDeclarationImpl
astMethodFunc(TType ret_type, String name, List<Tuple> type_params, TArgList arguments,
             {List<Statement> statements, List<AnnotationImpl> metadata, List<String> keywords}){
   var kws = _parseMethodDeclKWs(  keywords);
   return _astMethodFunc(
      ret_type   , name, type_params, arguments,
      //----------------------------------------
      is_get       : false      , is_set        : false       ,
      statements   : statements , is_yieldable  : kws.is_yield,
      is_async     : kws.is_async   , is_static : kws.is_static,
      is_abstract  : kws.is_abstract
   );
}


/*
                                                                                ;
                                                                                ;
                                                                                ;
        A S T    A R G U M E N T S    A N D    P A R A M E T E R S              ;
                                                                                ;
                                                                                ;
                                                                                ;
--------------------------------------------------------------------------------
*/


/// pass:
///
/// Description:
///      Generate ast of type arguments which always represents type arguments
///      of an arbitrary named type. Which means it's only valid under the context
///      of named type, other context like GenericFunctionTypeImpl would be invalid.
///
/// Ex: - under valid contexts and invalid contexts
///   [V] SomeNamedType<String> :: astTypeArguments(['String']);
///   [V] SomeNamedType<>       :: astTypeArguments();
///
///   [X] void Function<A, B>(A a, B b) :: as mentioned above in description
///                                     :: only valid under the context of named type
///
/// [type_params]
///      could be null, since a TypeArgumentListImpl represents no type arguments
///
///
TypeArgumentListImpl
astTypeArguments<T>(List<T> type_params) {
   if (type_params == null) return null;
   if (T == String) {
      List<TypeAnnotation> type_ann = type_params.map((p) => astNamedType(p as String)).toList();
      return TypeArgumentListImpl(tok_castl, type_ann, tok_castr);
   } else if (T == TypeAnnotation) {
      return TypeArgumentListImpl(tok_castl, type_params as List<TypeAnnotation>, tok_castr);
   } else {
      throw UnsupportedArgumentsException (
         supported: ["List<String>", "List<TypeAnnotation>"],
         provided: type_params
      );
   }
}


TypeParameterImpl
_astTypeParam<T>(T pname, {CommentImpl comment, List<AnnotationImpl> metadata, T extend_super}){
   if (T == String){
      var name = astIdent(pname as String);
      var extends_kw = extend_super != null ? astKeyword('extends') : null;
      var bound = extend_super != null ? astNamedType(extend_super as String) : null;
      return TypeParameterImpl(comment, metadata, name, extends_kw, bound);
   }else if (T == TypeAnnotation || T == TypeAnnotationImpl){
      var name = astIdent((pname as TypeAnnotationImpl).toString());
      var extends_kw = extend_super != null ? astKeyword('extends') : null;
      var bound = extend_super != null ? astNamedType(extend_super.toString()) : null;
      return TypeParameterImpl(comment, metadata, name, extends_kw, bound);
   }else{
      throw Exception('Invalid Usage');
   }
   
}

//pass:
///
/// Description:
///      Generate ast of type parameters represents type parameters
///      of GenericFunctionType or MethodDeclarationType. Which means it's only
///      valid under those contexts, other context like TypeNameImpl would not
///      be valid. Since TypeParameterListImpl allows extends clauses, TypeNameImpl
///      does not.
///
/// Ex - valid contexts and invalid contexts:
///
///   [V] void Function<T>(T a, String b) :: astTypeParams(['T'])
///   [V] bool condition<T>(T data) { }   :: astTypeParams(['T'])
///
///   [X] List<T> :: use astTypeArguments instead
///
/// [type_params]
///      could be null, since a TypeParameterListImpl represents no type arguments
///
TypeParameterListImpl
astTypeParams(List<Tuple<String, String>> type_params, {CommentImpl comment, List<AnnotationImpl> metadata}) {
   if (type_params == null) return null;
   var first =  type_params.first;
   if (first.key is String ) {
      List<TypeParameterImpl> type_ann = (type_params)
         .map((Tuple p) => _astTypeParam(
               p.key as String,
               comment: comment, metadata: metadata,
               extend_super: p.value != null ? p.value as String : null
            ))
         .toList();
      return TypeParameterListImpl(tok_castl, type_ann, tok_castr);
   } /*
   else if (first.key is TypeAnnotation) {
      List<TypeParameterImpl> type_ann = (type_params )
         .map((Tuple p) => _astTypeParam(
                  p.key as TypeAnnotation,
                  comment: comment, metadata: metadata,
                  extend_super: p.value != null ? p.value as TypeAnnotation : null
             ))
         .toList();
      return TypeParameterListImpl(tok_castl, type_ann, tok_castr);
   }*/ else {
      throw UnsupportedArgumentsException(
         supported: ["List<String>", "List<TypeAnnotation>"],
         provided: type_params
      );
   }
}


// pass:
ArgumentListImpl
astArgumentsList<T>(List<T> arguments){
   if(arguments == null) return null;
   var lt = tok_castl;
   var rt = tok_castr;
   if (T == String){
      return ArgumentListImpl(lt, arguments.map((arg) => astElement(arg)).toList(), rt);
   }else if (T == TArg){
     return ArgumentListImpl (lt,
        (arguments as List<TArg>).map((p) {
            return astNamedArgExp(p.arg_name, p.arg_value);
         }).toList(),
        rt
     );
   }else{
      throw Exception('Invalid Usage');
   }
}



const VAR_DECL_KEYWORDS    = ['final', 'const', 'var'];
const FIELD_DECL_KEYWORDS  = ['final', 'const', 'var', 'static', 'external'];
const METHOD_DECL_KEYWORDS = ['static', 'external', 'abstract', 'get', 'set', 'async', 'async*'];


_assertVarDecl(List<String> varnames, String keyword,  List<dynamic> values){
   if (keyword != null) assert(VAR_DECL_KEYWORDS.contains(keyword));
   if (values  != null) assert(varnames.length == values.length);
}


TKwMethod
_parseMethodDeclKWs(List<String> keywords){
   assert(IS.union(METHOD_DECL_KEYWORDS, keywords), 'Invalid keyword in keywords: $keywords');
   var is_static   = keywords.contains('static');
   var is_external = keywords.contains('external');
   var is_abstract = keywords.contains('abstract');
   
   var is_get      = keywords.contains('get');
   var is_set      = keywords.contains('set');
   var is_async    = keywords.contains('async');
   var is_yield    = keywords.contains('async*');
   
   if ((is_get || is_get) == true) assert(is_get != is_set);
   
   return TKwMethod (
      is_external: is_external,
      is_get: is_get, is_set: is_set, is_abstract: is_abstract,
      is_async: is_async, is_yield: is_yield, is_static: is_static
   );
}

TKwField
_assertFieldDeclKWs(List<String> keywords){
   assert( IS.union(FIELD_DECL_KEYWORDS, keywords)  , 'Invalid keyword in keywords: $keywords' );
   
   var is_final    = keywords.contains('final');
   var is_const    = keywords.contains('const');
   var is_var      = keywords.contains('var');
   var is_static   = keywords.contains('static');
   var is_external = keywords.contains('external');
   
   return TKwField(
      is_final: is_final, is_const:  is_const, is_var: is_var, is_static: is_static,
      is_external: is_external
   );
}

class TKwField{
   bool is_const;
   bool is_var;
   bool is_final;
   bool is_static;
   bool is_external;
   
   TKwField({this.is_const, this.is_var, this.is_final, this.is_static, this.is_external});
   
   static TKwField
   parse(List<String> keywords){
      return _assertFieldDeclKWs(keywords);
   }
}

class TKwMethod{
   bool is_get;
   bool is_set;
   bool is_async;
   bool is_yield;
   bool is_abstract;
   bool is_static;
   bool is_external;
   
   TKwMethod({this.is_get, this.is_set, this.is_abstract, this.is_async,
              this.is_static, this.is_yield, this.is_external});
   
   static TKwMethod
   parse(List<String> keywords){
      return _parseMethodDeclKWs(keywords);
   }
}



// pass:
FormalParameterListImpl
astParamList(TArgList params, {List<AnnotationImpl> metadata, CommentImpl comment}){
   if (params == null) return null;
   var l_parenthesis     = Token(TokenType.OPEN_PAREN, 0);
   var r_parenthesis     = Token(TokenType.CLOSE_PAREN, 0);
   Token l_square          = null;
   Token r_square          = null;
   var keyword           = null;
   var covariant_keyword = null;
   var parameters = params.list.map((p) {
      var identifier = astIdent(p.arg_name);
      var type       = p.arg_typ != null
                       ? p.arg_typ.named_type
                       : null;
      FormalParameterImpl ret;
      if (p.position_optional == true || p.named_optional == true){
         var parameter  = SimpleFormalParameterImpl(comment, metadata, covariant_keyword, keyword, type, identifier);
         var kind       = p.named_optional == true
              ? ParameterKind.NAMED
              : ParameterKind.POSITIONAL;
         var defaults   = astElement(p.arg_value);
         var eq         = p.arg_value == null
              ? null
              : tok_eq;
         ret = DefaultFormalParameterImpl(parameter, kind, eq, defaults);
      }else{
         ret = SimpleFormalParameterImpl(comment, metadata, covariant_keyword, keyword, type, identifier);
      }
      return ret;
   }).toList();
   if (params.optional_offset_l != null){
      l_square = Token(TokenType.OPEN_SQUARE_BRACKET, params.optional_offset_l);
      r_square = Token(TokenType.CLOSE_SQUARE_BRACKET, params.optional_offset_r);
   }
   return FormalParameterListImpl(l_parenthesis, parameters, l_square, r_square, r_parenthesis);
}


/*                                                                              ;
                                                                                ;
                                                                                ;
                                                                                ;
    A S T    B A S I C    T Y P E S    A N D    I D E N T S / T O K E N S       ;
                                                                                ;
                                                                                ;
                                                                                ;
                                                                                ;
--------------------------------------------------------------------------------
*/

//pass:
SimpleIdentifierImpl
astIdent(String name) {
   var token = KEYWORDS.contains(name)
      ? KeywordToken(Keyword.values.where((v) => v.lexeme == name).first, 0)
      : Token(TokenType(name, _tok_ident.name, _tok_ident.precedence, _tok_ident.kind), 0);
   return SimpleIdentifierImpl(token);
}

//pass:
KeywordToken
astKeyword(String name){
   return astIdent(name).childEntities.where((syn) => syn is KeywordToken).first;
}

//pass:
IntegerLiteralImpl
astInt(int value) {
   var tok = TokenType(value.toString(), TokenType.INT.name, TokenType.INT.precedence, TokenType.INT.kind);
   var literal = Token(tok, 0);
   return IntegerLiteralImpl(literal, value);
}

//pass:
StringLiteralImpl
astString(String value) {
   var tok = TokenType("'$value'", TokenType.STRING.name, TokenType.STRING.precedence, TokenType.STRING.kind);
   var literal = Token(tok, 0);
   return SimpleStringLiteralImpl(literal, value);
}
//pass:
DoubleLiteralImpl
astDouble(double value) {
   var tok = TokenType(value.toString(), TokenType.DOUBLE.name, TokenType.DOUBLE.precedence, TokenType.DOUBLE.kind);
   var literal = Token(tok, 0);
   return DoubleLiteralImpl(literal, value);
}

//pass:
ListLiteralImpl
astList<T>(List<T> value) {
   var const_kw = null;
   var begin_tok = tok_lsb;
   var end_tok = tok_rsb;
   var type_args = inferTypeArgs(value);
   var elements = (T == AstNode) || (T == SyntacticEntity)
                  ? value
                  : value.map((v) => astElement(v) as ExpressionImpl).toList();
   _log.log('[astList] typeargs: $type_args');
   return ListLiteralImpl(const_kw, type_args, begin_tok, elements, end_tok);
}

//pass:
MapLiteralEntryImpl
astMapEntry(key, value) {
   var k = (key is AstNode) || (key is SyntacticEntity)
           ? key
           : astElement(key);
   var v = (value is AstNode) || (value is SyntacticEntity)
           ? value
           : astElement(value);
   return MapLiteralEntryImpl(k, Token(TokenType.COLON, 0), v);
}

//pass:
MapLiteralImpl
astMap(Map value) {
   var const_kw = null;
   var type_args = inferTypeArgs(value);
   var left = tok_lb;
   var right = tok_rb;
   var entries = value
      .map((k, v) => MapEntry(k, v))
      .entries
      .toList();
   return MapLiteralImpl(
      const_kw,
      type_args,
      left,
      entries.map((e) => astMapEntry(e.key, e.value)).toList(),
      right
   );
}


ListLiteralImpl
astSet(List value) {
   return astList(value);
}

BooleanLiteralImpl
astBool(bool value){
   return BooleanLiteralImpl(astKeyword(value.toString()), value);
}

//pass:
AstNode
astElement<T>(T element) {
   if (element is String) {
      return astString(element);
   } else if (element is int) {
      return astInt(element);
   } else if (element is double) {
      return astDouble(element);
   } else if (element is num) {
      /*if (IS.Int(value)) return inferSimpleIdent( value as int);
   if (IS.Num(value)) return inferSimpleIdent( value as double);*/
      throw Exception('Uncaught Exception');
   } else if (element is List) {
      return astList(element);
   } else if (element is Map) {
      return astMap(element);
   } else if (element is bool) {
      return astBool(element);
   } else if (element is AstNode) {
      return element;
   } else if (element == null){
      return astFactory.nullLiteral(tok_null);
   } else if (element is SyntacticEntity) {
      return element as AstNode;
   }  else {
      return astIdent(element.toString());
   }
}

MethodInvocationImpl
astInvoke(String method_name, List arg_list, [String target_name, List type_params]){
   var target = target_name == null ? null : astIdent(target_name);
   var operator = target_name == null ? null : tok_dot;
   var methodName = astIdent(method_name);
   return MethodInvocationImpl(target, operator, methodName, astTypeArguments(type_params), astArgumentsList(arg_list));
}



//pass:
/*
   [EX]
      to generate this.temp.obj
      => asProcAccs(['this', 'temp', 'obj'])
      to generate TestCase.test.name
      => asProcAccs(['TestCase', 'test', 'name'])
*/
PREFIX_OR_ACCS
astPropAccs<PREFIX_OR_ACCS extends ExpressionImpl>(List<String> value) {
   ExpressionImpl target;
   SimpleIdentifierImpl propname;
   var op = tok_dot;
   var head = FN.head(value);
   var last = FN.last(value);
   if (head.first == THIS) {
      target = head.length > 1
         ? astPropAccs(head)
         : ThisExpressionImpl(tok_this);
      propname = astIdent(last);
      return PropertyAccessImpl(target, op, propname) as PREFIX_OR_ACCS;
   } else {
      if (head.length <= 1) {
         return PrefixedIdentifierImpl(astIdent(head.first), op, astIdent(last)) as PREFIX_OR_ACCS;
      } else {
         target = astPropAccs(head);
         propname = astIdent(last);
         return PropertyAccessImpl(target, op, propname) as PREFIX_OR_ACCS;
      }
   }
}

//pass:
/// [name]        type name represents for a type
/// [type_params] could be null if no type parameters
/*
   [EX]
      List<String> :: astNamedType('List', ['String'])
      String       :: astNamedType('String')
*/
TypeNameImpl
astNamedType(String name, [List<String> type_params]) {
   var typename, typeargs ;
   typename = astIdent(name);
   typeargs = type_params != null
        ? astTypeArguments(type_params)
        : null;
   var ret = TypeNameImpl(typename, typeargs);
   return ret;
}

//pass: bool Function(String a,...)
GenericFunctionTypeImpl
astGenericTypeFunc({List<Tuple<String, String>> funcType_params,
                    TArgList arguments, TType func_retType}){
   var func_kw  = astKeyword('Function');
   var ret_type = func_retType != null
         ? func_retType.named_type
            ?? func_retType.generic_functype
            ?? func_retType.param_functype
         : null;
   var type_params  = astTypeParams(funcType_params);
   var parameters   =  astParamList(arguments);
   return GenericFunctionTypeImpl(ret_type, func_kw, type_params, parameters);
}

//pass: bool condition(a, ...)
FunctionTypedFormalParameterImpl
astInlineParamTypeFunc(String func_name, {List<Tuple<String, String>>  funcType_params,
                       TArgList arguments, TType func_retType, CommentImpl comment}){
   var metadata = null;
   var covariantKeyword = null;
   var ret_type = func_retType != null
         ? func_retType.named_type
            ?? func_retType.generic_functype
            ?? func_retType.param_functype
         : null;
   var parameters = astParamList(arguments);
   var identifier = astIdent(func_name);
   var type_params  = astTypeParams(funcType_params);
   return FunctionTypedFormalParameterImpl(comment, metadata, covariantKeyword, ret_type, identifier, type_params, parameters);
}

//pass:
AstNodeImpl
astTypeFunc({String func_name, List<Tuple>  funcType_params ,
               TArgList arguments, TType func_retType}) {
   if (func_name == 'Function' || func_name == null) {
      // since GenericFunctionType e.g. "void Function()" cannot use inline parameters
      // as function type definition but allows generic function type definitions:
      // e.g. "bool condition(a) Function(a)" is not valid
      // e.g. "void Function() Function(a) is valid
      return astGenericTypeFunc(
         func_retType: func_retType ,
         arguments: arguments, funcType_params: funcType_params
      );
   }else{
      return astInlineParamTypeFunc(
         func_name,
         func_retType: func_retType,
         arguments: arguments, funcType_params: funcType_params
      );
   }
}

//pass:
///
/// Description:
///      Generate ast of following three types of definitions
///      1) NamedType                     :: astNamedType
///      2) GenericFunctionType           :: astGenericFuncType
///      3) FunctionTypeFormalParameter   :: astInlineParamFuncType
///
/// EX: - to generate NamedType
///      String         :: astType(name: 'String')
///      List<String>   :: astType(name: 'List', namedType_params: ['String'])
///
/// EX: - to generate GenericFuncType
///      void Function(String a) :: astType(func_name: 'Function' or null, funcType_params..
///
/// EX: - to generate Function type as inline formal parameter
///      bool condition(a)  ::  astType()
///
/// [type_params]
///      could be null, since a TypeArgumentListImpl represents no type arguments
///
AstNodeImpl
astType({String name, List<String> namedType_params, String func_name,
         List<Tuple> funcType_params, TArgList arguments, TType func_retType}){
   if (name != null){
      if (func_name != null || funcType_params != null || arguments != null)
         throw Exception('Obscure usage');
      return astNamedType(name, namedType_params);
   }else{
      if (name != null || namedType_params != null)
         throw Exception('Obscure usage');
      return astTypeFunc(
         func_name: func_name ,funcType_params: funcType_params,
         arguments: arguments, func_retType: func_retType
      );
   }
}

KeywordToken
astPropKw({bool is_get, bool is_set}) {
   return is_get == true
       ? astKeyword('get')
       : is_set == true
         ? astKeyword('set')
         : null;
}


// pass:
VariableDeclarationListImpl
astVarDeclList(List<String> varnames, {String keyword, TType type, List<dynamic> values, CommentImpl comment, List<AnnotationImpl> metadata}) {
   _assertVarDecl(varnames, keyword, values);
   var variables;
   var kw  = keyword == null
            ? null
            : KeywordToken(Keyword.values.where((k) => k.lexeme == keyword).first, 0);
   var typ = type == null
             ? null
             : type.named_type ?? type.generic_functype ?? type.param_functype;
   if (varnames != null){
      values  ??= List.generate(varnames.length, (i) => null);
      variables = FN.zip([varnames, values]).map((v) => astVarDecl(v[0] , value: v[1])).toList();
   }
   return VariableDeclarationListImpl(comment, metadata, kw, typ, variables);
}

// pass:
VariableDeclarationImpl
astVarDecl(String varname, {dynamic value}) {
   var name = astIdent(varname);
   var initializer = value != null ? astElement(value) : null;
   var equals      = value != null ? tok_eq : null;
   return VariableDeclarationImpl(name, equals, initializer);
}

AnnotationImpl
astMeta(String metaname, List<TArg> args){
   var at = tok_at;
   var name = astIdent(metaname);
   var period = null;
   var constructor_name = null;
   var arguments = astArgumentsList(args);
   return AnnotationImpl(at, name, period, constructor_name, arguments);
}

FieldDeclarationImpl
astSimpleField<E>(String ident_name, TypeAnnotationImpl type, [E element]){
   element ??= null;
   var defaults = element == null ? null : astElement<E>(element);
   var decl = astVarDecl(ident_name, value: defaults);
   var field_list = astFactory.variableDeclarationList(null, null, null, type, [decl]);
   return astFactory.fieldDeclaration2(
      fieldList: field_list, semicolon: tok_semi
   );
}


/*
*
*                                 C O M M E N T
*
* */
CommentReference
astCommentRef(String ident, {String new_kw}){
   var new_keyword = new_kw != null ? astKeyword('new') : null;
   var identifier  = astIdent(ident);
   return CommentReferenceImpl(new_keyword, identifier);
}

CommentImpl
_astComment(List<String> comments, bool multiline, CommentType comment_type, {List<CommentReference> refs}){
   var tok_typ = multiline == true ? TokenType.MULTI_LINE_COMMENT : TokenType.SINGLE_LINE_COMMENT;
   var toks = comments.map((comment) => CommentToken(tok_typ, comment, 0)).toList();
   return CommentImpl(toks, comment_type, refs);
}

CommentImpl
astLineComment(List<String> comments, {List<CommentReference> refs, bool multiline}){
   return _astComment(comments, multiline, CommentType.END_OF_LINE, refs: refs);
}

CommentImpl
astDocComment(List<String> comments, {List<CommentReference> refs, bool multiline}){
   return _astComment(comments, multiline, CommentType.DOCUMENTATION, refs: refs);
}

CommentImpl
astBlockComment(List<String> comments, {List<CommentReference> refs, bool multiline}){
   return _astComment(comments, multiline, CommentType.BLOCK, refs: refs);
}

CommentImpl
astComment(List<String> comments, CommentType comment_type, {List<CommentReference> refs, bool multiline}){
   if (comment_type == CommentType.DOCUMENTATION)
      return astDocComment(comments, refs: refs, multiline: multiline);
   else if (comment_type == CommentType.END_OF_LINE)
      return astLineComment(comments, refs: refs, multiline: multiline);
   else if (comment_type == CommentType.BLOCK)
      return astBlockComment(comments, refs: refs, multiline: multiline);
   else throw Exception('Invalid Usage');
}



// pass:
/*
   inferring a non-ast type into an ast type
*/
ExpressionImpl
inferSimpleIdent(dynamic value) {
   if (value is String) {
      return astString(value);
   } else if (value is int) {
      return astInt(value);
   } else if (value is double) {
      return astDouble(value);
   } else if (value is num) {
      /*if (IS.Int(value)) return inferSimpleIdent( value as int);
      if (IS.Num(value)) return inferSimpleIdent( value as double);*/
      throw Exception('Uncaught Exception');
   } else {
      return astIdent(value.toString());
   }
}

// pass:
TypeArgumentListImpl
inferSimpleTypeArgs(dynamic arg, {String output, TypeArgumentListImpl node, int level = 0}) {
   var typename = '';
   output ??= '';
   if (arg == null) {
      typename = DYNAMIC;
   } else if (arg is String) {
      typename = STRING;
   } else if (arg is int) {
      typename = INT;
   } else if (arg is double) {
      typename = DOUBLE;
   } else if (arg is num) {
      typename = NUM;
   } else {
      typename = arg.toString();
   }
   output = _closeTypeArg(output, typename, level);
   if (node != null)
      node.arguments.add(astNamedType('$typename'));
   node ??= astTypeArguments([typename]);
   return node;
}
// pass:
String
_closeTypeArg(String output, String argname, int level) {
   return output + '<$argname' + '>' * level;
}
// pass:
TAstInfer
inferListTypeArgs<T>(List<T> args, {String output, int level = 0, TypeArgumentListImpl node}) {
   output ??= 'List';
   var type = args.length > 0
              ? args.first
              : null;
   var is_dynamic_elements = !args.every((arg) => type.runtimeType == arg.runtimeType);
   if (is_dynamic_elements) {
      level += 1;
      output = _closeTypeArg(output, Keyword.DYNAMIC.lexeme, level);
      if (node != null)
         node.arguments.add(astNamedType(Keyword.DYNAMIC.lexeme));
      node ??= astTypeArguments([Keyword.DYNAMIC.lexeme]);
   } else {
      if (type is List) {
         output += '<List';
         if (node != null)
            node.arguments.add(astNamedType('List'));
         node ??= astTypeArguments(['List']);
         level += 1;
         _log.log('[inferListTyplist type args founded');
         inferListTypeArgs(type, output: output, level: level, node: node);
      } else if (type is Map) {
         level += 1;
         inferMapTypeArgs(type, output: output, level: level, node: node);
      } else {
         level += 1;
         _log.log('general type args founded');
         node = inferSimpleTypeArgs(type, output: output, level: level, node: node);
      }
   }
   
   return TAstInfer(output: output, node: node);
}
// pass:
TAstInfer
inferMapTypeArgs<K, V>(Map<K, V> args, {String output, int level = 0, TypeArgumentListImpl node}) {
   output ??= 'Map';
   var ktype = args.keys.length > 0
         ? args.keys.first
         : null;
   var vtype = args.values.length > 0
         ? args.values.first
         : null;
   var is_dynamic_keys   = !args.keys.every((arg) => ktype.runtimeType == arg.runtimeType);
   var is_dynamic_values = !args.values.every((arg) => vtype.runtimeType == arg.runtimeType);
   var klevel            = level;
   var vlevel            = level;
   
   void infer(type, int xlevel) {
      if (type is List) {
         xlevel += 1;
         inferListTypeArgs(type, output: output, level: xlevel, node: node);
      } else if (type is Map) {
         output += '<Map';
         if (node != null)
            node.arguments.add(astNamedType('Map'));
         node ??= astTypeArguments(['Map']);
         xlevel += 1;
         inferMapTypeArgs(type, output: output, level: xlevel, node: node);
      } else {
         xlevel += 1;
         node = inferSimpleTypeArgs(type, output: output, level: xlevel, node: node);
      }
   }
   if (is_dynamic_keys) {
      klevel += 1;
      output = _closeTypeArg(output, DYNAMIC, klevel);
      if (node != null)
         node.arguments.add(astNamedType(DYNAMIC));
      node ??= astTypeArguments([DYNAMIC]);
   } else {
      infer(ktype, klevel);
   }
   
   output += ',';
   if (is_dynamic_values) {
      vlevel += 1;
      output = _closeTypeArg(output, DYNAMIC, vlevel);
      if (node != null)
         node.arguments.add(astNamedType(DYNAMIC));
      node ??= astTypeArguments([DYNAMIC]);
   } else {
      infer(vtype, vlevel);
   }
   return TAstInfer(output: output, node: node);
}

TypeArgumentListImpl
inferTypeArgs<T>(T args) {
   if (args is Map) {
      return inferMapTypeArgs(args).node;
   } else if (args is List) {
      return inferListTypeArgs(args).node;
   } else {
      throw Exception('Invalid argument type, only support for infering type '
         'argumetns of List and Map');
   }
}




/*


               a s t    c o n v e r t e r s





*/

MethodInvocationImpl
astAnnotationToInvocation(AnnotationImpl ann){
   var type_args = null;
   var args = ann.arguments;
   var operator = ann.period;
   var target = ann.name;
   var method_name = ann.constructorName;
   return astFactory.methodInvocation(target, operator, method_name, type_args, args);
}






/*
                                                                                ;
                                                                                ;
                                                                                ;
          1)          F I E L D S    G E N E R A T O R S                        :
          2)          C L A S S      G E N E R A T O R S                        :
          3)        M E T H O D S    G E N E R A T O R S                        :
                                                                                ;
                                                                                ;
                                                                                ;
--------------------------------------------------------------------------------
*/



abstract class BaseAstDeclGenerator<E, N> {
   E parser;
   N result;
}





class Printable<T extends AstNodeImpl>{
   T _result;
  toString() {
      return _result.toSource();
  }
}
/*
[(FieldDeclarationImpl)
   [(KeywordToken) static]
   [(VariableDeclarationListImpl)
      [(TypeNameImpl)
         [(SimpleIdentifierImpl)
            [(StringToken) String]]]
      [(VariableDeclarationImpl)
         [(DeclaredSimpleIdentifier)
            [(StringToken) pure_static_field]]]]
   [(SimpleToken) ;]]
   
*/





/*



         following codes
         B A D    D E S I G N




*/


final UNDEFINED_FIELD_TYPE = TType();

bool isTerminated(AstNode node){
   var last = node.childEntities.last;
   return last is SimpleToken && last.lexeme == ';';
}

abstract class BaseCodegen <T extends AstNode>{
   T _result;
   List<AnnotationImpl> metadata;
   List<String> keywords;
   List<String> comments;
   T
   get result{
      if (_result == null) _generate();
      return _result;
   }
   addName(String name);
   addMeta(String metaname, List<TArg> args){
      metadata ??= [];
      metadata.add(astMeta( metaname,  args));
   }
   addKeywords(List<String> keywords);
   addComment(List<String> comments){
      this.comments ??= [];
      this.comments.addAll(comments);
   }
   _generate();
   _update(){
      _result = null;
   }
}


abstract class _Generatable<E extends AstNodeImpl> {
   E _result;
   E
   get result {
      if (_result == null) _generate();
      return _result;
   }
   _assertRequiredFields(){}
   _generate(){}
   _update() {
    _result = null;
  }
  toString() {
      return _result.toSource();
  }
}

abstract class _Annotatable<E extends AstNodeImpl> {
   E _result;
   List<AnnotationImpl> metadata;
   addMeta(String metaname, List<TArg> args){
      _result = null;
      metadata ??= [];
      metadata.add(astMeta( metaname,  args));
   }
}

abstract class _FieldKeyword<E extends AstNodeImpl> {
   List<String> keywords;
   bool is_const = false;
   bool is_final = false;
   bool is_var = false;
   bool is_static = false;
   E    _result;
   
   get decl_kw {
      return keywords?.contains('var') ?? false
            ? 'var'
            : keywords?.contains('const') ?? false
               ? 'const'
               : keywords?.contains('final') ?? false
                  ? 'final'
                  : null;
   }
   get field_kw {
      return keywords.contains('static')
         ? 'static'
         : null;
   }
   addKeywords(List<String> keys){
      _result = null;
      keywords ??= [];
      keywords.addAll(keys);
      if (keys.contains('var'))
         is_var = true;
      if (keys.contains('const'))
         is_const = true;
      if (keys.contains('final'))
         is_final = true;
      if (keys.contains('static'))
         is_static = true;
   }
}
abstract class _MethodKeyword<E extends AstNodeImpl> {
   List<String> keywords;
   bool is_yieldable;
   bool is_async;
   bool is_abstract;
   bool is_static;
   bool is_getter;
   bool is_setter;
   bool is_external;
   E _result;
   
   addKeywords(List<String> keys){
      _result = null;
      keywords ??= [];
      keywords.addAll(keys);
      if (keys.contains('get'))
         is_getter = true;
      if (keys.contains('set'))
         is_setter = true;
      if (keys.contains('async'))
         is_async = true;
      if (keys.contains('async*'))
         is_yieldable = true;
      if (keys.contains('abstract'))
         is_abstract = true;
      if (keys.contains('static'))
         is_static = true;
      if (keys.contains('external'))
         is_external = true;
   }
}

abstract class _ClassKeyword<E extends AstNodeImpl> {
   String          keyword;
   bool            is_abstract;
   E              _result;
   
   addKeyword(String key){
      _result = null;
      if (key == 'abstract')
         is_abstract = true;
      else
         throw Exception('Unsupported keyword: $key');
   }
}

abstract class _Decl<E extends AstNodeImpl> with _Annotatable<E> {
   List<String> identifiers;
   TType  type;
   List<dynamic> defaults;
   List<String> comments;
   CommentType comment_type;
   addComment(List<String> comments, CommentType type){
      _result = null;
      this.comment_type = type;
      this.comments ??= [];
      this.comments.addAll(comments);
   }
}

class _IsADecl<E extends AstNodeImpl> extends _Decl<E>{
   addType(TType type){
      _result = null;
      this.type = type;
   }
   addName(String name){
      _result = null;
      identifiers ??= [name];
   }
}

class _IsDeclList<E extends AstNodeImpl> extends _Decl<E>{
   addType(TType type){
      _result = null;
      this.type = type;
   }
   addNames(List<String> names){
      _result = null;
      identifiers ??= [];
      identifiers.addAll(names);
   }
}



class FieldGen<E extends FieldDeclarationImpl>
                 extends _IsDeclList<E> with _FieldKeyword<E>, _Generatable<E>{
   List<dynamic> defaults;
   
   @override
   _generate(){
      if (_result != null) return _result;
      _assertRequiredFields();
      var covariant_kw = null;
      var static_kw    = is_static == true
            ? astKeyword('static')
            : null;
      var field_list = astVarDeclList(identifiers, keyword: decl_kw, type: type, values: defaults);
      var comment    = comments != null ? astComment(comments, comment_type) : null;
      _result        = FieldDeclarationImpl(comment, metadata, covariant_kw, static_kw, field_list, tok_semi) as E;
      return _result;
   }
   @override
   _assertRequiredFields(){
      assert(identifiers != null,  'field variables not set');
      if (!is_static || (!is_var && !is_const && !is_final))
         assert(type != null, 'field type not set');
   }
   
   addDefault(dynamic value){
      _result = null;
      defaults ??= [];
      defaults.add(value);
   }
}


class MethodGen<E extends MethodDeclarationImpl>
                  extends _IsADecl<E> with _MethodKeyword<E>, _Generatable<E>{
   ExpressionImpl single_exp;
   TArgList arguments;
   List<Tuple> type_params;
   List<Statement> statements;
   TType ret_type;
   
   @override
   addType(TType name);
   
   @override
   _assertRequiredFields(){
      assert(identifiers != null,  'method name not set');
   }
   
   @override
   _generate(){
      arguments.init();
      _result = _astMethodFunc(
         ret_type, identifiers[0], type_params, arguments,
         statements : statements , is_yieldable : is_yieldable,
         is_async   : is_async   , is_static    : is_static,
         is_abstract: is_abstract, metadata     : metadata,
         is_set     : is_setter  , is_get       : is_getter,
      );
   }
   
   addTypeParams(List<Tuple> type_params){
      _update();
      this.type_params = type_params;
   }
   
   addStatement(List<Statement> statement){
      _update();
      statements ??= [];
      statements.addAll(statement);
   }
   
   addRetType(TType ret_type){
      _update();
      this.ret_type = ret_type;
   }
   
   addArguments(TArgList arguments){
      _update();
      this.arguments ??= TArgList();
      this.arguments.list.addAll(arguments.list);
   }
}


class ClassGen<E extends ClassDeclarationImpl>
                 extends _IsADecl<E> with _ClassKeyword<E> , _Generatable<E>{
   List<MethodGen> methods;
   List<FieldGen>  fields;
   TType           extends_clause;
   List<TType>     mixin_names;
   List<TType>     implement_clauses;
   List<Tuple<String, String>> type_params;
   
   
   addField(List<FieldGen> fields){
      fields ??= [];
      fields.addAll(fields);
   }
   
   addMethod(List<MethodGen> methods){
      methods ??= [];
      methods.addAll(methods);
   }
   
   @override
   addType(TType name);
   
   addTypeParam(List<String> type_params, List<String>param_supers){
      this.type_params  = FN.zip([
         type_params,
         param_supers ?? List.generate(type_params.length, (p) => null)
      ]).map((pair) =>
         Tuple(pair[0], pair[1])
      ).toList();
   }
   
   addClauses<E> ({E extends_clause, List<E> implements_clause, List<E> mixin_names}) {
      if (E != Tuple && E != TType)
         throw Exception("Invalid Usage");
      if (extends_clause != null){
              if (extends_clause is TType)
                  this.extends_clause  = extends_clause;
         else if (extends_clause is Tuple )
                  this.extends_clause  = TType(
                     name: extends_clause.key, namedType_params: extends_clause.value
                  );
      }
      
      if (implements_clause != null){
              if (implements_clause is List<TType>)
                  this.implement_clauses = implements_clause as List<TType>;
         else if (implements_clause is List<Tuple>)
                  this.implement_clauses = (implements_clause as List<Tuple>)
                     .map((imp) => TType(
                        name: imp.key, namedType_params: imp.value
                     )).toList();
      }
      
      if (mixin_names != null){
              if (mixin_names is List<TType>)
                  this.mixin_names  = mixin_names as List<TType>;
         else if (mixin_names is List<Tuple>)
                  this.mixin_names  = (mixin_names as List<Tuple>)
                     .map((imp) => TType(
                        name: imp.key, namedType_params: imp.value
                     )).toList();
      }
   }
   
   @override
   _update(){
      _result = null;
   }
   
   @override
  _assertRequiredFields() {
      assert(identifiers != null && identifiers.length == 1);
      if (comments != null)
         assert(comment_type != null);
  }
   
   @override
   _generate(){
      _assertRequiredFields();
      var comment = comments != null ? astComment(comments, comment_type) : null;
      var name = this.identifiers[0];
      _result = astClass(
         name,
         type_params   : type_params,     mixin_names        : mixin_names,
         extends_clause: extends_clause,  implements_clauses : implement_clauses,
         keyword       : keyword,         comment            : comment, metadata: metadata,
         methods       : methods?.map((method) => method.result)?.toList(),
         fields        : fields?.map((field)=>field.result)?.toList(),
      );
   }
}


//@fmt:on

