//import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/standard_ast_factory.dart';

import 'ast.vue.parsers.dart';
import 'ast.codegen.dart';
import 'ast.parsers.dart';

import 'common.dart';
import 'common.log.dart' show Logger, ELevel;

final _log = Logger(name: "vue.parser", levels: [ELevel.log, ELevel.info, ELevel.critical, ELevel.error, ELevel.warning, ELevel.sys ]);
const TAB = '   ';


String getFieldType(FieldsParser field){
   return field?.named_type?.toSource()
          ?? field.func_type?.origin?.toSource();
}

String getMethodType(MethodsParser method){
   if (method?.ret_type?.namedType != null)
      return method?.ret_type?.namedType?.origin?.toSource();
   //untested:
   return method.toFuncDef().toSource();
   //return method?.ret_type?.funcType?.origin?.toSource();
}

String getMemberType(BaseVueDefMember member){
   return member.isField
       ? getFieldType(member.field_body)
       : getMethodType(member.method_body);
}




class BaseVueDefinitionTransformer<
   Member extends BaseVueDefMember,
   Def    extends BaseVueDefinitions<Member>>
{
   Def    data;
   String dart_type = r'$dart_data';
   String interop_def_type = '_Data';
   String interop_member_type = 'TData';
   
   E getClsMember<E extends BaseDeclParser>(Member member){
      return member.field_body ?? member.method_body;
   }
   
   String getType(Member member){
      if  (member.field_body != null)
         return getFieldType(member.field_body);
      else
         return getMethodType(
               member.method_body
            ?? member.getter_body
            ?? member.setter_body);
   }
   
   String getFnName(Member member){
      return member.method_body?.name?.name
             ?? member.getter_body?.name?.name
             ?? member.setter_body?.name?.name;
   }
   
   String getPropName(Member member){
      return member.name;
   }
   
   bool isPublic(Member member) {
      return member.field_body?.is_public
      ?? member.method_body?.is_public
      ?? member.getter_body?.is_public
      ?? member.setter_body?.is_public
      ?? false;
   }
   
   String getBody(Member member){
      return member.field_body?.origin?.toSource()
         ?? member.method_body?.origin?.toSource()
         ?? member.getter_body?.origin?.toSource()
         ?? member.setter_body?.origin?.toSource();
   }
   
   String line(String data, [int tab = 0]){
      var t = TAB * tab;
      var b = '\n';
      return '$t${data.trim()}$b';
   }

   List<Member> get members
      => data.definitions.values.toList(growable: false);
   
   String getInitClause(String propname, String typename, String pseudo_get, String pseudo_set){
      pseudo_get = pseudo_get != null ? 'source.$pseudo_get' : null;
      pseudo_set = pseudo_set != null ? 'source.$pseudo_set' : null;
      return 'ret.$propname = Vue.$interop_member_type.init<$typename>($pseudo_get, $pseudo_set)';
   }
   
   /*
   @anonymous
      @JS()
      class _Data  {
         String hello   = 'Curtis';
         ...
         external _Data();
         static _Data init(DataDefs source){
            ...
         }
      }
      -------------------------------------------------------------
                       D A T A     T Y P E

   */
   
   List<String> _memberInit(Member member) {
      var member_names = <String>[];
      var type_name    = getType(member);
      var prop_name    = getPropName(member);
      var ret          = <String> [];
      if (member.field_body != null) {
         member_names.addAll(member.field_body.names);
      } else {
         member_names.add(getFnName(member));
      }
      print('member_name: $member_names, '
         'type_name:$type_name, '
         'prop_name:$prop_name');
      ret = member_names.map((member_name) =>
         getInitClause(prop_name, type_name,member_name, null )).toList();
      return ret;
   }
   
   String jsDataTypeFields() {
      return data.definitions.values
         .where((member) => isPublic(member))
         .map((member) => getBody(member))
         .toList().join('\n$TAB');
   }
   
   String jsDataType(String typename){
      var fields         = jsDataTypeFields();
      var initialization = _dataTypeInit();
      var template =
         line('@anonymous') +
         line('@JS()') +
         line('class $interop_def_type {') +
         line('   $fields', 1) +
         line('   external $interop_def_type();', 1) +
         line('   static $interop_def_type init($typename source) {', 1) +
         line('      $initialization', 2) +
         line('   }', 1) +
         line('}');
      return template;
   }
   /*
      var ret     = _Data();
      ret.noValue =  Vue.TData.init<String>(source.noValue);
      ...
      return ret;
       ------------------------------------------------------
               D A T A     I N I T I A T I O N
                                                            */
   String _dataTypeInit(){
      var statements = members
         .where ((member) => isPublic(member))
         .fold  ([], (initial, member) =>
               initial + _memberInit(member));
      if (statements.length > 0)
         statements.last += ';';
      var template =
         line('var ret = $interop_def_type();', 2) +
         line('${statements.join(';\n$TAB$TAB')}', 2) +
         line('return ret;', 2);
      return template;
   }


   /*
   String get hello {
      return_statement::
         | return $dart_data.hello;
         | return Vue.jsGet($dart_data, 'hello');
   }
   
   void set hello (String v) {
      assign_statement::
         | $dart_data.hello = v;
   }
      -------------------------------------------------------------
                 C O M P O N E N T      M E M B E R S
                 
                 
                         G E T T E R S
   */
   String componentJSGetterInit(Member member, [String template]){
      template ??= 'return Vue.jsGet($dart_type, \'${member.name}\');';
      return _componentBaseGetterInit(member, template);
   }
   
   String componentDartGetterInit(Member member, [String template]){
      template ??=  'return $dart_type.${member.name};';
      return _componentBaseGetterInit(member, template);
   }
   
   String _componentBaseGetterInit(Member member, String ret_stmt){
      var type      = getType(member);
      var prop_name = getPropName(member);
      var template  =
         line('$type get $prop_name {', 1) +
         line('   $ret_stmt', 2) +
         line('}', 1);
      return template;
   }
   
   /*
   
                           S E T T E R S
                           
   */
   String componentJSSetterInit(Member member, [String template]){
      template ??= 'Vue.jsSet($dart_type, \'${member.name}\', v);';
      return _componentBaseSetterInit(member, template);
   }

   String componentDartSetterInit(Member member, [String template]){
      template ??=  '$dart_type.${member.name} = v;';
      return _componentBaseSetterInit(member, template);
   }
   
   String _componentBaseSetterInit(Member member, String asn_stmt){
      var type      = getType(member);
      var prop_name = getPropName(member);
      var template  =
         line('   void set $prop_name ($type v) {', 1) +
         line('      $asn_stmt', 2) +
         line('   }', 1);
      return template;
   }

   String componentMembersInit({
       bool js_setter   = false, bool js_getter   = false,
       bool dart_setter = false, bool dart_getter = false})
   {
      var ret = <String> [];
      data.definitions.values.forEach((member){
         if (js_setter && member.isSetter)    ret.add(componentJSSetterInit(member));
         if (dart_setter && member.isSetter)  ret.add(componentDartSetterInit(member));
         if (js_getter)    ret.add(componentJSGetterInit(member));
         if (dart_getter)  ret.add(componentDartGetterInit(member));
      });
      return ret.join('\n');
   }

   Result init(String typename, {
      bool js_setter   = false, bool js_getter   = false,
      bool dart_setter = false, bool dart_getter = false})
   {
      var datatype  = jsDataType(typename);
      var members   = componentMembersInit(
         dart_getter: dart_getter, dart_setter: dart_setter,
         js_setter: js_setter, js_getter: js_getter
      );
      var interface =
         'abstract class $typename<E> {'
         'E self;'
         '}';
      return Result(datatype, members, interface);
   }
   
   BaseVueDefinitionTransformer(this.data);
}


class Result {
   String datatype;
   String members;
   String interface;
   Result(this.datatype, this.members, this.interface);
}

/*


               D A T A     T R A N S


*/
class VueDataTransformer
   extends BaseVueDefinitionTransformer<DataMember, DataDefinitions>{
   DataDefinitions   data;
   String dart_type      = r'$dart_data';
   String interop_def_type = '_Data';
   String interop_member_type = 'TData';
   
   
   Result init(typename, {
      bool js_setter   = false, bool js_getter   = false,
      bool dart_setter = false, bool dart_getter = false})
   {
      return super.init(typename, dart_getter: true);
   }
   
   VueDataTransformer(this.data): super(data);
}

//untested:
class VueOptionTransformer
   extends BaseVueDefinitionTransformer<OptionMember, OptionDefinitions> {
   OptionDefinitions data;
   Map<String, List> buildins = {};
   String dart_type        = r'$dart_option';
   String interop_def_type = '_Options';
   String interop_member_type = 'TOption';
   
   String jsDataTypeFields() {
      String getValue(String name){
         return buildins[name] == null ? '' : '=${buildins[name][0].toString()}';
      }
      var buildin_fields = '';
      var el      = getValue('el');
      var template= getValue('template');
      var name    = getValue('name');
      var delimiters= getValue('delimiters');
      var mixins    = getValue('mixins');
      var components= getValue('components');
      var filters    = getValue('filters');
      var model   = data.comp_host.option_model == null ? ''
         : 'Vue.Model('
           '"${data.comp_host.option_model[0]}", '
           '"${data.comp_host.option_model[1]}")';
      
      buildin_fields=
         'Map<String, Vue.VueApi> components $components;'
         'Map<String, dynamic Function(dynamic) filters $filters;'
         'List<Vue.VueApi> mixins $mixins;'
         'String el $el;'
         'String template $template;'
         'Vue.Model model $model;'
         'String name $name;'
         'List<String> delimiters $delimiters;';
      
      var custom_data = super.jsDataTypeFields();
      return '$buildin_fields\n$custom_data';
   }

   Result init(typename, {
      bool js_setter   = false, bool js_getter   = false,
      bool dart_setter = false, bool dart_getter = false})
   {
      return super.init(typename, dart_getter: true);
   }

   VueOptionTransformer(this.data): super(data){
      var buildins = {
         'el'        : [data.comp_host.option_el,        astNamedType('String')],
         'template'  : [data.comp_host.option_template,  astNamedType('String')],
         'name'      : [data.comp_host.option_name,      astNamedType('String')],
         'delimiters': [data.comp_host.option_delimiters,astNamedType('List', ['String'])],
         'model'     : [data.comp_host.option_model,     astNamedType('List', ['String'])],
         'components': [data.comp_host.option_components,astNamedType('Map', ['String', 'String'])],
         'filters'   : [data.comp_host.option_filters,   astNamedType('Map', ['String','dynamic'])]
      };
      
      buildins.keys.forEach((key){
         this.buildins[key] = buildins[key];
      });
   }
}

/*


               F I L T E R S     T R A N S


*/
class VueFiltersTransformer
   extends BaseVueDefinitionTransformer<FilterMember, FiltersDefinitions>{
   FiltersDefinitions   data;
   String dart_type      = r'$dart_filters';
   String interop_def_type = '_Filters';
   String interop_member_type = 'TFilter';
   
   @override
   List<String> _memberInit(FilterMember member) {
      var method_name = member.name;
      var ret = 'ret.$method_name = Vue.$interop_member_type.init(source.$method_name)';
      return [ret];
   }
   
   @override
   String jsDataTypeFields() {
      return data.definitions.values
         .where((member) => member.isMethod && super.isPublic(member))
         .map((member) {
         //fixme:
         var type = member.method_body.toFuncDef().toSource();
         var name = member.name;
         var ret  = '$type $name;';
         return ret;
      }).join('\n$TAB');
   }
   
   Result init(typename, {
      bool js_setter   = false, bool js_getter   = false,
      bool dart_setter = false, bool dart_getter = false})
   {
      return super.init(typename, dart_getter: true);
   }

   VueFiltersTransformer(this.data): super(data);
}

/*


               M E T H O D     T R A N S


*/
class VueMethodTransformer
   extends BaseVueDefinitionTransformer<MethodMember, MethodDefinitions>{
   MethodDefinitions   data;
   String dart_type      = r'$dart_method';
   String interop_def_type = '_Methods';
   String interop_member_type = 'TMethod';

   @override
   List<String> _memberInit(MethodMember member) {
      var method_name = member.name;
      var ret = 'ret.$method_name = Vue.$interop_member_type.init(source.$method_name)';
      return [ret];
   }

   @override
   String jsDataTypeFields() {
      return data.definitions.values
         .where((member) => member.isMethod && super.isPublic(member))
         .map((member) {
         //fixme:
         var type = member.method_body.toFuncDef().toSource();
         var name = member.name;
         var ret  = '$type $name;';
         return ret;
      }).join('\n$TAB');
   }
   
   Result init(typename, {
      bool js_setter   = false, bool js_getter   = false,
      bool dart_setter = false, bool dart_getter = false})
   {
      return super.init(typename, dart_getter: true);
   }

   VueMethodTransformer(this.data): super(data);
}
/*


               O N      T R A N S


*/
class VueOnsTransformer
   extends BaseVueDefinitionTransformer<OnMember, OnDefinitions>{
   OnDefinitions   data;
   String dart_type      = r'$dart_on';
   String interop_def_type = '_Ons';
   String interop_member_type = 'TOns';
   
   
   Result init(typename, {
      bool js_setter   = false, bool js_getter   = false,
      bool dart_setter = false, bool dart_getter = false})
   {
      return super.init(typename, dart_getter: true);
   }

   VueOnsTransformer(this.data): super(data);
}

/*


               O N C E     T R A N S


*/
class VueOncesTransformer
   extends BaseVueDefinitionTransformer<OnceMember, OnceDefinitions>{
   OnceDefinitions   data;
   String dart_type      = r'$dart_once';
   String interop_def_type = '_Onces';
   String interop_member_type = 'TOnces';
   
   
   Result init(typename, {
      bool js_setter   = false, bool js_getter   = false,
      bool dart_setter = false, bool dart_getter = false})
   {
      return super.init(typename, dart_getter: true);
   }

   VueOncesTransformer(this.data): super(data);
}

/*


               C O M P U T E D     T R A N S


*/
class VueComputedTransformer
   extends BaseVueDefinitionTransformer<ComputedMember, ComputedDefinitions>{
   ComputedDefinitions  data;
   String dart_type      = r'$dart_computed';
   String interop_def_type = '_Computeds';
   String interop_member_type = 'TComputed';
   
   @override
   getPropName(ComputedMember member){
      return member.prop_name;
   }
   
   @override
   String jsDataTypeFields() {
      return data.definitions.values
         .where((member) => super.isPublic(member))
         .map((member) {
            var type = getType(member);
            var name = member.prop_name;
            var ret  = 'Vue.$interop_member_type<$type> $name;';
            return ret;
         }).join('\n$TAB');
   }
   
   @override
   String getInitClause(String propname, String typename, String pseudo_get, String pseudo_set){
      return super.getInitClause(propname, typename, pseudo_get, pseudo_set);
   }
   
   @override
   List<String> _memberInit(ComputedMember member) {
      var member_names = <String>[];
      var type_name    = getType(member);
      var prop_name    = getPropName(member);
      member_names = [
         member.getter_body?.name?.name, member.setter_body?.name?.name
      ];
      var pseudo_get = member_names[0] == null ? null : 'source.${member_names[0]}';
      var pseudo_set = member_names[1] == null ? null : 'source.${member_names[1]}';
      var ret = 'ret.$prop_name = Vue.$interop_member_type.init<$type_name>($pseudo_get, $pseudo_set)';
      return [ret];
   }

   @override
   String componentDartGetterInit(ComputedMember member, [String template]){
      var template =  'return $dart_type.${member.prop_name}.get();';
      return super.componentDartGetterInit(member, template);
   }

   @override
   String componentDartSetterInit(ComputedMember member, [String template]){
      var template =  '$dart_type.${member.prop_name}.set(v);';
      return super.componentDartSetterInit(member, template);
   }

   Result init(typename, {
      bool js_setter   = false, bool js_getter   = false,
      bool dart_setter = false, bool dart_getter = false})
   {
      return super.init(typename, dart_getter: true, dart_setter: true);
   }
   
   VueComputedTransformer(this.data): super(data);
}

/*


               W A T C H E R S     T R A N S


*/
class VueWatcherTransformer
   extends BaseVueDefinitionTransformer<WatchMember, WatchDefinitions>{
   WatchDefinitions  data;
   String dart_type      = r'$dart_watcher';
   String interop_def_type = '_Watchers';
   String interop_member_type = 'TWatcher';
   
   @override
   getPropName(WatchMember member){
      return member.prop_name;
   }
   
   @override
   String jsDataTypeFields() {
      return data.definitions.values
         .where((member) => super.isPublic(member))
         .map((member) {
         var type = super.getType(member);
         var name = member.prop_name;
         var ret  = 'Vue.$interop_member_type<$type> $name;';
         return ret;
      }).join('\n$TAB');
   }
   
   @override
   List<String> _memberInit(WatchMember member) {
      var propname = getPropName(member);
      var typename = getType(member);
      var prop_string= "'$propname'";
      var deep     =  member.deep;
      var immediate= member.immediate;
      var onchange = member.method_body?.name?.name;
      var ret      = 'ret.$propname = Vue.$interop_member_type.init<$typename>('
         '$prop_string, $deep, $immediate, source.$onchange'
         ')';
      return [ret];
   }

   @override
   String componentMembersInit({
       bool js_setter   = false, bool js_getter   = false,
       bool dart_setter = false, bool dart_getter = false})
   {
      return '';
   }
   
   Result init(typename, {
      bool js_setter   = false, bool js_getter   = false,
      bool dart_setter = false, bool dart_getter = false})
   {
      return super.init(typename, dart_getter: true, dart_setter: true);
   }

   VueWatcherTransformer(this.data): super(data);
}


/*


               P R O P S     T R A N S


*/
class VuePropTransformer
   extends BaseVueDefinitionTransformer<PropMember, PropDefnitions>{
   PropDefnitions  data;
   String dart_type      = r'$dart_props';
   String interop_def_type = '_Props';
   String interop_member_type = 'TProp';
   
   @override
   getPropName(PropMember member){
      return member.prop_name;
   }
   
   @override
   String jsDataTypeFields() {
      return data.definitions.values
         .where((member) => super.isPublic(member))
         .map((member) {
         var type = super.getType(member);
         var name = member.prop_name;
         var ret  = 'Vue.$interop_member_type<$type> $name;';
         return ret;
      }).join('\n$TAB');
   }
   
   @override
   List<String> _memberInit(PropMember member) {
      var propname = member.prop_name;
      var typename = getType(member);
      var reqiured = member.is_required;
      var validator = member.validator_name;
      var ret = 'ret.$propname = Vue.$interop_member_type.init<$typename>('
         '$reqiured, source.$propname, source.$validator'
         ')';
      return [ret];
   }
   
   Result init(typename, {
      bool js_setter   = false, bool js_getter   = false,
      bool dart_setter = false, bool dart_getter = false})
   {
      return super.init(typename, js_getter: true);
   }

   VuePropTransformer(this.data): super(data);
}



/*


               C O M P O N E N T      T R A N S


*/
class VueComponentTransformer{
   String data_name, watcher_name, property_name, methods_name,
          computed_name, on_name, once_name, filters_name, fields = r'''
_Data      $dart_data    ;
_Watchers  $dart_watchers;
_Props     $dart_props   ;
_Methods   $dart_methods ;
_Ons       $dart_ons     ;
_Onces     $dart_onces   ;
_Computeds $dart_computed;
_Options   $dart_options ;
_Filters   $dart_filters ;
'''.trim(), hooksBody =r'''
void beforeCreate() {}
void created() {}
void beforeMount() {}
void mounted() {}
void beforeUpdate() {}
void updated() {}
void beforeDestroy() {}
void destroyed() {}
'''.trim(), get_vue_options = r'''
static Vue.ComponentOptions $getVueOptions(IVue fn()){
   var cache = Vue.VueApi.$instance_cache;
   if (cache[IVue] == null)
      cache[IVue] = fn();
   return cache[IVue].$toVueOptions(ivue: cache[IVue]);
}
''';
   
   String get constructorBody {
      String template;
      template =
      '\$dart_data      = _Data.init($data_name());'
      '\$dart_watchers  = _Watchers.init($watcher_name());'
      '\$dart_props     = _Props.init($property_name());'
      '\$dart_methods   = _Methods.init($methods_name());'
      '\$dart_filters   = _Filters.init($filters_name());'
      '\$dart_computed  = _Computeds.init($computed_name());'
      '\$dart_ons       = _Ons.init($on_name());'
      '\$dart_onces     = _Onces.init($once_name());'
      '\$dart_options   = _Options();';
      
   }
   Result init(typename ) {
   
   }
   
}







