import 'dart:io';

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/standard_ast_factory.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:astMacro/src/common.dart' show FN;
import 'package:front_end/src/scanner/token.dart'
   show BeginToken, CommentToken, KeywordToken, SimpleToken, StringToken;
import 'package:quiver/collection.dart' show DelegatingMap;
import 'package:analyzer/src/dart/ast/ast.dart';
import './ast.parsers.dart';
import './ast.vue.annotation.dart';
import './common.log.dart' show Logger, ELevel;


final _log = Logger(name: "io.glob", levels: [ELevel.critical, ELevel.error, ELevel.warning, ELevel.debug]);


/*
         Transform TODO List

   [ ]   Type x = value
         >>
            Type get x         { return $data.sum; }
            void set x(Type v) { set_sum(v); }
            void set_sum(Type new_v, [Type old_v]) { $data.sum = new_v }
   
   [ ]   >>
            P $props = _Props() as P;
            D $data  = _Data() as D;
   
   [ ]   @Props()
         Type x = value;
         >>
            Type get x => $props.x
         
   [ ]

*/



/*


             D A T A   T Y P E S



 */

class Dict<T> extends DelegatingMap<String, T> {
   final delegate = <String, T>{};
   
   Dict(Map<String, T> data) {
      delegate.addAll(data);
   }
   
   String toString() {
      String output = '';
      delegate.forEach((String k, v) {
         output += '\t$k: $v, \n';
      });
      return '{\n$output\t}\n';
   }
}


class Res<T> {
   List<Dict<T>> components = [];
   
   Res(this.components);
   
   Dict<T> get first => components.first;
   
   Dict<T> get last => components.last;
   
   void add(Dict<T> v) {
      components.add(v);
   }
   
   String toString() {
      return FN.stringPrettier(components);
   }
}

typedef BoolFunc = bool Function(SyntacticEntity elt);
typedef VoidFunc = void Function(SyntacticEntity elt);

//@fmt:off
class TSupportedAnn {
  List<String> cls      = COMP_META;
  List<String> property = OPTION_META + DATA_META + INJECT_META + PROP_META;
  List<String> method   = ['Method', 'Watch', 'Provide', 'On', 'Once'];
  List<String> getter   = ['Computed'];
  List<String> static   = [];
} //@fmt:on

final SUPPORTED = TSupportedAnn();


class TExpression extends Object {}

class TFunction {}

class TFieldMethod extends TMethod {}

class TConstruct extends TMethod {}

abstract class MTField {
   List annotations;
   String name;
   String body;
   String type;
   bool static;
   bool CONST;
   bool FINAL;
   bool EXTERNAL;
   
   MTField_init({annotations, name, body, type, static, CONST, FINAL, EXTERNAL = false}) {
      this.annotations = annotations;
      this.name = name;
      this.type = type;
      this.static = static;
      this.CONST = CONST;
      this.FINAL = FINAL;
      this.EXTERNAL = EXTERNAL;
   }
   
   @override
   toString([int level = 0]) {
      var data = {
         'name': name,
         'body': body,
         'type': type,
         'CONST': CONST,
         'FINAL': FINAL,
         'EXTERNAL': EXTERNAL,
         'annotations': annotations,
         'static': static
      };
      return FN.stringPrettier(data, level);
   }
}

class TField extends MTField {
   TField({annotations, name, body, type, static, CONST, FINAL, EXTERNAL = false}) {
      MTField_init(
         annotations: annotations,
         name: name,
         body: body,
         type: type,
         static: static,
         CONST: CONST,
         FINAL: FINAL,
         EXTERNAL: EXTERNAL);
   }
}

class ArgumentListStruct {
   static Type beginToken = BeginToken;
   static Type namedExpressionImp = NamedExpressionImpl;
   static Type simpleToken = SimpleToken;
}

class MArgumentList {
   static ArgumentListStruct struct;
}

class MTMethod {
   List annotations;
   String body;
   String name;
   String params;
   bool getter;
   bool setter;
   bool operator;
   bool static;
   
   MTMethod_init({annotations, body, name, params, getter, setter, operator, static}) {
      this.annotations = annotations;
      this.body = body;
      this.name = name;
      this.params = params;
      this.getter = getter;
      this.setter = setter;
      this.operator = operator;
      this.static = static;
   }
   
   String toString([int level = 0]) {
      return FN.stringPrettier({
         'name': name,
         'body': body,
         'params': params,
         'getter': getter,
         'setter': setter,
         'operator': operator,
         'static': static
      }, level);
   }
}

class TMethod extends MTMethod {
   TMethod({annotations, body, name, params, getter, setter, operator, static}) {
      MTMethod_init(
         annotations: annotations,
         body: body,
         name: name,
         params: params,
         getter: getter,
         setter: setter,
         operator: operator,
         static: static);
   }
}

class TClass extends MTMethod with MTField {}


/*




               A S T   T R A N S F O R M E R
               
      -------------------------------------------------
      BaseTransformer, FieldAnnotationTransformer,
      MethodAnnotationTransformer, ClassAnnotationTransformer,
      VariableTransformer



 */
abstract class BaseTransformer extends RecursiveAstVisitor {
   static final results = Res([]);
   
   static dynamic
   walkChildren(AstNode node, BoolFunc condition, VoidFunc action) {
      node.childEntities.where((SyntacticEntity elt) {
         if (condition(elt)) {
            action(elt);
         }
      });
   }
   
   static List<Map<String, dynamic>>
   getParsedMeta(List<Annotation> metadata, List<String> matchedNames) {
      List<Map<String, dynamic>> result;
      List<Annotation> filtered = List.from(metadata
         .where((meta) =>
         matchedNames.contains(
            meta.childEntities
               .firstWhere((syn) => syn is SimpleIdentifierImpl, orElse: () => null).toString()
         )
      )
      );
      filtered.forEach((Annotation node) {
         SimpleIdentifier ann_name = node.childEntities.firstWhere((syn) => syn is SimpleIdentifier, orElse: () => null);
         ArgumentList kwargs = node.childEntities.firstWhere((syn) => syn is ArgumentList, orElse: () => null);
         result ??= [];
         result.add({'name': ann_name, 'arguments': kwargs});
         _log('\nannotation_name:$ann_name, kwargs:$kwargs', ELevel.info);
      });
      return result;
   }
}

class ExpressionCommentAppender extends BaseTransformer {
   bool         multiline;
   List<String> comments;
   
   ExpressionCommentAppender(this.comments, this.multiline);
   
   List<CommentToken>
   getCommentToken(){
      var tok_typ = multiline == true
        ? TokenType.MULTI_LINE_COMMENT
        : TokenType.SINGLE_LINE_COMMENT;
      return comments.map((comment) => CommentToken(tok_typ, comment, 0)).toList();
   }
   
   combineOldComments(AnnotatedNode node){
      var old_comments = node.documentationComment?.tokens?.where((tok){
         var comment_string = (tok as CommentToken).toString();
         return comment_string.length > 2 && !comments.contains(comment_string);
      })?.map((c) => c.toString())?.toList();

      if (old_comments != null && old_comments.length > 0)
         comments = old_comments + comments;
   }
   
   visitMethodDeclaration(MethodDeclaration node) {
      combineOldComments(node);
      var tokens       = getCommentToken();
      var new_comment = astFactory.endOfLineComment(tokens);
      /*if (multiline == false) {
         if (old_comment.toString().length > 2)
            comments = [old_comment.toString()] + comments;
         new_comment = astFactory.endOfLineComment(tokens);
      }
      else {
         new_comment = astFactory.blockComment(tokens);
      }*/
      var metadata    = node.metadata;
      var external_kw = node.externalKeyword;
      var modifier_kw = node.modifierKeyword;
      var ret_type    = node.returnType;
      var prop_kw     = node.propertyKeyword;
      var operator_kw = node.operatorKeyword;
      var name        = node.name;
      var type_params = node.typeParameters;
      var params      = node.parameters;
      var body        = node.body;
      
      var new_node = astFactory.methodDeclaration(
         new_comment, metadata, external_kw, modifier_kw, ret_type,
         prop_kw, operator_kw, name, type_params, params, body
      );
      node.parent.accept(new NodeReplacer(node, new_node));
   }
   
   visitFieldDeclaration(FieldDeclaration node) {
      combineOldComments(node);
      var tokens        = getCommentToken();
      var new_comment   = astFactory.endOfLineComment(tokens);
      /*if (multiline == false) new_comment = astFactory.endOfLineComment(tokens);
      else                    new_comment = astFactory.blockComment(tokens);*/
      
      var new_node = astFactory.fieldDeclaration2(
         fieldList: node.fields, semicolon: node.semicolon, metadata: node.metadata,
         covariantKeyword: node.covariantKeyword, staticKeyword: node.staticKeyword,
         comment: new_comment
      );
      node.parent.accept(new NodeReplacer(node, new_node));
   }
   
   visitVariableDeclarationList(VariableDeclarationList node) {
      combineOldComments(node);
      var tokens        = getCommentToken();
      var new_comment   = astFactory.endOfLineComment(tokens);
      /*if (multiline == false) new_comment = astFactory.endOfLineComment(tokens);
      else                    new_comment = astFactory.blockComment(tokens);*/
      
      var metadata   = node.metadata;
      var keyword    = node.keyword;
      var type       = node.type;
      var variables  = node.variables;
      
      var new_node = astFactory.variableDeclarationList(
         new_comment, metadata, keyword, type, variables
      );
      node.parent.accept(new NodeReplacer(node, new_node));
   }
   
   /*visitExpressionStatement(ExpressionStatement node) {
   }*/
}

class FieldAnnotationTransformer extends BaseTransformer {
   static bool matched(FieldDeclaration node) {
      return IS.propAnnotation(node, SUPPORTED.property);
   }
   
   @override
   visitFieldDeclaration(FieldDeclaration node) {
      /*EX -----------------------
      @DSub(type: 'method') void hello() {}
      @DSub(type: 'computed') int get v => value;
      int sum() {return value + 100;}
      @DMaster(type: 'static') static String findName() {return 'x';}*/
      var fields = node.fields;
      var elts = node.declaredElement;
      var static = node.isStatic;
      var synth = node.isSynthetic;
      var cons = node.fields.isConst;
      var finl = node.fields.isFinal;
      var vars = node.fields.variables;
      var kw = node.fields.keyword;
      var typ = node.fields.type;
      var name = node.fields.variables[0].name;
      _log('\tField:\n\t\tname:$name, static:$static, synth:$synth'
         '\n\t\tfileds:$fields, elts:$elts, cons:$cons, finl:$finl'
         '\n\t\tvars:$vars, kw:$kw, typ:$typ, metadata: ${node.metadata}', ELevel.log);
      List results =
      BaseTransformer.getParsedMeta(node.metadata, SUPPORTED.property);
      BaseTransformer.results.last['properties'] ??= [];
      BaseTransformer.results.last['properties'].add(TField(
         annotations: results,
         name: name.toSource(),
         body: fields?.toSource(),
         static: static,
         type: typ.toSource(),
         CONST: cons,
         FINAL: finl));
      
      return super.visitFieldDeclaration(node);
   }
}

class MethodAnnotationTransformer extends BaseTransformer {
   static bool matched(MethodDeclaration node) {
      return IS.methodAnnotation(node, SUPPORTED.method);
   }
   
   @override
   visitMethodDeclaration(MethodDeclaration node) {
      /*EX -----------------------
      @DSub(type: 'string') String name;
      int value;
      static String NAME = 'Sample';*/ //@fmt:off
    var body = node.body;
    var exkw = node.externalKeyword;
    var mokw = node.modifierKeyword;
    var prkw = node.propertyKeyword;
    var opkw = node.operatorKeyword;
    var name = node.name;
    var params = node.parameters;

    var elt = node.declaredElement;
    var getter = node.isGetter;
    var operator = node.isOperator;
    var setter = node.isSetter;
    var static = node.isStatic;
    var synth = node.isSynthetic; //@fmt:on

    _log(
       '\tMethod: \n\t\tbody: $body, exkw:$exkw, mokw:$mokw, prkw:$prkw, opkw:$opkw'
          '\n\t\tname:$name, params:$params, elt:$elt, getter:$getter, setter:$setter'
          '\n\t\toperator:$operator, static:$static, synth:$synth', ELevel.log);
    List results =
    BaseTransformer.getParsedMeta(node.metadata, SUPPORTED.method);
    BaseTransformer.results.last['methods'] ??= [];
    BaseTransformer.results.last['methods'].add({
       'methodAnnotations': results,
       'name': name?.toSource(),
       'body': body?.toSource(),
       'params': params?.toSource(),
       'getter': getter,
       'setter': setter,
       'operator': operator,
       'static': static
    });
    return super.visitMethodDeclaration(node);
   }
}

//@fmt:off
class ClassAnnotationTransformer extends BaseTransformer {
  AstNode currentNode = null; //@fmt:on

  static bool matched(ClassDeclaration node) {
     return IS.classAnnotation(node, SUPPORTED.cls);
  }

  @override
  visitAnnotation(Annotation node) {
     /* EX ---------------------------*/
     List results = BaseTransformer.getParsedMeta([node], SUPPORTED.cls);
     try {
        if (results != null)
           BaseTransformer.results.last['classAnnotations'] = results;
     } catch (e) {
        print('node: ${node.childEntities}');
        throw (e);
     }
  }

  @override
  visitClassDeclaration(ClassDeclaration node) {
     /*EX --------------------------------------
      class ClassName extends Cls{}
      note: DeclaredSimpleIdentifier className, KeywordToken class_keyword
      note: ExtendsClauseImpl extends_cls
      */
     currentNode = node;
     List<SyntacticEntity> list = List.from(node.childEntities);
     DeclaredSimpleIdentifier clsNode = list.firstWhere((syn) => syn is DeclaredSimpleIdentifier, orElse: () => null);
     ExtendsClauseImpl extendsNodes = list.firstWhere((syn) => syn is ExtendsClauseImpl, orElse: () => null);
     ImplementsClauseImpl implNodes = list.firstWhere((syn) => syn is ImplementsClauseImpl, orElse: () => null);
   
     BaseTransformer.results.add(Dict({
        'className': clsNode,
        'extends': extendsNodes,
        'impl': implNodes,
     }));
     return super.visitClassDeclaration(node);
  }
}

class VariableTransformer extends BaseTransformer {
   static bool matched(dynamic n) {
      return IS.typeObject(n);
   }
   
   //    Some note on the Keyword class
   //     pseudo keywords are keywords that can be used as identifiers.
   //     e.g.
   //     const Keyword("await", isPseudo: true),
   //     const Keyword("yield", isPseudo: true)];
   // syntax arguments samples
   //    static const Keyword LIBRARY = const Keyword._('LIBRARY', "library", true);
   //    static const Keyword NEW = const Keyword._('NEW', "new");
   //    static const Keyword NULL = const Keyword._('NULL', "null");
   //    static const Keyword OPERATOR = const Keyword._('OPERATOR', "operator", true);
   @override
   visitVariableDeclarationList(VariableDeclarationList n) {
      var kw = const Keyword('Object', 'Object', isBuiltIn: false);
      var tok = new Token(kw, n.keyword.offset);
      var comment = n.documentationComment;
      //      var metadata = [];
      var metadata = n.metadata;
      var keyword = tok;
      var type = n.type;
      var variables = n.variables;
      var ndl = astFactory.variableDeclarationList(
         comment, metadata, keyword, type, variables);
      //changing var d to Object d
      _log('\nkw:$kw\ntok:$tok\nmeta:$metadata\ntype:$type'
         '\nvars:$variables\nnode:$n\noffset:${n.keyword.offset}\nNewNode:$ndl'
         ''
         '\n\n', ELevel.info);
      n.parent.accept(new NodeReplacer(n, ndl));
   }
}

class DartFileVisitor {
   Future<String> visitFile(File file) {
      return file.readAsString().then((str) {
         var ast = parseCompilationUnit(str, parseFunctionBodies: true);
         var v = Visitor();
         ast.visitChildren(v);
      });
   }
}

/*


             M A I N    V I S I T O R
             
      ------------------------------------------
      overall visitor, controlling ast visit flow



 */
class Visitor extends RecursiveAstVisitor {
   //   @deprecated
   //   @override
   //   visitVariableDeclarationList(VariableDeclarationList n) {
   //      if (!VariableTransformer.matched(n)) return;
   //      return n.parent.visitChildren(VariableTransformer());
   //   }
   @override
   visitLibraryDirective(LibraryDirective node) {
      // TODO: implement visitLibraryDirective
      return super.visitLibraryDirective(node);
   }
   
   @override
   visitImportDirective(ImportDirective node) {
      // TODO: implement visitImportDirective
      return super.visitImportDirective(node);
   }
   
   @override
   visitClassDeclaration(ClassDeclaration node) {
      if (!ClassAnnotationTransformer.matched(node))
         return super.visitClassDeclaration(node);
      node.parent?.visitChildren(ClassAnnotationTransformer());
      return super.visitClassDeclaration(node);
   }
   
   @override
   visitFieldDeclaration(FieldDeclaration node) {
      if (!FieldAnnotationTransformer.matched(node))
         return super.visitFieldDeclaration(node);
      return node.parent.visitChildren(FieldAnnotationTransformer());
   }
   
   @override
   visitMethodDeclaration(MethodDeclaration node) {
      if (!MethodAnnotationTransformer.matched(node))
         return super.visitMethodDeclaration(node);
      return node.parent.visitChildren(MethodAnnotationTransformer());
   }
   
}

