
/*
import '../lib/src/interop.window.dart';
import '../lib/src/ast.vue.annotation.dart';
import '../lib/src/interop.vue.dart' as Vue;

import 'assets.vue_sample_annVer.generated.dart';


class PropertyDefs extends IPropDefs<OriginalComponentA>{
   String Color          = 'RED';
   bool   Color_required = false;
   num    Num            = 24;
   bool   Num_required   = true;

   bool onColorValidated() {
      return null;
   }
   
   bool onNumValidated() {
      return null;
   }
}


class WatcherDefs extends IWatcherDefs<OriginalComponentA> {
   int    x;
   int    sum;
   String hello;
   
   void onHelloChanged(String newval, String oldval) {
   }
   
   void onSumChanged(int newval, int oldval) {
   }
   
   void onXChanged(int newval, int oldval) {
   }
}


class DataDefs extends IDataDefs {

}

*//*
@Transformer.methods.propertyAware.append*//*
class ComputedDefs extends DataDefs with IComputedDefs<OriginalComponentA>{
  String get_address() {
    return null;
  }

  String get_writableText() {
    return null;
  }

  void set_writableText(String v) {
  }
}




@Mixin (
   data: DataDefs, computed: ComputedDefs,
   prop: PropertyDefs, watch:WatcherDefs
)*/
/*
@Component (
   el: '#app', template: './src/test.vue',
   components: {'test': Vue.Vue }
)
class OriginalComponentA extends IVue with Vue.VueApi {
   @option
   Map components = {'list': Vue.VueApi};
   
   @option
   String el = '#app';
   
   @option
   String template = './index.vue';
   
   @data
   String noValue, noValue2;
   
   @data
   int _p1 = 12; //private
   int _p3 = 33; //private
   Map _data = {'address': 'St Road...'};
   
   @data
   int sum = 0;
   
   @data
   int x = 1927;
   
   @data
   String hello = 'Curtis';

   OriginalComponentA.init() : super.init();
   
   @Watch(var_name: 'sum', deep: false)
   onSumChanged(newval, oldvar) {
   
   }
   
   on_x_changed(newval, oldvar) {
   
   }
   
   onHelloChanged(newval, oldvar) {
   
   }
   
   Map<T, S>
   _getRef<T extends String, S extends int>(T name, S id) {
      Map<T, S> ret = {};
      ret[name] = id;
      return ret;
   }
   
   T Function(E arg)
   _getWrapper<T, E>(T name) {
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
   
   String
   getstr() {
      return hello;
   }
   
   @method void
   show() {
      console.log(getstr());
   }
   
   @method void
   callThis() {
      return getValue('callThis', 'paramC');
   }
   
   void getValue([b, c]) {
      console.log('getValue, this:', this, 'b:', b, 'c:', c, 'sum:', this.sum);
   }
   
   @option String
   CompName;
   
   
   
   @option
   void printInfo() {
      print('info...');
      
   }
   
   @Prop(required: true)
   String Color = 'RED';
   
   bool
   onColorValidated(String val) {
   
   }
   
   @Prop(required: false)
   int Num = 24;
   
   bool
   onNumValidated(int val) {
   
   }
   
   @provide
   String getMap() {
      return parentGetMap() + 'map';
   }
   
   @inject
   String Function() parentGetMap;
   
   @Once('beforeCreate', true) void
   callOnBeforeCreate(e) {
   
   }
   
   @On('click') void
   click(e) {
   
   }
   
   @Once('load') void
   onLoad(e) {
   
   }
   
   @computed String
   get address => _data['address'];
   
   @computed String
   get writableText => hello;
   
   @computed void
   set writableText(String v) => hello = v;
   
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

*/