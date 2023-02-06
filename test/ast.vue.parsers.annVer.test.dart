import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:test/test.dart';

import '../lib/src/ast.parsers.dart' show ClassDeclParser;
import '../lib/src/ast.vue.parsers.annVer.dart';
import '../lib/src/ast.codegen.dart';
import '../lib/src/ast.utils.dart';
import '../lib/src/common.dart';


typedef TVoid = void Function();



Iterable<ClassDeclarationImpl>
getClasses(CompilationUnitImpl node) {
   return node.declarations.where((d) => d is ClassDeclarationImpl).whereType();
}

Iterable<T>
getClassMembers<T extends ClassMember>(ClassDeclarationImpl node) {
   return node.members.where((member) => member is T).whereType();
}

main() {
   var sources = r'''
   @Component(el: '#app', template: './src/test.vue', components: {'list': hello, 'test': Best.test})
   class OriginalComponentA extends VueApp implements IVue {
      @Option()
      Map components = {'list': 'list'};
      
      @Option()
      String el = '#app';
      
      @Option()
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
      
      @watch(var_name: 'sum')
      onSumChanged(newval, oldvar){
      
      }
      
      on_x_changed(newval, oldvar){
      
      }
      
      onHelloChanged(newval, oldvar){
      
      }
      
      Map<T, S> _getRef<T extends String, S extends int>(T name, S id){
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
         return (E arg){
            return name;
         };
      }
      
      @ON.DOM_CHANGED('#elt')
      String getstr() {
         return hello; // this is comment.
      }
      
      @method
      void show() {
         console.log(getstr());
      }
      
      @method
      void callThis() {
         return getValue('callThis', 'paramC');
      }
      
      void getValue([b, c]) {
         console.log('getValue, this:', this, 'b:', b, 'c:', c, 'sum:', this.sum);
      }
      
      @Option()
      String CompName;
      
      
      
      @Option()
      void printInfo(){
         print('info...');
      }
      
      @Prop(required: true)
      String Color = 'RED';
      
      bool
      onColorValidated(String val){
      
      }
      
      @Prop(required: false)
      int Num = 24;
      
      bool
      onNumValidated(int val){
      }
      
      @Provide()
      String getMap(){
         return parentGetMap() + 'map';
      }
      
      @Inject()
      String Function() parentGetMap;
      
      @Once('beforeCreate', true)
      void callOnBeforeCreate(e){
      
      }
      
      @On('click')
      void click(e){
      
      }
      
      @Once('load')
      void onLoad(e){
      
      }
      
      @computed
      String get address => _data['address'];
      
      @computed
      String get writableText => hello;
      
      @computed
      void   set writableText(String v) => hello = v;
      
      void beforeCreate() {
      
      }
      void created() {
      
      }
      
      void beforeMount() {
      
      }
      
      void mounted() {
         x     = 19817012;
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
      
      void destroyed() {
      
      }
   }
   ''';
   var AST     = parseCompilationUnit(sources);
   var CLS     = AST.declarations.first as ClassDeclarationImpl;
   var VUE_CLS = VueClassParser(ClassDeclParser(CLS));
   var members = CLS.members;
   
   group('VueClassParser', (){
      final dfields                = VUE_CLS.data_fields.map     ((m) => m.variables.first.name).toList();
      final mfields                = VUE_CLS.method_fields.map   ((m) => m.name.name).toList();
      final wfields                = VUE_CLS.watch_fields.map    ((m) => m.name.name).toList();
      final cfields                = VUE_CLS.computed_fields.map ((m) => m.name.name).toList();
      final onfields               = VUE_CLS.on_fields.map       ((m) => m.name.name).toList();
      final oncefields             = VUE_CLS.once_fields.map     ((m) => m.name.name).toList();
      final opmethods              = VUE_CLS.options_method_fields.map ((m) => m.name.name).toList();
      final opfields               = VUE_CLS.options_prop_fields.map   ((m) => m.variables.first.name).toList();
      final prop_fields            = VUE_CLS.prop_fields.map            ((m) => m.variables.first.name).toList();
      final prop_validators        = VUE_CLS.prop_validator_fields.map  ((m) => m.name.name).toList();
      final prop_fields_validators = VUE_CLS.prop_fields.map            ((m) => (m.vueAnnotation as PropAnn).validator_bodies.first.name.name ).toList();
      final hook_fields            = VUE_CLS.lifecycle_fields.map       ((m) => m.name.name ).toList();

      var md = VUE_CLS.cls_parser.getMethod('getstr').first.body ;
      print('***************');
      print(dump(md));
      
      md.childEntities.forEach((syn){
         (syn as AstNodeImpl).childEntities.forEach((s){
            print(s);
         });
      });
      
      
      test('parsing vue annotations', (){
         var expected_dfields         = ['noValue', '_p1', 'sum', 'x', 'hello'];
         var expected_mfields         = ['show', 'callThis'];
         var expected_wfields         = ['onSumChanged', 'onHelloChanged', 'on_x_changed'];
         var expected_cfields         = ['address', 'writableText', 'writableText'];
         var expected_onfields        = ['click'];
         var expected_oncefields      = ['callOnBeforeCreate', 'onLoad'];
         var expected_opfields        = ['components', 'el', 'template', 'CompName'];
         var expected_opmethods       = ['printInfo'];
         var expected_prop_fields     = ['Color', 'Num'];
         var expected_prop_validators = ['onColorValidated', 'onNumValidated'];
         var expected_hooks           = ['beforeCreate', 'created'      , 'mounted',
                                         'beforeUpdate', 'beforeDestroy', 'destroyed'];
         
         expect(dfields    ,unorderedEquals(expected_dfields));
         expect(mfields    ,unorderedEquals(expected_mfields) );
         expect(cfields    ,unorderedEquals(expected_cfields));
         expect(onfields   ,unorderedEquals(expected_onfields));
         expect(oncefields ,unorderedEquals(expected_oncefields));
         expect(opmethods  ,unorderedEquals(expected_opmethods));
         expect(opfields   ,unorderedEquals(expected_opfields));
         
         expect(prop_fields            ,unorderedEquals(expected_prop_fields));
         expect(prop_fields_validators ,unorderedEquals(expected_prop_validators));
         expect(prop_validators        ,unorderedEquals(expected_prop_validators));
         expect(wfields                ,unorderedEquals(expected_wfields));
         
         var watchees = VUE_CLS.watch_fields.map((field) => (field.vueAnnotation as WatchAnn).var_name ).toList();
         print('watchees: $watchees');
         expect(watchees, unorderedEquals(["'sum'", "'x'", "'hello'"]));
         expect(hook_fields, unorderedEquals(expected_hooks));
      });
      
      test('', (){
         expect (VUE_CLS.el, equals("'#app'"));
         expect (VUE_CLS.template, equals("'./src/test.vue'"));
         expect (
            VUE_CLS.vueAnnotation.keys.map((key) => key.toSource()).toList(),
            equals(["'list'", "'test'"])
         );
         expect (
            VUE_CLS.components.map((entry) => entry.value).map((entry) => entry.toSource()).toList(),
            ['hello', 'Best.test']
         );
         
      });
   });
}





































