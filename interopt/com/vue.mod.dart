@JS() //@formatter:off
library vue;
import 'package:js/js_util.dart';
import 'package:js/js.dart';
import '../../interopt/common/window.dart' show jsGet, jsCall, jsSet;
import 'dart:js'
   show JsObject, allowInteropCaptureThis, allowInterop,
        JsFunction, JsArray, context;
import 'dart:html'
   show Notification, Element, ElementList, Window,
        HtmlDocument, Node, HtmlElement;

/*
notice:        windows common lib            ;



 */
@JS('Math')
class Math{
   external static int max(int a , int b);
   external static int min(int a, int b);
}
@JS('console')
class console{
   external static void log(dynamic str, [a,b,c,d,e,f,g]);
   external static void info(dynamic str, [a,b,c,d,e,f,g]);
   external static void warn(dynamic str, [a,b,c,d,e,f,g]);
   external static void error(dynamic str, [a,b,c,d,e,f,g]);
   external static void group(dynamic str, [a,b,c,d,e,f,g]);
   external static void groupEnd(dynamic str, [a,b,c,d,e,f,g]);
}
@JS('JSON.stringify')
external String str(dynamic any);

@JS('document.querySelector')
external Element querySelector(String str);

@JS('document.querySelector')
external ElementList<Element> querySelectorAll(String str);

@JS('window')
external Window get win;

@JS('document')
external HtmlDocument get doc;

@JS('Function')
@anonymous
class JsFunction{

}


/*
notice:        vue type definitions            ;



 */
@JS()
@anonymous
class TDescriptor{
   external dynamic get value;
   external dynamic get get;
   external dynamic get set;
   external factory TDescriptor({bool configurable, bool enumerable, value, bool writable, Function get, Function set});
}

@JS()
@anonymous
class TConstructor{
   external static String get name;
   external static dynamic get prototype;
}

@JS()
@anonymous
class TPrototypeClass{
   external  dynamic get prototype;
   external  TConstructor get constructor;
   external  String get name;
}

@JS('Object')
class Object{
   external static List<String> getOwnPropertyNames(TPrototypeClass obj);
   external static TDescriptor getOwnPropertyDescriptor(TPrototypeClass obj, String name);
   external static void defineProperty(dynamic obj, String name, TDescriptor opt);
}




typedef ScopedSlot = dynamic Function(dynamic props);

@anonymous
@JS()
abstract class VNodeChildrenArrayContents {
}

@anonymous
@JS()
abstract class VNodeChildren {
}

@anonymous
@JS()
class InlineTemplate{
   Function render;
   List<Function> staticRenderFns;
}

@anonymous
@JS()
abstract class VNodeComponentOptions {
   external VueApi        get Ctor;
   external dynamic       get propsData;
   external dynamic       get listeners;
   external VNodeChildren get children;
   external String        get tag;
}

@anonymous
@JS()
abstract class VNodeData {
   external dynamic /*String|num*/          get key;
   external String                          get slot;
   external Map<String, ScopedSlot>         get scopedSlots;
   external String                          get ref;
   external String                          get tag;
   external String                          get staticClass;
   external dynamic                         get JS$class;
   external Map<String, dynamic>            get staticStyle;
   external dynamic /*List<object>|object*/ get style;
   external Map<String, dynamic>            get props;
   external Map<String, dynamic>            get attrs;
   external Map<String, dynamic>            get domProps;
   external Map<String, Function>           get hook;
   external Map<String, dynamic>            get on;
   external Map<String, dynamic>            get nativeOn;
   external dynamic                         get transition;
   external bool                            get show;
   external InlineTemplate                  get inlineTemplate;
   external List<VNodeDirective>            get directives;
   external bool                            get keepAlive;
}

@anonymous
@JS()
abstract class VNode {
   external String                 get tag;
   external VNodeData              get data;
   external List<VNode>            get children;
   external String                 get text;
   external Node                   get elm;
   external String                 get ns;
   external VueApi                 get context;
   external dynamic /*String|num*/ get key;
   external VNodeComponentOptions  get componentOptions;
   external VueApi                 get componentInstance;
   external VNode                  get parent;
   external bool                   get raw;
   external bool                   get isStatic;
   external bool                   get isRootInsert;
   external bool                   get isComment;
}

@anonymous
@JS()
typedef DirectiveFunction = void Function(
   HtmlDocument el,
   VNodeDirective binding,
   VNode vnode,
   VNode oldvnode,
);

@anonymous
@JS()
abstract class VNodeDirective{
   external String get name;
   external dynamic get value;
   external dynamic get oldValue;
   external dynamic get expression;
   external String  get arg;
   external Map<String, bool> get modifiers;
}
@anonymous
@JS()
class DefaultData extends JsObj{
   external factory DefaultData(Map<String, dynamic> data);
}
@anonymous
@JS()
class DefaultProps extends JsObj{
   external factory DefaultProps(Map<String, dynamic> data);
}
@anonymous
@JS()
class DefaultMethods extends JsObj{
   external factory DefaultMethods(Map<String, dynamic> data);
}
@anonymous
@JS()
class DefaultComputed extends JsObj {
   external factory DefaultComputed(Map<String, dynamic> data);
}

typedef void WatchHandler(dynamic val, dynamic oldVal);
typedef dynamic CreateElement(dynamic tag, [dynamic arg1, dynamic arg2]);

@anonymous
@JS()
abstract class Model{
   String prop;
   String event;
}

@anonymous
@JS()
abstract class RenderContext{
   DefaultProps         props;
   List<VNode>          children;
   VNodeData            data;
   VueApi               parent;
   dynamic              injections;
   Map<String, dynamic> listeners;
   dynamic slots();
   
}
typedef PluginFunction = void Function(Vue vue, dynamic options);

@anonymous
@JS()
class TComputed extends JsObj {
   external factory TComputed(Map<String,dynamic> data);
}
@anonymous
@JS()
class TMethods extends JsObj{
   external factory TMethods(Map<String, dynamic> data);
}
@anonymous
@JS()
class TData extends JsObj {
   external factory TData(Map<String,dynamic> data);
}
typedef TValidator = bool Function(dynamic value);


@anonymous
@JS()
class TProp {
   dynamic     type;
   bool        required;
   dynamic     JS$default;
   TValidator  validator;
   external TProp({this.type, this.required, this.JS$default, this.validator});
}

@anonymous
@JS()
class TProps extends JsObj {
   external factory TProps(Map<String,TProp> data);
}
@anonymous
@JS()
class TWatch extends JsObj {
   external factory TWatch(Map<String, WatchOptions> watches);
}

@anonymous
@JS()
class TComponents extends JsObj {
   external factory TComponents(Map<String, ComponentOptions> components);
}

@anonymous
@JS()
class TDirectives extends JsObj {
   external factory TDirectives(Map<String, DirectiveOptions> data);
}

typedef FVueFilter = dynamic Function(dynamic value);

@anonymous
@JS()
class TFilters extends JsObj {
   external factory TFilters(Map<String, FVueFilter> filters);
}

@anonymous
@JS()
typedef VoidFunc = void Function();


@anonymous
@JS()
abstract class VueConfiguration {
   external bool          get silent;
   external dynamic       get optionMergeStrategies;
   external bool          get devtools;
   external bool          get productionTip;
   external bool          get performance;
   external dynamic       get keyCodes;
   external bool          get JS$async;
   external List<dynamic> get ignoredElements;

   external void errorHandler(Error err, VueApi vm, String info);
   external void warnHandler(String msg, VueApi vm, String trace);
}

@anonymous
@JS()
class VueApi {
   //note: readonly properties           ;
   external HtmlElement          get $el;
   external dynamic              get $options;
   external List<VueApi>         get $children;
   external VNode                get $vnode;
   external VueApi               get $parent;
   external VueApi               get $root;
   external dynamic              get $ref;
   external dynamic              get $slots;
   external dynamic              get $scopedSlots;
   external dynamic              get $ssrContext;
   external bool                 get $isServer;
   external Map<String, dynamic> get $data;
   external Map<String, dynamic> get $props;
   external Map<String, dynamic> get $attrs;
   external Map<String, dynamic> get $listeners;
   //note: writable properties          ;
   external dynamic              get $set;
   external dynamic              get $delete;
   CreateElement $createElement;
   //note: methods                      ;
   external VueApi           $mount(dynamic elementOrSelector, bool hydrating);
   external void             $forceUpdate();
   external void             $destroy();
   external VueApi           $on   (dynamic event, Function callback);
   external VueApi           $off  (dynamic event, Function callback);
   external VueApi           $once (String event, Function callback);
   external VueApi           $emit (String event, [arg1, arg2, arg3, arg4, arg5, arg6]);
   external void Function()  $watch(
      dynamic expOrFn, void Function(dynamic jsthis, dynamic n, dynamic o) callback, WatchOptions options);
   external dynamic          $nextTick([void callback(VueApi jsthis)]);

}
typedef TMethod = dynamic Function(VueApi self,[dynamic a, dynamic b, dynamic c, dynamic d, dynamic e ]);

/*
notice:        vue/option initilizers            ;



 */
@JS("Vue")
class Vue extends VueApi {
   external Vue(ComponentOptions options);
   external static dynamic  nextTick([void callback(), List<dynamic> context]);
   external static dynamic  JS$set (dynamic object_array, dynamic key_str_num, dynamic value);
   external static void     delete (dynamic object_array, dynamic key_str_num,);
   external static DirectiveOptions directive(String id, [dynamic definition]);
   external static Function filter(String id, [Function definition]);
   external static dynamic  component (String id, [dynamic  constructor_definition]);
   external static void     use(PluginObject plugin, [dynamic /*T|List<dynamic>*/ options]);
   external static void     mixin(Mixin mixin);
   external static dynamic  compile(String template);
   external static VueConfiguration get config;
   external static dynamic get prototype;
}

@anonymous
@JS()
abstract class PluginObject extends JsObj{
   PluginFunction install;
   external factory PluginObject({PluginFunction install});
}

Function JFunc(dynamic fn, [bool capture = false]){
   return capture == true
      ? allowInteropCaptureThis(fn)
      : allowInterop(fn);
}
@anonymous
@JS()
class DirectiveOptions{
   DirectiveFunction bind;
   DirectiveFunction inserted;
   DirectiveFunction update;
   DirectiveFunction componentUpdated;
   DirectiveFunction unbind;
   external DirectiveOptions({
                                DirectiveFunction bind, DirectiveFunction inserted, DirectiveFunction update,
                                DirectiveFunction componentUpdated, DirectiveFunction unbind});
}
@anonymous
@JS()
class WatchOptions {
   external bool get deep;
   external bool get immediate;
   external WatchHandler get handler;
   external WatchOptions({WatchHandler handler, bool deep, bool immediate});
}

@JS()
@anonymous
class Transitions extends JsObj{
   external factory Transitions({
                                   void beforeEnter(),
                                   void enter(),
                                   void afterEnter(),
                                   void enterCancelled(),
                                   void beforeLeave(),
                                   void leave(),
                                   void afterLeave(),
                                   void leaveCancelled()
                                });
   external Function get beforeEnter;
   external Function get enter;
   external Function get afterEnter;
   external Function get enterCancelled;
   external Function get beforeLeave;
   external Function get leave;
   external Function get afterLeave;
   external Function get leaveCancelled;
//   external void set beforeEnter(void beforeEnter(Element el));
//   external void set enter(void enter(Element el));
//   external void set afterEnter(void afterEnter(Element el));
//   external void set enterCancelled(void enterCancelled(Element el));
//   external void set beforeLeave(void beforeLeave(Element el));
//   external void set leave(void leave(Element el));
//   external void set afterLeave(void afterLeave(Element el));
//   external void set leaveCancelled(void leaveCancelled(Element el));
}


@anonymous
@JS()
class ComponentOptions extends JsObj{
   // note: properties             ;
   external String               get name;
   external dynamic              get data;
   external TProps                get props;
   external dynamic              get propsData;
   external TMethods              get methods;
   external TComputed             get computed;
   external TWatch                get watch;
   external String               get el;
   external String               get template;
   external TComponents        get components;
   external Transitions       get transitions;
   external TDirectives        get directives;
   external TFilters           get filters;
   external Model                      get model;
   external VueApi                     get parent;
   external bool                       get comments;
   external bool                       get inheritAttrs;
   external List<String>               get delimiters;
   external dynamic                    get JS$extends;
   external Map<String, dynamic>       get inject;
   
   // note: functions                ;
   external VNode render(CreateElement cr, RenderContext hack);
   external VNode renderError(VNode h(), Error err);
   external void  beforeCreate();
   external void  created();
   external void  beforeDestroy();
   external void  destroyed();
   external void  beforeMount();
   external void  mounted();
   external void  beforeUpdate();
   external void  updated();
   external void  activated();
   external void  deactivated();
   external bool  errorCaptured(Error err, VueApi vue, String info);
   external List<VNode Function(CreateElement cr)> get staticRenderFns;
   
   void addAll(Map<String, dynamic> data){
      _toOptionsMap(data, TDynamic.ComponentOptions, this);
   }
   external factory ComponentOptions({
                   String name, dynamic data, TProps props, dynamic propsData, TMethods methods,
                   TComputed computed, TWatch watch, String el, String template,
                   TComponents components, Transitions transitions,
                   TFilters filters, Model model, VueApi parent, bool comments, bool inheritAttrs,
                   List<String> delimiters, dynamic JS$extends, Map<String, dynamic> inject,
                   VoidFunc beforeCreate, VoidFunc created, VoidFunc beforeDestory, VoidFunc destroyed,
                   VoidFunc beforeMount, VoidFunc mounted, VoidFunc beforeUpdate, VoidFunc updated,
                   VoidFunc activated, VoidFunc deactivated //, TDirectives directives
                });
}



@JS()
@anonymous
class Mixin extends ComponentOptions {
   external factory Mixin({
                   String name, dynamic data, TProps props, dynamic propsData, TMethods methods,
                   TComputed computed, TWatch watch, String el, String template,
                   TComponents components, Transitions transitions, TDirectives directives,
                   TFilters filters, Model model, VueApi parent, bool comments, bool inheritAttrs,
                   List<String> delimiters, dynamic JS$extends, Map<String, dynamic> inject,
                   VoidFunc beforeCreate, VoidFunc created, VoidFunc beforeDestory, VoidFunc destroyed,
                   VoidFunc beforeMount, VoidFunc mounted, VoidFunc beforeUpdate, VoidFunc updated,
                   VoidFunc activated, VoidFunc deactivated
                });
}

TFilters Filters(Map<String, FVueFilter> filters){
   return toJsMap(filters, true, TDynamic.FVueFilter);
}
TDirectives Directives(Map<String, DirectiveOptions> directives){
   return toJsMap(directives, true, TDynamic.DirectiveOptions);
}
TComponents Components(Map<String, ComponentOptions> components){
   return toJsMap(components, true, TDynamic.ComponentOptions);
}
TWatch Watch(Map<String, dynamic> watches){
   return toJsMap(watches, true, TDynamic.WatchOptions);
}
dynamic Data(dynamic data){
   if (data is Map)
      return toJsMap(data, true, TDynamic.JsObj);
   if (data is Function)
      return JFunc(allowInteropCaptureThis(data));
   throw Exception('Invalid type, only typeof map and function are supported.');
}
TProps Props(Map<String, dynamic> props){
   return toJsMap(props, true, TDynamic.JsObj);
}
TProp Prop(TProp prop){
   return prop;
}
TMethods Methods(Map<String, dynamic> methods){
   return toJsMap(methods, true, TDynamic.JsObj);
}
TMethods Computed(Map<String, dynamic> computed){
   return toJsMap(computed, true, TDynamic.JsObj);
}

/*

notice:       options  generator               ;
------------------------------------------------


*/
ComponentOptions _genComponentOptions({
                                         String name, TData data, TProps props, dynamic propsData, TMethods methods,
                                         TComputed computed, TWatch watch, String el, String template,
                                         TComponents components, Transitions transitions, TDirectives directives,
                                         TFilters filters, Model model, VueApi parent, bool comments, bool inheritAttrs,
                                         List<String> delimiters, dynamic JS$extends, Map<String, dynamic> inject,
                                         VoidFunc beforeCreate, VoidFunc created, VoidFunc beforeDestory, VoidFunc destroyed,
                                         VoidFunc beforeMount, VoidFunc mounted, VoidFunc beforeUpdate, VoidFunc updated,
                                         VoidFunc activated, VoidFunc deactivated
                                      }){
   return ComponentOptions(name:name, data:data, props:props, propsData:propsData, methods:methods,
      computed:computed, watch:watch, el:el, template:template, components:components,
      transitions:transitions, filters:filters, model:model, parent:parent,
      comments:comments, inheritAttrs:inheritAttrs, delimiters: delimiters, JS$extends: JS$extends, inject: inject,
      beforeCreate: beforeCreate, created: created, beforeDestory: beforeDestory,destroyed: destroyed,
      beforeMount: beforeMount, mounted: mounted, beforeUpdate:beforeUpdate, updated: updated, activated: activated,
      deactivated: deactivated/* directives:directives,*/  );
}
ComponentOptions genComponentOptions(Map<String, dynamic>map){
   return Function.apply(_genComponentOptions, [], symbolizeKeys(map));
}
/*
var vm = new Vue({
  data: {
    a: 1,
    b: 2,
    c: 3,
    d: 4,
    e: {
      f: {
        g: 5
      }
    }
  },
  watch: {
    a: function (val, oldVal) {
      console.log('new: %s, old: %s', val, oldVal)
    },
    // string method name
    b: 'someMethod',
    // deep watcher
    c: {
      handler: function (val, oldVal) { /* ... */ },
      deep: true
    },
    // the callback will be called immediately after the start of the observation
    d: {
      handler: function (val, oldVal) { /* ... */ },
      immediate: true
    },
    e: [
      function handle1 (val, oldVal) { /* ... */ },
      function handle2 (val, oldVal) { /* ... */ }
    ],
    // watch vm.e.f's value: {g: 5}
    'e.f': function (val, oldVal) { /* ... */ }
  }
})
vm.a = 2 // => new: 2, old: 1
*/
WatchOptions _genWatchOptions({WatchHandler handler, bool deep, bool immediate}){
   //[note] handler => function; deep and immediate is not necessary
   return WatchOptions(handler: handler, deep: deep, immediate: immediate);
}
WatchOptions genWatchOptions(Map<String, dynamic>map){
   return Function.apply(_genWatchOptions, [], symbolizeKeys(map));
}
DirectiveOptions _genDirectiveOptions({
                                         DirectiveFunction bind, DirectiveFunction inserted, DirectiveFunction update,
                                         DirectiveFunction componentUpdated, DirectiveFunction unbind}){
   return DirectiveOptions(bind: bind, inserted: inserted, update: update,
      componentUpdated: componentUpdated, unbind: unbind);
}
DirectiveOptions genDirectiveOptions(Map<String, dynamic>map){
   return Function.apply(_genWatchOptions, [], symbolizeKeys(map));
}
JsObj _toOptionsMap(Map<String, dynamic> map, [TDynamic type = TDynamic.WatchOptions, JsObj instance]){
   final object = instance ?? new JsObj();
   for (final key in map.keys){
      var val = map[key];
      switch(type){
         case TDynamic.ComponentOptions:
            object[key] = val is Map
               ? genComponentOptions(val)
               : val;
            break;
         case TDynamic.DirectiveOptions:
            object[key] = val is Map
               ? genDirectiveOptions(val)
               : val;
            break;
         case TDynamic.WatchOptions:
            object[key] = val is Map
               ? genWatchOptions(val)
               : val;
            break;
         default:
            throw Exception('Invalid Type!');
      }
   }
   return object;
}
JsObj _toFnMap(Map<String, dynamic> map, [TDynamic type = TDynamic.FVueFilter]){
   final object = new JsObj();
   for (final key in map.keys){
      Function val = map[key];
      object[key] = type == TDynamic.FVueFilter
         ? allowInteropCaptureThis(val)
         : allowInterop(val);
   }
   return object;
}
//@formatter:on

/*
notice:        interoption utilities            ;



 */

@JS('Object')
@anonymous
class JsObj {
   external factory JsObj([dynamic any]);
   
   external operator []=(String key, dynamic value);
   
   external operator [](String key);
   
   external static List<String> getOwnPropertyNames(TPrototypeClass obj);
   
   external static TDescriptor getOwnPropertyDescriptor(TPrototypeClass obj, String name);
   
   external static void defineProperty(dynamic obj, String name, TDescriptor opt);
   
   external static T assign<T>(T target, T source, [T source2, T source3]);
}
enum TDynamic {
   JsObj,
   WatchOptions,
   ComponentOptions,
   DirectiveOptions,
   FVueFilter
}

dynamic vueGetObj(dynamic vuethis) =>
   getProperty(vuethis, r'$dartobj');

dynamic _interopWithObj(Function func) =>
   allowInteropCaptureThis((context) =>
      func(vueGetObj(context)));

Map<Symbol, dynamic> symbolizeKeys(Map<String, dynamic> map) {
   try {
      final result = new Map<Symbol, dynamic>();
      map.forEach((String k, v) {
         result[new Symbol(k)] = v;
      });
      return result;
   } catch (e) {
      console.error('some exceptions occurred while symbolizing keys. $e', '\nmap:', map);
      rethrow;
   }
}


JsObj toJsMap(Map<String, dynamic> map, [bool deep = false, TDynamic type = TDynamic.JsObj]) {
   if (type == TDynamic.JsObj) {
      final object = new JsObj();
      for (final key in map.keys) {
         var val = map[key];
         object[key] = val is Function
                       ? allowInteropCaptureThis(val)
                       : val is Map
                         ? deep == true
                           ? toJsMap(val, deep, type)
                           : val
                         : val is List
                           ? deep == true
                             ? toJsArray(val)
                             : val
                           : val;
      }
      return object;
   } else if (type == TDynamic.FVueFilter) {
      return _toFnMap(map, type);
   } else if ([TDynamic.DirectiveOptions, TDynamic.WatchOptions, TDynamic.ComponentOptions].contains(type)) {
      return _toOptionsMap(map, type);
   } else {
      throw new Exception('Invalid usage, value for enum: $type is not supported');
   }
}

List toJsArray(List list) {
   return list.map((l) {
      if (l is List) return toJsArray(l);
      return l;
   }).toList();
}

/*
notice:       implementing proxies for vue class            ;




 */



/*


note:         trivial tests              ;




 */
@JS()
class IS_Body extends JsObj {
   external factory IS_Body();
   
   external Map<String, String> get Data;
   
   external bool array(dynamic v);
   
   external bool string(String v);
   
   external bool number(num v);
   
   external void ShowInfo();
   
   external IS_Data get data;
   
   external void hey();
   
   external void showInfo();
}

@JS('IS')
external IS_Body Function(IS_Data data, _IS_Methods methods) get IS;

@anonymous
@JS()
class IS_Data {
   String name;
   String author;
   
   external IS_Data({this.name, this.author});
}

@anonymous
@JS()
class _IS_Methods extends JsObj {
   external factory _IS_Methods(Map<String, dynamic> data);
}

_IS_Methods IS_Methods(Map<String, dynamic> methods) {
   return toJsMap(methods, true, TDynamic.JsObj);
}



