import '../lib/src/interop.window.dart';
import '../lib/src/ast.vue.annotation.dart';
import '../lib/src/interop.vuejs.dart' as Vue;

import 'assets.vue_sample.vue.generated.dart';
import 'package:html_builder/elements.dart';


class PropertyDefs extends IPropDefs<OriginalComponentA> {
   String Color        = 'RED';
   bool Color_required = false;
   num Num             = 24;
   bool Num_required   = true;
   
   bool onColorValidated(String v) {
      //onColorValidated
      return null;
   }
   bool onNumValidated(num v) {
      return null;
   }
}

class WatcherDefs extends IWatcherDefs<OriginalComponentA> {
   int x;
   bool x_deep = true;
   int sum;
   bool sum_immediate = true;
   String hello;
   
   void onHelloChanged(String newval, String oldval) {
      if (newval == oldval) return;
   }
   void onSumChanged(int newval, int oldval) {
      if (newval == oldval) return;
   }
   void onXChanged(int newval, int oldval) {
      if (newval == oldval) return;
   }
}

class DataDefs extends IDataDefs {
   String hello  = 'Curtis';
   String noValue;
   String noValue2;
   int _p1    = 12;
   int sum    = 0;
   int x      = 1927;
   void Function(String, int) temp = (String a, int b){
   
   };
}
/*
@Transformer.methods.getterSetterAwareness.append  :: transform methods into getter setter
@Transformer.getterSetter.methodAwareness.append   :: transform getter setter into methods
*/
class ComputedDefs extends IComputedDefs<OriginalComponentA> {
   String get_address() {
      return self._data['address'];
   }
   
   String get_writableText() {
      return self.hello;
   }
   
   void set_writableText(String v) {
      self.hello = v;
   }
}

class FilterDefs extends IFilterDefs<OriginalComponentA>{
   String capitalize(String value) {
      if (value == null || value == '') return '';
      value = value.toString();
      return value[0].toUpperCase() + value.substring(1);
   }
}

class OptionDefs extends IOptionDefs<OriginalComponentA>{
   String    el       = '#app';
   String    template = './index.vue';
   String    name     = 'OriginalA';
   Vue.Model model    = Vue.Model('prop', 'event');
   List<Type> mixins  = [];
   List<String> delimiters = ['{{', '}}'];
   Map<String, Type> components = {'test': OriginalComponentA};
   String CompName;
   void printInfo(){
   
   }
}

class OnEventDefs extends IOnEventDefs<OriginalComponentA>{
   @ON.CLICK
   onClick(e){
   
   }
}

class OnceEventDefs extends IOnceEventDefs<OriginalComponentA>{
   //todo untested:
   //following annotation need further test
   @ON.DOM_CHANGED('#elt')
   onLoad(e){
   }
   @ON.VUE_HOOK('beforeCreate')
   void onBeforeCreate(e){
   }
}

class MethodDefs extends IMethodDefs<OriginalComponentA> {
  void callThis() {
     show();
     this.getMap();
     self._data['address'] += 'hello';
     self.mounted();
     return self.getValue('callThis', 'paramC');
  }
  void show() {
     console.log (self.getstr());
  }
  String getMap() {
     return  'map';
  }
}



/*
todo
2) copy all vue imports into generated code.
3) functionality of OptionDefs are overlaps with Component annotation
4) consider there's no VueDefinitions to be defined [X]
*/
@Mixin (
   data: DataDefs /*hello*/, computed: ComputedDefs,
   prop: PropertyDefs, watch: WatcherDefs, method: MethodDefs,
   once: OnceEventDefs, on: OnEventDefs, //option: OptionDefs
   filters: FilterDefs,
)
// settings setup here, overrides what defines in OptionDefs
@Component (
   el: '#app',
   template: './assets.vue_templateA.vue',
   name: 'OriginalA',
   // under some cases we want to assign components programmatically
   // in those cases use OptionDefs instead.
   components: {'test': Vue.Vue},
   mixins: [],
   activated: true,
   // convert to jsType later on
   model: Model('checked', 'changed'),
   delimiters: ['{{', '}}'],
)

// all methods and lifecycle hooks
class OriginalComponentA extends IVue{
   int _p3 = 33; //private
   Map _data = {'address': 'St Road...'};
   
   Map<T, S> _getRef<T extends String, S extends int>(T name, S id) {
      Map<T, S> ret = {};
      ret[name] = id;
      return ret;
   }
   
   T Function(E arg) _getWrapper<T, E>(T name) {
      this.x;
      this.x = 3;
      var cc = this.x;
      var fn = getstr;
      var __getRef__ = this._getRef;
      x += 2;
      this._getRef(hello, this.x);
      return (E arg) {
         return name;
      };
   }
   
   String getstr() {
      return hello;
   }
   
   void getValue([b, c]) {
      console.log('getValue, this:', this, 'b:', b, 'c:', c, 'sum:', this.sum);
   }
   
   void mounted() {
      x = 19817012;
      hello = 'hi there!!';
      console.warn('mounted: this:', this);
   }
}

void main(){

}