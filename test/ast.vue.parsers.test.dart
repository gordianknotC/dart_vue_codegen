
import 'dart:io';

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:test/test.dart';
import 'package:html/parser.dart' show parseFragment, parse;
import 'package:html/dom.dart' show DocumentFragment, Node, Element;

import '../lib/src/ast.parsers.dart' show ClassDeclParser;
import '../lib/src/ast.vue.parsers.dart';
import '../lib/src/ast.codegen.dart';
import '../lib/src/io.util.dart';
import '../lib/src/common.dart';
import '../lib/src/ast.vue.codegen.dart';



Iterable<ClassDeclarationImpl>
getClasses(CompilationUnitImpl node) {
   return node.declarations.where((d) => d is ClassDeclarationImpl).whereType();
}

Iterable<T>
getClassMembers<T extends ClassMember>(ClassDeclarationImpl node) {
   return node.members.where((member) => member is T).whereType();
}

main() {
   var path       = getScriptPath(Platform.script);
   var vue_file   = getScriptUri(Platform.script, 'assets.vue_templateA.vue');
   var def_file   = getScriptUri(Platform.script, 'assets.vue_sample.vue.dart');
   var vue_source = readFileAsStringSync(path, 'assets.vue_templateA.vue');
   var def_source = readFileAsStringSync(path, 'assets.vue_sample.vue.dart');
   var gen_source = readFileAsStringSync(path, 'assets.vue_sample.vue.generated.dart');
   
   var dom         = parseFragment(vue_source);
   var dom_script  = dom.querySelector('script');
   var dom_template= dom.querySelector('template');
   var dom_style   = dom.querySelector('style');
   
   print('script: ${dom_script.outerHtml}');
   print('template: ${dom_template.outerHtml}');
   print('style: ${dom_style.outerHtml}');
   
   var vue  = VueDartFileParser(uri: def_file);
   var code = parseCompilationUnit(gen_source, parseFunctionBodies: true);
   
   print('code $code');
   
   group('VueDataTransformer', (){
      var comp     = vue.vue_components.first;
      var method   = comp.method;
      var data     = comp.data;
      var dt       = VueDataTransformer(data);
      /*
      
      
                  O N C E S
      
      
      */
      test('once generator', (){
         var dt = VueOncesTransformer(comp.once);
         var result = dt.init('OnceDefs');
         var data_expected = r'''
@anonymous
@JS()
class _Onces {
   Vue.TOnce onLoad;
   Vue.TOnce onBeforeCreate;
   external _Onces();
   static _Onces init(OnceEventDefs source){
      var ret = _Onces();
      ret.onLoad = Vue.TOnce.init('event_name', source.onLoad);
      ret.onBeforeCreate = Vue.TOnce.init('event_name', source.onBeforeCreate);
      return ret;
   }
}'''.trim();
         var members_expected = r'''
   String Function(dynamic) get onLoad {
      return $dart_onces.onLoad.cb;
   }

   String Function(dynamic) get onBeforeCreate {
      return $dart_onces.onBeforeCreate.cb;
   }
 '''.trim();
   
         print(result.datatype.trim());
         print(result.members.trim());
   
         expect(result.datatype.trim(), data_expected);
         expect(result.members.trim(), members_expected);
      });
      /*
      
      
                  O N S
      
      
      */
      test('on generator', (){
         var dt = VueOnsTransformer(comp.on);
         var result = dt.init('OnDefs');
         var data_expected = r'''
@anonymous
@JS()
class _Ons {
   Vue.TOn onClick;
   external _Ons();
   static _Ons init(OnEventDefs source){
      var ret = _Ons();
      ret.onClick = Vue.TOn.init('event_name', source.onClick);
      return ret;
   }
} '''.trim();
         var members_expected = r'''
   String Function(dynamic) get onClick {
      return $dart_ons.onClick.cb;
   }
 '''.trim();
   
         print(result.datatype.trim());
         print(result.members.trim());
   
         expect(result.datatype.trim(), data_expected);
         expect(result.members.trim(), members_expected);
      });
      
      /*
      
      
                  M E T H O D S
      
      
      */
      test('method generator', (){
         var dt = VueMethodTransformer(comp.method);
         var result = dt.init('MethodDefs');
         var data_expected = r'''
@anonymous
@JS()
class _Methods {
   Function show;
   Function callThis  ;
   external _Methods();
   static _Methods init(MethodDefs source){
      var ret = _Methods();
      ret.show     = Vue.TMethod.init(source.show);
      ret.callThis = Vue.TMethod.init(source.callThis);
      return ret;
   }
}  '''.trim();
         var members_expected = r'''
   void Function() get callThis {
      return $dart_methods.callThis;
   }
   void Function() get show {
      return $dart_methods.show;
   } '''.trim();
   
         print(result.datatype.trim());
         print(result.members.trim());
   
         expect(result.datatype.trim(), data_expected);
         expect(result.members.trim(), members_expected);
      });
      
      /*
      
      
                  P R O P E R T I E S
      
      
      */
      test('prop generator', (){
         var dt = VuePropTransformer(comp.prop);
         var result = dt.init('PropertyDefs');
         var data_expected = r'''
@anonymous
@JS()
class _Props {
   Vue.TProp<String> Color;
   Vue.TProp<num> Num;
   external _Props();
   static _Props init(PropertyDefs source) {
      var ret = _Props();
      ret.Color = Vue.TProp.init<String>(false, source.Color, source.onColorValidated);
      ret.Num = Vue.TProp.init<num>(true, source.Num, source.onNumValidated);
      return ret;
   }
}   '''.trim();
         var members_expected = r'''
   String get Color {
      return Vue.jsGet($dart_props, 'Color');
   }

   num get Num {
      return Vue.jsGet($dart_props, 'Num');
   } '''.trim();
         
         print(result.datatype.trim());
         print(result.members.trim());
   
         expect(result.datatype.trim(), data_expected);
         expect(result.members.trim(), members_expected);
      });
      
      
      /*
      
      
                  W A T C H E R S
      
      */
      test('watcher generator', (){
         var dt = VueWatcherTransformer(comp.watch);
         var result = dt.init('WatcherDefs');
         var data_expected = r'''
@anonymous
@JS()
class _Watchers {
   Vue.TWatcher<int> x;
   Vue.TWatcher<int> sum;
   Vue.TWatcher<String> hello;
   external _Watchers();
   static _Watchers init(WatcherDefs source) {
      var ret = _Watchers();
      ret.x = Vue.TWatcher.init<int>('x', true, false, source.onXChanged);
      ret.sum = Vue.TWatcher.init<int>('sum', false, true, source.onSumChanged);
      ret.hello = Vue.TWatcher.init<String>('hello', false, false, source.onHelloChanged);
      return ret;
   }
}  '''.trim();
         var members_expected = r''' '''.trim();
         print(result.datatype.trim());
         print(result.members.trim());
   
         expect(result.datatype.trim(), data_expected);
         expect(result.members.trim(), members_expected);
      });
      
      /*
      
      
            C O M P U T E D
      
      */
      test('computed generator', (){
         var dt = VueComputedTransformer(comp.computed);
         var result = dt.init('ComputedDefs');
         var data_expected = r'''
@anonymous
@JS()
class _Computeds {
   Vue.TComputed<String> address;
   Vue.TComputed<String> writableText;
   external _Computeds();
   static _Computeds init(ComputedDefs source) {
      var ret = _Computeds();
      ret.address = Vue.TComputed.init<String>(source.get_address, null);
      ret.writableText = Vue.TComputed.init<String>(source.get_writableText, source.set_writableText);
      return ret;
   }
}  '''.trim();
         var members_expected = r'''
   String get address {
      return $dart_computed.address.get();
   }

   void set writableText (String v) {
      $dart_computed.writableText.set(v);
   }

   String get writableText {
      return $dart_computed.writableText.get();
   }     '''.trim();
         print(result.datatype.trim());
         print(result.members.trim());
         
         expect(result.datatype.trim(), data_expected);
         expect(result.members.trim(), members_expected);
         
      });
      
      /*
      
      
                  D A T A
                  
      
      */
      test('jsDataType generator', (){
         var ret = dt.jsDataType('DataDefs').trim();
         var expected = r'''
@anonymous
@JS()
class _Data {
   String hello = 'Curtis';
   String noValue;
   String noValue2;
   int sum = 0;
   int x = 1927;
   void Function(String, int) temp = (String a, int b) {};
   external _Data();
   static _Data init(DataDefs source) {
      var ret = _Data();
      ret.hello = Vue.TData.init<String>(source.hello, null);
      ret.noValue = Vue.TData.init<String>(source.noValue, null);
      ret.noValue2 = Vue.TData.init<String>(source.noValue2, null);
      ret.sum = Vue.TData.init<int>(source.sum, null);
      ret.x = Vue.TData.init<int>(source.x, null);
      ret.temp = Vue.TData.init<void Function(String, int)>(source.temp, null);
      return ret;
   }
}     '''.trim();
         print(ret);
         expect(ret, expected);
      });
      
      test('dartGetter initialization', (){
         var ret = dt.componentMembersInit(dart_getter: true).trim();
         var expected = r'''
   String get hello {
      return $dart_data.hello;
   }

   String get noValue {
      return $dart_data.noValue;
   }

   String get noValue2 {
      return $dart_data.noValue2;
   }

   int get _p1 {
      return $dart_data._p1;
   }

   int get sum {
      return $dart_data.sum;
   }

   int get x {
      return $dart_data.x;
   }

   void Function(String, int) get temp {
      return $dart_data.temp;
   }  '''.trim();
         print(ret);
         expect(ret, expected);
      });
      
      test('jsGetter initialization', (){
         var ret = dt.componentMembersInit(js_getter: true).trim();
         var expected = r'''
   String get hello {
      return Vue.jsGet($dart_data, 'hello');
   }

   String get noValue {
      return Vue.jsGet($dart_data, 'noValue');
   }

   String get noValue2 {
      return Vue.jsGet($dart_data, 'noValue2');
   }

   int get _p1 {
      return Vue.jsGet($dart_data, '_p1');
   }

   int get sum {
      return Vue.jsGet($dart_data, 'sum');
   }

   int get x {
      return Vue.jsGet($dart_data, 'x');
   }

   void Function(String, int) get temp {
      return Vue.jsGet($dart_data, 'temp');
   }  '''.trim();
         print(ret);
         expect(ret, expected);
      });
   });
   
   group('VueClassParser', (){
      var imported_defs = vue.vue_imported_defs;
      var imports       = vue.vue_imports;
      var defs          = vue.vue_defs;
      
      var comp     = vue.vue_components.first;
      var method   = comp.method;
      var data     = comp.data;
      var computed = comp.computed;
      var option   = comp.option;
      var watcher  = comp.watch;
      var prop     = comp.prop;
      var on       = comp.on;
      var once     = comp.once;
      
      void testInheritance({ BaseVueDefinitions member, String def_name,
      String super_cls, String root_cls, String super_def, String root_def, EDefTypes def_type})
      {
         expect(member.def_name.name, def_name);
         expect(member.super_cls.name.name, super_cls);
         expect(member.root_cls.name.name, root_cls);
   
         expect(member.super_def?.def_name?.name, super_def);
         expect(member.root_def,                  root_def);
         expect(member.def_type, def_type);
      }
      
      test('validating OnEventDefs and OnceEventDefs', (){
         
         expect(on.def_name.name, 'OnEventDefs');
         expect(on.super_cls.name.name, 'IOnEventDefs');
         expect(on.root_cls.name.name, 'IOnEventDefs');
         expect(on.super_def?.def_name?.name, null);
         expect(on.root_def,                  null);
         expect(on.def_type, EDefTypes.on);
         
         expect(once.def_name.name, 'OnceEventDefs');
         expect(once.super_cls.name.name, 'IOnceEventDefs');
         expect(once.root_cls.name.name, 'IOnceEventDefs');
         expect(once.super_def?.def_name?.name, null);
         expect(once.root_def,                  null);
         expect(once.def_type, EDefTypes.once);
         
      });
      
      test('validating WatcherDefs', (){
         var watched_properties = watcher.watchers.keys.toList(growable: false);
         var x                  = watcher.watchers['x'];
         var hello              = watcher.watchers['hello'];
         var sum                = watcher.watchers['sum'];
         
         expect(watched_properties, unorderedEquals(['x', 'sum', 'hello']));
         
         expect(x.prop_name, 'x');
         expect(x.prop_type.named_type.name.name, 'int');
         expect(x.deep_field.names, ['x_deep']);
         expect(x.deep, true);
         expect(x.immediate, false);
         expect(x.immediate_field, null);
         expect(x.watcher.name.name, 'onXChanged');

         expect(hello.prop_name, 'hello');
         expect(hello.prop_type.named_type.name.name, 'String');
         expect(hello.deep, false);
         expect(hello.deep_field, null);
         expect(hello.immediate, false);
         expect(hello.immediate_field, null);
         expect(hello.watcher.name.name, 'onHelloChanged');

         expect(sum.prop_name, 'sum');
         expect(sum.prop_type.named_type.name.name, 'int');
         expect(sum.deep, false);
         expect(sum.deep_field, null);
         expect(sum.immediate, true);
         expect(sum.immediate_field.names, ['sum_immediate']);
         expect(sum.watcher.name.name, 'onSumChanged');
         
         expect(watched_properties, ['x', 'sum', 'hello']);
         expect(watcher.def_name.name, 'WatcherDefs');
         expect(watcher.super_cls.name.name, 'IWatcherDefs');
         expect(watcher.root_cls.name.name, 'IWatcherDefs');
   
         expect(watcher.super_def?.def_name?.name, null);
         expect(watcher.root_def,                  null);
         expect(watcher.def_type, EDefTypes.watch);
      });
      
      test('validating PropertyDefs', (){
         var property_names = prop.props.keys;
         var color       = prop.props['Color'];
         var num         = prop.props['Num'];
         
         var c_field     = color.field_body;
         var c_default   = color.default_value.toSource();
         var c_required  = color.is_required;
         var c_vname     = color.validator_name;
         var c_validator = color.method_body;
         var c_name      = color.prop_name;
         var c_type      = color.prop_type;
         
         var n_field     = num.field_body;
         var n_default   = num.default_value.toSource();
         var n_required  = num.is_required;
         var n_vname     = num.validator_name;
         var n_validator = num.method_body;
         var n_name      = num.prop_name;
         var n_type      = num.prop_type;
         
         expect(property_names, ['Color', 'Num']);
         expect(prop.def_name.name, 'PropertyDefs');
         expect(prop.super_cls.name.name, 'IPropDefs');
         expect(prop.root_cls.name.name, 'IPropDefs');

         expect(prop.super_def?.def_name?.name, null);
         expect(prop.root_def,                  null);
         expect(prop.def_type, EDefTypes.prop);
         
         expect(c_field.names, ['Color']);
         expect(c_default, "'RED'");
         expect(c_required, false);
         expect(c_vname, 'onColorValidated');
         expect(c_validator.name.name, 'onColorValidated');
         expect(c_name, 'Color');
         expect(c_type.named_type.name.name, 'String' );

         expect(n_field.names, ['Num']);
         expect(n_default, "24");
         expect(n_required, true);
         expect(n_vname, 'onNumValidated');
         expect(n_validator.name.name, 'onNumValidated');
         expect(n_name, 'Num');
         expect(n_type.named_type.name.name, 'num' );
      });
      
      test('validating MethodDefs', (){
         var method_keys= method.definitions.keys.toList();
         var callThis = method.definitions['callThis'];
         var getMap = method.definitions['getMap'];
         var show = method.definitions['show'];
         
         
         expect(method.def_name.name, 'MethodDefs');
         expect(method.super_cls.name.name, 'IMethodDefs');
         expect(method.root_cls.name.name, 'IMethodDefs');
         
         expect(method.super_def?.def_name?.name, null);
         expect(method.root_def,                  null);
         expect(method.def_type, EDefTypes.method);

         expect(method_keys, ['callThis', 'show', 'getMap']);
         expect(callThis.name, 'callThis');
         expect(callThis.method_body.ret_type.toSource(), 'void');
         
         expect(callThis.method_body.refs_in_body
            .map((ref) => ref.refs.map((r) => r.name).toList())
            .toList(), unorderedEquals([
               ['show'],
               ['getMap'],
               ['self', '_data'],
               ['self', 'mounted'],
               ['self', 'getValue']
         ]));
         
         expect(callThis.method_body.refs_in_body
            .map((ref) => ref.getTargetRef(['self']))
            .toList(),unorderedEquals(
               ['show', 'getMap', '_data', 'mounted', 'getValue']
         ));

         expect(
            callThis.method_body
               .getReferencedMethods({'self': [comp.cls_parser]})
               .map((m) => m.refs.map((r) => r.name).toList()),
            unorderedEquals([
               ['show'],
               ['getMap'],
               ['self', 'mounted'],
               ['self', 'getValue']
            ]),
            reason: 'getReferencedMethods expect to be:'
         );

         expect(
            callThis.method_body
               .getReferencedClassMethods({'self': [comp.cls_parser]})
               .map((m) => m.name.name).toList(),
            unorderedEquals(['show', 'getMap', 'mounted', 'getValue']),
            reason: 'getReferencedClassMethods expect to be:'
         );
         
         expect(
            callThis.method_body
               .getReferencedFields({'self': [comp.cls_parser]})
               .fold<List>(<String>[], (initial, m) => initial + m.refs.map((r) => r.name).toList()),
            equals(['self', '_data']),
            reason: 'getReferencedFields expect to be:'
         );
         
         expect(
            callThis.method_body
               .getReferencedClassFields({'self': [comp.cls_parser]})
               .fold<List>(<String>[], (initial, m) => initial + m.names),
            // note: self is not included here, since it assigned as reference_host
            equals(['_data']),
            reason: 'getReferencedClassFields expect to be:'
         );
         
         expect(callThis.host_references, unorderedEquals([
            '_data', 'show', 'getMap', 'mounted', 'getValue'
         ]));
         
         expect(getMap.name, 'getMap');
         expect(getMap.method_body.ret_type.toSource(), 'String');
         expect(getMap.annotation_names, ['provide']);
         expect(getMap.host_references, ['parentGetMap']);

         expect(show.name, 'show');
         expect(show.method_body.ret_type.toSource(), 'void');
         expect(show.host_references, ['getstr']);
         
      });

      test('validating ComputedDefs', (){
         var computed_keys    = computed.props.keys.toList();
         
         var address          = computed.props['address'];
         var writableText     = computed.props['writableText'];

         var get_address      = address.getter_body;
         var get_writableText = writableText.getter_body;
         var set_writableText = writableText.setter_body;
         
         expect(computed_keys, unorderedEquals(['address', 'writableText']));
         
         expect(get_address.name.name, 'get_address');
         expect(get_address.ret_type.toSource(), 'String');
         
         expect(address.body.isGetterSetter, false);
         expect(address.body.isGetter, true);
         expect(address.body.isSetter, false);
         expect(address.body.pseudo_gtr_str, true);
         expect(address.host_references, ['_data']);
         expect(address.isGetter, true);
         expect(address.isSetter, false);

         expect(get_writableText.name.name, 'get_writableText');
         expect(get_writableText.ret_type.toSource(), 'String');
         expect(set_writableText.name.name, 'set_writableText');
         expect(set_writableText.ret_type.toSource(), 'void');
         
         expect(writableText.body.isGetter, true);
         expect(writableText.body.isSetter, true);
         expect(writableText.body.isGetterSetter, true);
         expect(writableText.body.isMethod, false);
         expect(writableText.body.pseudo_gtr_str, true);
         expect(writableText.isGetter, true);
         expect(writableText.isSetter, true);
         expect(writableText.isMethod, false);
         expect(writableText.host_references, ['hello']);
         
      });
   });
}





































