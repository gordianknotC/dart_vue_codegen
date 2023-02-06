/*
import 'dart:html';
import '../lib/src/interop.vue.dart';
import '../lib/src/interop.window.dart';
import 'package:js/js.dart';
import 'dart:js' show context;


class DMaster {
   static String currentName = null;
   static Map currentOptions = null;
   final String name;
   final Map options;
   
   const DMaster({this.name, this.options = const {}});
}

class DSub {
   static String currentName = null;
   static Map currentOptions = null;
   final String type;
   final Map options;
   
   const DSub({this.type, this.options = const {}});
}

void GP(String msg, Function cb) {
   console.group(msg+'\n\n\n');
   cb();
   console.groupEnd(msg );
}

class SampleApp {}

@DMaster(name: 'hell')
class Sample extends SampleApp {
   @DSub(type: 'string')
   String name;
   int value;
   
   @DSub(type: 'method')
   void hello() {
   
   }
   
   @DSub(type: 'computed')
   int get v => value;
   
   int sum() {
      return value + 100;
   }
   
   static String NAME = 'Sample';
}


final template = '''
   <section>hello world, this is Vue rootComponent,
      </br>x:{{x}}
      </br>getValue:{{getValue(1,2,3)}}, x:{{x}}
      </br>callThis:{{callThis()}}, x:{{x}}
      <List></List>
      <section id="sub"></section>
   </section>
''';

final template2 = '''
   <section>subordinary app,
      </br>x:{{x}}
      </br>hello: {{hello}}
      </br>getValue:{{getValue(1,2,3)}}, x:{{x}}
      </br>callThis:{{callThis()}}, x:{{x}}
      <List></List> </section>
''';

class Test {
   String name;
   
   Test(this.name);
}

@anonymous
@JS()
class FakeData {
   String hello;
   int x;
   FakeData({this.x, this.hello});
}


class Fake {
   int sum = 0;
   //int x = 1927;                       [original]
   int get x => $data.x;              //[translated]
   void set x (int v) => $data.x = v; //[translated]
   //String hello = 'Curtis'; [original]
   String get hello => $data.hello;
   void   set hello(String v) => $data.hello = v;
   // ... [original]
   FakeData $data = FakeData(x: 1927, hello: 'Curtis'); // [translated]
   
   
   String getstr() {
      return hello;
   }
   
   void show() {
      console.log(getstr());
   }
   
   void callThis() {
      return getValue('callThis', 'paramC');
   }
   
   void getValue([b, c]) {
      console.log('getValue, this:', this, 'b:', b, 'c:', c, 'sum:', this.sum);
   }
   
   void mounted() {
      x = 19817012;
      hello = 'hi there!!';
      console.warn('mounted: this:', this, r'this.$data', this.$data);
   }
   
   void beforeCreate() {
      console.warn('before create, this:', this);
   }
   
   void beforeDestroy() {
      console.warn('before destroy: this:', this);
   }
}

ComponentOptions getComponentOptions(dynamic vueDart_instance){
   return ComponentOptions(
      name: 'SubApp',
      el: '#sub',
      template: template2,
      data: vueDart_instance.data,
      methods: Methods({
         'getValue': vueDart_instance.getValue,
         'callThis': vueDart_instance.callThis,
      }),
      components: Components({
         'List': ComponentOptions(
            //            name: 'list',
            template: '<section id="list"><h5>list component</h5></section>'
         )
      }),
      mounted: vueDart_instance.mounted,
      beforeCreate: vueDart_instance.beforeCreate,
      beforeDestory: vueDart_instance.beforeDestroy,
   );
}



void main() {
   GP('[Dart Annotation Tests]', () {
      GP('[Fetch Annotation infos ]', () {
      
      });
   });
   GP('[Test interoping IS class]', () {
      console.log('Math:', Math);
      console.log('vue:', Vue);
      console.log("IS:", IS);
      Function fn = JFunc((a, b, c) => a + b + c);
      Function fn2 = (a, b, c) => a + b + c;
      IS_Body inst;
      IS_Data data;
      dynamic methods;
      data = IS_Data(name: 'instance', author: '');
      methods = IS_Methods({
         'ids': [1, 2, 3, 4, 5],
         'datas': {'name': 'hello', 'info': {
            'gender': 'man',
            'age': 13
         }},
         'hey': () {
            var lst = [1, 2, 3];
            var t = new Test('hello');
            console.log('inst:', inst, 'lst:', lst, 't:', t);
            inst.showInfo();
         },
         'showInfo': () {
            console.log('show info:');
         }
      });
      console.log('data:', data);
      console.log('methods:', methods);
      inst = IS(data, methods);
      console.log('inst:', inst);
      console.log('inst.hey', inst['hey']);
      inst['hey']();
      console.log('fn:', fn(1, 2, 3));
      console.log('fn2:', fn2(1, 2, 3));
      //      console.log('ms:', ms);
      
   });
   
   GP('[Vue preInterop]', () {
      console.log('VueConstructor:', Vue);
      console.log('VueConstructor.prototype:', Vue.prototype);
      console.log('VueApi:', VueApi);
      console.log('VueConfiguration:', VueConfiguration);
      
      var rootVue, lst;
      Map<String, dynamic> data = {'hell': 12};
      final fake = Fake();
      final config = ComponentOptions(
         name: 'RootApp',
         el: '#app',
         template: template,
         data: Data({
            'hell': 12,
            'x': 0
         }),
         methods: Methods({
            'getValue': (self, [b, c]) {
               console.log('getValue, self:', self, 'b:', b, 'c:', c, 'sum:', self.s);
               return 'tests';
            },
            'callThis': (self) {
               return self.getValue('callThis', 'paramC');
            },
         }),
         components: Components({
            'List': ComponentOptions(
               //            name: 'list',
               template: '<section id="list"><h5>list component</h5></section>'
            )
         }),
         mounted: ([self]) {
            console.warn('mounted, cannot access this rootVue:', rootVue, 'self:', self);
         },
         beforeCreate: () {
            console.warn('beforeCreate');
         },
         beforeDestory: () {
         
         },
      );
      console.log('config:', config);
      rootVue = Vue(config);
      console.log('rootVue:', rootVue);
   });
   
   GP('[Vue preInterop2]', () {
      console.log('VueConstructor:', Vue);
      console.log('VueConstructor.prototype:', Vue.prototype);
      console.log('VueApi:', VueApi);
      console.log('VueConfiguration:', VueConfiguration);
      
      Vue rootVue;
      var lst;
      Map<String, dynamic> data = {'hell': 12};
      final fake = Fake();
      final config = ComponentOptions(
         name: 'SubApp',
         el: '#sub',
         template: template2,
         data: fake.$data,
         methods: Methods({
            'getValue': fake.getValue,
            'callThis': fake.callThis,
         }),
         components: Components({
            'List': ComponentOptions(
               //            name: 'list',
               template: '<section id="list"><h5>list component</h5></section>'
            )
         }),
         mounted: fake.mounted,
         beforeCreate: fake.beforeCreate,
         beforeDestory: fake.beforeDestroy,
      );
      console.log('config:', config);
      rootVue = Vue(config);
      console.log('rootVue:', rootVue);
      console.log(r'fake.$data:', fake.$data);
      
      
      
      
      
      
      
   });
}
*/
