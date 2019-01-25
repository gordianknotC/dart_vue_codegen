import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/standard_ast_factory.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:front_end/src/scanner/token.dart'
   show BeginToken, CommentToken,  SimpleToken ;
import 'package:quiver/collection.dart' show DelegatingMap;
import 'package:analyzer/src/dart/ast/ast.dart';


import 'package:common/src/common.dart' show FN;
import 'package:common/src/common.log.dart' show Logger, ELevel;


final _log = Logger(name: "io.glob", levels: [ELevel.critical, ELevel.error, ELevel.warning, ELevel.debug]);



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

class Visitor extends RecursiveAstVisitor {

}
/*
1) DataDefs
--------------------------------------------------------------
   [interoperate DataType Class]
      > rewrite all fields into anonymous data type for js interop
        Details are as follows
         - anonymouse annotation + @JS() annotation
         - default value of data field

      
   [Vue Definition Interface]
      > rewrite all field of definitions into IDataDefs.
      Details are as follows
         - field definition only.
         - default values are ignored.
         - E self;
   
   [Vue Component]
      > add DataDefs initialization and Write following codes
        into IVue Interface. Details are as follows.
         - $dart_data = DataDefs();
      
      > add field definition for DataDefs in VueComponent.
        Detail are as follows.
         - DataDefs $dart_data;
      
   
2) PropertyDefs
--------------------------------------------------------------
   [Interop DataType Class]
      > rewrite all essential members, which composed a prop
        data type, into anonymous prop data type for js interop.
        Details are as follows.
            @anonymous
            @JS()
            class _Props {
               Vue.TProp<String> Color;
               _Props({this.Color});
            }
   
   [Vue Definition Interface]
      > Rewrite all definitions and defaults into IPropDefs
        interface. Details are as follows.
            abstract class IPropDefs<E> {
               E    self;
               bool Color_required = false;
               bool onColorValidated(String v);
            }
      
   [Vue Component]
      > Add PropertyDefs initialization into IVue consturctor.
            $dart_props = _Props(
               Color : Vue.TProp<String>(required: true, JS$default: 'RED', validator: onColorValidated),
            );
      
      > Rewrite all fields into getters and setters as a propxy
        redirect to $dart_props. Details are as follows.
            String get Color {
               return $props['Color'];
            }
            bool Function(String v) get onColorValidated {
               return $dart_props.Color.validator;
            }

*/



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
















