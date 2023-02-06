import 'package:astMacro/src/interop.vuejs.dart' as Vue;
import 'package:js/js.dart';
import 'assets.vue_sample.vue.dart';


@anonymous
@JS()
class _Data extends Vue.Object  {
   String noValue, noValue2;
   int    sum     = 0;
   int    x       = 1927;
   String hello   = 'Curtis';
   external _Data();
   static _Data init(DataDefs source){
      var ret     = _Data();
      ret.noValue =  Vue.TData.init<String>(source.noValue);
      ret.noValue2= Vue.TData.init<String>(source.noValue2);
      ret.sum     = Vue.TData.init<int>(source.sum);
      ret.x       = Vue.TData.init<int>(source.x);
      ret.hello   = Vue.TData.init<String>(source.hello);
      return ret;
   }
}

@anonymous
@JS()
class _Watchers extends Vue.Object {
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
}


@anonymous
@JS()
class _Props extends Vue.Object {
   Vue.TProp<String> Color;
   Vue.TProp<num> Num;
   external _Props();
   static _Props init(PropertyDefs source) {
      var ret = _Props();
      ret.Color = Vue.TProp.init<String>(false, source.Color, source.onColorValidated);
      ret.Num = Vue.TProp.init<num>(true, source.Num, source.onNumValidated);
      return ret;
   }
}

@anonymous
@JS()
class _Methods extends Vue.Object {
   Function show;
   Function callThis  ;
   external _Methods();
   static   _Methods init(MethodDefs source){
      var ret = _Methods();
      ret.show     = Vue.TMethod.init(source.show);
      ret.callThis = Vue.TMethod.init(source.callThis);
      return ret;
   }
}

@anonymous
@JS()
class _Filters extends Vue.Object {
   Function capitalize ;
   external _Filters();
   static   _Filters init(FilterDefs source){
      var ret = _Filters();
      ret.capitalize = Vue.TFilter.init(source.capitalize);
      return ret;
   }
}

@anonymous
@JS()
class _Options extends Vue.Object {
   //initialize in constructor of vue component not here...
   Map<String, dynamic> components;
   List<dynamic>        mixins;
   Vue.Model               model       = Vue.Model('prop', 'event');
   List<String>            delimiters  = ['{{', '}}'];
   String el         = '#app';
   String template   = './assets.vue_templateA.vue';
   String name       = 'OriginalA';
   external _Options();
   static _Options init(OptionDefs source){
      var ret = _Options();
      
   }
}

@anonymous
@JS()
class _Computeds extends Vue.Object{
   Vue.TComputed<String> address     ;
   Vue.TComputed<String> writableText;
   external _Computeds();
   static _Computeds init(ComputedDefs source){
      var ret          = _Computeds();
      ret.address      = Vue.TComputed.init<String>(source.get_address, null);
      ret.writableText = Vue.TComputed.init<String>(source.get_writableText, source.set_writableText);
      return ret;
   }
}

@anonymous
@JS()
class _Ons extends Vue.Object {
   Vue.TOn onClick;
   external _Ons();
   static _Ons init(OnEventDefs source){
      var ret = _Ons();
      ret.onClick = Vue.TOn.init('event_name', source.onClick);
      return ret;
   }
}

@anonymous
@JS()
class _Onces extends Vue.Object {
   Vue.TOnce onLoad;
   Vue.TOnce onBeforeCreate;
   external _Onces();
   static _Onces init(OnceEventDefs source){
      var ret = _Onces();
      ret.onLoad = Vue.TOnce.init('event_name', source.onLoad);
      ret.onBeforeCreate = Vue.TOnce.init('event_name', source.onBeforeCreate);
      return ret;
   }
}

/*



              following interface definitions generated from its
              subclasses




--------------------------------------------------------------------------------
*/

abstract class IDataDefs<E>{
   E self;
}
abstract class IPropDefs<E> {
   E self;
}
abstract class IWatcherDefs<E> {
   E self;
}
abstract class IComputedDefs<E>{
   E self;
}
abstract class IOptionDefs<E> {
   E self;
}
abstract class IMethodDefs<E>{
   E self;
}
abstract class IOnEventDefs<E>{
   E self;
}
abstract class IOnceEventDefs<E>{
   E self;
}
abstract class IFilterDefs<E>{
   E self;
}
abstract class ITransitions extends Vue.ITransitions{
}
abstract class ILifeCycleHooks extends Vue.ILifeCycleHooks{
}





class IVue extends Vue.VueApi {
   /*_Provide   $dart_provide ;
   _Inject    $dart_inject  ;*/
   _Data      $dart_data    ;
   _Watchers  $dart_watchers;
   _Props     $dart_props   ;
   _Methods   $dart_methods ;
   _Ons       $dart_ons     ;
   _Onces     $dart_onces   ;
   _Computeds $dart_computed;
   _Options   $dart_options ;
   _Filters   $dart_filters;
   
   IVue() {
      $dart_data     = _Data.init(DataDefs());
      $dart_watchers = _Watchers.init(WatcherDefs());
      $dart_props = _Props.init(PropertyDefs());
      $dart_methods = _Methods.init(MethodDefs());
      $dart_filters = _Filters.init(FilterDefs());
      $dart_computed =  _Computeds.init(ComputedDefs());
      $dart_ons =  _Ons.init(OnEventDefs());
      $dart_onces =  _Onces.init(OnceEventDefs());
      $dart_options =  _Options();
   }
   
   /*static Vue.ComponentOptions $getVueOptions(IVue fn()){
      var cache = Vue.VueApi.$instance_cache;
      if (cache[IVue] == null)
         cache[IVue] = fn();
      return cache[IVue].$toVueOptions(ivue: cache[IVue]);
   }*/
   
   /*
                  B:Data
                  render Vue data into getter and setter
                  
      
   */
   String get hello {
      return $dart_data.hello;
   }

   void set hello(String v) {
      $dart_data.hello = v;
   }

   String get noValue {
      return $dart_data.noValue;
   }

   void set noValue(String v) {
      $dart_data.noValue = v;
   }

   String get noValue2 {
      return $dart_data.noValue2;
   }

   void set noValue2(String v) {
      $dart_data.noValue2 = v;
   }

   int get sum {
      return $dart_data.sum;
   }

   void set sum(int v) {
      $dart_data.sum = v;
   }

   int get x {
      return $dart_data.x;
   }

   void set x(int v) {
      $dart_data.x = v;
   }

   /*
         B:Prop
         render Vue prop into getter and setter
         
         prop better be readOnly, since it's not recommend to access
         property within vue component;
   */
   String get Color {
      return Vue.jsGet($props, 'Color');
   }

   int get Num {
      return Vue.jsGet($props, 'Num');
   }
   
   /*
            B:Computed
            render Vue computed into getter and setter
                  
   */

   String get address {
      return $dart_computed.address.get();
   }

   String get writableText {
      return $dart_computed.writableText.get();
   }

   void set writableText(String v) {
      $dart_computed.writableText.set(v);
   }

   /*
   
   
         B:Options
         render Vue options into getter and setter
                  
      
   */
   String get el {
      return $dart_options.el;
   }
   Vue.Model get $model {
      return $dart_options.model;
   }
   List get $delimiters{
      return $dart_options.delimiters;
   }
   /*
   
   
         B:Methods
         render Vue methods into getter and setter
                  
      
   */
   void Function() get callThis {
      return $dart_methods.callThis;
   }
   void Function() get show {
      return $dart_methods.show;
   }
   

   /*
   
     
            B:On, Once
            
            
      
   */
   String Function(dynamic) get onClick {
      return $dart_ons.onClick.cb;
   }

   String Function(dynamic) get onLoad {
      return $dart_onces.onLoad.cb;
   }

   String Function(dynamic) get onBeforeCreate {
      return $dart_onces.onBeforeCreate.cb;
   }
   
   /*
   
   
                              life cycle hooks
            
            
            
   */
   
}








