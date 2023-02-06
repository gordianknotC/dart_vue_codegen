/*
import 'package:astMacro/src/interop.vue.dart' as Vue;
import 'package:js/js.dart';


@anonymous
@JS()
class _Data  {
   int    sum     = 0;
   int    x       = 1927;
   String hello   = 'Curtis';
}

@anonymous
@JS()
class _Watch<E>{
   String prop_name;
   Function(E newval, E oldval) onChange;
   _Watch(this.prop_name, this.onChange);
}

@anonymous
@JS()
class _Watchers  {
   _Watch   sum;
   _Watch   x;
   _Watch   hello;
   dynamic  self;
   _Watchers({this.self, this.sum, this.x, this.hello});
}


@anonymous
@JS()
class _Prop<E> {
   bool required;
   E defaults;
   bool Function(E val) validator;
   _Prop({this.required, this.defaults, this.validator});
}

@anonymous
@JS()
class _Props {
   _Prop Color;
   _Prop Num  ;
   _Props({this.Color, this.Num});
}

@anonymous
@JS()
class _Methods {
   void Function() show;
   void Function() callThis  ;
   _Methods({this.show, this.callThis}); //todo: read definition from class methods
}

@anonymous
@JS()
class _Tuple {
   String key;
   dynamic value;
   _Tuple(this.key, this.value);
}

@anonymous
@JS()
class _Options {
   List<_Tuple> components;
   String el;
   String template;
   String CompName;
   Function printInfo;
   _Options({this.components, this.el, this.template, this.CompName, this.printInfo});
}

@anonymous
@JS()
class _Provide {
   Function getMap;
   _Provide({this.getMap});
}

@anonymous
@JS()
class _Inject {
   Function parentGetMap  ;
   _Inject({this.parentGetMap});
}

@anonymous
@JS()
class _On {
   String event_name;
   void Function (dynamic e) cb;
   _On({this.event_name, this.cb});
}

@anonymous
@JS()
class _Once  {
   String event_name;
   void Function (dynamic e) cb;
   _Once({this.event_name, this.cb});
}

@anonymous
@JS()
class _Ons {
   _On click;
   _Ons({this.click});
}

@anonymous
@JS()
class _Onces {
   _Once onLoad;
   _Onces({this.onLoad});
}

@anonymous
@JS()
class _Computed<E>{
   E Function() get;
   void Function(E v) set;
   _Computed({this.get, this.set});
}

@anonymous
@JS()
class _Computeds {
   _Computed<String> address;
   _Computed<String> writableText  ;
   _Computeds({this.address, this.writableText});
}


*/
/*



                 following interfaces generated from IVue




--------------------------------------------------------------------------------
*//*

abstract class IDataDefs<E>{
   String hello = 'Curtis';
   String noValue;
   String noValue2;
   int    _p1 = 12;
   int    sum = 0;
   int    x = 1927;
}

abstract class IPropDefs<E> {
   E      self;
   String Color = 'RED';
   num    Num   = 24;
   bool   Color_required = false;
   bool   Num_required   = true;
   
   bool onColorValidated();
   bool onNumValidated();
}

abstract class IWatcherDefs<E> {
   E      self;
   int    x;
   int    sum;
   String hello;
   
   void onSumChanged    (int newval, int oldval);
   void onXChanged      (int newval, int oldval);
   void onHelloChanged  (String newval, String oldval);
}

abstract class IComputedDefs<E>{
   E self;
   String get_address();
   String get_writableText();
   void   set_writableText(String v);
}



abstract class IVue {
   _Data      $dart_data    ;
   _Watchers  $dart_watchers;
   _Props     $dart_props   ;
   _Methods   $dart_methods ;
   _Ons       $dart_ons     ;
   _Onces     $dart_onces   ;
   _Computeds $dart_computed;
   _Provide   $dart_provide ;
   _Inject    $dart_inject  ;
   _Options   $dart_options ;
   
   IVue.init(){
      $dart_data     = _Data();
      $dart_watchers = _Watchers(
         self  : this,
         sum   : _Watch<int>   ('sum', this.onSumChanged),
         hello : _Watch<String>('hello', this.onHelloChanged),
         x     : _Watch<int>   ('x', this.on_x_changed)
      );
      $dart_props = _Props(
         Color : _Prop(required: true, defaults: 'RED', validator: onColorValidated),
         Num   : _Prop(required: false, defaults: 24, validator: onNumValidated)
      );
      $dart_methods = _Methods(
         show     : show,
         callThis : callThis
      );
      $dart_options = _Options(
         components: [_Tuple('list', Vue.Vue)] ,
         el        : '#app',
         template  : './index.vue',
         CompName  : null,
         printInfo : printInfo,
      );
      $dart_computed = _Computeds(
         address      : _Computed(get: _$dart_get_address),
         writableText : _Computed(get: _$dart_get_writableText, set: _$dart_set_writableText),
      );
      $dart_ons = _Ons(
        click: _On(event_name: 'click', cb: click)
      );
      $dart_onces = _Onces(
         onLoad: _Once(event_name: 'load', cb: onLoad)
      );
      $dart_provide  = _Provide(getMap: getMap);
      $dart_inject   = _Inject(parentGetMap: parentGetMap);
   }

   void onSumChanged   (int newval    , int oldval);
   void onHelloChanged (String newval , String oldval);
   void on_x_changed   (int newval    , int oldval);
   
   bool onColorValidated (String v);
   bool onNumValidated   (int v);
   
   void show();
   void callThis();
   
   void printInfo();

   String _$dart_get_address();              // temp var, need to be assigned from computed getter
   String _$dart_get_writableText();         // temp var, need to be assigned from computed getter
   void   _$dart_set_writableText(String v); // temp var, need to be assigned from computed setter
   String get address;
   String get writableText;
   void   set writableText(String v);
   
   
   void click(dynamic e);
   void onLoad(dynamic e);
   
   String Function() parentGetMap;
   String getMap();
   
   */
/*
   
   
                              life cycle hooks
            
            
   -----------------------------------------------------------------------------
   *//*

   void beforeCreate() {
   }
   
   void created() {
   }
   
   void beforeMount() {
   }
   
   void mounted() {
   }
   
   void beforeUpdate() {
   }
   
   void update() {
   }
   
   void beforeDestroy() {
   }
   
   void destroyed() {
   }
}


class Mixin {
   final Type data;
   final Type computed;
   final Type prop;
   final Type watch;
   
   const Mixin({this.data, this.computed, this.prop, this.watch});
}













*/
