export 'ast.vue.annotation.dart';
export 'ast.transformers.dart' show
   ExpressionCommentAppender, VariableTransformer, DartFileVisitor, ClassAnnotationTransformer,
   FieldAnnotationTransformer, MethodAnnotationTransformer, Dict, BaseTransformer, Visitor;

export 'ast.vue.parsers.dart';
export 'ast.vue.codegen.dart';
export 'ast.vue.spell.dart' show TypoSuggest;
export 'ast.vue.template.dart' show VueTemplate;



void main([arguments]) {
   if (arguments.length == 1 && arguments[0] == '-directRun') {
   
   }
}




