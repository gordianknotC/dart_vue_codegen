import 'package:astMacro/src/interop.vue.dart' as Vue;
import 'package:js/js.dart';
import 'assets.vue_sample_clsVer.dart';


@anonymous
@JS()
class _Data  {
   String noValue, noValue2;
   int    sum     = 0;
   int    x       = 1927;
   String hello   = 'Curtis';
   int _p1 = 12; //private
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


/*



                 following interface definitions generated from its
                 subclasses




--------------------------------------------------------------------------------
*/
abstract class IDataDefs<E>{
   String hello  ;
   String noValue;
   String noValue2;
   int    _p1    ;
   int    sum    ;
   int    x      ;
}
abstract class IPropDefs<E> {
   E    self;
   bool Color_required = false;
   bool Num_required   = false;
   bool onColorValidated(String v);
   bool onNumValidated(num v);
   
}
abstract class IWatcherDefs<E> {
   E    self;
   void onSumChanged    (int newval, int oldval);
   void onXChanged      (int newval, int oldval);
   void onHelloChanged  (String newval, String oldval);
}
abstract class IComputedDefs<E>{
   E self;
   bool x_deep        = false;
   bool x_immediate   = false;
   bool sum_deep      = false;
   bool sum_immediate = false;
   bool hello_deep      = false;
   bool hello_immediate = false;
   String get_address();
   String get_writableText();
   void   set_writableText(String v);
}
abstract class IOptionDefs<E> {
   E self;
   List<List> components = [['test', Vue.Vue]];
   String el = '#app';
   String template = null;
   void printInfo();
}
abstract class IMethodDefs<E>{
   E self;
   void show();
   void callThis();
}

abstract class IOnEventDefs<E>{
   E self;
}
abstract class IOnceEventDefs<E>{
   E self;
}






abstract class IVue with Vue.VueApi {
   DataDefs          $dart_data    ;
   WatcherDefs       $dart_watchers;
   PropertyDefs      $dart_props   ;
   OnEventDefs       $dart_ons     ;
   OnceEventDefs     $dart_onces   ;
   ComputedDefs      $dart_computed;
   OptionDefs        $dart_options ;
   
   _Provide     $dart_provide ;
   _Inject      $dart_inject  ;
   MethodDefs   $dart_methods ;
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
                  
      
   */
   String get Color {
      return $dart_props.Color;
   }

   void set Color(String v) {
      $dart_props.Color = v;
   }

   num get Num {
      return $dart_props.Num;
   }

   void set Num(num v) {
      $dart_props.Num = v;
   }

   bool Function(String v) get onColorValidated {
      return $dart_props.onColorValidated;
   }

   void set onColorValidated(Function v) {
      throw Vue.ReadOnlyValidatorException('Color', 'onColorValidated');
   }

   bool Function(String v) get onNumValidated {
      return $dart_props.onColorValidated;
   }

   void set onNumValidated(Function v) {
      throw Vue.ReadOnlyValidatorException('Num', 'onNumValidated');
   }

   
   
   /*
                  B:Computed
                  render Vue computed into getter and setter
                  
      todo:
      warning for naming conflict while rendering getter and setter
   */

   String get address {
      return $dart_computed.get_address();
   }

   void set address(String v) {
      throw Exception('address is not writable');
   }

   String get writableText {
      return $dart_computed.get_writableText();
   }

   void set writableText(String v) {
      $dart_computed.set_writableText(v);
   }

   /*
   
   
                  B:Watch
                  render Vue watch into getter and setter
                  
      
   */
   void Function(int neval, int oldval) get onSumChange {
      return $dart_watchers.onSumChanged;
   }

   void set onSumChange(void Function(int neval, int oldval) v) {
      throw Vue.ReadOnlyWatchCBException( 'sum',  'onSumChange');
   }

   void Function(int neval, int oldval) get onHelloChanged {
      return $dart_watchers.onSumChanged;
   }

   void set onHelloChanged(void Function(int neval, int oldval) v) {
      throw Vue.ReadOnlyWatchCBException( 'hello',  'onHelloChanged');
   }

   void Function(int neval, int oldval) get onXChanged {
      return $dart_watchers.onSumChanged;
   }

   void set onXChanged(void Function(int neval, int oldval) v) {
      throw Vue.ReadOnlyWatchCBException( 'x',  'onXChanged');
   }
   /*
   
   
                  B:Options
                  render Vue options into getter and setter
                  
      
   */
   List<List> get components {
      return $dart_options.components;
   }

   void set components(List<List> v) {
      $dart_options.components = v;
   }

   String get el {
      return $dart_options.el;
   }

   void set el(String v) {
      $dart_options.el = v;
   }

   String get template {
      return $dart_options.template;
   }

   void set template(String v) {
      $dart_options.template = v;
   }

   String get CompName {
      return $dart_options.CompName;
   }

   void set CompName(String v) {
      $dart_options.CompName = v;
   }

   void Function() get printInfo {
      return $dart_options.printInfo;
   }

   void set printInfo(void Function() v) {
      throw Vue.ReadOnlyOptionsException('printInfo');
   }

   /*
   
   
                  B:Methods
                  render Vue methods into getter and setter
                  
      
   */
   
   void Function() get callThis {
      return $dart_methods.callThis;
   }

   void set callThis(void Function() v) {
      throw Vue.ReadOnlyMethodException('callThis');
   }

   void Function() get show {
      return $dart_methods.show;
   }

   void set show(void Function() v) {
      throw Vue.ReadOnlyMethodException('callThis');
   }
   
   /*
   
     
            B:Provide, Inject
            render Vue provides and injects into getter and setter
            
            todo:
            Inspect what could be providable or injectable.
      
   */

   Function get getMap {
      return $dart_methods.getMap;
   }

   void set getMap(Function v) {
      throw Vue.ReadOnlyMethodException('getMap');
   }

   Function get parentGetMap {
      return $dart_methods.parentGetMap;
   }

   void set parentGetMap(String Function() v) {
      throw Vue.ReadOnlyMethodException('parentGetMap');
   }

   /*
   
     
            B:On, Once
            
            
      
   */

   String Function(dynamic) get onClick {
      return $dart_ons.onClick;
   }

   void set onClick(String Function(dynamic) v) {
      throw Vue.ReadOnlyMethodException('onClick');
   }

   String Function(dynamic) get onLoad {
      return $dart_ons.onClick;
   }

   void set onLoad(String Function(dynamic) v) {
      throw Vue.ReadOnlyMethodException('onLoad');
   }

   String Function(dynamic) get onBeforeCreate {
      return $dart_ons.onClick;
   }

   void set onBeforeCreate(String Function(dynamic) v) {
      throw Vue.ReadOnlyMethodException('onBeforeCreate');
   }
   
   
   IVue(){
      $dart_data     = DataDefs();
      $dart_watchers = WatcherDefs();
      $dart_props    = PropertyDefs();
      $dart_options  = OptionDefs();
      $dart_computed = ComputedDefs();
      $dart_ons      = OnEventDefs();
      $dart_onces    = OnceEventDefs();
      $dart_methods  = MethodDefs();
      
   }
   /*
   
   
                              life cycle hooks
            
            
            
   */
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











