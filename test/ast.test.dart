import 'dart:io';
import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:astMacro/src/ast.transformers.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' show join, dirname;

/*import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/ast_factory.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/standard_ast_factory.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:quiver/collection.dart' show DelegatingMap;
import 'package:front_end/src/scanner/token.dart' show KeywordToken, SimpleToken, StringToken;
import 'package:colorize/colorize.dart' show color, Colorize, Styles;*/

import 'package:astMacro/src/ast.utils.dart';
import 'package:astMacro/src/ast.dart';

const SAMPLE_CODE = r'''
library temp;

import 'package:colorize/colorize.dart' show color, Colorize, Styles;
import 'dart:io';
import 'package:js/js.dart';
import 'package:path/path.dart' as Path;

String vars1, vars2, vars3;

@DSub(type: 'toplevelprop')
var d = new SampleApp();
var o = new Object();

@DSub(type: 'toplevelprop')
void topLevelMethod(List<String> hellos) {
   return null;
}

void emptyFunction(String a, int b, [num c, String d]) {
   var result = b + c;
}

void emptyFunctionB(a, b, {c, d}) {
}

typedef _TEndsStartsWith = bool Function(String source, String end);
typedef _TSubstring = String Function(String source, int start, int end);

enum ELevel {
   log,
   info,
   debug,
   warning,
   critical,
   error,
   level0,
   level1,
   level2,
   level3,
   level4
}

const LEVEL0 = [ELevel.log, ELevel.info, ELevel.error, ELevel.debug, ELevel.warning, ELevel.critical];


/*
*
*
*           original codes
*
*
* */

class Options{
   const Options();
}
class Props<T>{
   final bool  required;   //
   final bool  validator;  //has validator ornot
   const Props({this.required, this.validator});
   
}
class Provide{
   const Provide();
}
class Inject{
   const Inject();
}
class On{
   final String eventname;
   final bool   lifehook;
   const On(this.eventname, [this.lifehook = false]);
}
class Once{
   final String eventname;
   final bool   lifehook;
   const Once(this.eventname, [this.lifehook = false]);
}
class Watch{
   final String   varname;
   final bool     immediate;
   final bool     deep;
   const Watch (this.varname, {this.immediate, this.deep});
}
class Component{
   final String               template;
   final String               el;
   final Map<String, dynamic> components;
   const Component ({this.template, this.el, this.components});
}


@JS()
@anonymous
class VueData{

}
@JS()
@anonymous
class VueWatchers{

}
@JS()
@anonymous
class VueOptions{

}
@JS()
@anonymous
class VueProps{

}
typedef TWatchCB = Function([dynamic newval, dynamic oldvar]);
abstract class VueApp<D, W ,P> {
   D      $data;
   W  $watchers;
   P     $props;
   
   /*
   *     vue hooks
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
abstract class IVue{
   String el;
   String template;
   Map components;
}



@Component(el: '#app', template: './src/test.vue', components: {'list': hello, 'test': Best.test})
class OriginalComponentA extends VueApp implements IVue {
   @Options()
   Map components = {'list': 'list'};
   
   @Options()
   String el = '#app';
   
   @Options()
   String template = './index.vue';
   /*
   *      [PrivateField]
   *      private fields are dart fields.
   *
   */
   String noValue, noValue2;
   int _p1 = 12; //private
   int _p3 = 33; //private
   Map _data = {'address': 'St Road...'};
   /*
   *
   *     [PublicField] NOTE: Vue Data
   *
   *     Public fields are default to be a vue data field,
   *     codes would be transformed into a proxy getter
   *     and setter.
   *
   *     or force using annotations like this:
   *
   *     @data
   *     String num;
   *     ----------------------------------------------------
   *
   *     [Design]
   *
   *     Any vue data referenced in vue methods or computed
   *     properties directly or indirectly would resulted an
   *     unexpected infinite loop, which is expected by design.
   *     So it would be a plus if Dart can warn users that there's
   *     an potential warning that would caused an infinite loop
   *     in case user sets vue data in vue methods/computedProps or
   *     commit for changed in those sections.
   *
   
   *
   */
   int sum = 0;
   int x = 1927;
   String hello = 'Curtis';
   
   /*
   *      [PrivateMethods]
   *      private methods are dart methods.
   *
   */
   Map<T, S> _getRef<T extends String, S extends int>(T name, S id){
      Map<T, S> ret = {};
      ret[name] = id;
      return ret;
   }
   T Function(E arg) _getWrapper<T, E>(T name){
      this.x;
      this.x = 3;
      var cc = this.x;
      var fn = getstr;
      var __getRef__ = this._getRef;
      sum += 19;
      x += 2;
      this._getRef(hello, this.x);
      return (E arg){
         return name;
      };
   }
   /*
   *     [PublicMethod] - NOTE: Vue Methods
   *
   *     Public methods are default to be a vue methods,
   *     codes would not be transformed .
   *
   *     or force using annotations like this:
   *
   *     @method
   *     void method(){}
   *     -----------------------------------------------
   *
   *     [Design] - see sections in Vue Data
   *
   */
   String getstr() {
      return hello;
   }
   
   //public methods defaults to be a vue method
   void show() {
      console.log(getstr());
   }
   
   //public methods defaults to be a vue method
   void callThis() {
      return getValue('callThis', 'paramC');
   }
   
   //public methods defaults to be a vue method
   void getValue([b, c]) {
      console.log('getValue, this:', this, 'b:', b, 'c:', c, 'sum:', this.sum);
   }
   /*
   *
   *     [@Options, and @Props] - VueOptions and VueProps
   *     Options must annotated with @Options. Options can be public methods and
   *     fields which make a differentiation from public VueMethods and VueData.
   *
   *     [NOTE]
   *     Options' value can't be a vue lifecycle hooks, like created, mounted...
   *
   * */
   @Options()
   String CompName;
   
   @Options()
   void printInfo(){
      print('info...');
   }
   
   @Props()
   String Color = 'RED';
   
   @Props()
   int Num = 24;
   
   /*
   *
   *     [@Inject, and @Provide] - dependency injection
   *     provide a public dependency, that is injectable,
   *     for children components.
   *
   *
   */
   @Provide()
   String getMap(){
      return parentGetMap() + 'map';
   }
   @Inject()
   String Function() parentGetMap;
   
   /*
   *
   *     [@On, and @Once] - event listener
   *
   *
   */
   @Once('beforeCreate', true)
   void callOnBeforeCrate(e){
   
   }
   @On('click')
   void click(e){
   
   }
   @Once('load')
   void onLoad(e){
   
   }
   
   /*
   *
   *      [PrivateGetters]
   *      private getters are dart getters.
   *
   */
   int get _id => 12357;
   /*
   *
   *     [PublicGetter] - readOnly - note: Vue Computed Property
   *     Public and readonly getters are default to be a
   *     vue computed property.
   *
   *     ---------------------------------------
   *
   *     [Design] - see section in Vue Data
   *
   *
   */
   String get address => _data['address'];
   // followings are not a readonly getter
   String get writableText => hello;
   void   set writableText(String v) => hello = v;
   
   /*
   *     vue hooks
   */
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
   
   void destroyed() {
   
   }
}

''';


main() {
   final SAMPLE_PTH  = join(r"E:\MyDocument\Dart\astMacro\test", "sampleCode.dart");
   final codes       = File(SAMPLE_PTH).readAsStringSync();
   group('test delegateMap', (){
      var res = Dict({'filename': 'helloworld.dart'});
      
      test('get keys of res', (){
         expect(res.keys, contains('filename'));
      });
      test('fetch property by index', (){
         expect(res['filename'], equals('helloworld.dart'));
      });
      showFlatTree(codes);
   });
   
   group('test dumping AstNode into readable Trees', (){
      var expressions = codes;
      CompilationUnit ast;
      setUp((){
         ast = parseCompilationUnit(expressions ,parseFunctionBodies: true);
      });
      test('dump expression', (){
         print(dumpAst(ast));
      });
   });
   
   
}



































