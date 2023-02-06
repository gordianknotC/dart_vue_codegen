@JS() //@formatter:off
library vue;
import 'package:js/js_util.dart';
import 'package:js/js.dart';

import 'dart:js'
   show JsObject, allowInteropCaptureThis, allowInterop,
   JsFunction, JsArray, context;
import 'dart:html'
   show Notification, Element, ElementList, Window,
   HtmlDocument, Node, HtmlElement;


const DEFAULT_DELIMITERS = ['{{', '}}'];
const DEFAULT_MODEL      = ['prop', 'event'];



/*
notice:        windows common lib            ;



 */
@JS('Date')
class Date{
   external static int parse(String date_string);
   external factory Date(int computer_time);
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
void jsSet(dynamic obj, String name, dynamic value){
   return setProperty(obj, name, value);
}
dynamic jsGet(dynamic obj, String name){
   return getProperty(obj, name);
}

dynamic jsCall(dynamic obj, String method, List args ){
   return callMethod(obj, method, args);
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
class Model{
   final String prop;
   final String event;
   const Model(this.prop, this.event);
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
class TComputeds extends JsObj {
   external factory TComputeds(Map<String,dynamic> data);
}

@anonymous
@JS()
class TDatas extends JsObj {
   external factory TDatas(Map<String,dynamic> data);
}

typedef TValidator = bool Function(dynamic value);


class TMethod<E>{
   static Function init<E extends Function>(E body){
      return toJSType<Function>(body);
   }
}

class TFilter<E>{
   static Function init<E extends Function>(E body){
      return toJSType<Function>(body);
   }
}

class TOption<E>{
   static E init<E>(dynamic data){
      return toJSType<E>(data as E);
   }
}

class TData<E>{
   static E init<E>(dynamic data){
      return toJSType<E>(data as E);
   }
}

@anonymous
@JS()
class TComputed<E>{
   E Function() get;
   void Function(E v) set;
   external TComputed({this.get, this.set});

   static TComputed<E> init<E>(E get(), void set(E v)){
      return TComputed(
         get: get != null ? toJSType<Function>(get) : null,
         set: set != null ? toJSType<Function>(set) : null
      );
   }
}

@anonymous
@JS()
class TMethods extends JsObj{
   external factory TMethods(Map<String, dynamic> data);
}

@anonymous
@JS()
class TWatcher<E>{
   String prop_name;
   bool deep;
   bool immediate;
   Function(E newval, E oldval) onChange;
   external TWatcher(this.prop_name, this.onChange, this.deep, this.immediate);
   
   static TWatcher<E> init<E>(String prop_name, bool deep, bool immediate, bool onChange(E n, E o)){
      return TWatcher(prop_name, toJSType<Function>(onChange), deep, immediate);
   }
}
@anonymous
@JS()
class TWatchers extends JsObj {
   external factory TWatchers(Map<String, WatchOptions> watches);
}
@anonymous
@JS()
class TProp<E> {
   dynamic  type;
   bool     required;
   E        JS$default;
   bool Function(E value)  validator;
   external TProp({this.required, this.JS$default, this.validator, this.type});
   
   static TProp<E>
   init<E>(bool required, dynamic JS$default, bool validator(E value)){
      var type;
      if (isNumber(JS$default)){
         type = TJNumber;
      }else if (isString(JS$default)){
         type = TJString;
      }else if (isBoolean(JS$default)){
         type = TJBoolean;
      }else if (isArray(JS$default)){
         type = TJArray;
      }else if (isFunction(JS$default)){
         type = TJFunction;
      }else if (isSymbol(JS$default)){
         type = TJSymbol;
      }else if (isDate(JS$default)){
         type = TJDate;
      }else{
         type = TJObject;
      }
      return TProp<E>(
         required: required, JS$default: JS$default,
         validator:  allowInterop(validator), type:type
      );
   }
}

@anonymous
@JS()
class TOn {
   String event_name;
   void Function (dynamic e) cb;
   TOn(this.event_name, this.cb);
   
   static TOn init (String event_name, Function cb){
      return TOn(event_name, toJSType<Function>(cb));
   }
}

@anonymous
@JS()
class TOnce {
   String event_name;
   void Function (dynamic e) cb;
   TOnce(String event_name, Function cb);
   
   static TOnce init (String event_name, Function cb) {
      return TOnce(event_name, toJSType<Function>(cb));
   }
}


@anonymous
@JS()
class TProps extends JsObj {
   external factory TProps(Map<String,TProp> data);
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








/*

export interface ComponentOptions<
  V extends Vue,
  Data=DefaultData<V>,
  Methods=DefaultMethods<V>,
  Computed=DefaultComputed,
  PropsDef=PropsDefinition<DefaultProps>,
  Props=DefaultProps> {
  data?: Data;
  props?: PropsDef;
  propsData?: object;
  computed?: Accessors<Computed>;
  methods?: Methods;
  watch?: Record<string, WatchOptionsWithHandler<any> | WatchHandler<any> | string>;

  el?: Element | string;
  template?: string;
  // hack is for functional component type inference, should not be used in user code
  render?(createElement: CreateElement, hack: RenderContext<Props>): VNode;
  renderError?(createElement: CreateElement, err: Error): VNode;
  staticRenderFns?: ((createElement: CreateElement) => VNode)[];

  beforeCreate?(this: V): void;
  created?(): void;
  beforeDestroy?(): void;
  destroyed?(): void;
  beforeMount?(): void;
  mounted?(): void;
  beforeUpdate?(): void;
  updated?(): void;
  activated?(): void;
  deactivated?(): void;
  errorCaptured?(err: Error, vm: Vue, info: string): boolean | void;

  directives?: { [key: string]: DirectiveFunction | DirectiveOptions };
  components?: { [key: string]: Component<any, any, any, any> | AsyncComponent<any, any, any, any> };
  transitions?: { [key: string]: object };
  filters?: { [key: string]: Function };

  provide?: object | (() => object);
  inject?: InjectOptions;

  model?: {
    prop?: string;
    event?: string;
  };

  parent?: Vue;
  mixins?: (ComponentOptions<Vue> | typeof Vue)[];
  name?: string;
  // TODO: support properly inferred 'extends'
  extends?: ComponentOptions<Vue> | typeof Vue;
  delimiters?: [string, string];
  comments?: boolean;
  inheritAttrs?: boolean;
}
*/
@anonymous
@JS()
class VueApi with VueApiUtil{
   static Map<Type, ComponentOptions> $options_cache = {};
   static Map<Type, VueApi> $instance_cache = {};
   //note: readonly properties           ;
   external HtmlElement  get $el;
   external dynamic      get $options;
   external List<VueApi> get $children;
   external VNode        get $vnode;
   external VueApi       get $parent;
   external VueApi       get $root;
   external dynamic      get $ref;
   external dynamic      get $slots;
   external dynamic      get $scopedSlots;
   external dynamic      get $ssrContext;
   external bool         get $isServer;
   external dynamic get $data;
   external dynamic get $props;
   external dynamic get $computed;
   external dynamic get $attrs;
   external dynamic get $listeners;
   external dynamic get $set;
   external dynamic get $delete;
   //note: methods                      ;
   external dynamic          $createElement(dynamic tag, [dynamic arg1, dynamic arg2]);
   external VueApi           $mount(dynamic elementOrSelector, bool hydrating);
   external void             $forceUpdate();
   external void             $destroy();
   external VueApi           $on   (dynamic event, Function callback);
   external VueApi           $off  (dynamic event, Function callback);
   external VueApi           $once (String event, Function callback);
   external VueApi           $emit (String event, [arg1, arg2, arg3, arg4, arg5, arg6]);
   external void Function()  $watch(dynamic expOrFn, void Function(dynamic n, dynamic o) callback,
                                    WatchOptions options);
   external dynamic          $nextTick([void callback(VueApi jsthis)]);
   
   

   void beforeCreate() {}
   void created() {}
   void beforeMount() {}
   void mounted() {}
   void beforeUpdate() {}
   void updated() {}
   void beforeDestroy() {}
   void destroyed() {}
   void activated(){}
   void deactivated(){}
   
}
//typedef TMethod = dynamic Function(VueApi self,[dynamic a, dynamic b, dynamic c, dynamic d, dynamic e ]);




class VueApiUtil {
   ComponentOptions $getVueOptions(type, fn()){
      var cache = VueApi.$instance_cache;
      if (cache[type] == null)
         cache[type] = fn();
      return cache[type].$toVueOptions(ivue: cache[type]);
   }
   ComponentOptions $toVueOptions({
       dynamic ivue, /*String name, Map<String, ComponentOptions> components,
       String el, Model model, List<String>delimiters, String template,
       computed, watch, props, data, methods, mixins, filters*/})
{
      if (VueApi.$options_cache[ivue] != null)
         return VueApi.$options_cache[ivue];
      var op = ivue.$dart_options;
      var render, renderError, transitions, activated, deactivated;

      if (ivue is ICustomRender){
         render      =  ivue.render ;
         renderError =  ivue.renderError;
      }
      if (ivue is ITransitions){
         transitions = Transitions(
            beforeLeave: ivue.beforeLeave, afterLeave: ivue.afterLeave,
            afterEnter: ivue.afterEnter, leaveCancelled: ivue.leaveCancelled,
            leave: ivue.leave, enterCancelled: ivue.enterCancelled,
            beforeEnter: ivue.beforeEnter, enter: ivue.enter,
         );
      }
      if (ivue is IKeepAlive){
         activated = ivue.activated;
         deactivated = ivue.deactivated;
      }

      var components = {};
      var mixins     = [];
      var filters    = {};
      ivue.$dart_options?.components?.entries?.forEach((entry){
         components[entry.key] = entry.value.$toVueOptions(
            ivue: $getVueOptions(entry.value, () => entry.value())
         );
      });
      ivue.$dart_filters?.filters?.entries?.forEach((entry){
         filters[entry.key] = entry.value.method_body;
      });
      ivue.$dart_options?.mixins?.forEach((m){
         mixins.add(m.$getVueOptions(() => m()));
      });

      var ret = ComponentOptions (
         // considered vue options setup in Component arguments ---------------
         name: op.name, components: convertToComponents(components),
         el: op.el, model: op.model, delimiters: op.delimiters, template: op.template,
   
         // vue options setup by VueDefinition classes -------------------------
         computed: ivue.$dart_computed, watch: ivue.$dart_watchers,
         props: ivue.$dart_props, data: ivue.$dart_data, methods: ivue.$dart_methods,
   
         // lifecycle hooks defined in components ------------------------------
         updated: ivue.updated, beforeCreate: ivue.beforeCreate,
         beforeDestory: ivue.beforeDestroy, beforeMount: ivue.beforeMount,
         beforeUpdate: ivue.beforeUpdate, mounted: ivue.mounted,
         created: ivue.created, destroyed: ivue.destroyed,
         activated: activated, deactivated: deactivated,
         mixins: mixins, filters: TFilters(filters), render: render,
         renderError: renderError, transitions: transitions
         // transitions hooks defines in MethodDefs ----------------------------
         // to be ignored ---------------------------------------------
         /*parent: parent, JS$extends: JS$extends, inheritAttrs: inheritAttrs,
            inject: inject, filters: filters, propsData: propsData,
             comments: comments, */
      );
      return VueApi.$options_cache[this.runtimeType] = ret;
   }
}



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
class ComponentOptions_origin extends JsObj{
   // note: properties             ;
   external String               get name;
   external dynamic              get data;
   external TProps                get props;
   external dynamic              get propsData;
   external TMethods              get methods;
   external TComputeds             get computed;
   external TWatchers                get watch;
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
   external List<ComponentOptions>     get mixins;
   
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
   external factory ComponentOptions_origin({
       String name, dynamic data, TProps props, dynamic propsData, TMethods methods,
       TComputeds computed, TWatchers watch, String el, String template,
       TComponents components, Transitions transitions, List<ComponentOptions> mixins,
       TFilters filters, Model model, VueApi parent, bool comments, bool inheritAttrs,
       List<String> delimiters, dynamic JS$extends, Map<String, dynamic> inject,
       VoidFunc beforeCreate, VoidFunc created, VoidFunc beforeDestory, VoidFunc destroyed,
       VoidFunc beforeMount, VoidFunc mounted, VoidFunc beforeUpdate, VoidFunc updated,
       VoidFunc activated, VoidFunc deactivated,
       VNode render(CreateElement cr, RenderContext hack),
       VNode renderError(VNode h(), Error err)
                                        //, TDirectives directives
    });
}



@anonymous
@JS()
class ComponentOptions extends JsObj{
   // note: properties             ;
   external String               get name;
   external Object              get data;
   external Object                get props;
   external dynamic              get propsData;
   external Object              get methods;
   external Object             get computed;
   external Object                get watch;
   external String               get el;
   external String               get template;
   external TComponents        get components;
   external Transitions       get transitions;
   external Object        get directives;
   external TFilters           get filters;
   external Model                      get model;
   external VueApi                     get parent;
   external bool                       get comments;
   external bool                       get inheritAttrs;
   external List<String>               get delimiters;
   external dynamic                    get JS$extends;
   external Map<String, dynamic>       get inject;
   external List<ComponentOptions>     get mixins;
   
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
       String name, Object data, Object props, Object propsData, Object methods,
       Object computed, Object watch, String el, String template,
       TComponents components, Transitions transitions, List<ComponentOptions> mixins,
       TFilters filters, Model model, VueApi parent, bool comments, bool inheritAttrs,
       List<String> delimiters, Object JS$extends, Map<String, dynamic> inject,
       VoidFunc beforeCreate, VoidFunc created, VoidFunc beforeDestory, VoidFunc destroyed,
       VoidFunc beforeMount, VoidFunc mounted, VoidFunc beforeUpdate, VoidFunc updated,
       VoidFunc activated, VoidFunc deactivated,
       VNode render(CreateElement cr, RenderContext hack),
       VNode renderError(VNode h(), Error err)
       //, TDirectives directives
      });
}





@JS()
@anonymous
class Mixin extends ComponentOptions {
   external factory Mixin({
        String name, dynamic data, TProps props, dynamic propsData, TMethods methods,
        TComputeds computed, TWatchers watch, String el, String template,
        TComponents components, Transitions transitions, TDirectives directives,
        TFilters filters, Model model, VueApi parent, bool comments, bool inheritAttrs,
        List<String> delimiters, dynamic JS$extends, Map<String, dynamic> inject,
        VoidFunc beforeCreate, VoidFunc created, VoidFunc beforeDestory, VoidFunc destroyed,
        VoidFunc beforeMount, VoidFunc mounted, VoidFunc beforeUpdate, VoidFunc updated,
        VoidFunc activated, VoidFunc deactivated
     });
}

TFilters convertToFilters(Map<String, FVueFilter> filters){
   return toJsMap(filters, true, TDynamic.FVueFilter);
}
TDirectives convertToDirectives(Map<String, DirectiveOptions> directives){
   return toJsMap(directives, true, TDynamic.DirectiveOptions);
}
TComponents convertToComponents(Map<String, ComponentOptions> components){
   return toJsMap(components, true, TDynamic.ComponentOptions);
}
TWatchers convertToWatchers(Map<String, dynamic> watches){
   return toJsMap(watches, true, TDynamic.WatchOptions);
}
dynamic convertToData(dynamic data){
   if (data is Map)
      return toJsMap(data, true, TDynamic.JsObj);
   if (data is Function)
      return JFunc(allowInteropCaptureThis(data));
   throw Exception('Invalid type, only typeof map and function are supported.');
}
TProps convertToProps(Map<String, dynamic> props){
   return toJsMap(props, true, TDynamic.JsObj);
}
TProp Prop(TProp prop){
   return prop;
}
TMethods convertToMethods(Map<String, dynamic> methods){
   return toJsMap(methods, true, TDynamic.JsObj);
}
TMethods convertToComputed(Map<String, dynamic> computed){
   return toJsMap(computed, true, TDynamic.JsObj);
}

ComponentOptions convertIVueToComponentOptions<E>(ivue){
   var _data = ivue.$dart_data;
   var _watchers = ivue.$dart_watchers;
   var _props = ivue.$dart_props;
   var _methods = ivue.$dart_methods;
   var _ons = ivue.$dart_ons;
   var _computed = ivue.$dart_computed;
   var _options = ivue.$dart_options;
   
   return ComponentOptions(
   
   );
}




/*

notice:       options  generator               ;
------------------------------------------------


*/
ComponentOptions_origin _genComponentOptions_orig({
        String name, TDatas data, TProps props, dynamic propsData, TMethods methods,
        TComputeds computed, TWatchers watch, String el, String template,
        TComponents components, Transitions transitions, TDirectives directives,
        TFilters filters, Model model, VueApi parent, bool comments, bool inheritAttrs,
        List<String> delimiters, dynamic JS$extends, Map<String, dynamic> inject,
        VoidFunc beforeCreate, VoidFunc created, VoidFunc beforeDestory, VoidFunc destroyed,
        VoidFunc beforeMount, VoidFunc mounted, VoidFunc beforeUpdate, VoidFunc updated,
        VoidFunc activated, VoidFunc deactivated
     }){
   return ComponentOptions_origin(name:name, data:data, props:props, propsData:propsData, methods:methods,
      computed:computed, watch:watch, el:el, template:template, components:components,
      transitions:transitions, filters:filters, model:model, parent:parent,
      comments:comments, inheritAttrs:inheritAttrs, delimiters: delimiters, JS$extends: JS$extends, inject: inject,
      beforeCreate: beforeCreate, created: created, beforeDestory: beforeDestory,destroyed: destroyed,
      beforeMount: beforeMount, mounted: mounted, beforeUpdate:beforeUpdate, updated: updated, activated: activated,
      deactivated: deactivated/* directives:directives,*/  );
}
ComponentOptions_origin genComponentOption_origs(Map<String, dynamic>map){
   return Function.apply(_genComponentOptions_orig, [], symbolizeKeys(map));
}



ComponentOptions _genComponentOptions({
     String name, Object data, Object props, dynamic propsData, Object methods,
     Object computed, Object watch, String el, String template,
     TComponents components, Transitions transitions, Object directives,
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


E toJSType<E>(E data){
   if (isNumber(data)){
      return data;
   }else if (data is String){
      return data;
   }else if (data is bool){
      return data;
   }else if (data is List){
      return data;
   }else if (data is Function){
      return allowInteropCaptureThis(data) as E;
   }else if (isSymbol(data)){
      return data;
   }else if (data is DateTime){
      var date_string = '${data.year} ${data.month} ${data.day} ${data.hour}:${data.minute}:${data.second}';
      return Date(Date.parse(date_string)) as E;
   }else if (data is Map){
      data.keys.forEach((key){
         data[key] = toJsMap(data[key]);
      });
      return data;
   }
   return data;
}



/*
*
*
*           Exceptions
*
*
*
* */



class ReadOnlyWatchCBException implements Exception {
   String propname;
   String onChangeName;
   ReadOnlyWatchCBException(this.propname, this.onChangeName);
   
   String toString() {
      var w = r'$watch';
      return '$onChangeName is readonly. To watch property $propname for change use vue api instead. \nEx $w("$propname", cb, option)';
   }
}

class ReadOnlyValidatorException implements Exception {
   String propname;
   String validatorName;
   ReadOnlyValidatorException(this.propname, this.validatorName);
   
   String toString() {
      var w = r'$watch';
      return '$validatorName is readonly. To set validator for property "$propname". \nEx $w("$propname", cb, option)';
   }
}

class ReadOnlyOptionsException implements Exception {
   String optname;
   ReadOnlyOptionsException(this.optname);
   
   String toString() {
      var w = r'$watch';
      return 'Option: $optname is readonly. Readonly options are class methods, to define a writable options use class fields instead.';
   }
}

class ReadOnlyMethodException implements Exception {
   String methodname;
   ReadOnlyMethodException(this.methodname);
   
   String toString() {
      var w = r'$watch';
      //todo:
      return 'Option: $methodname is readonly. To set method dynamically.';
   }
}




/*

   TYpe of Vue Property

String
Number
Boolean
Array
Object
Date
Function
Symbol

*/
bool isNumber(dynamic n){
   return n is int || n is num || n is double;
}
bool isString(dynamic n){
   return n is String;
}
bool isBoolean(dynamic n){
   return n is bool;
}
bool isArray(dynamic n){
   return n is List;
}
bool isFunction(dynamic n){
   return n is Function;
}
bool isDate(dynamic n){
   return n is DateTime;
}
bool isSymbol(dynamic n){
   return n is Symbol;
}

@JS('String')
class TJString {
   TJString(n);
}
@JS('Array')
class TJArray{
   TJArray(n);
}
@JS('Object')
class TJObject{
   TJObject(n);
}
@JS('Boolean')
class TJBoolean{
   TJBoolean(n);
}
@JS('Number')
class TJNumber{
   TJNumber(n);
}
@JS('Function')
class TJFunction{
   TJFunction(n);
}
@JS('Symbol')
class TJSymbol{
   TJSymbol(n);
}
@JS('Date')
class TJDate{
   TJDate(n);
}

abstract class ITransitions{
   void enter();
   void beforeEnter();
   void enterCancelled();
   void leave();
   void beforeLeave();
   void leaveCancelled();
   void afterEnter();
   void afterLeave();
}
abstract class ILifeCycleHooks{
   void beforeCreate();
   void created();
   void beforeMount();
   void mounted();
   void beforeUpdate();
   void update();
   void beforeDestroy();
   void destroyed();
   void activated();
   void deactivated();
}
abstract class ICustomRender{
   VNode render(CreateElement cr, RenderContext hack);
   VNode renderError(VNode Function() h, Error err);
}
abstract class IKeepAlive{
   /*
   When a component is toggled inside <keep-alive>, its activated and
   deactivated lifecycle hooks will be invoked accordingly.
   */
   void activated();
   void deactivated();
}

abstract class IPropDefs<E> {
   E self;
   String name;
   
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





