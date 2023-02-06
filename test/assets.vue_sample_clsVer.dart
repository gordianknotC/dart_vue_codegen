import '../lib/src/interop.window.dart';
import '../lib/src/ast.vue.annotation.dart';
import '../lib/src/interop.vue.dart' as Vue;

import 'assets.vue_sample_clsVer.generated.dart';
import 'package:html_builder/elements.dart';


class PropertyDefs extends IPropDefs<OriginalComponentA> {
   String Color = 'RED';
   bool Color_required = false;
   num Num = 24;
   bool Num_required = true;
   
   bool onColorValidated(String v) {
      return null;
   }
   bool onNumValidated(num v) {
      return null;
   }
}

class WatcherDefs extends IWatcherDefs<OriginalComponentA> {
   int x;
   int sum;
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
   String hello  ;
   String noValue;
   String noValue2;
   int    _p1    ;
   int    sum    ;
   int    x      ;
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

class OptionDefs extends IOptionDefs<OriginalComponentA>{
   List<List> components = [['test', Vue.Vue]];
   String el       = '#app';
   String template = './index.vue';
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
   @ON.DOM_CHANGED('#elt')
   onLoad(e){
   
   }
   @ON.VUE_HOOK('beforeCreate')
   void onBeforeCreate(e){
   
   }
}

class MethodDefs extends IMethodDefs<OriginalComponentA>{
  void callThis() {
     return self.getValue('callThis', 'paramC');
  }

  void show() {
     console.log (self.getstr());
  }

  @provide //todo
  String getMap() {
     return self.parentGetMap() + 'map';
  }

  @inject //todo
  String Function() parentGetMap;
}



Node $template = html(lang: 'en', c: [
   head(c: [
      title(c: [text('Hello, world!')])
   ]),
   body(c: [
      h1(c: [text('Hello, world!')]),
      p(c: [text('Ok')])
   ])
]);


@Mixin (
   data: DataDefs /*hello*/, computed: ComputedDefs,
   prop: PropertyDefs, watch: WatcherDefs
)
@Component (
   el: '#app', template: './src/test.vue',
   components: {'test': Vue.Vue}
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
   
   void beforeCreate() {
   
   }
   
   void created() {
   
   }
   
   void beforeMount() {
   
   }
   
   void mounted() {
      x = 19817012;
      hello = 'hi there!!';
      console.warn('mounted: this:', this);
   }
   
   void beforeUpdate() {
   
   }
   
   void update() {
   
   }
   
   void beforeDestroy() {
      console.warn('before destroy: this:', this);
   }
}

void main(){

}