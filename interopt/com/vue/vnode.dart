/*
@JS("Vue")
library vnode;

import "package:js/js.dart";
import "dart:html" show Node;
import "vue.dart" show Vue;



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
class object{
   external static List<String> getOwnPropertyNames(TPrototypeClass obj);
   external static TDescriptor getOwnPropertyDescriptor(TPrototypeClass obj, String name);
   external static void defineProperty(dynamic obj, String name, TDescriptor opt);
}



/// Scoped slots can technically return anything if used from
/// a render function, but this is "good enough" for templates
typedef dynamic */
/*ScopedSlotArrayContents|VNode|String|dynamic*//*
 ScopedSlot(
    dynamic props); */
/*export type ScopedSlotChildren = ScopedSlotArrayContents | VNode | string | undefined;*//*


@anonymous
@JS()
abstract class ScopedSlotArrayContents
    implements
        List<dynamic */
/*ScopedSlotArrayContents|VNode|String|dynamic*//*
 > {}

/// Relaxed type compatible with $createElement
*/
/*export type VNodeChildren = VNodeChildrenArrayContents | [ScopedSlot] | string | boolean | null | undefined;*//*

@anonymous
@JS()
abstract class VNodeChildrenArrayContents
    implements
        List<
            dynamic */
/*VNodeChildrenArrayContents|Tuple of <ScopedSlot>|String|bool|Null|dynamic|VNode*//*
 > {
}


@anonymous
@JS()
abstract class VNode {
  external String get tag;
  external set tag(String v);
  external VNodeData get data;
  external set data(VNodeData v);
  external List<VNode> get children;
  external set children(List<VNode> v);
  external String get text;
  external set text(String v);
  external Node get elm;
  external set elm(Node v);
  external String get ns;
  external set ns(String v);
  external Vue get context;
  external set context(Vue v);
  external dynamic */
/*String|num*//*
 get key;
  external set key(dynamic */
/*String|num*//*
 v);
  external VNodeComponentOptions get componentOptions;
  external set componentOptions(VNodeComponentOptions v);
  external Vue get componentInstance;
  external set componentInstance(Vue v);
  external VNode get parent;
  external set parent(VNode v);
  external bool get raw;
  external set raw(bool v);
  external bool get isStatic;
  external set isStatic(bool v);
  external bool get isRootInsert;
  external set isRootInsert(bool v);
  external bool get isComment;
  external set isComment(bool v);
  external factory VNode(
      {String tag,
      VNodeData data,
      List<VNode> children,
      String text,
      Node elm,
      String ns,
      Vue context,
      dynamic */
/*String|num*//*
 key,
      VNodeComponentOptions componentOptions,
      Vue componentInstance,
      VNode parent,
      bool raw,
      bool isStatic,
      bool isRootInsert,
      bool isComment});
}

@anonymous
@JS()
abstract class VNodeComponentOptions {
  external dynamic get Ctor;
  external set Ctor(dynamic v);
  external object get propsData;
  external set propsData(object v);
  external object get listeners;
  external set listeners(object v);
  external List<VNode> get children;
  external set children(List<VNode> v);
  external String get tag;
  external set tag(String v);
  external factory VNodeComponentOptions(
      {dynamic Ctor,
      object propsData,
      object listeners,
      List<VNode> children,
      String tag});
}

@anonymous
@JS()
abstract class VNodeData {
  external dynamic */
/*String|num*//*
 get key;
  external set key(dynamic */
/*String|num*//*
 v);
  external String get slot;
  external set slot(String v);
  external dynamic */
/*JSMap of <String,ScopedSlot|dynamic>*//*
 get scopedSlots;
  external set scopedSlots(dynamic */
/*JSMap of <String,ScopedSlot|dynamic>*//*
 v);
  external String get ref;
  external set ref(String v);
  external bool get refInFor;
  external set refInFor(bool v);
  external String get tag;
  external set tag(String v);
  external String get staticClass;
  external set staticClass(String v);
  external dynamic get JS$class;
  external set JS$class(dynamic v);
  external dynamic */
/*JSMap of <String,dynamic>*//*
 get staticStyle;
  external set staticStyle(dynamic */
/*JSMap of <String,dynamic>*//*
 v);
  external dynamic */
/*List<object>|object*//*
 get style;
  external set style(dynamic */
/*List<object>|object*//*
 v);
  external dynamic */
/*JSMap of <String,dynamic>*//*
 get props;
  external set props(dynamic */
/*JSMap of <String,dynamic>*//*
 v);
  external dynamic */
/*JSMap of <String,dynamic>*//*
 get attrs;
  external set attrs(dynamic */
/*JSMap of <String,dynamic>*//*
 v);
  external dynamic */
/*JSMap of <String,dynamic>*//*
 get domProps;
  external set domProps(dynamic */
/*JSMap of <String,dynamic>*//*
 v);
  external dynamic */
/*JSMap of <String,Function>*//*
 get hook;
  external set hook(dynamic */
/*JSMap of <String,Function>*//*
 v);
  external dynamic */
/*JSMap of <String,Function|List<Function>>*//*
 get on;
  external set on(dynamic */
/*JSMap of <String,Function|List<Function>>*//*
 v);
  external dynamic */
/*JSMap of <String,Function|List<Function>>*//*
 get nativeOn;
  external set nativeOn(
      dynamic */
/*JSMap of <String,Function|List<Function>>*//*
 v);
  external object get transition;
  external set transition(object v);
  external bool get show;
  external set show(bool v);
  external dynamic
      */
/*{
    render: Function;
    staticRenderFns: Function[];
  }*//*

      get inlineTemplate;
  external set inlineTemplate(
      dynamic */
/*{
    render: Function;
    staticRenderFns: Function[];
  }*//*

      v);
  external List<VNodeDirective> get directives;
  external set directives(List<VNodeDirective> v);
  external bool get keepAlive;
  external set keepAlive(bool v);
  external factory VNodeData(
      {dynamic */
/*String|num*//*
 key,
      String slot,
      dynamic */
/*JSMap of <String,ScopedSlot|dynamic>*//*
 scopedSlots,
      String ref,
      bool refInFor,
      String tag,
      String staticClass,
      dynamic JS$class,
      dynamic */
/*JSMap of <String,dynamic>*//*
 staticStyle,
      dynamic */
/*List<object>|object*//*
 style,
      dynamic */
/*JSMap of <String,dynamic>*//*
 props,
      dynamic */
/*JSMap of <String,dynamic>*//*
 attrs,
      dynamic */
/*JSMap of <String,dynamic>*//*
 domProps,
      dynamic */
/*JSMap of <String,Function>*//*
 hook,
      dynamic */
/*JSMap of <String,Function|List<Function>>*//*
 on,
      dynamic */
/*JSMap of <String,Function|List<Function>>*//*
 nativeOn,
      object transition,
      bool show,
      dynamic */
/*{
    render: Function;
    staticRenderFns: Function[];
  }*//*

      inlineTemplate,
      List<VNodeDirective> directives,
      bool keepAlive});
}

@anonymous
@JS()
abstract class VNodeDirective {
  external String get name;
  external set name(String v);
  external dynamic get value;
  external set value(dynamic v);
  external dynamic get oldValue;
  external set oldValue(dynamic v);
  external dynamic get expression;
  external set expression(dynamic v);
  external String get arg;
  external set arg(String v);
  external dynamic */
/*JSMap of <String,bool>*//*
 get modifiers;
  external set modifiers(dynamic */
/*JSMap of <String,bool>*//*
 v);
  external factory VNodeDirective(
      {String name,
      dynamic value,
      dynamic oldValue,
      dynamic expression,
      String arg,
      dynamic */
/*JSMap of <String,bool>*//*
 modifiers});
}
*/
