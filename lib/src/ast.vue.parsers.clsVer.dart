//@fmt:off
//import 'package:astMacro/src/common.dart';
import 'dart:io' show File;

import 'package:path/path.dart' as Path;
import 'package:analyzer/dart/ast/ast.dart'              show AstNode;
import 'package:analyzer/dart/ast/syntactic_entity.dart' show SyntacticEntity;
import 'package:analyzer/src/dart/ast/ast.dart';

//import 'ast.vue.dart';
import 'ast.vue.transformers.dart' show ExpressionCommentAppender;
import 'ast.vue.spell.dart'      show TypoSuggest;
import 'common.dart'             show FN, raise, tryRaise;
import 'common.spell.dart'       show CamelCaseTyping;
import 'ast.vue.annotation.dart' show DATA_META, INJECT_META, METHOD_META, PROVIDE_META, VUE_HOOKS;
import 'ast.vue.template.dart'   show VueTemplate;
import 'ast.parsers.dart';
import 'ast.codegen.dart';

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

final SUPPORTED_META_FN    = PROVIDE_META + INJECT_META;
final SUPPORTED_META_FIELD = [];

const ANN_MIXIN   = 'Mixin';
const ANN_COMP    = 'Component';
const ANN_ON      = 'On';
const ANN_PROVIDE = 'provide';
const ANN_INJECT  = 'inject';
const COMP_ANNS   = [ANN_MIXIN, ANN_COMP];
const FIELD_ANNS  = [ANN_INJECT];
const METHOD_ANNS = [ANN_ON, ANN_PROVIDE];

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

final ALPHABETIC = 'abcdefghijklmnopqrstuvwxyz'.split('');

abstract class BaseDefTransformer {
}

/*



                             CONDITIONS
      
      
      
*/

bool isIntType(String type_name) {
   return type_name == 'int';
}

bool isNumberType(String type_name) {
   return type_name == 'num' || type_name == 'double' || type_name == 'int';
}

bool isBoolType(String type_name) {
   return type_name == 'bool';
}

bool isStringType(String type_name) {
   return type_name == 'String';
}

bool isListType(String type_name) {
   return type_name.indexOf('List') != -1;
}

bool isDateType(String type_name) {
   return type_name == 'DateTime';
}

bool isSymbolType(String type_name) {
   return type_name == 'Symbol';
}

bool isObjectType(String type_name) {
   return !isListType(type_name)
          && !isBoolType(type_name)
          && !isDateType(type_name)
          && !isStringType(type_name)
          && !isNumberType(type_name);
}

bool isOnChangedWatcher(String field_name) {
   var onl = 2;
   var changedl = 7;
   return field_name.length > onl + changedl
          && field_name.substring(0, onl) == 'on'
          && field_name.substring(changedl + 1) == 'Changed';
}

bool isValidatorProp(String field_name) {
   var onl = 2;
   var validatedl = 9;
   return field_name.length > onl + validatedl
          && field_name.substring(0, onl) == 'on'
          && field_name.substring(validatedl + 1) == 'Validated';
}

bool isRequiredProp(String field_name) {
   var rl = 9;
   return field_name.length > rl && field_name.substring(rl + 1) == '_required';
}

bool isImmediateWatcher(String field_name) {
   var rl = 10; // _immediate
   return field_name.length > rl && field_name.substring(rl + 1) == '_immediate';
}

bool isDeepWatcher(String field_name) {
   var rl = 5; // _deep
   return field_name.length > rl && field_name.substring(rl + 1) == '_deep';
}

bool isSetComputed(String field_name) {
   var rl = 4; // set_
   return field_name.length > 3 && field_name.substring(0, rl) == 'set_';
}

bool isGetComputed(String field_name) {
   var rl = 4; // get_
   return field_name.length > 3 && field_name.substring(0, rl) == 'get_';
}

bool isRequiredOrValidator(String field_name) {
   return isRequiredProp(field_name) || isValidatorProp(field_name);
}

bool isDeepOrImmediateOrOnChanged(String field_name) {
   return isDeepWatcher(field_name) || isImmediateWatcher(field_name) || isOnChangedWatcher(field_name);
}

bool isNotConvention(String field_name) {
   return !isRequiredProp(field_name)
          && !isValidatorProp(field_name)
          && !isDeepWatcher(field_name)
          && !isImmediateWatcher(field_name);
}

/*



                        C O M M O N    U T I L S
      
      
      
*/

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
_getPropReqiuredConvention(String propname) {
   return '${propname}_required';
}

String
_getPrefixPlusSuffixConvention(String prefix, String propname, String suffix) {
   return '$prefix${propname.substring(0, 1).toUpperCase()}${propname.substring(1)}$suffix';
}

String
_getPropValidatorConvention(String propname) {
   return _getPrefixPlusSuffixConvention('on', propname, 'Validated');
}

String
_getWatchOnChangedConvention(String propname) {
   return _getPrefixPlusSuffixConvention('on', propname, 'Changed');
}

String
_getWatchDeepConvention(String propname) {
   return '${propname}_deep';
}

String
_getWatchImmediateConvention(String propname) {
   return '${propname}_immediate';
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
   return xter.substring('get_'.length);
}




//todo:...
class BaseCompMember{

}
class BaseVueDefMember{

}


abstract class BaseVueDefType {
   
   List<AnnotationImpl> annotations;
   List<String>         annotation_names;
   List<List<String>>   annotation_args;
   
   _annotationNotAllowed(String def) {
      if (annotations != null)
         raise("annotation not allowed under $def");
   }
   
   _annotationInit() {
      annotation_names = annotations.map((ann) => ann.name.name).toList();
      annotation_args = annotations.map((ann) => ann.arguments?.arguments?.map((arg) => arg.toString()));
   }
   
   _guardMethodType(MethodsParser definition, List<TType> params, [int length]) {
      if (definition == null) return;
      List<FormalParameterParser>
      defined_params = definition.params?.params?.params?.toList()
                     ?? definition.params?.params?.default_params?.toList();
      
      var is_length_mismatched = defined_params.length == (length ?? params.length);
      assert(is_length_mismatched, 'parameter length missmatch');
      
      for (var i = 0; i < params.length; ++i) {
         var param      = params[i];
         var named_type = param.named_type;
         var func_type  = param.generic_functype;
         var type_name  = named_type != null
               ? named_type?.name?.name
               : func_type?.toString();
         
         if (func_type == null && named_type == null){
            var stack = StackTrace.fromString('Uncaught Exception at typeCheckMethod');
            throw Exception(stack);
         }
         
         var def_param = defined_params[i];
         var def_type_name = def_param.named_type != null
               ? def_param.named_type.name.name
               : def_param.func_type.toString();
         var expected   = def_type_name;
         var real       = type_name;
         
         assert(expected == real, 'type of validator missmatch, expect $expected to be $real');
      }
   }
}

class ComputedType extends BaseVueDefType {
   MethodsParser  getter;
   MethodsParser  setter;
   String         name;
   TType          prop_type;
   List<String>   host_references; //todo
   
   ComputedType({this.name, this.getter, this.setter, this.prop_type}) {
      typecheckComputed();
      _annotationNotAllowed('IComputedDefs');
   }
   
   typecheckComputed() {
      _guardMethodType(getter, [prop_type], 0);
      _guardMethodType(setter, [prop_type], 1);
   }
}

class DataType extends BaseVueDefType {
   TypeNameImpl named_type;
   MethodsParser func_type;
   String name;
   
   DataType({this.name, this.named_type, this.func_type}) {
      _annotationNotAllowed('IDataDefs');
   }
}

class OptionType extends DataType {
   TypeNameImpl named_type;
   MethodsParser func_type;
   String name;
   
   OptionType({this.name, this.named_type, this.func_type}) :
         super(name: name, named_type: named_type, func_type: func_type);
}

class OnType extends BaseVueDefType {
   List<AnnotationImpl> annotations;
   List<List<String>> annotation_args;
   List<String> annotation_names;
   String name;
   MethodsParser handler;
   
   OnType({this.name, this.handler, this.annotations}) {
      _annotationInit();
   }
}

class OnceType extends OnType {
}

class MethodType extends BaseVueDefType {
   MethodsParser handler;
   List<AnnotationImpl> annotations;
   List<String> annotation_names;
   List<List<String>> annotation_args;
   String name;
   
   MethodType({this.handler}) {
      /*if (handler.is_getter || handler.is_setter)
         throw Exception('getter and setter is not allowed under IMethodDefs');*/
      annotations = handler.annotations;
      _annotationInit();
   }
}

class WatchType extends BaseVueDefType {
   TypeNameImpl named_type;
   GenericFunctionTypeImpl func_type;
   
   MethodsParser watcher;
   String name;
   bool deep;
   bool immediate;
   
   WatchType({this.name, this.deep, this.immediate, this.watcher, this.named_type, this.func_type}) {
      typecheckOnChangeHandler();
      _annotationNotAllowed('IWatchDefs');
   }
   
   typecheckOnChangeHandler() {
      _guardMethodType(watcher, named_type, func_type);
   }
}

class PropType extends BaseVueDefType {
   TypeNameImpl            named_type;
   GenericFunctionTypeImpl func_type;
   
   ExpressionImpl value;
   MethodsParser  validator;
   String         name;
   bool           required;
   
   PropType({String name, bool required = false, ExpressionImpl value, MethodsParser validator, dynamic named_type, this.func_type}) {
      this.name = name;
      this.required = required;
      this.value = value;
      if (named_type != null)
         this.named_type = named_type is String
            ? astNamedType(named_type)
            : named_type is TypeNameImpl
               ? named_type
               : () {
            throw Exception('Invalid Usage');
         };
      typecheckValidator();
      _annotationNotAllowed('IPropDefs');
   }
   
   typecheckValidator() {
      _guardMethodType(validator, named_type, func_type);
   }
}


class PropDefnitions<E> extends BaseVueDefinitions<E, PropType> {
   ClassDeclParser parser;

   Map<String, PropType>
   get props => definitions;
   
   void
   set props(Map<String, PropType> v) {
      definitions = v;
   }

   PropDefnitions(this.parser) {
      def_name = parser.name;
      props ??= {};
      parser.fields.forEach((field) {
         field.names.forEach((field_name) {
            if (isRequiredProp(field_name)) return null;
            if (host_comp.getField(field_name) == null)
               return warningForFieldNameNotFound(field_name, field);
            var required_name = _getPropReqiuredConvention(field_name);
            var validator_name = _getPropValidatorConvention(field_name);
            var required = parser
               .getField(required_name)?.assigned_value?.toString() == 'true' ?? false;
            var value = parser
               .getField(field_name)
               ?.assigned_value;
            var type = field.named_type ?? field.func_type;
            var validator = parser
               .getMethod(validator_name)
               ?.first; //getValidatorByFieldName(field_name, host_parser);

            _warningForTypoField(field);
            if (type is TypeNameImpl) {
               props[field_name] = PropType(
                  name: field_name, required: required, value: value, validator: validator, named_type: type
               );
            } else if (type is FuncTypeParser) {
               props[field_name] = PropType(
                  name: field_name, required: required, value: value, validator: validator, func_type: type.origin as GenericFunctionTypeImpl
               );
            }
         });
      });
   }
   
   PropType
   operator [](String key) {
      return props[key];
   }
}

class ComputedDefinitions<E> extends BaseVueDefinitions<E, ComputedType> {
   ClassDeclParser parser;
   
   Map<String, ComputedType>
   get props => definitions;
   
   void
   set props(Map<String, ComputedType> v) {
      definitions = v;
   }

   ComputedDefinitions(this.parser) {
      def_name = parser.name;
      props ??= {};
      parser.methods.forEach((method) {
         var method_name = method.name.name;
         var is_get = isGetComputed(method_name);
         var is_set = isSetComputed(method_name);
         
         if (!is_get && !is_set)
            return warningForNotValidComputed(method_name, method);
         var prop_name = _getPropByGetterOrSetter(method_name);
         var getter = is_get ? method : null;
         var setter = is_set ? method : null;
         var named_type = is_get
                          ? getter.ret_type.namedType
                          : is_set
                            ? setter.params.params.params.first.named_type
                            : () {
            throw Exception('uncaught exception');
         }();
         var func_type = is_get
                         ? getter.ret_type.funcType.origin
                         : is_set
                           ? setter.params.params.params.first.func_type.origin
                           : () {
            throw Exception('uncaught exception');
         }();
         
         var type = TType();
         
         if (named_type != null)
            type.named_type = named_type;
         if (func_type != null)
            type.generic_functype = func_type;
         
         _warningForTypoMethod(method);
         props[prop_name] = ComputedType(
            name: prop_name, getter: getter,
            setter: setter, prop_type: type
         );
      });
   }
}

class MethodDefinitions<E> extends BaseVueDefinitions<E, MethodType> {
   ClassDeclParser parser;
   
   Map<String, MethodType>
   get methods => definitions;
   
   void
   set methods(Map<String, MethodType> v) {
      definitions = v;
   }

   MethodDefinitions(this.parser) {
      def_name = parser.name;
      methods ??= {};
      parser.methods.forEach((method) {
         var method_name = method.name.name;
         var is_get = isGetComputed(method_name);
         var is_set = isSetComputed(method_name);
         if (is_get || is_set)
            return warningForNotValidMethod(method_name, method);

         _warningForTypoMethod(method);
         methods[method_name] = MethodType(
            handler: method
         );
      });
   }
}

class DataDefinitions<E> extends BaseVueDefinitions<E, DataType> {
   ClassDeclParser parser;
   
   Map<String, DataType>
   get data => definitions;
   
   void
   set data(Map<String, DataType> v) {
      definitions = v;
   }

   DataDefinitions(this.parser) {
      def_name = parser.name;
      data ??= {};
      parser.methods.forEach((method) {
         var method_name = method.name.name;
         var is_get = isGetComputed(method_name);
         var is_set = isSetComputed(method_name);
         if (method.annotations != null)
            return warningForAnnNotSupport(method_name, method);
         if (is_get || is_set)
            return warningForNotValidData(method_name, method);

         _warningForTypoMethod(method);
         data[method_name] = DataType(
            name: method_name, func_type: method
         );
      });
      parser.fields.forEach((field) {
         field.names.forEach((field_name) {
            if (field.annotations != null)
               return warningForAnnNotSupport(field_name, field);
            if (field_name.startsWith('_'))
               return warningForNotValidData(field_name, field);

            _warningForTypoField(field);
            data[field_name] = DataType(
               name: field_name, named_type: field.named_type
            );
         });
      });
   }
}

class OptionDefinitions<E> extends BaseVueDefinitions<E, OptionType> {
   ClassDeclParser parser;
   
   Map<String, OptionType>
   get options => definitions;
   
   void
   set options(Map<String, OptionType> v) {
      definitions = v;
   }

   OptionDefinitions(this.parser) {
      def_name = parser.name;
      options ??= {};
      parser.methods.forEach((method) {
         var method_name = method.name.name;
         var is_get = isGetComputed(method_name);
         var is_set = isSetComputed(method_name);
         if (method.annotations != null)
            return warningForAnnNotSupport(method_name, method);
         if (is_get || is_set)
            return warningForNotValidData(method_name, method);

         _warningForTypoMethod(method);
         options[method_name] = OptionType(
            name: method_name, func_type: method
         );
      });
      parser.fields.forEach((field) {
         field.names.forEach((field_name) {
            if (field.annotations != null)
               return warningForAnnNotSupport(field_name, field);
            if (field_name.startsWith('_'))
               return warningForNotValidData(field_name, field);

            _warningForTypoField(field);
            options[field_name] = OptionType(
               name: field_name, named_type: field.named_type
            );
         });
      });
   }
}


class OnDefinitions<E> extends BaseVueDefinitions<E, MethodType> {
   ClassDeclParser parser;
   
   Map<String, MethodType>
   get methods => definitions;
   
   void
   set methods(Map<String, MethodType> v) {
      definitions = v;
   }
   
   OnDefinitions (this.parser) {
      def_name = parser.name;
      methods ??= {};
      parser.methods.forEach((method) {
         var method_name = method.name.name;
         var is_get = isGetComputed(method_name);
         var is_set = isSetComputed(method_name);
         if (is_get || is_set || method.annotations == null)
            return warningForNotValidMethod(method_name, method);
         _warningForTypoMethod(method);
         methods[method_name] = MethodType(
            handler: method
         );
      });
   }
}

class OnceDefinitions<E> extends OnDefinitions<E> {
   ClassDeclParser parser;

   OnceDefinitions (this.parser): super(parser);
}

class WatchDefinitions<E> extends BaseVueDefinitions<E, WatchType> {
   ClassDeclParser parser;
   ClassDeclParser host_comp;
   
   Map<String, WatchType>
   get watchers => definitions;
   
   void
   set watchers(Map<String, WatchType> v) {
      definitions = v;
   }

   WatchDefinitions(this.parser) {
      def_name = parser.name;
      watchers ??= {};
      
      parser.fields.forEach((field) {
         field.names.forEach((field_name) {
            if (isDeepWatcher(field_name)) return null;
            if (isImmediateWatcher(field_name)) return null;
            if (host_comp.getField(field_name) == null)
               warningForFieldNameNotFound(field_name, field);
            _warningForTypoField(field);
            var deep_name = _getWatchDeepConvention(field_name);
            var immedate_name = _getWatchImmediateConvention(field_name);
            var watcher_name = _getWatchOnChangedConvention(field_name);
            var deep = parser.getField(deep_name)
                          ?.assigned_value
                          ?.toString() == 'true' ?? false;
            var immediate = parser.getField(immedate_name)
                               ?.assigned_value
                               ?.toString() == 'true' ?? false;
            var type = field.named_type ?? field.func_type;
            var watcher = parser.getMethod(watcher_name)?.first;
            
            if (type is TypeNameImpl) {
               watchers[field_name] = WatchType(
                  name: field_name, deep: deep, immediate: immediate, watcher: watcher, named_type: type
               );
            } else if (type is FuncTypeParser) {
               watchers[field_name] = WatchType(
                  name: field_name, deep: deep, immediate: immediate, watcher: watcher, func_type: type.origin as GenericFunctionTypeImpl
               );
            }
         });
      });
   }
}



abstract class BaseVueDefinitions<E, D> {
   ClassDeclParser _host_comp;
   ClassDeclParser parser;
   EDefTypes _def_type;
   SimpleIdentifierImpl def_name;
   BaseDefTransformer transformer;
   Map<String, D> definitions;
   BaseVueDefinitions _super_def;
   BaseVueDefinitions   _root_def;
   
   BaseVueDefinitions
   get super_def {
      if (_super_def != null) return _super_def;
      var imported_defs = getVueImportedDefs(parser.file.imp_divs, parser.file);
      _super_def = imported_defs.firstWhere((def) => def.def_name.name == parser.ext.key.toSource());
      return _super_def;
   }

   BaseVueDefinitions
   get root_def{
      if (_root_def != null) return _root_def;
      var imported_defs = getVueImportedDefs(parser.file.imp_divs, parser.file);
      var root_cls = getRootedSuper(parser, imported_defs.map((def) => def.parser).toList());
      _root_def = clsToVueDefinition(root_cls);
      return _root_def;
   }
   
   
   ClassDeclParser
   get host_comp{
      if (_host_comp != null) return _host_comp;
      var comp_name = parser.ext.key.superclass.typeArguments.arguments.first.type.name;
      _host_comp = parser.file.cls_decls.firstWhere((cls) => cls.name.name == comp_name, orElse: () => null)
                  ?? parser.file.exported_references.firstWhere((ref) => ref == comp_name, orElse: () => null);

      if (_host_comp == null)
         throw Exception('at ${parser.ext.key}<host_comp>. host_comp not specifiied.');
      return _host_comp;
   }

   EDefTypes
   get def_type {
      if (_def_type != null) return _def_type;
      switch (def_name.name){
         case IMETHOD: _def_type = EDefTypes.method; break;
         case IOPTION: _def_type = EDefTypes.option; break;
         case ICOMPUTED: _def_type = EDefTypes.computed; break;
         case IDATA: _def_type = EDefTypes.data; break;
         case ION: _def_type = EDefTypes.on; break;
         case IONCE: _def_type = EDefTypes.once; break;
         case IPROP: _def_type = EDefTypes.prop; break;
         case IWATCHER: _def_type = EDefTypes.watch; break;
         default:
            throw Exception('Uncaught Exception');
      }
      return _def_type;
   }
   
   use(BaseDefTransformer transformer) {
      this.transformer = transformer;
   }
   
   warningForNotValidComputed(String method_name, MethodsParser method) {
      warningLineComment(
         '$method_name is not a valid vue computed method. A valid naming convention for computed method should be set_computedName or get_computedName',
         'not a valid computed convention',
         method.origin
      );
   }
   
   warningForFieldNameNotFound(String field_name, FieldsParser field) {
      warningLineComment(
         '$field_name is not found in component fields',
         'not a component field',
         field.origin
      );
   }
   
   warningForNotValidMethod(String method_name, MethodsParser method) {
      warningLineComment(
         '$method_name is not a valid vue method',
         'not a valid vue method',
         method.origin
      );
   }
   
   warningForNotValidData(String method_or_field_name, BaseDeclParser method_or_field) {
      warningLineComment(
         '$method_or_field_name is not a valid vue data',
         'not a valid vue method',
         method_or_field.origin
      );
   }
   
   warningForAnnNotSupport(String method_or_field_name, BaseDeclParser method_or_field) {
      warningLineComment(
         'annotation is not supported under context of VueOption and VueData',
         'annotation is not supported here..',
         method_or_field.origin
      );
   }
   
   _warningForTypoField(FieldsParser parser) {
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
   
   _warningForTypoMethod(MethodsParser parser) {
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
}













/*


                             A N N O T A T I O N S
      
      
      
*/


FieldsParser
_getFieldByConvention(String prefix, String suffix, String name, ClassDeclParser cls_parser) {
   var field_name = FN.dePrefix(name, prefix, suffix);
   var lfield_name = '${field_name.substring(0, 1).toLowerCase()}${field_name.substring(1)}';
   print('## name: $name, field_name: $field_name, $lfield_name');
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



// used to be annotated on vue component
class VueAnnotation {
   Map<String, NamedExpressionImpl> named_args;
   List<SyntacticEntity>            args;
   MethodInvokeParser               annotation;
   AnnotationImpl                   origin;
   VueClassParser                   host;
   
   bool get isMixin     => annotation.name.toSource().endsWith('Mixin');
   bool get isComponent => annotation.name.toSource().endsWith('Component');
   
   VueAnnotation (this.annotation, this.host, this.origin) {
      args        = annotation.arguments.args;
      named_args  = annotation.arguments.named_args;
   }

   ClassDeclParser
   _getRefCls(String name){
      var arg_value = named_args[name].expression.toSource();
      return host.cls_parser.file.cls_decls.firstWhere (
            (cls) => cls.name.name == arg_value, orElse: () => null
      );
   }
}


class ComponentAnnotation extends VueAnnotation{
   MethodInvokeParser               annotation;
   Map<String, NamedExpressionImpl> named_args;
   List<SyntacticEntity>            args;
   VueClassParser                   host;
   AnnotationImpl                   origin;
   
   String
   get el {
      return named_args['el'].expression.toSource();
   }
   
   String
   get template {
      return named_args['template'].expression.toSource();
   }
   
   Map<String, ClassDeclParser>
   get components {
      var data = named_args['components'].expression as SetOrMapLiteralImpl;
      var ret = <String, ClassDeclParser>{};
      data.entries.forEach((entry){
         var entry_value = entry.value.toSource();
         ret[entry_value] = host.cls_parser.file.imp_divs.firstWhere((imp){
               return imp.exports.contains(entry_value);
            }, orElse: () => null).content_parser.cls_decls
            .firstWhere((cls) => entry_value.endsWith(cls.name.name),
               orElse: () => null
            );
      });
      return ret;
   }
   
   ComponentAnnotation( this.annotation, this.host, this.origin ): super(annotation, host, origin){
      if (!isComponent) throw Exception('annotation name:${annotation.name.name} is not matched with "Component"');
   }
}


class MixinAnnotation extends VueAnnotation{
   MethodInvokeParser               annotation;
   Map<String, NamedExpressionImpl> named_args;
   List<SyntacticEntity>            args;
   VueClassParser                   host;
   AnnotationImpl                   origin;
   
   DataDefinitions
   get data {
      return DataDefinitions(_getRefCls('data'));
   }

   ComputedDefinitions
   get computed {
      return ComputedDefinitions(_getRefCls('computed'));
   }

   PropDefnitions
   get prop {
      return PropDefnitions(_getRefCls('prop'));
   }

   WatchDefinitions
   get watch {
      return WatchDefinitions(_getRefCls('watch'));
   }

   OptionDefinitions
   get option {
      return OptionDefinitions(_getRefCls('option'));
   }

   OnDefinitions
   get on {
      return OnDefinitions(_getRefCls('on'));
   }

   OnceDefinitions
   get once {
      return OnceDefinitions(_getRefCls('once'));
   }

   MethodDefinitions
   get method {
      return MethodDefinitions(_getRefCls('method'));
   }
   
   MixinAnnotation( this.annotation, this.host, this.origin): super(annotation, host, origin){
      if (!isMixin) throw Exception('annotation name:${annotation.name.name} is not matched with "Mixin"');
   }
}

StatementImpl
getStatementFromNode(AstNode node){
   if (node == null) return node;
   if (node is StatementImpl) return node;
   return getStatementFromNode(node.parent);
}


class VueMethodsParser<E extends DeclarationImpl> extends MethodsParser {
   MethodDeclarationImpl node;
   ClassDeclParser       classOwner;
   VueClassParser        vueOwner;
   BaseVueDefinitions    def_source;
   List<FieldsParser>   _vue_data_refs;
   List<MethodsParser>  _vue_method_refs;
   List<MethodsParser>  _vue_computed_refs;
   List<dynamic>        _vue_refs;
   List<dynamic>        _non_vue_refs;
   
   List<MethodInvokeParser> parsed_annotations;
   
   bool get is_method   => def_source is MethodDefinitions;
   bool get is_computed => def_source is ComputedDefinitions;
   bool get is_prop    => def_source is PropDefnitions;
   bool get is_hook    => def_source == null && VUE_HOOKS.contains(vueOwner.cls_parser.name.name);
   bool get is_option  => def_source is OptionDefinitions;
   bool get is_provide => def_source is MethodDefinitions && annotationNames.contains('provide');
   bool get is_inject  => def_source is PropDefnitions    && annotationNames.contains('inject');
   bool get is_watch   => def_source is WatchDefinitions;
   bool get is_on      => def_source is OnDefinitions;
   bool get is_once    => def_source is OnceDefinitions;
   
   List<FieldsParser>
   get vue_data_refs {
      if (_vue_data_refs != null) return _vue_data_refs;
      var data_names     = vueOwner.data.data.keys.toList();
      return _vue_data_refs = referencedClassFields.where((field) {
         if (field.names.every((name) => isPublic(name))){
            return data_names.any((name) => field.names.any((fname) => fname == name));
         }
         return false;
      }).toList() ?? [];
   }
   
   List<MethodsParser>
   get vue_method_refs {
      if (_vue_method_refs != null) return _vue_method_refs;
      var method_names = vueOwner.method.methods.keys.toList();
      return _vue_method_refs = referencedClassMethods.where((MethodsParser method) {
         if (isPublic(method.name.name))
            return method_names.contains(method.name.name);
         return false;
      }) ?? [];
   }

   List<MethodsParser>
   get vue_computed_refs {
      if (_vue_computed_refs != null) return _vue_computed_refs;
      var computed_names = vueOwner.computed.props.keys.toList();
      return _vue_computed_refs = referencedClassMethods.where((MethodsParser method) {
         if (isPublic(method.name.name))
            return computed_names.contains(method.name.name);
         return false;
      }) ?? [];
   }
   
   List<dynamic>
   get vue_refs{
      if (_vue_refs != null) return _vue_refs;
      _vue_refs =  [] + vue_data_refs + vue_method_refs + vue_computed_refs;
      return _vue_refs;
   }
   
   List<Refs<AstNode, SimpleIdentifierImpl>>
   get non_vue_refs{
      if (_non_vue_refs != null) return _non_vue_refs;
      _non_vue_refs ??= [];
      var vue_refnames = vue_computed_refs.map((ref) => ref.name.name).toList()
                     + vue_method_refs.map((ref) => ref.name.name).toList()
                     + vue_data_refs.fold([], (initial, ref) => initial + ref.names);
      refs_in_body.forEach((ref){
         if (!vue_refnames.contains(ref.ref.name))
            _non_vue_refs.add(ref);
      });
      return _non_vue_refs;
   }
   
   warningForReferencingToNonListenableProperty(){
      non_vue_refs.forEach((ref){
         var node = getStatementFromNode(ref.context);
         var message = 'referenced to non-listenable property: ${ref.ref.name}';
         var comment = message;
         warningLineComment(message, comment, node);
      });
   }
   
   warningForTriggeringPotentialInfiniteUpdating(){
      //todo:
      // it's possible to provide such warnings only under the premise that
      // we have a parsable template to walk through.
   }
   
   assertReferenceWarnings(){
      //refinement:
      if (is_method){
         if (vue_data_refs.length > 0 || vue_computed_refs.length > 0)
            warningForTriggeringPotentialInfiniteUpdating();
      }else if (is_computed){
         if (non_vue_refs.length > 0)
            warningForReferencingToNonListenableProperty();
         if (vue_data_refs.length > 0)
            warningForTriggeringPotentialInfiniteUpdating();
      }else if (is_watch){
         if (vue_data_refs.length > 0 || vue_computed_refs.length > 0)
            warningForTriggeringPotentialInfiniteUpdating();
         if (vue_method_refs.length > 0)
            warningForTriggeringPotentialInfiniteUpdating();
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

bool isVueDart(String file_path){
   return file_path.endsWith('.vue.dart') || file_path.endsWith('vue.generated.dart');
}

bool isIVue(ClassDeclParser cls_decl){
   return cls_decl.name.name == 'IVue' && cls_decl.is_abstract && cls_decl.ext.key.toSource().endsWith('VueApi');
}

bool isVueComp(List<ClassDeclParser> cls_decls, String file_path){
   var cls_components = cls_decls.where((cls) => cls.annotationNames.contains('Component') );
   return isVueDart(file_path) && cls_components != null;
}

ClassDeclParser
getRootedSuper(ClassDeclParser cls, List<ClassDeclParser> vue_imported_classes){
   var extended_super = vue_imported_classes.firstWhere((parser) => parser.name.name == cls.ext.key.toSource(), orElse: () => null);
   if (extended_super.ext == null) return extended_super;
   var imported_vue = getVueImportedClasses(extended_super.file.imp_divs, extended_super.file);
   return getRootedSuper(extended_super, imported_vue);
}

ClassDeclParser
getRootComp(ClassDeclParser cls, List<VueClassParser> vue_imported_comps){
   var extended_super = vue_imported_comps.map((vue) => vue.cls_parser).firstWhere((parser) => parser.name.name == cls.ext.key.toSource(), orElse: () => null);
   if (extended_super.ext == null) return extended_super;
   var imported_vue = getVueImportedClasses(extended_super.file.imp_divs, extended_super.file);
   return getRootedSuper(extended_super, imported_vue);
}

BaseVueDefinitions
clsToVueDefinition(ClassDeclParser cls){
   if (cls == null) return null;
   var ext = cls.ext.key.superclass.name.name;
   switch(ext){
      case IPROP:     return PropDefnitions(cls);
      case IWATCHER:  return WatchDefinitions(cls);
      case IONCE:     return OnceDefinitions(cls);
      case ION:       return OnDefinitions(cls);
      case IDATA:     return DataDefinitions(cls);
      case ICOMPUTED: return ComputedDefinitions(cls);
      case IOPTION:   return OptionDefinitions(cls);
      case IMETHOD:   return MethodDefinitions(cls);
      default:
         return null;
   }
}

List<BaseVueDefinitions>
getVueDefsViaClassesAndImportedSupers (List<ClassDeclParser> cls_decls, List<BaseVueDefinitions> vue_imported_defs) {
   return cls_decls.where((cls){
      var ext = cls.ext.key.superclass.name.name;
      if (VUE_INTERFACES.contains(ext)) return true;
      return vue_imported_defs.map((def) => def.parser).any((cls) => cls.name.name == ext);
   }).map((cls) => clsToVueDefinition(cls)).toList();
}

List<BaseVueDefinitions>
getVueImportedDefs(List<ImportParser> imp_divs, DartFileParser file){
   var ret = <BaseVueDefinitions>[];
   imp_divs.where((imp) => isVueDart(imp.path.value)).forEach((imp) {
      ret.addAll( getVueDefFromImport(imp) );
   });
   return ret;
}

List<ClassDeclParser>
getVueImportedClasses(List<ImportParser> imp_divs, DartFileParser file){
   var ret = <ClassDeclParser>[];
   imp_divs.where((imp) => isVueDart(imp.path.value)).forEach((imp) {
      ret.addAll( getClassesFromImport(imp) );
   });
   return ret;
}

List<BaseVueDefinitions>
getVueDefFromImport(ImportParser imp){
   var explicit    = (imp.shows != null ?  imp.shows : []).map((x) => x.name).toList();
   var implicit    = imp.content_parser.cls_decls?.map((cls) => clsToVueDefinition(cls)) ?? [];
   var e_clsdecls  = explicit.map(
         (e) => imp.content_parser.cls_decls
            .firstWhere((cls) => explicit.any((e) => e.endsWith(cls.name.name)),
            orElse: () => throw Exception('Uncaught Exception')
      )
   ).toList() ?? [];
   var imp_cls = <BaseVueDefinitions>[];
   imp_cls = e_clsdecls.length > 0
             ? e_clsdecls.map((cls) => clsToVueDefinition(cls)).toList()
             : implicit;
   return imp_cls;
}

List<ClassDeclParser>
getClassesFromImport(ImportParser imp){
   var explicit    = (imp.shows != null ?  imp.shows : []).map((x) => x.name).toList();
   var implicit    = imp.content_parser.cls_decls ?? [];
   var e_clsdecls  = explicit.map(
         (e) => imp.content_parser.cls_decls
         .firstWhere((cls) => explicit.any((e) => e.endsWith(cls.name.name)),
            orElse: () => throw Exception('Uncaught Exception')
      )
   ).toList() ?? [];
   var imp_cls = <ClassDeclParser>[];
   imp_cls = e_clsdecls.length > 0
              ? e_clsdecls
              : implicit;
   return imp_cls;
}

List<TopFuncDeclParser>
getTopFnsFromImport(ImportParser imp){
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
   imp_divs.where((imp) => isVueDart(imp.path.value)).forEach((imp) {
      var imp_classes = getClassesFromImport(imp).map((cls) => VueClassParser(cls, imp.content_parser)).toList();
      ret.addAll(imp_classes);
   });
   return ret;
}

void warningLineComment(String message, String comment, AstNode node){
   var visitor = ExpressionCommentAppender([comment], false);
   node.visitChildren(visitor);
   raise(message);
}

void warningMultiLineComment(List<String> messages, List<String> comments, AstNode node){
   var visitor = ExpressionCommentAppender(comments, true);
   node.visitChildren(visitor);
   messages.forEach((message) => raise(message));
}

String
getStringFromNamedArg(NamedExpressionImpl arg) => arg.expression.toSource();

SimpleIdentifierImpl
getIdentFromNamedArg(NamedExpressionImpl arg) => arg.expression;

Map<String, SimpleIdentifierImpl>
getMapFromNamedArg (NamedExpressionImpl arg) {
   var map = arg.expression as SetOrMapLiteralImpl;
   var ret = <String, SimpleIdentifierImpl>{};
   map.entries.forEach((entry){
      var key   = entry.key.toSource();
      var value = entry.value;
      ret[key] = value;
   });
   return ret;
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
   List<ImportParser>       _vue_imports;           // imported clauses referenced to vue dart
   List<BaseVueDefinitions> _vue_imported_defs;     // classes imported from vue dart that extends from vue interfaces
   List<BaseVueDefinitions> _vue_defs;              // classes extends from vue interfaces
   List<VueClassParser>     _vue_imported_comps;    // imported classes annotated with vue Component
   List<VueClassParser>     _vue_components;        // classes annotated with vue Component
   
   bool
   isVueMember(ClassDeclParser cls, List<VueClassParser> vue_imported_classes){
      var ext = cls.ext.key.superclass.name.name;
      if (VUE_INTERFACES.contains(ext)) return true;
      if (vue_imported_classes.any((vue_cls) => VUE_INTERFACES.contains(vue_cls.cls_parser.ext.key)))
         return true;
      
      var extended_cls = vue_imported_classes.firstWhere((vue_cls) => vue_cls.cls_parser.name.name == ext, orElse: ()=>null);
      if (extended_cls == null)
         return false;
      
      var vue_import = getVueImportedComps(extended_cls.cls_parser.file.imp_divs, extended_cls.cls_parser.file);
      return isVueMember(extended_cls.cls_parser, vue_import);
   }
   
   List<BaseVueDefinitions>
   get vue_defs {
      if ( _vue_defs != null ) return _vue_defs;
      _vue_defs = getVueDefsViaClassesAndImportedSupers(cls_decls, vue_imported_defs) ;
      return _vue_defs;
   }
  
   List<VueClassParser>
   get vue_components {
      if ( _vue_components != null ) return _vue_components;
      var cls_components = cls_decls.where((cls) => cls.annotationNames.contains('Component'));
      _vue_components = cls_components.map((cls) => VueClassParser(cls, this)).toList();
      return _vue_components;
   }
   
   List<BaseVueDefinitions>
   get vue_imported_defs{
      if (_vue_imported_defs != null) return _vue_imported_defs;
      _vue_imported_defs ??= getVueImportedDefs(imp_divs, this);
      return _vue_imported_defs;
   }

   List<VueClassParser>
   get vue_imported_comps {
      if (_vue_imported_comps != null) return _vue_imported_comps;
      _vue_imported_comps ??= getVueImportedComps(imp_divs, this);
      return _vue_imported_comps;
   }
   
   List<ImportParser>
   get vue_imports{
      if ( _vue_imports != null ) return _vue_imports;
      _vue_imports ??= imp_divs.where((imp) => isVueDart(imp.path.toSource())).toList();
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
   
   VueDartFileParser({CompilationUnitImpl code, String file_path}) : super(code: code, file_path: file_path);
}





class VueClassParser {
   static Map<ClassDeclParser, VueClassParser> parsed_classes;
   ClassDeclParser      _super_parser;
   ClassDeclParser      _root_parser;
   ClassDeclParser      cls_parser;
   List <VueAnnotation> vueAnnotations;
   VueDartFileParser    vue_owner;
   
   DataDefinitions     data;
   PropDefnitions      prop;
   WatchDefinitions    watch;
   ComputedDefinitions computed;
   OptionDefinitions   option;
   OnDefinitions       on;
   OnceDefinitions     once;
   MethodDefinitions   method;
   
   bool        _isMetaMethodForced;
   bool        _isMetaDataForced;
   String      el;
   VueTemplate template;
   String      style;
   Map<String, SimpleIdentifierImpl> components;
   
   ClassDeclParser
   get super_parser{
      if (_super_parser != null) return _super_parser;
      _super_parser = vue_owner.vue_imported_comps
         .firstWhere((comp) => comp.cls_parser.name.name == cls_parser.ext.key.toSource()
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

   assertMixinArgs<N extends NamedExpressionImpl>(N data_ident,  N method_ident){
      /*var messages = [], comments = [];
      var node = vueAnnotations.firstWhere((ann) => ann.isMixin, orElse: () => null).origin;
      if (data_ident == null) {
         messages.add('');
         comments.add('');
      }
      if (method_ident == null){
         messages.add('');
         comments.add('');
      }
      warningMultiLineComment(messages, comments, getStatementFromNode(node));*/
   }
   
   VueTemplate
   parseTemplate(String path_or_data){
      var is_path = path_or_data.endsWith('.vue');
      var is_vue_template = path_or_data.trim().startsWith('<template>');
      var raw_data = is_path
               ? File(path_or_data).readAsStringSync()
               : is_vue_template
                  ? path_or_data
                  : (){throw Exception('Uncaught Exception');}();
      return VueTemplate(raw_data: raw_data, host: this);
   }
   
   componentInit(MethodInvokeParser invok){
      List<ClassDeclParser> decls;
      List<VueClassParser>  imported_comps;
      var el_value         = getStringFromNamedArg(invok.arguments.named_args['el']);
      var template_value   = getStringFromNamedArg(invok.arguments.named_args['template']);;
      var components_value = getMapFromNamedArg(invok.arguments.named_args['components']);
      
      el          = el_value;
      template    = parseTemplate(template_value);
      components  = components_value;
   }
   
   mixinInit(MethodInvokeParser invok){
      var decls         = vue_owner.cls_decls;
      var imported_defs = getVueDefsViaClassesAndImportedSupers(decls, vue_owner.vue_imported_defs);

      ClassDeclParser
      getDecl(NamedExpressionImpl ident)
         => decls.firstWhere((cls) => cls.name.name == ident.name.toSource(), orElse: () => null);

      BaseVueDefinitions
      getImported(NamedExpressionImpl ident)
         => imported_defs.firstWhere((def) => def.parser.name.name == ident.name.toSource(), orElse: () => null);
      
      var data_ident     = invok.arguments.named_args['data'];
      var prop_ident     = invok.arguments.named_args['prop'];
      var watch_ident    = invok.arguments.named_args['watch'];
      var computed_ident = invok.arguments.named_args['computed'];
      var option_ident   = invok.arguments.named_args['option'];
      var on_ident       = invok.arguments.named_args['on'];
      var once_ident     = invok.arguments.named_args['once'];
      var method_ident   = invok.arguments.named_args['method'];
      
      assertMixinArgs(data_ident,  method_ident);
      
      /*
      1) assign named_arg by classes defined in current file
      2) assign named arg by classes imported from somewhere
      */
      data      = clsToVueDefinition(getDecl(data_ident)) ?? getImported(data_ident);
      prop      = clsToVueDefinition(getDecl(prop_ident)) ?? getImported(prop_ident);
      watch     = clsToVueDefinition(getDecl(watch_ident)) ?? getImported(watch_ident);
      computed  = clsToVueDefinition(getDecl(computed_ident)) ?? getImported(computed_ident);
      option    = clsToVueDefinition(getDecl(option_ident)) ?? getImported(option_ident);
      on        = clsToVueDefinition(getDecl(on_ident)) ?? getImported(on_ident);
      once      = clsToVueDefinition(getDecl(once_ident)) ?? getImported(once_ident);
      method    = clsToVueDefinition(getDecl(method_ident)) ?? getImported(method_ident);
   }

   fieldsInit(){
      //todo
   
   }
   methodsInit(){
      //todo
      /*
      lifecycle_fields       = _getLifeCycles();*/
      //----------------------------------------
   }
   definitionInit(){
      /*data     = clsToVueDefinition(cls_parser);
      prop     = clsToVueDefinition(cls_parser);
      watch    = clsToVueDefinition(cls_parser);
      computed = clsToVueDefinition(cls_parser);
      option   = clsToVueDefinition(cls_parser);
      on       = clsToVueDefinition(cls_parser);
      once     = clsToVueDefinition(cls_parser);
      method   = clsToVueDefinition(cls_parser);*/
      //todo:
      
   }

   annotationsInit(){
      vueAnnotations = cls_parser.annotations.where((ann){
         return COMP_ANNS.contains (ann.name.name);
      }).map((ann){
         var invok = MethodInvokeParser(getNode<MethodInvocationImpl>(ann));
         if (ann.name.name == ANN_COMP)  componentInit(invok);
         if (ann.name.name == ANN_MIXIN) mixinInit(invok);
         return VueAnnotation(invok, this, ann);
      }).toList();
   }

   factory VueClassParser(ClassDeclParser cls_parser, [VueDartFileParser vue_owner]) {
      if (VueClassParser.parsed_classes.containsKey(cls_parser))
         return VueClassParser.parsed_classes[cls_parser];
      VueClassParser.parsed_classes[cls_parser] = VueClassParser.init(cls_parser, vue_owner);
      return VueClassParser.parsed_classes[cls_parser];
   }
   
   VueClassParser.init(ClassDeclParser this.cls_parser, [VueDartFileParser this.vue_owner]) {
      annotationsInit();
      definitionInit();
      fieldsInit();
      methodsInit();
   }

   /*List<VueMethodsParser>
   _getLifeCycles() {
      return cls_parser.methods.where((method) {
         return IS.vueHook(method);
      }).map((MethodsParser method) => VueMethodsParser(method.origin, cls_parser, this)).toList();
   }

   List<VueMethodsParser>
   _getOnChangedMethods() {
      return cls_parser.methods.where((MethodsParser method) {
         return _isOnChangeConvention(FN.toCamelCase(method.name.name), cls_parser)
                && !watch_fields.map((VueMethodsParser p) => p.origin).contains(method.origin);
      }).map((MethodsParser method) => VueMethodsParser(method.origin, cls_parser, this)).toList();
   }

   List<VueMethodsParser>
   _getValidatorFields() {
      return cls_parser.methods.where((MethodsParser method) {
         return _isValidatorConvention(FN.toCamelCase(method.name.name), cls_parser)
                && !prop_validator_fields.map((VueMethodsParser p) => p.origin).contains(method.origin);
      }).map((MethodsParser method) => VueMethodsParser(method.origin, cls_parser, this)).toList();
   }

   List<VueMethodsParser>
   _getMethodFields(String annName) {
      return cls_parser.methods.where((method) =>
         method.annotationNames.map((name) => name.toLowerCase()).contains(annName)
      ).map((MethodsParser method) => VueMethodsParser(method.origin, cls_parser, this)).toList();
   }

   List<VueFieldsParser>
   _getDataFields(String annName) {
      return cls_parser.fields.where((field) => field.annotationNames.map((name) => name.toLowerCase()).contains(annName))
         .map((FieldsParser field) {
         return VueFieldsParser(field.origin, cls_parser, this);
      }).toList();
   }*/
}







