/*
@JS("Vue")
library vue;

import "package:js/js.dart";
import "vnode.dart" show VNode, VNodeData, ScopedSlot;
import "package:func2/func.dart";
import "options.dart"
    show
        Component,
        AsyncComponent,
        ComponentOptions,
        WatchOptions,
        FunctionalComponentOptions,
        RecordPropsDefinition,
        DirectiveOptions,
        DirectiveFunction;
import "dart:html" show Element;
import "plugin.dart" show PluginObject, PluginFunction;

@anonymous
@JS()
abstract class CreateElement {
  */
/*external VNode call([String|Component<dynamic,dynamic,dynamic,dynamic>|AsyncComponent<dynamic,dynamic,dynamic,dynamic>|Func0<Component> tag, VNodeChildrenArrayContents|Tuple of <ScopedSlot>|String|bool|Null|dynamic children]);*//*

  */
/*external VNode call([String|Component<dynamic,dynamic,dynamic,dynamic>|AsyncComponent<dynamic,dynamic,dynamic,dynamic>|Func0<Component> tag, VNodeData data, VNodeChildrenArrayContents|Tuple of <ScopedSlot>|String|bool|Null|dynamic children]);*//*

  external VNode call(
      [dynamic */
/*String|Func0<Component>*//*
 tag,
      dynamic */
/*VNodeChildrenArrayContents|Tuple of <ScopedSlot>|String|bool|dynamic|VNodeData*//*
 children_data,
      dynamic */
/*VNodeChildrenArrayContents|Tuple of <ScopedSlot>|String|bool|dynamic*//*
 children]);
}

@JS("Vue")
abstract class Vue {
  external Element get $el;
  external set $el(Element v);
  external ComponentOptions<Vue> get $options;
  external set $options(ComponentOptions<Vue> v);
  external Vue get $parent;
  external set $parent(Vue v);
  external Vue get $root;
  external set $root(Vue v);
  external List<Vue> get $children;
  external set $children(List<Vue> v);
  external dynamic */
/*JSMap of <String,Vue|Element|List<Vue>|List<Element>>*//*
 get $refs;
  external set $refs(
      dynamic */
/*JSMap of <String,Vue|Element|List<Vue>|List<Element>>*//*
 v);
  external dynamic */
/*JSMap of <String,List<VNode>|dynamic>*//*
 get $slots;
  external set $slots(dynamic */
/*JSMap of <String,List<VNode>|dynamic>*//*
 v);
  external dynamic */
/*JSMap of <String,ScopedSlot|dynamic>*//*
 get $scopedSlots;
  external set $scopedSlots(dynamic */
/*JSMap of <String,ScopedSlot|dynamic>*//*
 v);
  external bool get $isServer;
  external set $isServer(bool v);
  external Record<String, dynamic> get $data;
  external set $data(Record<String, dynamic> v);
  external Record<String, dynamic> get $props;
  external set $props(Record<String, dynamic> v);
  external dynamic get $ssrContext;
  external set $ssrContext(dynamic v);
  external VNode get $vnode;
  external set $vnode(VNode v);
  external Record<String, String> get $attrs;
  external set $attrs(Record<String, String> v);
  external Record<String, dynamic */
/*Function|List<Function>*//*
 > get $listeners;
  external set $listeners(
      Record<String, dynamic */
/*Function|List<Function>*//*
 > v);
  external Vue $mount(
      [dynamic */
/*Element|String*//*
 elementOrSelector, bool hydrating]);
  external void $forceUpdate();
  external void $destroy();
  external dynamic get $set;
  external set $set(dynamic v);
  external dynamic get $delete;
  external set $delete(dynamic v);
  */
/*external VoidFunc0 $watch(
    String expOrFn, void callback(Vue JS$this, dynamic n, dynamic o),
    [WatchOptions options]);*//*

  */
/*external VoidFunc0 $watch<T>(T expOrFn(Vue JS$this), void callback(Vue JS$this, T n, T o), [WatchOptions options]);*//*

  external VoidFunc0 $watch*/
/*<T>*//*
(
      dynamic */
/*String|Func0<T>*//*
 expOrFn,
      VoidFunc2<dynamic,
          dynamic> */
/*VoidFunc2<dynamic, dynamic>|VoidFunc2<T, T>*//*
 callback,
      [WatchOptions options]);
  external Vue $on(dynamic */
/*String|List<String>*//*
 event, Function callback);
  external Vue $once(dynamic */
/*String|List<String>*//*
 event, Function callback);
  external Vue $off([dynamic */
/*String|List<String>*//*
 event, Function callback]);
  external Vue $emit(String event,
      [dynamic args1,
      dynamic args2,
      dynamic args3,
      dynamic args4,
      dynamic args5]);
  */
/*external void $nextTick(void callback(Vue JS$this));*//*

  */
/*external Promise<Null> $nextTick();*//*

  external dynamic */
/*Null|Promise<Null>*//*
 $nextTick(
      [void callback(*/
/*Vue this*//*
)]);
  external CreateElement get $createElement;
  external set $createElement(CreateElement v);
}

*/
/*export type CombinedVueInstance<Instance extends Vue, Data, Methods, Computed, Props> =  Data & Methods & Computed & Props & Instance;*//*

*/
/*export type ExtendedVue<Instance extends Vue, Data, Methods, Computed, Props> = VueConstructor<CombinedVueInstance<Instance, Data, Methods, Computed, Props> & Vue>;*//*

@anonymous
@JS()
abstract class VueConfiguration {
  external bool get silent;
  external set silent(bool v);
  external dynamic get optionMergeStrategies;
  external set optionMergeStrategies(dynamic v);
  external bool get devtools;
  external set devtools(bool v);
  external bool get productionTip;
  external set productionTip(bool v);
  external bool get performance;
  external set performance(bool v);
  external void errorHandler(Error err, Vue vm, String info);
  external void warnHandler(String msg, Vue vm, String trace);
  external List<dynamic */
/*String|RegExp*//*
 > get ignoredElements;
  external set ignoredElements(List<dynamic */
/*String|RegExp*//*
 > v);
  external dynamic */
/*JSMap of <String,num|List<num>>*//*
 get keyCodes;
  external set keyCodes(dynamic */
/*JSMap of <String,num|List<num>>*//*
 v);
  external bool get JS$async;
  external set JS$async(bool v);
}

@JS("Vue")
abstract class VueConstructor<V extends Vue, Vue> {
  */
/*external factory VueConstructor([object&ComponentOptions<V,DataDef<Data,Record<PropNames,dynamic>,V>,Methods,Computed,List<PropNames>,Record<PropNames,dynamic>>&ThisType<Data&Methods&Computed&Readonly<Record<PropNames,dynamic>>&V> options]);*//*

  /// ideally, the return type should just contain Props, not Record<keyof Props, any>. But TS requires to have Base constructors with the same return type.
  */
/*external factory VueConstructor([object&ComponentOptions<V,DataDef<Data,Props,V>,Methods,Computed,RecordPropsDefinition<Props>,Props>&ThisType<Data&Methods&Computed&Readonly<Props>&V> options]);*//*

  */
/*external factory VueConstructor([ComponentOptions<V> options]);*//*

  external factory VueConstructor(
      [dynamic */
/*object|ComponentOptions<V>*//*
 options]);
  */
/*external VueConstructor<Data&Methods&Computed&Props&Instance&Vue> extend<Data, Methods, Computed, PropNames extends String, never>([object&ComponentOptions<V,DataDef<Data,Record<PropNames,dynamic>,V>,Methods,Computed,List<PropNames>,Record<PropNames,dynamic>>&ThisType<Data&Methods&Computed&Readonly<Record<PropNames,dynamic>>&V> options]);*//*

  */
/*external VueConstructor<Data&Methods&Computed&Props&Instance&Vue> extend<Data, Methods, Computed, Props>([object&ComponentOptions<V,DataDef<Data,Props,V>,Methods,Computed,RecordPropsDefinition<Props>,Props>&ThisType<Data&Methods&Computed&Readonly<Props>&V> options]);*//*

  */
/*external VueConstructor<Data&Methods&Computed&Props&Instance&Vue> extend<PropNames extends String, never>(FunctionalComponentOptions<Record<PropNames,dynamic>,List<PropNames>> definition);*//*

  */
/*external VueConstructor<Data&Methods&Computed&Props&Instance&Vue> extend<Props>(FunctionalComponentOptions<Props,RecordPropsDefinition<Props>> definition);*//*

  */
/*external VueConstructor<Data&Methods&Computed&Props&Instance&Vue> extend([ComponentOptions<V> options]);*//*

  external VueConstructor<Data */
/*Data&Methods&Computed&Props&Instance&Vue*//*
 > extend*/
/*<Data, Methods, Computed, PropNames extends String, never, Props>*//*
(
      [dynamic */
/*object|FunctionalComponentOptions<Record<PropNames,dynamic>,List<PropNames>>|FunctionalComponentOptions<Props,RecordPropsDefinition<Props>>|ComponentOptions<V>*//*
 options_definition]);
  */
/*external void nextTick(void callback(), [List<dynamic> context]);*//*

  */
/*external Promise<Null> nextTick();*//*

  external dynamic */
/*Null|Promise<Null>*//*
 nextTick(
      [void callback(), List<dynamic> context]);
  */
/*external T JS$set<T>(object object, String|num key, T value);*//*

  */
/*external T JS$set<T>(List<T> array, num key, T value);*//*

  external dynamic*/
/*=T*//*
 JS$set*/
/*<T>*//*
(dynamic */
/*object|List<T>*//*
 object_array,
      dynamic */
/*String|num*//*
 key, dynamic*/
/*=T*//*
 value);
  */
/*external void delete(object object, String|num key);*//*

  */
/*external void delete<T>(List<T> array, num key);*//*

  external void delete*/
/*<T>*//*
(
      dynamic */
/*object|List<T>*//*
 object_array, dynamic */
/*String|num*//*
 key);
  external DirectiveOptions directive(String id,
      [DirectiveOptions */
/*DirectiveOptions|DirectiveFunction*//*
 definition]);
  external Function filter(String id, [Function definition]);
  */
/*external VueConstructor component(String id);*//*

  */
/*external VC component<VC extends VueConstructor>(String id, VC constructor);*//*

  */
/*external VueConstructor<Data&Methods&Computed&Props&Instance&Vue> component<Data, Methods, Computed, Props>(String id, AsyncComponent<Data,Methods,Computed,Props> definition);*//*

  */
/*external VueConstructor<Data&Methods&Computed&Props&Instance&Vue> component<Data, Methods, Computed, PropNames extends String, never>(String id, [object&ComponentOptions<V,DataDef<Data,Record<PropNames,dynamic>,V>,Methods,Computed,List<PropNames>,Record<PropNames,dynamic>>&ThisType<Data&Methods&Computed&Readonly<Record<PropNames,dynamic>>&V> definition]);*//*

  */
/*external VueConstructor<Data&Methods&Computed&Props&Instance&Vue> component<Data, Methods, Computed, Props>(String id, [object&ComponentOptions<V,DataDef<Data,Props,V>,Methods,Computed,RecordPropsDefinition<Props>,Props>&ThisType<Data&Methods&Computed&Readonly<Props>&V> definition]);*//*

  */
/*external VueConstructor<Data&Methods&Computed&Props&Instance&Vue> component<PropNames extends String>(String id, FunctionalComponentOptions<Record<PropNames,dynamic>,List<PropNames>> definition);*//*

  */
/*external VueConstructor<Data&Methods&Computed&Props&Instance&Vue> component<Props>(String id, FunctionalComponentOptions<Props,RecordPropsDefinition<Props>> definition);*//*

  */
/*external VueConstructor<Data&Methods&Computed&Props&Instance&Vue> component(String id, [ComponentOptions<V> definition]);*//*

  external dynamic */
/*VueConstructor|VC|VueConstructor<Data&Methods&Computed&Props&Instance&Vue>*//*
 component*/
/*<VC extends VueConstructor, Data, Methods, Computed, Props, PropNames extends String, never>*//*
(
      String id,
      [dynamic */
/*VC|object|FunctionalComponentOptions<Record<PropNames,dynamic>,List<PropNames>>|FunctionalComponentOptions<Props,RecordPropsDefinition<Props>>|ComponentOptions<V>*//*
 constructor_definition]);
  */
/*external VueConstructor<V> use<T>(PluginObject<T>|PluginFunction<T> plugin, [T options]);*//*

  */
/*external VueConstructor<V> use(PluginObject<dynamic>|PluginFunction<dynamic> plugin, [dynamic options1, dynamic options2, dynamic options3, dynamic options4, dynamic options5]);*//*

  external VueConstructor<V> use*/
/*<T>*//*
(
      PluginObject<dynamic> */
/*PluginObject<T>|PluginObject<dynamic>*//*
 plugin,
      [dynamic */
/*T|List<dynamic>*//*
 options]);
  external VueConstructor<V> mixin(
      dynamic */
/*VueConstructor|ComponentOptions<Vue>*//*
 mixin);
  external dynamic
      */
/*{
    render(createElement: typeof Vue.prototype.$createElement): VNode;
    staticRenderFns: (() => VNode)[];
  }*//*

      compile(String template);
  external VueConfiguration get config;
  external set config(VueConfiguration v);
}

@JS()
external VueConstructor get Vue;
*/
