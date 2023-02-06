//@fmt:off
//import 'package:astMacro/src/common.dart';
import 'dart:io' show File;

import 'package:meta/meta.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/src/dart/ast/ast.dart';

//import 'ast.vue.dart';
import 'common.dart'             show FN, guard, raise, tryRaise;
import 'common.spell.dart'       show CamelCaseTyping;
import 'ast.vue.annotation.dart' show DATA_META, INJECT_META, METHOD_META, PROVIDE_META, VUE_HOOKS;
import 'ast.vue.template.dart'   show VueTemplate;
import 'ast.parsers.dart';
import 'ast.codegen.dart';
import 'ast.transformers.dart'      show ExpressionCommentAppender;
import 'ast.vue.spell.dart'         show TypoSuggest;
import 'ast.utils.dart'             show dumpAst;
import 'io.util.dart' show Path;

import './common.log.dart' show Logger, ELevel;
final _log = Logger(name: "vue.parser", levels: [ELevel.log, ELevel.info, ELevel.critical, ELevel.error, ELevel.warning, ELevel.sys ]);


class BaseAnnotationTransformer {
}

enum EDefTypes {
   method,
   watch,
   computed,
   option,
   prop,
   data,
   on,
   once
}

enum EJSType {
   string,
   number,
   object,
   list,
   boolean,
   function,
   date,
   symbol
}

const BUILDIN_FIELDS = ['el', 'delimiters', 'name', 'template', 'model', 'components', 'mixins'];
final SUPPORTED_META_FN    = PROVIDE_META + INJECT_META;
final SUPPORTED_META_FIELD = [];

class IDefs {
   static const IOnceEventDefs = 'IOnceEventDefs';
   static const IComputedDefs  = 'IComputedDefs';
   static const IOptionDefs    = 'IOptionDefs';
   static const IPropDefs      = 'IPropDefs';
   static const IMethodDefs    = 'IMethodDefs';
   static const IWatcherDefs   = 'IWatcherDefs';
   static const IDataDefs      = 'IDataDefs';
   static const IOnEventDefs   = 'IOnEventDefs';
   static const IFilterDefs    = 'IFilterDefs';
}

const ANN_MIXIN   = 'Mixin';
const ANN_COMP    = 'Component';
const ANN_ON      = 'ON';
const ANN_PROVIDE = 'provide';
const ANN_INJECT  = 'inject';

const COMP_ANNS   = [ANN_MIXIN, ANN_COMP];
const FIELD_ANNS  = [ANN_INJECT];
const METHOD_ANNS = [ANN_ON, ANN_PROVIDE];

const IVUE_NAME = 'VueApi';
const IMETHOD   = 'IMethodDefs';
const IPROP     = 'IPropDefs';
const IWATCHER  = 'IWatcherDefs';
const IDATA     = 'IDataDefs';
const ICOMPUTED = 'IComputedDefs';
const IOPTION   = 'IOptionDefs';
const ION       = 'IOnEventDefs';
const IONCE     = 'IOnceEventDefs';
const VUE_INTERFACES = [
  IMETHOD, IPROP, IWATCHER, IDATA, ICOMPUTED, IOPTION, ION, IONCE
];

const VUE_GEN_FILENAME = '.vue.generated.dart';
const VUE_FILENAME     = '.vue.dart';

const PSEUDO_GETTER    = 'get_';
const PSEUDO_SETTER    = 'set_';
const PSEUDO_DEEP      = '_deep';
const PSEUDO_IMMEDIATE = '_immediate';
const PSEUDO_REQUIRED  = '_required';

final ALPHABETIC = 'abcdefghijklmnopqrstuvwxyz'.split('');

class Nullable {
   const Nullable();
}
const nullable = Nullable();

abstract class BaseDefTransformer {

}

/*



                             CONDITIONS
      
      
      
*/

bool _isIntType(String type_name) {
   return type_name == 'int';
}

bool _isNumberType(String type_name) {
   return type_name == 'num' || type_name == 'double' || type_name == 'int';
}

bool _isBoolType(String type_name) {
   return type_name == 'bool';
}

bool _isStringType(String type_name) {
   return type_name == 'String';
}

bool _isListType(String type_name) {
   return type_name.indexOf('List') != -1;
}

bool _isDateType(String type_name) {
   return type_name == 'DateTime';
}

bool _isSymbolType(String type_name) {
   return type_name == 'Symbol';
}

bool _isObjectType(String type_name) {
   return !_isListType(type_name)
          && !_isBoolType(type_name)
          && !_isDateType(type_name)
          && !_isStringType(type_name)
          && !_isNumberType(type_name);
}

bool isOnChangedWatcher(String method_name) {
   var onl = 2;
   var changedl = 7;
   return method_name.length > onl + changedl
          && method_name.substring(0, onl) == 'on'
          && method_name.substring(changedl + 1) == 'Changed';
}

bool isValidatorProp(String field_name) {
   var onl = 2;
   var validatedl = 9;
   return field_name.length > onl + validatedl
          && field_name.substring(0, onl) == 'on'
          && field_name.substring(validatedl + 1) == 'Validated';
}

bool _isSuffixConvention(String field_name, String suffix){
   var rl = suffix.length;
   var l = field_name.length;
   return l > rl && field_name.substring(l - rl) == suffix;
}

bool isPropRequired(String field_name) {
   return _isSuffixConvention(field_name, PSEUDO_REQUIRED);
}

bool isWatcherImmediate(String field_name) {
   return field_name.endsWith(PSEUDO_IMMEDIATE);
}

bool isWatcherDeep(String field_name) {
   return field_name.endsWith(PSEUDO_DEEP);
}

bool isSetComputed(String field_name) {
   var rl = 4; // set_
   return field_name.length > 3 && field_name.substring(0, rl) == PSEUDO_SETTER;
}

bool isGetComputed(String field_name) {
   var rl = 4; // get_
   return field_name.length > 3 && field_name.substring(0, rl) == PSEUDO_GETTER;
}

bool isRequiredOrValidator(String field_name) {
   return isPropRequired(field_name) || isValidatorProp(field_name);
}

bool isDeepOrImmediateOrOnChanged(String field_name) {
   return isWatcherDeep(field_name) || isWatcherImmediate(field_name) || isOnChangedWatcher(field_name);
}

bool isNotConvention(String field_name) {
   return !isPropRequired(field_name)
      && !isValidatorProp(field_name)
      && !isWatcherDeep(field_name)
      && !isWatcherImmediate(field_name);
}

bool isTemplateFilePath(String pth){
   return pth.endsWith('.vue');
}

bool isVueDart(String file_path) {
   return file_path.endsWith(VUE_FILENAME) ;//|| file_path.endsWith(VUE_GEN_FILENAME);
}

bool isVueDartGen(String file_path) {
   return file_path.endsWith(VUE_GEN_FILENAME);
   
}

bool isNotModuleImport(ImportParser imp) => imp.source_file != null;
bool isModuleImport(ImportParser imp) => imp.source_file == null;

bool isVueDefInterface(ClassDeclParser cls_decl){
   return cls_decl.is_abstract
       && VUE_INTERFACES.contains(cls_decl.name.name);
}

bool isIVueDef(String key){
   return key != null
      && VUE_INTERFACES.any(
         (i) => key.endsWith(i));
}

bool isVueDef(ClassDeclParser cls_decl){
   if (cls_decl.is_abstract){
      return false;
   }else{
      var extend_name = cls_decl.ext?.key?.superclass?.name?.name;
      return isIVueDef(extend_name);
   }
}
bool isIVue(ClassDeclParser cls_decl) {
   var super_name = superClsName(cls_decl);
   return cls_decl.name.name == 'IVue'
       && cls_decl.is_abstract
       && super_name.endsWith(IVUE_NAME);
}

bool isVueComp(List<ClassDeclParser> cls_decls, String file_path){
   var cls_components = cls_decls.where((cls) => cls.annotationNames.contains(ANN_COMP) );
   var cls_mixins = cls_decls.where((cls) => cls.annotationNames.contains(ANN_MIXIN) );
   return isVueDart(file_path) && cls_components != null && cls_mixins != null;
}

bool isMemberOfVueComp(ClassDeclParser host, BaseVueDefinitions def){
   var ann_qualified = host.annotationNames.contains(ANN_COMP)
                     && host.annotationNames.contains(ANN_MIXIN);
   if (ann_qualified) return false;
   var ann_mixin = host.annotations.where((ann) => ann.name.name == ANN_MIXIN);
   return ann_qualified;
}

bool isPrivate(String name){
   return name.startsWith('_');
}

bool isPublic(String name){
   return !isPrivate(name);
}




/*



                        C O M M O N    U T I L S
      
      
      
*/
String
superClsName(ClassDeclParser cls){
   return cls.ext.key.superclass?.name?.name;
}

MethodsParser
getValidatorByFieldName(String validator_name, ClassDeclParser parser) {
   var field_name = FN.dePrefix(validator_name, 'on', 'Validated');
   var lfield_name = '${field_name.substring(0, 1).toLowerCase()}${field_name.substring(1)}';
   var field = parser
      .getMethod(field_name)
      ?.first;
   var lfield = parser
      .getMethod(lfield_name)
      ?.first;
   return field ?? lfield;
}

String
getPropReqiuredConvention(String propname) {
   return '${propname}${PSEUDO_REQUIRED}';
}

String
_getPrefixAndSuffixConvention(String prefix, String propname, String suffix) {
   return '$prefix${propname.substring(0, 1).toUpperCase()}${propname.substring(1)}$suffix';
}

String
_dePrefixAndSuffixConvention(String prefix, String convention, String suffix) {
   return FN.range(convention, prefix.length);
}

String
getPropValidatorConvention(String propname) {
   return _getPrefixAndSuffixConvention('on', propname, 'Validated');
}

String
getWatchOnChangedConvention(String propname) {
   return _getPrefixAndSuffixConvention('on', propname, 'Changed');
}

String
_getWatchDeepConvention(String propname) {
   return '${propname}${PSEUDO_DEEP}';
}

String
_getWatchImmediateConvention(String propname) {
   return '${propname}${PSEUDO_IMMEDIATE}';
}

String
_getComputedGetterConvention(String propname) {
   return 'get_${propname}';
}

String
_getComputedSetterConvention(String propname) {
   return 'set_${propname}';
}

String
_getPropByGetterOrSetter(String xter) {
   var l = 4;
   return xter.substring(4);
}


DeclarationImpl
getCommentableDeclFromNode(AstNode node) {
   _log.log('getCommentableDeclFromNode ${node.runtimeType}');
   if (node == null) return node;
   if (  node is StatementImpl               || node is ClassDeclarationImpl
      || node is MethodDeclarationImpl       || node is FunctionDeclarationImpl
      || node is FieldDeclarationImpl        || node is FunctionDeclarationStatementImpl
      || node is ConstructorDeclarationImpl  || node is TopLevelVariableDeclarationImpl
      || node is EnumDeclarationImpl)
         return node;
   if (node.parent == null)
      return node;
   return getCommentableDeclFromNode(node.parent);
}







/*


                             A N N O T A T I O N S
      
      
      
*/


FieldsParser
_getFieldByConvention(String prefix, String suffix, String name, ClassDeclParser cls_parser) {
   var field_name = FN.dePrefix(name, prefix, suffix);
   var lfield_name = '${field_name.substring(0, 1).toLowerCase()}${field_name.substring(1)}';
   _log.log('_getFieldByConvention, $name, field_name: $field_name, $lfield_name');
   var field = cls_parser.getField(field_name);
   var lfield = cls_parser.getField(lfield_name);
   return field ?? lfield;
}

bool
_isPrefixConvention(String prefix, String suffix, String name, ClassDeclParser cls_parser) {
   var l = prefix.length;
   if (name.startsWith(prefix) && name.endsWith(suffix)) {
      var field = _getFieldByConvention(prefix, suffix, name, cls_parser);
      return field != null;
   };
   return false;
}

bool
_isOnChangeConvention(String name, ClassDeclParser cls_parser) {
   if (IS.snakeCase(name))
      name = FN.toCamelCase(name);
   return _isPrefixConvention('on', 'Changed', name, cls_parser);
}

bool
_isValidatorConvention(String name, ClassDeclParser cls_parser) {
   if (IS.snakeCase(name))
      name = FN.toCamelCase(name);
   return _isPrefixConvention('on', 'Validated', name, cls_parser);
}






/*




                        W A R N N I N G S




*/

warningForOverridingBuildinMethods(MethodsParser method){
   warningLineComment(
      'Overriding Buildin Methods: ${method.name} is not Allowed'
      'Overriding Buildin Methods: ${method.name} is not Allowed',
      'override buildin method is not allowed',
      method.origin
   );
}

warningForOverridingBuildinFields(FieldsParser field){
   warningLineComment(
      'Overriding Buildin Field: ${field.names} is not Allowed'
      'Overriding Buildin Methods: ${field.names} is not Allowed',
      'override buildin field is not allowed',
      field.origin
   );
}

warningForInvalidComputed(String method_name, MethodsParser method) {
   warningLineComment(
      '$method_name is not a valid vue computed method. A valid naming convention '
      'for computed method should be set_computedName or get_computedName',
      'not a valid computed convention',
      method.origin
   );
}

warningForInvalidConvention(MethodsParser method, String key){
   warningLineComment(
      'not a proper $key convention: ${method.name.name}',
      'not a valid computed convention',
      method.origin
   );
}

warningForWatchedPropertyNotFound(String field_name, MethodsParser method){
   warningLineComment(
      'a watched property: $field_name not found in definition',
      'watched property: $field_name not found',
      method.origin
   );
}

warningForWatcherNotDefined(String field_name, String method_name, FieldsParser field){
   warningLineComment(
      'Watcher method:$method_name not defined',
      'Watcher method:$method_name not defined',
      field.origin
   );
}

warningForFieldNameNotFound(String field_name, FieldsParser field) {
   warningLineComment(
      '$field_name is not found in component fields',
      'not a component field',
      field.origin
   );
}

warningForInvalidMethod(String method_name, MethodsParser method) {
   warningLineComment(
      '$method_name is not a valid vue method',
      'not a valid vue method',
      method.origin,
      error: "PrivateError"
   );
}

warningForInvalidOnEvent(MethodsParser method){
   var ann_names = method.annotationNames;
   warningLineComment(
      'invalid on events: ${ann_names}',
      'invalid on events: ${ann_names}',
      method.origin,
      error: "OnEventError"
   );
}

warningForInvalidData(String method_or_field_name, BaseDeclParser method_or_field) {
   warningLineComment(
      '$method_or_field_name is not a valid vue data',
      'not a valid vue method',
      method_or_field.origin,
      error: "PrivateError"
   );
}

warningForParamLengthMissmatch(MethodsParser def, List<TType> params, int length, String key){
   warningLineComment(
      'parameter length for $key missmatch, expect $length got ${params.length}',
      'param length for $key missmatch',
      def.origin
   );
}

warningForParamTypesMissmatch(MethodsParser def, String expected, String real, String key){
   warningLineComment(
      'param types of $key missmatch, expect $expected to be $real',
      'param types of $key missmatch, expect $expected to be $real',
      def.origin
   );
}

warningForAnnNotSupport(String method_or_field_name, BaseDeclParser method_or_field,
                        List<String> anns, String def_name)
{
   warningLineComment(
      'annotations: ${anns} are not supported under context of ${def_name}',
      'annotation: ${anns} is not supported here..',
      method_or_field.origin
   );
}
warningForObscureConvention(List<String> possible_names, MethodsParser method_body) {
   var message = 'cannot infer property name on convention:${method_body.name.name}, which implicates either ${possible_names[0]} or ${possible_names.sublist(1)}';
   var comment = 'Obscured Validator Convention';
   var node = method_body.origin;
   warningLineComment(message, comment, node);
}

warningForTypoField(FieldsParser parser) {
   var names = parser.names.map((name) => name.toString()).toList();
   var typo = TypoSuggest();
   names.forEach((name) {
      if (typo.isCamelCase(name)) {
         var words = CamelCaseTyping(name).words;
         var suggest = TypoSuggest().correct(name);
         if (words.length == suggest.length) {
            raise(StackTrace.fromString('found typo on method:$name, did you mean:$suggest'));
         }
      }
   });
}

warningForMixinAnnotationNotDefined(ClassDeclParser cls_body) {
   var message = 'To Define a Vue Component, append a Mixin Annotation is Necessary';
   var comment = 'To Define a Vue Component, append a Mixin Annotation is Necessary';
   var node = cls_body.origin;
   warningLineComment(message, comment, node);
}

warningForTypoMethod(MethodsParser parser) {
   if (parser == null) return;
   var fn_name = parser.name.name;
   var typo = TypoSuggest();
   if (typo.isCamelCase(fn_name)) {
      var words = CamelCaseTyping(fn_name).words;
      var suggest = TypoSuggest().correct(fn_name);
      if (VUE_HOOKS.any((hook) => suggest.contains(hook))) {
         return raise(StackTrace.fromString('found typo on life hook:$fn_name, did you mean:$suggest'));
      }
      if (words.length == suggest.length) {
         raise(StackTrace.fromString('found typo on method:$fn_name, did you mean:$suggest'));
      }
   }
}

warningForReferencingToNonListenableProperty(List<dynamic> non_vue_refs) {
   non_vue_refs.forEach((ref){
      var node = getCommentableDeclFromNode(ref.context);
      var message = 'referenced to non-listenable property: ${ref.refs.name}';
      var comment = message;
      warningLineComment(message, comment, node);
   });
}

_walkRefs(List<VueMethodsParser> ref_chain, VueMethodsParser current,
         bool cb(List<VueMethodsParser> chain, VueMethodsParser current)){
   var refs  = (ref_chain.last.vue_method_refs + ref_chain.last.vue_computed_refs);
   var new_chain = [] + ref_chain + [current];
   for (var i = 0; i < refs.length; ++i) {
      var ref = refs[i];
      if (cb(new_chain, ref))
         _walkRefs(new_chain, ref, cb);
   }
}

bool hasCircularReference(VueMethodsParser host){
   var ref_chain = <VueMethodsParser>[];
   var circular_found = false;
   _walkRefs(ref_chain, host, (chain, current){
      var is_circular = chain.contains(current);
      if (is_circular)
         circular_found = true;
      return !is_circular || circular_found;
   });
   return circular_found;
}

warningForTriggeringPotentialInfiniteUpdating(VueMethodsParser host){
   /*
    A - easiness *****
    search any non-cachable properties referenced to data object and altered
    it's value directory or indirectly. Followings are non-cachable properties:
        (1) method

    B - easiness *
    search infinite loop */
   var infinit_rendering_update = false;
   
   if (host.is_computed  ){
      if (hasCircularReference(host))
         infinit_rendering_update = true;
   }else if (host.is_method  ){
      if (host.vue_assignment_refs.length > 0){
         infinit_rendering_update = true;
      }
   }else if (host.is_watch ){
      if (hasCircularReference(host))
         infinit_rendering_update = true;
   }else{
      throw Exception('Uncaught Exception');
   }
   if (infinit_rendering_update){
      var node = host.origin;
      var message = '[WARN] infinite rendering update';
      var comment = '[WARN] infinite rendering update';
      warningLineComment(message, comment, node);
   }
}





/*



               D E F I N I T I O N    M E M B E R S




*/

abstract class NullableInitiation {

}

class TClsMember {
   FieldsParser  field;
   MethodsParser method;
   MethodsParser getter;
   MethodsParser setter;
   bool pseudo_gtr_str = false;
   bool get isField  => field  !=null;
   bool get isMethod => method !=null;
   bool get isGetter => getter !=null;
   bool get isSetter => setter !=null;
   bool get isGetterSetter => getter_setter != null;
   
   List<MethodsParser>
   get getter_setter => getter != null && setter != null ? [getter, setter] : null;
   set getter_setter(List<MethodsParser> v) {
      if (v == null) return;
      getter = v[0];
      setter = v[1];
   }
   
   bool contains(BaseDeclParser member){
      if (field == member || method == member || getter == member || setter == member)
         return true;
      return false;
   }
   
   pseudoModeInit(){
      /*
      [DESCRIPTION]
      - About Pseudo Getter/Setter
         pseudo getter and setter simulated by naming convention which
         prefixed by PSEUDO_GETTER or PSEUDO_SETTER; not a real getter and setter
         
      - Why Using Pseudo Getter/Setter
         only for easy interop.
         
         [EX]
            set_pseudoSetter, et_pseudoGetter          */
      if (getter != null && getter.name.name.startsWith(PSEUDO_GETTER))
         pseudo_gtr_str = true;
      if (setter != null && setter.name.name.startsWith(PSEUDO_SETTER))
         pseudo_gtr_str = true;
   }
   
   TClsMember.staticInit({this.field, this.getter, this.setter, this.method, List<MethodsParser> getter_setter}){
      this.getter_setter = getter_setter;
      pseudoModeInit();
   }
   
   TClsMember.dynamicInit(dynamic body){
      if (body is List<MethodsParser>){
         var g = body.firstWhere((b) => b != null && b.is_getter, orElse: () => null);
         var s = body.firstWhere((b) => b != null && b.is_setter, orElse: () => null);
         var b = [g, s];
         if (g != null && s != null){
            getter_setter = b;
         } else if (g == null && s == null) {
            g = body[0]; s = body.length > 1 ? body[1] : null;
            if (g != null && g.name.name.startsWith(PSEUDO_GETTER)) getter = g;
            if (s != null && s.name.name.startsWith(PSEUDO_SETTER)) setter = s;
            getter_setter = [g, s];
         } else {
            getter = g;
            setter = s;
         }
      } else if (body is FieldsParser)
         field = body;
      else if (body is MethodsParser){
         if (body.is_getter) getter = body;
         else if (body.is_setter) setter = body;
         else method = body;
      }else
         throw Exception('Uncaught Exception');
      pseudoModeInit();
   }
   
   factory TClsMember({dynamic body, FieldsParser field, MethodsParser method, MethodsParser getter, MethodsParser setter}){
      if (body != null)
         return TClsMember.dynamicInit(body);
      var getter_setter = getter != null && setter != null
         ? [getter, setter]
         : null;
      return TClsMember.staticInit(
         field:field, method: method, getter: getter, setter: setter, getter_setter: getter_setter
      );
   }
}



abstract class BaseVueDefMember {
   static String Self = 'self';
   // todo
   // note: an indicator to bypass current member for temporary pending processing.
   bool bypass = false;
   FieldsParser  field_body;
   MethodsParser method_body;
   MethodsParser getter_body;
   MethodsParser setter_body;
   List<String> _host_references;
   
   BaseVueDefinitions def_host;
   VueClassParser     comp_host;
   
   String get name =>
      field_body?.names?.first ?? method_body?.name?.name;
   
   bool get isFieldMethod =>
      field_body != null && field_body.func_type != null;
   
   bool get isMethod => method_body != null;
   bool get isGetter => getter_body != null;
   bool get isSetter => setter_body != null;
   bool get isField  => field_body  != null;

   List<AnnotationImpl>
   get annotations {
      BaseDeclParser body;
      if      (isMethod) body = method_body;
      else if (isGetter) body = getter_body;
      else if (isSetter) body = setter_body;
      else if (isField)  body = field_body;
      else               throw Exception('Uncaught Exception');
      return body.annotations;
   }
   
   List<String>
   get annotation_names =>
      annotations.map((ann) => ann.name.name.split('.')[0]).toList();
   
   List<List<String>>
   get annotation_args =>
      annotations.map((ann) => ann.arguments?.arguments?.map((arg) => arg.toString()));
   
   TClsMember
   get body {
      if (getter_body != null || setter_body != null)
         return TClsMember (getter: getter_body, setter: setter_body);
      if (field_body != null)
         return TClsMember (field: field_body);
      return TClsMember (method: method_body);
   }
   
   void
   set body(TClsMember b){
      if      (b.isField)  {field_body  = b.field;}
      else if (b.isMethod) {method_body = b.method;}
      else if (b.isGetterSetter) {
         getter_body = b.getter_setter[0];
         setter_body = b.getter_setter[1];
      }else if (b.isGetter){
         getter_body = b.getter;
      }
      else if (b.isSetter){
         setter_body = b.setter;
      } else {
         throw new Exception('Invalid type ${b.isGetter}, ${b.getter}');}
   }
   
   List<String>
   get host_references {
      if (_host_references != null)
         return _host_references;
      
      var field_refs  = <String>[];
      var method_refs = <String>[];
      var reference_host  = {
         THIS: [def_host.cls_parser],
         SELF: [comp_host.cls_parser] + comp_host.getExtendedClasses()
      };
      
      List<String>
      get_refs(MethodsParser method) {
         field_refs = method.getReferencedClassFields(reference_host)
                     .fold (<String>[], (initial, field) => initial + field.names);
         method_refs = method.getReferencedClassMethods(reference_host)
                     .map((m) => m.name.name).toList();
         return field_refs + method_refs;
      }
      
      if (_host_references != null)
         return _host_references;
      
      if (body.isGetterSetter || body.isGetter || body.isSetter) {
         var getter = body.getter;
         var setter = body.setter;
         var refs = Set<String>();
         if (getter != null) refs.addAll(get_refs(getter));
         if (setter != null) refs.addAll(get_refs(setter));
         return _host_references = refs.toList();
      } else if(body.isMethod){
         var method = body.method;
         return _host_references = get_refs(method);
      }else if (body.isField){
         return [];
      }else{
         throw Exception('E');
      }
   }
   
   ExpressionImpl
   get default_value {
      if (field_body != null){
         ExpressionImpl ret = field_body.assigned_value;
         if (field_body.func_type != null)       return ret;
         else if (field_body.named_type != null) return ret;
      }
      return null;
   }
   
   _guardAnnotation(String def) {
      if (annotation_names == null) return;
      var allowed_anns = ['deprecate'];
      switch(def){
         case IDefs.IComputedDefs:
         case IDefs.IPropDefs:
         case IDefs.IWatcherDefs:
            break;
            
         case IDefs.IMethodDefs:
            allowed_anns.addAll(METHOD_ANNS);
            break;
            
         case IDefs.IOnceEventDefs:
         case IDefs.IOnEventDefs:
            allowed_anns.add(ANN_ON);
            break;
            
         case IDefs.IOptionDefs:
            allowed_anns.addAll(FIELD_ANNS + METHOD_ANNS);
            break;
            
         case IDefs.IDataDefs:
            allowed_anns.addAll(FIELD_ANNS);
            break;
      }
      var ann_names = annotation_names;
      var unsupported = ann_names.where((ann) => !allowed_anns.contains(ann)).toList();
      
      if(unsupported.length > 0){
         //raise("annotation: ${anns} not allowed under $def.");
         if (field_body != null)
            warningForAnnNotSupport(field_body.names.first, field_body, unsupported, def);
         if (method_body != null)
            warningForAnnNotSupport(method_body.name.name, method_body, unsupported, def);
      }
   }
   
   _guardMethodParams(MethodsParser definition, List<TType> params, String key, [int length]) {
      if (definition == null) return;
      List<FormalParameterParser>
      defined_params = definition.params?.params?.params?.toList()
                     ?? definition.params?.params?.default_params?.toList();
      
      var is_length_mismatched = defined_params.length == (length ?? params.length);
      assert(is_length_mismatched, () {
         warningForParamLengthMissmatch(definition, params, length, key);
      });
      
      for (var i = 0; i < length ?? params.length; ++i) {
         var param      = params[i];
         var named_type = param.named_type;
         var func_type  = param.generic_functype;
         var type_name  = named_type != null
               ? named_type?.name?.name
               : func_type?.toString();
         
         if (func_type == null && named_type == null){
//            var stack = StackTrace.fromString('Uncaught Exception at _guardMethodParams');
//            throw Exception(stack);
         }
         
         var def_param = defined_params[i];
         var def_type_name = def_param.named_type != null
               ? def_param.named_type.name.name
               : def_param.func_type.toString();
         var expected   = def_type_name;
         var real       = type_name;
         
         if (expected != real){
            warningForParamTypesMissmatch(definition, expected, real, key);
            raise('type of validator missmatch, expect $expected to be $real');
         }
      }
   }
   
   _guardMethodType(MethodsParser method, {bool getter = false, bool setter = false}){
      if (method.is_getter != getter) raise('getter is not allowed');
      if (method.is_setter != setter) raise('setter is not allowed');
   }
   
   BaseVueDefMember(this.def_host, this.comp_host);
}

class ComputedMember extends BaseVueDefMember {
   TType              prop_type;
   BaseVueDefinitions def_host;
   VueClassParser     comp_host;
   
   String get prop_name =>
      _getPropName( getter_body?.name?.name ?? setter_body?.name?.name );
   
   String _getPropName(String name){
      if (name.startsWith(PSEUDO_GETTER)) return name.substring(PSEUDO_GETTER.length, name.length);
      if (name.startsWith(PSEUDO_SETTER)) return name.substring(PSEUDO_SETTER.length, name.length);
      throw Exception('Uncaught exception');
   }
   
   TType _getPropType(){
      if (prop_type != null)
         return prop_type;
      
      if (getter_body != null){
         var type = getter_body.ret_type.namedType ?? getter_body.ret_type.funcType;
         if (type == null)
            throw Exception('uncaught exception');
         prop_type = TType.astNodeInit(type);
         return prop_type;
      }
      
      if (setter_body != null){
         var param = setter_body.params.params.params.first;
         var type  = param.named_type ?? param.func_type;
         if (type == null)
            throw Exception('uncaught exception');
         prop_type = TType.astNodeInit(type);
         return prop_type;
         
      }else{
         throw Exception('uncaught exception');
      }
   }
   
   ComputedMember({List<MethodsParser> methods ,this.def_host, this.comp_host}) :super(def_host, comp_host)
   {
      getter_body = methods.firstWhere((m) => m.name.name.startsWith(PSEUDO_GETTER), orElse: () => null);
      setter_body = methods.firstWhere((m) => m.name.name.startsWith(PSEUDO_SETTER), orElse: () => null);
      
      if (isGetter == null && isSetter == null){
         methods.forEach((method){
            warningForInvalidComputed(method.name.name, method);
         });
      }
      /*
      getter_body and setter_body here is a pseudo getter/setter
      simulated by prefixed with set_/get_, not a real getter/setter*/
      _log.log('computed TCLsMember dynamic init: ${methods.map((m) => m.name.name)}');
      body      = TClsMember(body:methods);
      prop_type = _getPropType();
      _log.log('body.getter: ${body.getter?.name}, body.setter: ${body.setter?.name}');

      warningForTypoMethod(getter_body);
      warningForTypoMethod(setter_body);
      
      _guardMethodParams(getter_body, [prop_type], 'computed', 0);
      _guardMethodParams(setter_body, [prop_type], 'computed', 1);
      _guardAnnotation(IDefs.IComputedDefs);
   }
}

class DataMember extends BaseVueDefMember {
   BaseVueDefinitions def_host;
   VueClassParser     comp_host;
   TType             _prop_type;
   
   TType get prop_type{
      if (_prop_type != null) return _prop_type;
      return _prop_type = TType.astNodeInit(field_body ?? method_body);
   }
   
   DataMember ({BaseDeclParser field_or_method, this.def_host, this.comp_host})
      :super(def_host, comp_host)
   {
      this.body = TClsMember(body: field_or_method);
      if (method_body != null){
         warningForTypoMethod(method_body);
         if (isGetter || isSetter)
            warningForInvalidData(method_body?.name?.name, method_body);
      }
      if (field_body != null){
         if (name.startsWith('_'))
            warningForInvalidData(name, field_body);
         warningForTypoField(field_body);
      }
      _guardAnnotation(IDefs.IDataDefs);
   }
}

class OptionMember extends BaseVueDefMember {
   BaseVueDefinitions def_host;
   VueClassParser     comp_host;
   
   OptionMember({BaseDeclParser field_or_method, this.def_host, this.comp_host})
      :super(def_host, comp_host)
   {
      this.body = TClsMember(body: field_or_method);
      if (method_body != null){
         warningForTypoMethod(method_body);
         if (isGetter || isSetter)
            warningForInvalidData(method_body?.name?.name, method_body);
      }
      if (field_body != null){
         if (name.startsWith('_'))
            warningForInvalidData(name, field_body);
         warningForTypoField(field_body);
      }
      _guardAnnotation(IDefs.IOptionDefs);
   }
}


class OnMember extends BaseVueDefMember {
   BaseVueDefinitions def_host;
   VueClassParser     comp_host;
   
   MethodsParser get handler => method_body;
   
   OnMember({MethodsParser handler, this.def_host, this.comp_host})
      :super(def_host, comp_host)
   {
      this.body = TClsMember(method: handler);
      if (isGetter || isSetter || annotations == null)
         warningForInvalidMethod(method_body.name.name, method_body);
      warningForTypoMethod(method_body);
      _guardAnnotation(IDefs.IOnEventDefs);
   }
}


class OnceMember extends BaseVueDefMember {
   BaseVueDefinitions def_host;
   VueClassParser     comp_host;
   
   MethodsParser get handler => method_body;
   
   OnceMember({MethodsParser handler, this.def_host, this.comp_host})
      :super(def_host, comp_host)
   {
      this.body = TClsMember(method: handler);
      if (isGetter || isSetter || annotations == null)
         warningForInvalidMethod(method_body.name.name, method_body);
      warningForTypoMethod(method_body);
      _guardAnnotation(IDefs.IOnEventDefs);
   }
}

class MethodMember extends BaseVueDefMember {
   BaseVueDefinitions def_host;
   VueClassParser     comp_host;
   
   MethodMember({MethodsParser body, this.def_host, this.comp_host})
      :super(def_host, comp_host)
   {
      this.body = TClsMember(method: body);
      if (isGetter || isSetter)
         warningForInvalidMethod(body.name.name, body);
      _guardMethodType(body, getter: false, setter: false);
      _guardAnnotation(IDefs.IMethodDefs);
   }
}

class FilterMember extends BaseVueDefMember {
   BaseVueDefinitions def_host;
   VueClassParser     comp_host;
   
   FilterMember({MethodsParser body, this.def_host, this.comp_host})
      :super(def_host, comp_host)
   {
      this.body = TClsMember(method: body);
      if (isGetter || isSetter)
         warningForInvalidMethod(body.name.name, body);
      _guardMethodType(body, getter: false, setter: false);
      _guardAnnotation(IDefs.IFilterDefs);
   }
}

class WatchMember extends BaseVueDefMember {
   TType  prop_type;
   bool   deep;
   bool   immediate;
   String _prop_name;
   
   FieldsParser       deep_field;
   FieldsParser       immediate_field;
   BaseVueDefinitions def_host;
   VueClassParser     comp_host;
   
   MethodsParser get watcher => method_body;
   
   String  get prop_name {
      if (_prop_name != null) return _prop_name;
      if (field_body != null) return _prop_name = field_body.names.first;
      if (deep_field != null) return _prop_name = FN.range(deep_field.names.first, -PSEUDO_DEEP.length);
      if (immediate_field != null) return _prop_name = FN.range(immediate_field.names.first, -PSEUDO_IMMEDIATE.length);
      if (method_body == null)
         throw Exception('Uncaught Exception');
      return _prop_name = getPossiblePropNames().first;
   }
   
   List<String> getPossiblePropNames() {
      var raw_name   = method_body.name.name;
      var lower_name = raw_name.toLowerCase();
      if (lower_name.startsWith('on') && lower_name.endsWith('changed')){
         var raw_prop      = FN.range(raw_name, 'on'.length, -'changed'.length);
         var lower_prop    = raw_prop[0].toLowerCase() + raw_prop.substring(1);
         var possible_props= [raw_prop, lower_prop];
         var possible_data = comp_host.data.data.values.toList()
            .where((data) => possible_props.contains(data.name.toLowerCase())).toList();
         
         if (possible_data.length > 1) return possible_props;
         else                          return possible_data.map((x) => x.name).toList();
      }
      return null;
   }
   
   TType _getPropType(){
      var field_type = method_body.params.params.params.first.func_type
         ?? method_body.params.params.params.first.named_type;
      return TType.astNodeInit(field_type);
   }
   
   _guardOnChangedHandler() {
      _guardMethodParams(method_body, [prop_type, prop_type], 'watcher', 2);
      var pnames = getPossiblePropNames();
      if (pnames == null)
         warningForInvalidConvention(method_body, 'onChange');
      if (pnames.length > 1)
         warningForObscureConvention(pnames, method_body);
   }
   
   WatchMember({this.deep_field, this.immediate_field, FieldsParser field_body,
      @required MethodsParser watcher, this.def_host, this.comp_host}) :super(def_host, comp_host)
   {
      this.method_body = watcher;
      deep      = deep_field?.assigned_value?.toSource()      == 'true' ?? false;
      immediate = immediate_field?.assigned_value?.toSource() == 'true' ?? false;
      prop_type = _getPropType();

      this.field_body  = field_body ?? comp_host.cls_parser.getField(prop_name);
      if (this.field_body == null){
         warningForWatchedPropertyNotFound(prop_name, watcher);
      }
      _guardOnChangedHandler();
      _guardAnnotation(IDefs.IWatcherDefs);
   }
}

class PropMember extends BaseVueDefMember {
   BaseVueDefinitions def_host;
   VueClassParser     comp_host;
   String validator_name;
   String prop_name;
   TType  prop_type;
   bool   is_required;
   
   TType _getPropType(){
      return TType.astNodeInit(field_body.named_type ?? field_body.func_type);
   }
   
   PropMember({this.is_required, this.prop_name, @required FieldsParser field,
     MethodsParser validator, this.def_host, this.comp_host}) :super(def_host, comp_host)
   {
      field_body     = field;
      validator_name = getPropValidatorConvention(prop_name);
      method_body    = def_host.cls_parser.methods.firstWhere((method) => method.name.name == validator_name, orElse: () => null);
      is_required  ??= false;
      prop_type   = _getPropType();
      _guardValidator();
      _guardAnnotation(IDefs.IPropDefs);
   }
   
   List<String>
   get inferredPropnames {
      var expect_type;
      var real_type;
      return guard<List<String>>((){
         var lname       = validator_name.toLowerCase();
         if (lname.startsWith('on') && lname.endsWith('validated')) {
            var validator_propname   = validator_name.substring(2, validator_name.length - 'validated'.length);
            var possible_v    = [validator_propname, validator_propname[0].toLowerCase() + validator_propname.substring(1)];
            var possible_data = possible_v.where((v) => v == prop_name).toList();
            // ----------------------
            if (possible_data.length > 1) return possible_v;
            else                          return possible_data;
         }
         return null;
      },
         'Faild to infer propname from Validator:${method_body}, expect:$expect_type to be :$real_type',
         error:'InferPropertyName'
      );
   }
   
   _guardValidator() {
      _guardMethodParams(method_body, [prop_type], 'Validator', 1);
      var possible_names = inferredPropnames;
      if (possible_names == null) {
         warningForFieldNameNotFound(prop_name, field_body);
         raise('not a proper onValidated convention: ${method_body.name.name}');
      }
      if (possible_names.length > 1) {
         warningForObscureConvention(possible_names, method_body);
         raise('watcher handler for:$name indicates to an obscure implication, cannot infer '
         'whether to choose ${possible_names[0]} or ${possible_names[1]} as watched property');
      }
   }
}


/*



               D E F I N I T I O N    C L A S S




*/
class AllDefs {
   static Map<VueClassParser, PropDefnitions>      props = {};
   static Map<VueClassParser, DataDefinitions>     data = {};
   static Map<VueClassParser, MethodDefinitions>   methods = {};
   static Map<VueClassParser, WatchDefinitions>    watchers = {};
   static Map<VueClassParser, OnceDefinitions>     once = {};
   static Map<VueClassParser, OnDefinitions>       on = {};
   static Map<VueClassParser, OptionDefinitions>   option = {};
   static Map<VueClassParser, ComputedDefinitions> computed = {};
   static Map<VueClassParser, FiltersDefinitions>   filters = {};
   
   //todo:
   static getCacheKey(){
   }
   static removeCacheByName(String name){
   
   }
}

class PropDefnitions extends BaseVueDefinitions<PropMember> {
   ClassDeclParser cls_parser;
   VueClassParser  host_comp;
   
   Map<String, PropMember>
   get props => definitions;
   
   void
   set props(Map<String, PropMember> v) {
      definitions = v;
   }

   factory PropDefnitions(VueClassParser host_comp, ClassDeclParser parser){
      if (AllDefs.props[host_comp] != null) return AllDefs.props[host_comp];
      return AllDefs.props[host_comp] = PropDefnitions.init(host_comp, parser);
   }
   
   PropDefnitions.init(this.host_comp, this.cls_parser): super(host_comp, cls_parser) {
      props  ??= {};
      fieldsInit((field, field_name) {
         if (isPropRequired(field_name)) return null;
         
         var required_name  = getPropReqiuredConvention(field_name);
         var validator_name = getPropValidatorConvention(field_name);
         var required       = cls_parser.getField(required_name)
                              ?.assigned_value?.toString() == 'true' ?? false;
         var validator = cls_parser.getMethod(validator_name)?.first; //getValidatorByFieldName(field_name, host_parser);

         props[field_name] = PropMember(
            is_required: required, validator: validator, prop_name: field_name,
            field: field, def_host: this, comp_host: host_comp,
         );
      }, 'PropMember');
   }
   
   PropMember
   operator [](String key) {
      return props[key];
   }
}

class ComputedDefinitions extends BaseVueDefinitions<ComputedMember> {
   ClassDeclParser cls_parser;
   VueClassParser host_comp;
   
   Map<String, ComputedMember>
   get props => definitions;
   
   void
   set props(Map<String, ComputedMember> v) {
      definitions = v;
   }

   factory ComputedDefinitions(VueClassParser host_comp, ClassDeclParser parser){
      if (AllDefs.computed[host_comp] != null) return AllDefs.computed[host_comp];
      return AllDefs.computed[host_comp] = ComputedDefinitions.init(host_comp, parser);
   }
   
   ComputedDefinitions.init(this.host_comp, this.cls_parser): super(host_comp, cls_parser) {
      props ??= {};
      var methods_pairs = <String, List<MethodsParser>>{};
      cls_parser.methods.forEach((method){
         if (method.name.name.startsWith(PSEUDO_GETTER) || method.name.name.startsWith(PSEUDO_SETTER)){
            methods_pairs[method.name.name.substring(4)] ??= [];
            methods_pairs[method.name.name.substring(4)].add(method);
         }else{
            warningForInvalidComputed(method.name.name, method);
         }
      });
      
      methods_pairs.keys.forEach((method_name) {
         props[method_name] = ComputedMember(
            def_host: this, comp_host: host_comp, methods: methods_pairs[method_name],
         );
      });
   }
}

class MethodDefinitions extends BaseVueDefinitions<MethodMember> {
   ClassDeclParser cls_parser;
   VueClassParser comp_host;
   
   Map<String, MethodMember>
   get methods => definitions;
   
   void
   set methods(Map<String, MethodMember> v) {
      definitions = v;
   }
   
   MethodMember
   getMethodByName(String method_name){
      return methods[method_name];
   }
   
   factory MethodDefinitions(VueClassParser host_comp, ClassDeclParser parser){
      if (AllDefs.methods[host_comp] != null) return AllDefs.methods[host_comp];
      return AllDefs.methods[host_comp] = MethodDefinitions.init(host_comp, parser);
   }
   
   MethodDefinitions.init(this.comp_host, this.cls_parser): super(comp_host, cls_parser)  {
      methods ??= {};
      cls_parser.methods.forEach((method) {
         var method_name = method.name.name;
         methods[method_name] = MethodMember(
            def_host: this, comp_host: comp_host, body: method
         );
      });
   }
}


class FiltersDefinitions extends BaseVueDefinitions<FilterMember> {
   ClassDeclParser cls_parser;
   VueClassParser comp_host;
   
   Map<String, FilterMember>
   get filters => definitions;
   
   void
   set filters(Map<String, FilterMember> v) {
      definitions = v;
   }
   
   FilterMember
   getFilterByName(String method_name){
      return filters[method_name];
   }
   
   factory FiltersDefinitions(VueClassParser host_comp, ClassDeclParser parser){
      if (AllDefs.methods[host_comp] != null) return AllDefs.filters[host_comp];
      return AllDefs.filters[host_comp] = FiltersDefinitions.init(host_comp, parser);
   }
   
   FiltersDefinitions.init(this.comp_host, this.cls_parser): super(comp_host, cls_parser)  {
      filters ??= {};
      cls_parser.methods.forEach((method) {
         var method_name = method.name.name;
         filters[method_name] = FilterMember(
            def_host: this, comp_host: comp_host, body: method
         );
      });
   }
}





class DataDefinitions extends BaseVueDefinitions<DataMember> {
   ClassDeclParser cls_parser;
   VueClassParser comp_host;
   
   Map<String, DataMember>
   get data => definitions;
   
   void
   set data(Map<String, DataMember> v) {
      definitions = v;
   }

   factory DataDefinitions(VueClassParser host_comp, ClassDeclParser parser){
      if (AllDefs.data[host_comp] != null) return AllDefs.data[host_comp];
      return AllDefs.data[host_comp] = DataDefinitions.init(host_comp, parser);
   }
   
   DataDefinitions.init(this.comp_host, this.cls_parser): super(comp_host, cls_parser) {
      data ??= {};
      cls_parser.methods.forEach((method) {
         var method_name = method.name.name;
         data[method_name] = DataMember(
            comp_host: comp_host, def_host: this, field_or_method: method
         );
      });
      cls_parser.fields.forEach((field) {
         field.names.forEach((field_name) {
            data[field_name] = DataMember(
               comp_host: comp_host, def_host: this, field_or_method: field
            );
         });
      });
   }
}


class OptionDefinitions extends BaseVueDefinitions<OptionMember> {
   ClassDeclParser cls_parser;
   VueClassParser  comp_host;
   
   Map<String, OptionMember>
   get options => definitions;
   
   void
   set options(Map<String, OptionMember> v) {
      definitions = v;
   }

   factory OptionDefinitions(VueClassParser host_comp, ClassDeclParser parser){
      if (AllDefs.option[host_comp] != null) return AllDefs.option[host_comp];
      return AllDefs.option[host_comp] = OptionDefinitions.init(host_comp, parser);
   }
   
   OptionDefinitions.init(this.comp_host, this.cls_parser): super(comp_host, cls_parser) {
      options ??= {};
      var buildin_fields  = BUILDIN_FIELDS;
      var buildin_methods = VUE_HOOKS;
      
      /*
      [NOTE] about buildin fields.
      
         Prevent overriding buildin_fields of VueComponents if user redefine
         those fields in OptionDefinition.
      
      
      [NOTE] about defining vue hooks in OptionDefinition
      
         Since all vue hooks overrides by vue component, user still can fetch those
         hooks via $dart_option.hook_name.
         [EX]
            beforeCreate() {
               $dart_option.beforeCreate();
            }
      */
      cls_parser.methods.forEach((method) {
         var method_name = method.name.name;
         if (buildin_methods.contains(method_name))
            return warningForOverridingBuildinMethods(method);
         
         options[method_name] = OptionMember(
            comp_host: comp_host, def_host: this, field_or_method: method
         );
      });
      
      cls_parser.fields.forEach((field) {
         field.names.forEach((field_name) {
            if (buildin_fields.contains(field_name))
               return warningForOverridingBuildinFields(field);
            options[field_name] = OptionMember(
               comp_host: comp_host, def_host: this, field_or_method: field
            );
         });
      });
   }
}

class OnDefinitions extends BaseVueDefinitions<OnMember> {
   ClassDeclParser cls_parser;
   VueClassParser comp_host;
   
   Map<String, OnMember>
   get methods => definitions;
   
   void
   set methods(Map<String, OnMember> v) {
      definitions = v;
   }
   
   factory OnDefinitions (VueClassParser host_comp, ClassDeclParser parser) {
      if (AllDefs.on[host_comp] != null) return AllDefs.on[host_comp];
      return AllDefs.on[host_comp] = OnDefinitions.init(host_comp, parser);
   }
   
   OnDefinitions.init (this.comp_host, this.cls_parser): super(comp_host, cls_parser)  {
      methods ??= {};
      cls_parser.methods.forEach((method) {
         var method_name = method.name.name;
         methods[method_name] = OnMember(
            handler: method, def_host: this, comp_host: comp_host
         );
      });
   }
}

class OnceDefinitions extends BaseVueDefinitions<OnceMember> {
   ClassDeclParser cls_parser;
   VueClassParser comp_host;
   
   Map<String, OnceMember>
   get methods => definitions;
   
   void
   set methods(Map<String, OnceMember> v) {
      definitions = v;
   }
   
   factory OnceDefinitions (VueClassParser host_comp, ClassDeclParser parser) {
      if (AllDefs.once[host_comp] != null) return AllDefs.once[host_comp];
      return AllDefs.once[host_comp] = OnceDefinitions.init(host_comp, parser);
   }
   
   OnceDefinitions.init (this.comp_host, this.cls_parser): super(comp_host, cls_parser)  {
      methods ??= {};
      cls_parser.methods.forEach((method) {
         var method_name = method.name.name;
         methods[method_name] = OnceMember(
            handler: method, def_host: this, comp_host: comp_host
         );
      });
   }
}

class WatchDefinitions extends BaseVueDefinitions<WatchMember> {
   ClassDeclParser cls_parser;
   VueClassParser comp_host;
   
   Map<String, WatchMember>
   get watchers => definitions;
   
   void
   set watchers(Map<String, WatchMember> v) {
      definitions = v;
   }

   factory WatchDefinitions(VueClassParser host_comp, ClassDeclParser parser){
      if (AllDefs.watchers[host_comp] != null) return AllDefs.watchers[host_comp];
      return AllDefs.watchers[host_comp] = WatchDefinitions.init(host_comp, parser);
   }
   
   WatchDefinitions.init(this.comp_host, this.cls_parser): super(comp_host, cls_parser)  {
      watchers ??= {};
      
      var deep_fields      = <String, FieldsParser>{};
      var immediate_fields = <String, FieldsParser>{};
      var watcher_methods   = <String, MethodsParser>{};
      var watched_fields    = <String, FieldsParser> {};
      
      fieldsInit((field, field_name){
         if (isWatcherDeep(field_name)){
            deep_fields[FN.range(field_name, 0, -PSEUDO_DEEP.length)] = field;
         } else if (isWatcherImmediate(field_name)){
            immediate_fields[FN.range(field_name, 0, -PSEUDO_IMMEDIATE.length)] = field;
         } else if (isPrivate(field_name)){
         
         } else{
            watched_fields[field_name] = field;
            var watcher_name = getWatchOnChangedConvention(field_name);
            var watcher      = cls_parser.getMethod(watcher_name).first;
            if (watcher != null)
               watcher_methods[field_name] = watcher;
            else
               warningForWatcherNotDefined(field_name, watcher_name, field);
         }
      }, 'WatchMember');
      
      watcher_methods.keys.forEach((field_name){
         watchers[field_name] = WatchMember(
            comp_host       : comp_host,
            def_host        : this,
            watcher         : watcher_methods[field_name],
            deep_field      : deep_fields[field_name],
            immediate_field : immediate_fields[field_name],
            field_body      : watched_fields[field_name]
         );
      });
   }
}

abstract class BaseVueDefinitions<D> {
   VueClassParser       comp_host;
   ClassDeclParser      cls_parser;
   EDefTypes            _def_type;
  
   BaseDefTransformer   transformer;
   Map<String, D>       definitions;
   BaseVueDefinitions   _super_def;
   BaseVueDefinitions   _root_def;
   
   /*
   [NOTE]
      Difference Between super_cls and root_cls
      - super_cls could be null if no further inheritance
      - root_cls could not be null since "root" also indicates itself
   */
   @nullable ClassDeclParser
   get super_cls {
      return getExtendedClassesWithinFile(comp_host.vue_owner, cls_parser)?.first;
   }
   
   ClassDeclParser
   get root_cls{
      var imported_classes = getImportedClasses(comp_host.vue_owner.imp_divs, comp_host.vue_owner);
      return getRootCls(cls_parser, imported_classes);
   }
   
   /* [NOTE]
      Difference Between super_def and root_def
      - super_def could be null if no further inheritance
      - root_def could not be null since "root" also indicates itself
   */
   @nullable BaseVueDefinitions
   get super_def {
      if (_super_def != null) return _super_def;
      var imported_defs = getVueDefsFromImportClauses(cls_parser.file.imp_divs);
      _super_def = imported_defs
         .firstWhere((def) => def.def_name.name == superClsName(cls_parser),
            orElse: () => null);
      return _super_def;
   }
   
   BaseVueDefinitions
   get root_def{
      if (_root_def != null) return _root_def;
      var imported_defs = getVueDefsFromImportClauses(cls_parser.file.imp_divs);
      var root_cls = getRootCls(cls_parser, imported_defs.map((def) => def.cls_parser).toList());
      _root_def = clsToVueDefinition(comp_host, root_cls);
      return _root_def;
   }
   
   EDefTypes
   get def_type {
      if (_def_type != null) return _def_type;
      if (!VUE_INTERFACES.contains(root_cls.name.name))
         throw Exception('Uncaught Exception');
      
      switch (super_cls.name.name){
         case IMETHOD: _def_type = EDefTypes.method; break;
         case IOPTION: _def_type = EDefTypes.option; break;
         case ICOMPUTED: _def_type = EDefTypes.computed; break;
         case IDATA: _def_type = EDefTypes.data; break;
         case ION: _def_type = EDefTypes.on; break;
         case IONCE: _def_type = EDefTypes.once; break;
         case IPROP: _def_type = EDefTypes.prop; break;
         case IWATCHER: _def_type = EDefTypes.watch; break;
         default:
            throw Exception('Uncaught Exception, invalid def_name: ${def_name.name}');
      }
      return _def_type;
   }
   
   SimpleIdentifierImpl
   get def_name => cls_parser.name;
   
   fieldsInit(void cb(FieldsParser field, String field_name), String type){
      cls_parser.fields.forEach((field) {
         field.names.forEach((field_name){
            guard<void>((){
                  cb(field, field_name);
               }, 'Initialize Definition Member: $type.$field_name Failed',
               error: '${type}Error'
            );
         });
      });
   }
   
   methodsInit(void cb(MethodsParser method, String method_name), String type){
      cls_parser.methods.forEach((method) {
         guard<void>((){
               cb(method, method.name.name);
            }, 'Initialize Definition Member: $type.${method.name.name} Failed',
            error: '${type}Error'
         );
      });
   }
   
   BaseVueDefinitions(this.comp_host, this.cls_parser){
      if (comp_host == null || cls_parser == null)
         throw Exception('Invalid Usage.');
   }
   
   //notImplemented:
   use(BaseDefTransformer transformer) {
      this.transformer = transformer;
   }
}



// used to be annotated on vue component
class VueAnnotation {
   Map<String, NamedExpressionImpl> named_args;
   List<SyntacticEntity>            args;
   AnnInvokeParser annotation;
   AnnotationImpl  origin;
   VueClassParser  host;
   
   bool get isMixin     => annotation.name.toSource().endsWith('Mixin');
   bool get isComponent => annotation.name.toSource().endsWith('Component');
   
   VueAnnotation (this.annotation, this.host, this.origin) {
      args        = annotation.arguments.args;
      named_args  = annotation.arguments.named_args;
   }

   ClassDeclParser
   _getRefCls(String name){
      if (named_args[name] == null) return null;
      var arg_value = named_args[name].expression.toSource();
      var ret = host.cls_parser.file.cls_decls.firstWhere (
         (cls) => cls.name.name == arg_value, orElse: () => null
      );
      _log.info('getRefCls: $name, ${ret?.name?.name}');
      return ret;
   }
}

class ComponentAnnotation extends VueAnnotation {
   Map<String, NamedExpressionImpl> named_args;
   Map<String, ClassDeclParser>     _components;
   
   List<SyntacticEntity> args;
   AnnInvokeParser       annotation;

   VueClassParser  host;
   AnnotationImpl  origin;
   String          _template;
   
   String
   get el {
      return named_args['el'].expression.toSource();
   }
   
   String
   get template {
      if (_template != null) return _template;
      var tmp = isTemplateFilePath(named_args['template'].toString())
         ? File(named_args['template'].toString()).readAsStringSync()
         : named_args['template'].toString();
      return _template = tmp;
   }
   
   Map<String, ClassDeclParser>
   get components {
      if (_components != null) return _components;
      var data = named_args['components'].expression as SetOrMapLiteralImpl;
      var ret = <String, ClassDeclParser>{};
      data.entries.forEach((entry){
         var entry_value = entry.value.toSource();
         var imports     = host.cls_parser.file.imp_divs
            .firstWhere((imp) =>
               imp.exports.contains(entry_value) && isNotModuleImport(imp), orElse: () => null);
         ret[entry_value] = imports.content_parser.cls_decls
            .firstWhere((cls) =>
               entry_value.endsWith(cls.name.name), orElse: () => null);
      });
      return _components = ret;
   }
   
   ComponentAnnotation( this.annotation, this.host, this.origin ): super(annotation, host, origin) {
      if (!isComponent) throw Exception('annotation name:${annotation.name.name} is not matched with "Component"');
   }
}

class MixinAnnotation extends VueAnnotation{
   AnnInvokeParser                  annotation;
   Map<String, NamedExpressionImpl> named_args;
   List<SyntacticEntity>            args;
   VueClassParser                   host;
   AnnotationImpl                   origin;
   
   DataDefinitions
   get data {
      var parser = _getRefCls('data');
      return parser != null
         ? DataDefinitions(host, parser)
         : annNotAssigned('data');
   }

   ComputedDefinitions
   get computed {
      var parser = _getRefCls('computed');
      return parser != null
         ? ComputedDefinitions(host, parser)
         : annNotAssigned('computed');;
   }

   PropDefnitions
   get prop {
      var parser = _getRefCls('prop');
      return parser != null
         ? PropDefnitions(host, parser)
         : annNotAssigned('prop');;
   }

   WatchDefinitions
   get watch {
      var parser = _getRefCls('watch');
      return parser != null
         ? WatchDefinitions(host, parser)
         : annNotAssigned('watch');;
   }

   OptionDefinitions
   get option {
      var parser = _getRefCls('option');
      return parser != null
         ? OptionDefinitions(host, parser)
         : annNotAssigned('option');;
   }

   OnDefinitions
   get on {
      var parser = _getRefCls('on');
      return parser != null
         ? OnDefinitions(host, parser)
         : annNotAssigned('on');;
   }

   OnceDefinitions
   get once {
      var parser = _getRefCls('once');
      return parser != null
         ? OnceDefinitions(host, parser)
         : annNotAssigned('once');;
   }

   MethodDefinitions
   get method {
      var parser = _getRefCls('method');
      return parser != null
         ? MethodDefinitions(host, parser)
         : annNotAssigned('method');;
   }
   
   FiltersDefinitions
   get filters {
      var parser = _getRefCls('filters');
      return parser != null
         ? FiltersDefinitions(host, parser)
         : annNotAssigned('filters');;
   }
   
   Null annNotAssigned(String name){
      var error = 'VueDefNotAssigned';
      var message =
         'Vue Definition: $name accessed before assignment. \nMake sure you have '
         'assigned it at the first place in Mixin annotation';
      raise(message, error: error);
      return null;
   }
   
   operator [](String key){
      switch(key){
         case 'method':
            return method;
         case 'watch':
            return watch;
         case 'data':
            return data;
         case 'prop':
            return prop;
         case 'on':
            return on ;
         case 'once':
            return once;
         case 'option':
            return option;
         case 'computed':
            return computed;
         default:
            throw Exception('Uncaught Error');
      }
   }
   
   MixinAnnotation(this.annotation, this.host, this.origin): super(annotation, host, origin){
      if (!isMixin)
         throw Exception('annotation name:${annotation.name.name} is not matched with "Mixin"');
   }
}



//study following classes
class VueMethodsParser<E extends DeclarationImpl> extends MethodsParser {
   MethodDeclarationImpl node;
   ClassDeclParser       classOwner;
   VueClassParser        vueOwner;
   BaseVueDefinitions    def_source;
   List<FieldsParser>   _vue_data_refs;
   List<MethodsParser>  _vue_method_refs;
   List<MethodsParser>  _vue_computed_refs;
   List<String>         _vue_assignment_refs;
   List<dynamic>        _vue_refs;
   List<dynamic>        _non_vue_refs;
   
   List<MethodInvokeParser> parsed_annotations;
   
   bool get is_method  => def_source is MethodDefinitions;
   bool get is_computed=> def_source is ComputedDefinitions;
   bool get is_prop    => def_source is PropDefnitions;
   bool get is_hook    => def_source == null && VUE_HOOKS.contains(vueOwner.cls_parser.name.name);
   bool get is_option  => def_source is OptionDefinitions;
   bool get is_provide => def_source is MethodDefinitions && annotationNames.contains('provide');
   bool get is_inject  => def_source is PropDefnitions    && annotationNames.contains('inject');
   bool get is_watch   => def_source is WatchDefinitions;
   bool get is_on      => def_source is OnDefinitions;
   bool get is_once    => def_source is OnceDefinitions;
   
   List<String>
   get template_refs{
      return vueOwner.option_template.refs;
   }
   
   List<FieldsParser>
   get vue_data_refs {
      if (_vue_data_refs != null)
         return _vue_data_refs;
      var data_names = vueOwner.data.data.keys.toList();
      var reference_host = {
         THIS: [classOwner],
         SELF: [vueOwner.cls_parser] + vueOwner.getExtendedClasses()
      };
      return _vue_data_refs = getReferencedClassFields(reference_host).where((field) {
         if (field.names.every((name) => isPublic(name))){
            return data_names.any(
               (name) => field.names.any((fname) => fname == name)
            );
         }
         return false;
      }).toList() ?? [];
   }
   
   List<MethodsParser>
   get vue_method_refs {
      if (_vue_method_refs != null)
         return _vue_method_refs;
      var method_names = vueOwner.method.methods.keys.toList();
      var reference_host = {
         THIS: [classOwner],
         SELF: [vueOwner.cls_parser] + vueOwner.getExtendedClasses()
      };
      return _vue_method_refs = getReferencedClassMethods(reference_host).where((method) {
         if (isPublic(method.name.name))
            return method_names.contains(method.name.name);
         return false;
      }) ?? [];
   }

   List<MethodsParser>
   get vue_computed_refs {
      if (_vue_computed_refs != null)
         return _vue_computed_refs;
      var computed_names = vueOwner.computed.props.keys.toList();
      var reference_host = {
         THIS: [classOwner],
         SELF: [vueOwner.cls_parser] + vueOwner.getExtendedClasses()
      };
      return _vue_computed_refs = getReferencedClassMethods(reference_host).where((method) {
         if (isPublic(method.name.name))
            return computed_names.contains(method.name.name);
         return false;
      }) ?? [];
   }
   
   List<dynamic>
   get vue_refs {
      if (_vue_refs != null) return _vue_refs;
      _vue_refs =  [] + vue_data_refs + vue_method_refs + vue_computed_refs;
      return _vue_refs;
   }
   
   List<String>
   get vue_assignment_refs {
      if (_vue_assignment_refs != null) return _vue_assignment_refs;
      var possible_refs = []
         + vue_data_refs.fold([], (initial, f) => initial + f.names)
         + vue_computed_refs.map((m) => m.name).toList();
      var assignments = assignment_refs_in_body.map((a) => a.refs).toList();
      var ret         = assignments
         .fold(<String>[], (initial, a) => initial + a[1].map((_a) => _a.name)
         .where((ref_name) => possible_refs.contains(ref_name))
         .toList());
      return _vue_assignment_refs = ret;
   }
   
   List<String>
   get vue_refs_string{
      return vue_refs.fold(<String>[], (initial, ref){
         if (ref is FieldsParser) return initial + ref.names;
         if (ref is MethodsParser) return initial + [ref.name.name];
      });
   }
   
   List<Refs<AstNode, SimpleIdentifierImpl>>
   get non_vue_refs {
      if (_non_vue_refs != null) return _non_vue_refs;
      _non_vue_refs ??= [];
      var reference_host = [THIS, SELF];
      var vue_refnames = vue_computed_refs.map((ref) => ref.name.name).toList()
                     + vue_method_refs.map((ref) => ref.name.name).toList()
                     + vue_data_refs.fold([], (initial, ref) => initial + ref.names);
      refs_in_body.forEach((ref) {
         if (!vue_refnames.contains(ref.getTargetRef(reference_host)))
            _non_vue_refs.add(ref);
      });
      return _non_vue_refs;
   }
   
   assertReferenceWarnings(){
      //refinement:
      if (is_method){
         if (vue_data_refs.length > 0 || vue_computed_refs.length > 0)
            warningForTriggeringPotentialInfiniteUpdating(this);
      }else if (is_computed){
         if (non_vue_refs.length > 0)
            warningForReferencingToNonListenableProperty(non_vue_refs);
         if (vue_data_refs.length > 0)
            warningForTriggeringPotentialInfiniteUpdating(this );
      }else if (is_watch){
         if (vue_data_refs.length > 0 || vue_computed_refs.length > 0)
            warningForTriggeringPotentialInfiniteUpdating(this );
         if (vue_method_refs.length > 0)
            warningForTriggeringPotentialInfiniteUpdating(this );
      }
   }
   
   VueMethodsParser(this.node, this.classOwner, this.def_source, this.vueOwner) : super(node, classOwner) {
      var anns = annotations.where((ann) => SUPPORTED_META_FN.contains(ann.name.name));
      parsed_annotations = anns.map((AnnotationImpl ann){
         var invoke = astAnnotationToInvocation(ann);
         return MethodInvokeParser(invoke);
      }).toList();
      assertReferenceWarnings();
   }
}



/*



         E S S E N T I A L    U T I L S



*/


ClassDeclParser
getRootCls(ClassDeclParser cls, List<ClassDeclParser> vue_imported_classes){
   if (cls.ext?.key == null) return cls;
   var extended_super = vue_imported_classes
      .firstWhere((parser) => parser.name.name == superClsName(cls)
         , orElse: () => null);
   if (extended_super == null) {
      _log.log('cannot found "${cls.ext.key}" within import classes: ${vue_imported_classes.map((cls) => cls.name)}');
      return null;
   }
   if (extended_super.ext == null) return extended_super;
   var imported_vue = getVueImportedClasses(extended_super.file.imp_divs, extended_super.file);
   return getRootCls(extended_super, imported_vue);
}

ClassDeclParser
getRootComp(ClassDeclParser cls, List<VueClassParser> vue_imported_comps){
   var extended_super = vue_imported_comps.map((vue) => vue.cls_parser)
      .firstWhere((parser) => parser.name.name == superClsName(cls)
         , orElse: () => null);
   if (extended_super.ext == null) return extended_super;
   var imported_vue = getVueImportedClasses(extended_super.file.imp_divs, extended_super.file);
   return getRootCls(extended_super, imported_vue);
}

@nullable BaseVueDefinitions
clsToVueDefinition(VueClassParser comp, ClassDeclParser cls){
   if (cls == null) return null;
   var ext = cls.ext?.key?.superclass?.name?.name;
   return guard<BaseVueDefinitions>((){
      switch(ext){
         case IPROP:     return PropDefnitions     (comp, cls);
         case IWATCHER:  return WatchDefinitions   (comp, cls);
         case IONCE:     return OnceDefinitions    (comp, cls);
         case ION:       return OnDefinitions      (comp, cls);
         case IDATA:     return DataDefinitions    (comp, cls);
         case ICOMPUTED: return ComputedDefinitions(comp, cls);
         case IOPTION:   return OptionDefinitions  (comp, cls);
         case IMETHOD:   return MethodDefinitions  (comp, cls);
         default:
            return null;
      }
   },
      'Initialize Vue Definition: ${cls.name.name} Failed',
      error: '${cls.name.name}Error');
}

List<BaseVueDefinitions>
getVueDefsViaClassesOrImportDefs (
   List<ClassDeclParser> cls_decls, List<BaseVueDefinitions> vue_imported_defs,
   List<VueClassParser> vue_components)
{
   return cls_decls.where((cls){
      var ext = superClsName(cls);
      if (VUE_INTERFACES.contains(ext))
         return true;
      return vue_imported_defs
         .map((def) => def.cls_parser)
         .any((cls) => cls.name.name == ext);
   }).fold(<BaseVueDefinitions>[], (initial, cls) {
      var comps = vue_components.where (
         (_comp) => _comp.getDefinition(cls) != null
      );
      return initial + comps.map   ((comp) => clsToVueDefinition(comp, cls))
                            .where ((def)  => def != null).toList();
   });
}

List<ClassDeclParser>
getExtendedClassesWithinFile(VueDartFileParser file_parser, ClassDeclParser cls_parser){
   var supers = [cls_parser.ext.key?.superclass?.name?.name];
   var withs  = cls_parser.ext.value?.mixinTypes?.map((t) => t?.name?.name)?.toList() ?? [];
   var extended_names = (supers + withs).where((name) => name != 'null');
   
   var ret = extended_names
      .map((name) => getExtendedClassByNameWithinFile(file_parser, name))
      .where((cls) => cls != null)
      .toList();
   //_log.info('getExtendedClasses: ${ret.map((cls) => cls.name.name)}');
   return ret ?? [];
}

@nullable ClassDeclParser
getExtendedClassByNameWithinFile(VueDartFileParser file_parser, String name){
   var current_cls = file_parser.cls_decls
      .firstWhere((cls) => cls.name.name == name, orElse: () => null);
   if (current_cls != null)
      return current_cls;
   var imported_classes = getVueImportedClasses(file_parser.vue_imports, file_parser);
   return imported_classes.firstWhere((cls) => cls.name.name == name, orElse: () => null);
}

List<ClassDeclParser>
getImportedClasses(List<ImportParser> imp_divs, DartFileParser file){
   return imp_divs
      .where((imp) => isNotModuleImport(imp))
      .fold<List<ClassDeclParser>>([],
         (initial, imp) => initial + getClassesFromImport(imp)
   );
}

List<ClassDeclParser>
getVueImportedClasses(List<ImportParser> imp_divs, DartFileParser file){
   var ret = <ClassDeclParser>[];
   var vue_imports = imp_divs.where((imp) =>
      isVueDart(imp.path) || isVueDartGen(imp.path)//&& isNotModuleImport(imp)
   );
   vue_imports.forEach((imp) {
      ret.addAll( getClassesFromImport(imp) );
   });
   return ret;
}

List<BaseVueDefinitions>
getVueDefsFromImportClauses (List<ImportParser> imp_divs){
   var ret = <BaseVueDefinitions>[];
   imp_divs.where((imp) =>
      isVueDart(imp.path)
      && isNotModuleImport(imp)
   ).forEach((imp) {
      _log.log('try fetching definitions from ${imp.origin.uri}');
      var _ret = getVueDefFromImport(imp);
      ret.addAll(_ret);
      _log.debug('getVueDefFromImport: result: $_ret');
   });
   return ret;
}




/*
   [NOTE]
      get vue definition from import clause.
*/
List<BaseVueDefinitions>
getVueDefFromImport(ImportParser imp){
   if (isModuleImport(imp)) return [];
   if (!isVueDart(imp.path))
      throw Exception('not a vue dart import clause');
   var vue_file_parser = VueDartFileParser(file: imp.content_parser);
   var explicit        = (imp.shows != null ?  imp.shows : []).map((x) => x.name).toList();
   var implicit        = imp.content_parser.cls_decls
      ?.where ((cls) => isVueDef(cls))
      ?.map   ((cls) => clsToVueDefinition(getVueCompByCls(vue_file_parser, cls),cls))
      ?.where ((cls) => cls != null)
      ?.toList() ?? [];
   
   _log.log('implicit vue import: ${implicit.map((b) => b.def_name.name)}');
   _log.log('explicit vue import: ${explicit.map((e) => e.toString())}');
   
   var e_clsdecls  = explicit.map(
      (e) => imp.content_parser.cls_decls
         .firstWhere((cls) =>
            isVueDef(cls) && explicit.any((e) => e.endsWith(cls.name.name)),
            orElse: () => throw Exception('Uncaught Exception')
      )).toList() ?? [];
   
   var imp_cls = <BaseVueDefinitions>[];
   imp_cls = e_clsdecls.length > 0
      ? e_clsdecls
         .map   ((cls) => clsToVueDefinition(getVueCompByCls(vue_file_parser, cls), cls))
         .where ((def) => def != null)
         .toList()
      : implicit;
   return imp_cls;
}


@nullable VueClassParser
getVueCompByCls(VueDartFileParser vue_file, ClassDeclParser cls){
   return vue_file.vue_components.firstWhere((comp){
      return comp.getDefinition(cls) != null;
   }, orElse: () => null);
}



List<ClassDeclParser>
getClassesFromImport(ImportParser imp){
   if (isModuleImport(imp) || !imp.isFilePath(imp.origin.uri.toSource()))
      return [];
   var explicit    = (imp.shows != null ?  imp.shows : []).map((x) => x.name).toList();
   var implicit    = imp.content_parser?.cls_decls ?? [];
   var e_clsdecls  = explicit.map(
      (e) => imp.content_parser.cls_decls
      .firstWhere((cls) => explicit.any((e) => e.endsWith(cls.name.name)),
         orElse: () => throw Exception('Uncaught Exception')
      )
   ).toList() ?? [];
   var imp_cls = <ClassDeclParser>[];
   imp_cls     = e_clsdecls.length > 0
      ? e_clsdecls
      : implicit;
   return imp_cls;
}

List<TopFuncDeclParser>
getTopFnsFromImport(ImportParser imp){
   if (isModuleImport(imp) || !imp.isFilePath(imp.origin.uri.toSource()))
      return [];
   var explicit    = (imp.shows != null ?  imp.shows : []).map((x) => x.name).toList();
   var implicit    = imp.content_parser.func_decls ?? [];
   var e_fns  = explicit.map(
         (e) => imp.content_parser.func_decls
         .firstWhere((cls) => explicit.any((e) => e.endsWith(cls.name.name)),
         orElse: () => throw Exception('Uncaught Exception')
      )
   ).toList() ?? [];
   var imp_fns = <TopFuncDeclParser>[];
   imp_fns = e_fns.length > 0
       ? e_fns
       : implicit;
   return imp_fns;
}

List<TopVarDeclParser>
getTopVarsFromImport(ImportParser imp){
   if (isModuleImport(imp) || !imp.isFilePath(imp.origin.uri.toSource()))
      return [];
   
   var explicit    = (imp.shows != null ?  imp.shows : []).map((x) => x.name).toList();
   var implicit    = imp.content_parser.var_decls ?? [];
   var e_vardecls  = explicit.map(
         (e) => imp.content_parser.var_decls.firstWhere(
               (v_decl) => explicit.any(
                     (e) => v_decl.variables.map((_var) => _var.name.name).any(
                        (name) => e.endsWith(name)
                     )
               ),
         orElse: () => throw Exception('Uncaught Exception')
      )
   ).toList() ?? [];
   var imp_vars = <TopVarDeclParser>[];
   imp_vars = e_vardecls.length > 0
             ? e_vardecls
             : implicit;
   return imp_vars;
}


List<VueClassParser>
getVueImportedComps(List<ImportParser> imp_divs, DartFileParser file){
   var ret = <VueClassParser>[];
   var vue_imports = imp_divs.where((imp) =>
      isVueDart(imp.path) && isNotModuleImport(imp)
   );
   
   vue_imports.forEach((imp) {
      var imp_classes = getClassesFromImport(imp)
         .map((cls) => VueClassParser(cls, imp.content_parser)).toList();
      ret.addAll(imp_classes);
   });
   return ret;
}

void warningLineComment(String message, String comment, AstNode node, {String error = 'AnError'}){
   var visitor = ExpressionCommentAppender([comment], false);
   node.visitChildren(visitor);
   raise(message, error: error);
}

void warningMultiLineComment(List<String> messages, List<String> comments, AstNode node, {String error = 'AnError'}){
   var visitor = ExpressionCommentAppender(comments, true);
   node.visitChildren(visitor);
   messages.forEach((message) => raise(message, error: error));
}

String
getStringFromNamedArg(NamedExpressionImpl arg) =>
   (arg.expression as StringLiteralImpl).stringValue;

SimpleIdentifierImpl
getIdentFromNamedArg(NamedExpressionImpl arg) => arg.expression;

Map<String, String>
getMapFromNamedArg (NamedExpressionImpl arg) {
   var map = arg.expression as SetOrMapLiteralImpl;
   var ret = <String, String>{};
   map.entries.forEach((entry){
      var key   = entry.key.toSource();
      var value = entry.value;
      ret[key] = value.toSource();
   });
   return ret;
}

List<String>
getListFromNamedArg(NamedExpressionImpl arg){
   var list = arg.expression as ListLiteralImpl;
   return list.elements.map((elt) => elt.toSource()).toList();
}




class VueFieldsParser extends FieldsParser {
   FieldDeclarationImpl node;
   ClassDeclParser      classOwner;
   BaseVueDefinitions   def_source;
   VueClassParser       vueOwner;
   List<MethodInvokeParser>  parsed_annotations;
   
   bool get is_data   => def_source is DataDefinitions && isPublic(vueOwner.cls_parser.name.name);
   bool get is_option => def_source is OptionDefinitions;
   bool get is_inject => def_source is MethodDefinitions && annotationNames.contains('inject');
   bool get is_prop   => def_source is PropDefnitions;
   
   VueFieldsParser(this.node, this.classOwner, this.def_source, this.vueOwner) : super(node, classOwner) {
      var supported_anns = annotations.where((ann) => FIELD_ANNS.any((ann_name) => ann.name.name == ann_name));
      parsed_annotations = supported_anns.map((ann) => MethodInvokeParser(astAnnotationToInvocation(ann))).toList();
      
   }
}

var pseudo_hook = VUE_HOOKS.map((s) => s.toLowerCase());



//untested:
class VueDartFileParser extends DartFileParser {
   static Map<String, VueDartFileParser> cache = {};
   
   List<ImportParser>       _vue_imports;           // imported clauses referenced to vue dart
   List<BaseVueDefinitions> _vue_imported_defs;     // classes imported from vue dart that extends from vue interfaces
   List<VueClassParser>     _vue_imported_comps;    // imported classes annotated with vue Component
   List<BaseVueDefinitions> _vue_defs;              // classes extends from vue interfaces
   List<VueClassParser>     _vue_components;        // classes annotated with vue Component
   List<ClassDeclParser>    _non_vue_classes;       //
   
   bool
   isVueMember(ClassDeclParser cls, List<VueClassParser> vue_imported_classes){
      if (cls.ext == null) return false;
      var ext = superClsName(cls);
      if (VUE_INTERFACES.contains(ext))
         return true;
      if (vue_imported_classes.any((vue_cls) =>
            VUE_INTERFACES.contains(vue_cls.cls_parser.ext.key)))
         return true;
      
      var extended_cls = vue_imported_classes.firstWhere((vue_cls) => vue_cls.cls_parser.name.name == ext, orElse: ()=>null);
      if (extended_cls == null)
         return false;
      
      var vue_import = getVueImportedComps(extended_cls.cls_parser.file.imp_divs, extended_cls.cls_parser.file);
      return isVueMember(extended_cls.cls_parser, vue_import);
   }
   
   List<BaseVueDefinitions>
   get vue_defs {
      //note: should initialize definitions first
      if ( _vue_defs != null ) return _vue_defs;
      _vue_defs = getVueDefsViaClassesOrImportDefs(cls_decls, vue_imported_defs, vue_components) ;
      return _vue_defs;
   }
  
   List<VueClassParser>
   get vue_components {
      //note: should initialize definitions first
      if ( _vue_components != null ) return _vue_components;
      var cls_components = cls_decls.where((cls) => cls.annotationNames.contains('Component'));
      _vue_components = cls_components.map((cls) => VueClassParser(cls, this)).toList();
      return _vue_components;
   }
   
   List<BaseVueDefinitions>
   get vue_imported_defs{
      if (_vue_imported_defs != null) return _vue_imported_defs;
      _vue_imported_defs ??= getVueDefsFromImportClauses(imp_divs);
      return _vue_imported_defs;
   }

   List<VueClassParser>
   get vue_imported_comps {
      if (_vue_imported_comps != null) return _vue_imported_comps;
      _vue_imported_comps ??= getVueImportedComps(imp_divs, this);
      return _vue_imported_comps;
   }
   /*
   [NOTE]
      Import Clauses ends with VUE_FILENAME/VUE_GEN_FILENAME, includes
      - vue generated code
      - vue definition
      - vue components
   */
   List<ImportParser>
   get vue_imports{
      if ( _vue_imports != null ) return _vue_imports;
      _vue_imports ??= imp_divs.where((imp) =>
         (isVueDart(imp.path) || isVueDartGen(imp.path)) && isNotModuleImport(imp)
      ).toList();
      return _vue_imports;
   }
   
   ClassDeclParser
   getClsByName(String name){
      var cls = cls_decls.firstWhere((cls) => cls.name.name == name, orElse: () => null);
      if (cls != null) return cls;
      for (var i = 0; i < imp_divs.length; ++i) {
         var imp = imp_divs[i];
         var classes = getClassesFromImport(imp);
         cls = classes.firstWhere((cls) => cls.name.name == name, orElse: () => null);
         if (cls != null) return cls;
      }
      return null;
   }
   
   TopVarDeclParser
   getVarByName(String name){
      var top_var = var_decls.firstWhere((va) => va.variables.map((v) => v.name.name).contains(name) );
      if (top_var != null) return top_var;
      for (var i = 0; i < imp_divs.length; ++i) {
         var imp = imp_divs[i];
         var vars = getTopVarsFromImport(imp);
         top_var = vars.firstWhere((v) => v.variables.map((_v)=>_v.name.name).any((_name) => _name == name) , orElse: () => null);
         if (top_var != null) return top_var;
      }
      return null;
   }
   
   TopFuncDeclParser
   getFnByName(String name){
      var top_fn = func_decls.firstWhere((fn) => fn.name.name == name, orElse: () => null );
      if (top_fn != null) return top_fn;
      for (var i = 0; i < imp_divs.length; ++i) {
         var imp = imp_divs[i];
         var fns = getTopFnsFromImport(imp);
         top_fn = fns.firstWhere((fn) => fn.name.name == name, orElse: () => null);
         if (top_fn != null) return top_fn;
      }
      return null;
   }
   
   factory VueDartFileParser({CompilationUnitImpl code, Uri uri, DartFileParser file}){
      var result;
      if (file == null){
         result = VueDartFileParser.init(code, uri, file);
      } else if (VueDartFileParser.cache[file.file_path] == null){
         result = VueDartFileParser.fileInit(file);
      }else {
         return VueDartFileParser.cache[file.file_path];
      }
      VueDartFileParser.cache[result.file_path] = result;
      return result;
   }
   
   VueDartFileParser.fileInit(DartFileParser file): super.fileInit(file);
   
   VueDartFileParser.init(CompilationUnitImpl code, Uri uri, DartFileParser file)
      :super.init(code, uri.toFilePath(), uri);
}

class CacheManager{
   static Map<String, VueDartFileParser> get files{
      return VueDartFileParser.cache;
   }
   static removeFileKey({String key, DartFileParser file}){
      if (key != null && files.containsKey(key))
         files.remove(key);
      if (file != null && files.containsKey(file.file_path))
         files.remove(file.file_path);
   }
}

class VueClassParser {
   /*static Map<String, VueClassParser> cache = {};
   static String getKey(ClassDeclParser cls){
      return '${cls.file.file_path}/${cls.name.name}';
   }*/
   ClassDeclParser      _super_parser;
   ClassDeclParser      _root_parser;
   ClassDeclParser      cls_parser;
   VueDartFileParser    vue_owner;
   
   MixinAnnotation      mixin_ann;
   ComponentAnnotation  comp_ann;
   
   List<VueFieldsParser>  vue_fields;
   List<VueMethodsParser> vue_methods;
   
   DataDefinitions     _data;
   PropDefnitions      _prop;
   WatchDefinitions    _watch;
   ComputedDefinitions _computed;
   OptionDefinitions   _option;
   OnDefinitions       _on;
   OnceDefinitions     _once;
   MethodDefinitions   _method;
   FiltersDefinitions  _filters;
   
   bool        _isMetaMethodForced;
   bool        _isMetaDataForced;

   Map<String, String> option_components;
   Map<String, FilterMember>  option_filters;
   List<String>option_model;
   List<String>option_delimiters;
   List<String>option_mixins;
   String      option_name;
   String      option_el;
   VueTemplate option_template;
   String      style;

   
   
   DeclaredSimpleIdentifier
   get name => cls_parser.name;
   
   ClassDeclParser
   get super_parser{
      if (_super_parser != null) return _super_parser;
      _super_parser = vue_owner.vue_imported_comps
         .firstWhere((comp) => comp.cls_parser.name.name == superClsName(cls_parser)
            , orElse: () => null
         )?.cls_parser;
      return _super_parser;
   }
   
   ClassDeclParser
   get root_parser{
      if (_root_parser != null) return _root_parser;
      _root_parser = getRootComp(cls_parser, vue_owner.vue_imported_comps);
      return _root_parser;
   }
   
   bool
   get isDataMetaForced {
      if (_isMetaDataForced != null) return _isMetaDataForced;
      return _isMetaDataForced = cls_parser.fieldsAnnotations.map((a) => a.name.name)
         .any((name) => DATA_META.contains(name));
   }
   
   void
   set isDataMetaForced(bool v) {
      _isMetaDataForced = v;
   }
   
   bool
   get isMethodMetaForced {
      if (_isMetaMethodForced != null) return _isMetaMethodForced;
      return _isMetaMethodForced = cls_parser.methodsAnnotations.map((a) => a.name.name)
         .any((name) => METHOD_META.contains(name));
   }
   
   void
   set isMethodMetaForced(bool v) {
      _isMetaMethodForced = v;
   }
   
   Iterable<VueMethodsParser>
   get hooks{
      return vue_methods.where((method) => method.is_hook);
   }
   FiltersDefinitions get filters{
      if (_filters != null) return _filters;
      return _filters  = _getDefFromAnnotation('filters');
   }
   ComputedDefinitions get computed  {
      if (_computed != null) return _computed;
      return _computed  = _getDefFromAnnotation('computed');
   }
   OptionDefinitions get option  {
      if (_option != null) return _option;
      return _option  = _getDefFromAnnotation('option');
   }
   OnDefinitions get on  {
      if (_on != null) return _on;
      return _on  = _getDefFromAnnotation('on');
   }
   OnceDefinitions get once  {
      if (_once != null) return _once;
      return _once  = _getDefFromAnnotation('once');
   }
   MethodDefinitions get method  {
      if (_method != null) return _method;
      return _method  = _getDefFromAnnotation('method');
   }
   WatchDefinitions get watch  {
      if (_watch != null) return _watch;
      return _watch  = _getDefFromAnnotation('watch');
   }
   PropDefnitions get prop  {
      if (_prop != null) return _prop;
      return _prop  = _getDefFromAnnotation('prop');
   }
   DataDefinitions get data {
   if (_data != null) return _data;
     return _data  = _getDefFromAnnotation('data');
   }
   
   VueTemplate
   parseTemplate(String path_or_data){
      //fixme: parseTemplate Failed
      var is_path         = path_or_data.trim().endsWith('.vue');
      var is_vue_template = path_or_data.trim().startsWith('<template>');
      var template_path   = is_path
         ? Path.join(Path.dirname(cls_parser.file.file_path) , path_or_data)
         : null;
      if(is_path && !File(template_path).existsSync()){
         throw Exception('\nFile not found. template :${Path.join(cls_parser.file.file_path, path_or_data)} not found');
      }
      var raw_data = is_path
         ? File(template_path).readAsStringSync()
         : is_vue_template
            ? path_or_data
            : (){throw Exception('Uncaught Exception \n$path_or_data is_path: $is_path, is_template $is_vue_template');}();
      return VueTemplate(raw_data: raw_data, host: this);
   }
   
   
   BaseVueDefinitions
   _getDefFromAnnotation(String def_name){
      _log.log('getDefFromAnn: $def_name');
      switch(def_name){
         case 'method':
            return mixin_ann.method ;
         case 'watch':
            return mixin_ann.watch ;
         case 'data':
            return mixin_ann.data ;
         case 'prop':
            return mixin_ann.prop ;
         case 'on':
            return mixin_ann.on  ;
         case 'once':
            return mixin_ann.once ;
         case 'option':
            return mixin_ann.option ;
         case 'computed':
            return mixin_ann.computed ;
         case 'filters':
            return mixin_ann.filters ;
         default:
            throw Exception('Uncaught Error');
      }
   }
   
   
   List<ClassDeclParser>
   getExtendedClasses(){
      return getExtendedClassesWithinFile(vue_owner, cls_parser);
   }
   
   ClassDeclParser
   getExtendedClassByName(String name){
      return getExtendedClassByNameWithinFile(vue_owner, name);
   }
   
   // untested:
   Iterable<MethodsParser>
   getMethod(String name){
      var classes = [this.cls_parser] + getExtendedClasses();
      var ret;
      for (var i = 0; i < classes.length; ++i) {
         var cls = classes[i];
         var ret = cls.getMethod(name);
         if (ret.length > 0) return ret;
      }
      return ret;
   }
   
   // untested:
   FieldsParser
   getField(String name){
      var classes = [this.cls_parser] + getExtendedClasses();
      var ret;
      for (var i = 0; i < classes.length; ++i) {
         var cls = classes[i];
         var ret = cls.getField(name);
         if (ret != null) return ret;
      }
      return ret;
   }
   
   
   getDefinition(field_method_cls){
      // note:notice:
      // following section should be initialized before calling mixinInit.
      var ret;
     
      if (field_method_cls is FieldsParser){
         ret =   data?.definitions?.values?.firstWhere((value) => value.field_body == field_method_cls, orElse: () => null)
            ??   prop?.definitions?.values?.firstWhere((value) => value.field_body == field_method_cls, orElse: () => null)
            ?? option?.definitions?.values?.firstWhere((value) => value.field_body == field_method_cls, orElse: () => null);
      } else if (field_method_cls is MethodsParser){
         ret =     data?.definitions?.values?.firstWhere((value) => value.method_body == field_method_cls, orElse: () => null)
            ??     prop?.definitions?.values?.firstWhere((value) => value.method_body == field_method_cls, orElse: () => null)
            ??    watch?.definitions?.values?.firstWhere((value) => value.method_body == field_method_cls, orElse: () => null)
            ?? computed?.definitions?.values?.firstWhere((value) =>
                  value.body.contains(field_method_cls), orElse: () => null)
            ?? option?.definitions?.values?.firstWhere((value) => value.method_body == field_method_cls, orElse: () => null)
            ??     on?.definitions?.values?.firstWhere((value) => value.method_body == field_method_cls, orElse: () => null)
            ?? method?.definitions?.values?.firstWhere((value) => value.method_body == field_method_cls, orElse: () => null);
      } else if (field_method_cls is ClassDeclParser){
         ret                        = data?.cls_parser == field_method_cls
            || prop?.cls_parser     == field_method_cls
            || watch?.cls_parser    == field_method_cls
            || computed?.cls_parser == field_method_cls
            || option?.cls_parser   == field_method_cls
            || on?.cls_parser       == field_method_cls
            || once?.cls_parser     == field_method_cls
            || method?.cls_parser   == field_method_cls;
      }
      return ret;
   }
   
   assertMixinArgs(){
      if (mixin_ann == null)
         return warningForMixinAnnotationNotDefined(cls_parser);
      var invok = mixin_ann;
      var data_ident     = invok.named_args['data'];
      var prop_ident     = invok.named_args['prop'];
      var watch_ident    = invok.named_args['watch'];
      var computed_ident = invok.named_args['computed'];
      var option_ident   = invok.named_args['option'];
      var on_ident       = invok.named_args['on'];
      var once_ident     = invok.named_args['once'];
      var method_ident   = invok.named_args['method'];
      var messages       = <String>[],
          comments       = <String>[];
      
      if (data_ident == null) {
         messages.add("It's recommended to create a data definition class");
         comments.add("It's recommended to create a data definition class");
      }
      if (method_ident == null){
         messages.add("It's recommended to create a method definition class");
         comments.add("It's recommended to create a method definition class");
      }
      var statement = getCommentableDeclFromNode(mixin_ann.origin);
      warningMultiLineComment(messages, comments, statement);
   }
   
   componentInit(){
      List<ClassDeclParser> decls;
      List<VueClassParser>  imported_comps;
      var invok    = comp_ann;
      var el_value = getStringFromNamedArg (invok.named_args['el']);
      var template_value  = getStringFromNamedArg(invok.named_args['template']);
      var components_value= getMapFromNamedArg   (invok.named_args['components']);
      var mixin_value     = getListFromNamedArg  (invok.named_args['mixins']);
      
      option_el         = el_value;
      //fixme: parseTemplate failed
      option_template   = parseTemplate(template_value);
      option_components = components_value;
      option_name       = getStringFromNamedArg(invok.named_args['name']);
      option_mixins     = mixin_value;
      option_filters    = filters?.filters;
      option_delimiters = (invok.named_args['delimiters']?.expression as ListLiteralImpl)
         ?.elements
         ?.map((f) => (f as StringLiteralImpl).stringValue)
         ?.toList();
      option_model = (invok.named_args['model']?.expression as InvocationExpressionImpl)
         ?.argumentList?.arguments
         ?.map((arg) => (arg as StringLiteralImpl).stringValue)
         ?.toList();
   }
   
   mixinInit(){
      vue_owner.vue_imported_defs;
      prop;
      computed;
      option;
      on;
      once;
      method;
      data;
      watch;
      assertMixinArgs();
   }
   
   fieldsInit(){
      if (vue_fields != null) return;
      vue_fields = cls_parser.fields.map((field){
         var names = field.names;
         if (BUILDIN_FIELDS.any((bname) => names.contains(bname)))
            return warningForOverridingBuildinFields(field);
         var node = field.origin;
         var classOwner = cls_parser;
         var def_source = getDefinition(field);
         var vueOwner = this;
         return VueFieldsParser(node, classOwner, def_source, vueOwner);
      }).toList();
   }
   
   methodsInit(){
      if (vue_methods != null) return;
      vue_methods = cls_parser.methods.map((method){
         var node = method.origin;
         var classOwner = cls_parser;
         var def_source = getDefinition(method);
         var vueOwner = this;
         return VueMethodsParser(node, classOwner, def_source, vueOwner);
      }).toList();
      /*
      lifecycle_fields       = _getLifeCycles();*/
      //----------------------------------------
   }

   annotationsInit(){
      var annotations  = cls_parser.annotations
         .where((ann) => COMP_ANNS.contains (ann.name.name))
         .map((ann) {
            var invok = AnnInvokeParser(ann);
            if (ann.name.name == ANN_COMP)
               comp_ann = ComponentAnnotation(invok, this, invok.origin);
            if (ann.name.name == ANN_MIXIN)
               mixin_ann = MixinAnnotation(invok, this, invok.origin);
            return comp_ann ?? mixin_ann;
      }).toList();
   }
   
   
   factory VueClassParser(ClassDeclParser cls_parser, [VueDartFileParser vue_owner]) {
      /*var key = getKey(cls_parser);
      if (VueClassParser.cache.containsKey(key)){
         return VueClassParser.cache[key];
      }
      VueClassParser.cache[key] = VueClassParser.init(cls_parser, vue_owner);
      return VueClassParser.cache[key];*/
      return VueClassParser.init(cls_parser, vue_owner);
   }
   
   VueClassParser.init(ClassDeclParser this.cls_parser, [VueDartFileParser this.vue_owner]) {
      annotationsInit();
      mixinInit();
      componentInit();
      fieldsInit();
      methodsInit();
   }
}












