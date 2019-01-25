// ignore_for_file: unused_import, missing_js_lib_annotation, unused_local_variable, unused_element, unused_field, missing_return, unused_shown_name, unused_import

library temp;

import 'package:colorize/colorize.dart' show color, Colorize, Styles;
import 'dart:io';
import 'package:js/js.dart';
import 'package:common/src/common.dart' as _;

/*
________________________________________________________
 
                   AST Declarations
                  

[AST]
   ClassDeclarationImpl
   [Description]
      represent the whole class declaration, includes
      metadata(class annotation)
   [EX]
      class DMasterB {...}
      class DMasterB {...}
      @DMasterB(name: 'hellB')
      @DMaster(name: 'hell')
      class Sample extends SampleApp { ... }
      
[AST]
   TopLevelVariableDeclarationImpl
   [Description]
      top level declarations, excludes metadata, and topLevelFunctions
   [EX]
      var d = new SampleApp();
      var o = new Object();

[AST]
   FunctionDeclarationImpl
   [Description]
      top-level and non-top-level function declaration except class methods,
      metadata is includes.
   [Ex]
      @DSub(type:'toplevelprop')
      void topLevelMethod(List<String> hellos){
         return null;
      }

[AST]
   MethodDeclarationImpl
   [Description]
      class methods declaration, includes metadata.
   [Ex]
      @DSub(type: 'method') void hello() {print('hello');}
      int argtype(List<String> listarg, Map<String, int> maparg) {return value + 100;}
      void namedArg({String name, int value, List<String> data}) {return;}
      get moduleText {var c = Colorize('[$name] '); c.apply(Styles.DEFAULT); return c.toString();}
      static List<T> sorted<T>(List<T> data, [int compare(T a, T b)]) {if (data.isEmpty) return data; final iterators = data.toList(growable: false); iterators.sort(compare); return iterators;}

[AST]
   ArgumentListImpl
   [Description]
      represents invoking methods with argument list
   [EX]
      (name: 'common', levels: [ELevel.level3])
	   (msg, front: Styles.DARK_GRAY, isBold: false, isItalic: false, isUnderline: false)

[AST]
   FormalParameterListImpl
   [Description]
      represents argument list definition
   [EX]
      ({this.type, this.options = const {}})
	   (List<String> listarg, Map<String, int> maparg)
	   
[AST]
   AnnotationImpl
   [Description]
      annotations
   [EX]
      @DSub(type: 'toplevelprop')
      @DMaster(name: 'static', options: {'hello' : 'world'})

[AST]
   VariableDeclarationListImpl
   [Description]
      non-top-level and top-level variable declaration
   [EX]
      var d = new SampleApp()
      var o = new Object()
      String currentName = null
      Map currentOptions = null
      final String name

[AST]
   DeclaredSimpleIdentifier
   [Description]
      represent a declaration identifier
   [EX]
      1) in class declaration
         > class ClassName{...}
         where [className] is a DeclaredSimpleIdentifier
      2) in methods
         > void topLevelMethod(){...}
         where [topLevelMethod] is a DeclaredSimpleIdentifier
      3) in annotation
         > @DSub(type: 'toplevelprop')
         where [DSub] is a DeclaredSimpleIdentifier
      4) in function parameters
         > void topLevelMethod(List<String> hellos){ ...
         where [hellos] is a DeclaredSimpleIdentifier
      5) in variable declaration
         > var d = new SampleApp();
         where [d] is a DeclaredSimpleIdentifier

[AST]
   GenericTypeAliasImpl
   [EX]
      typedef _TEndsStartsWith = bool Function(String source, String end)
      
[AST]
   EnumDeclarationImpl
   [EX]
      enum ELevel {log, info, debug, warning, critical, error, level0, level1, level2, level3, level4}


[AST]
   FieldDeclarationImpl
   [Description]
      class fields declaration includes metadata.
   [EX]
      static String currentName = null;
      final String name;
      @DSub(type: 'string') int name = 54;


[AST]
   ConstructorDeclarationImpl
   [EX]
      const DMasterB({this.name, this.options = const {}});
      Logger({this.name, this.levels = LEVELS}) {var error = () {if (levels.length > 1) throw Exception("Collection levels 'level0~level4' can't be used combining with regular level 'log, info, erro...'");}; if (levels.contains(ELevel.level0)) {error(); levels = LEVEL0;} else if (levels.contains(ELevel.level1)) {error(); levels = LEVEL1;} else if (levels.contains(ELevel.level2)) {error(); levels = LEVEL2;} else if (levels.contains(ELevel.level3)) {error(); levels = LEVEL3;} else if (levels.contains(ELevel.level4)) {error(); levels = LEVEL4;}}
      Tuple(this.key, this.value);

[AST]
   ExtendsClauseImpl
   [EX]
      extends SampleApp

[AST]
   TypeParameterListImpl
   [EX]
      <K, V>
      <F, M, C>
________________________________________________________
 
                   AST Expressions
                  

[AST]
   FunctionExpressionImpl
   [Description]
      represents function body except class methods includes argument list.
   [EX]
      (List<String> hellos) {return null;}
      (Function expression, [Object message]) {try {try {expression();} catch ...
   

[AST]
   BlockFunctionBodyImpl
   [Description]
      represents
   [EX]
      {var error = () {if (levels.length > 1) throw Exception("Collection levels 'level0~level4' can't be used combining with regular level 'log, info, erro...'");}; if (levels.contains(ELevel.level0)) {error(); levels = LEVEL0;} else if (levels.contains(ELevel.level1)) {error(); levels = LEVEL1;} else if (levels.contains(ELevel.level2)) {error(); levels = LEVEL2;} else if (levels.contains(ELevel.level3)) {error(); levels = LEVEL3;} else if (levels.contains(ELevel.level4)) {error(); levels = LEVEL4;}}
      {var c = Colorize('[$name] '); c.apply(Styles.DEFAULT); return c.toString();}
      {if (levels.contains(level)) {switch (level) {case ELevel.warning: warning(msg); break; case ELevel.error: error(msg); break; case ELevel.critical: error(msg); break; case ELevel.debug: debug(msg); break; case ELevel.info: info(msg); break; default: log(msg); break;}}}
      {stdout.write(moduleText); color(msg, front: Styles.DARK_GRAY, isBold: false, isItalic: false, isUnderline: false);}
 
[AST]
   EmptyFunctionBodyImpl
   
[AST]
   ExpressionFunctionBodyImpl
   [EX]
      => value;
      => e.moveNext()
      
[AST]
   NamedExpressionImpl
   [EX]
      type: 'toplevelprop'
      name: 'hellB'
      name: 'hell'
      type: 'string'

[AST]
   InstanceCreationExpressionImpl
      new SampleApp()
      new Object()
[AST]
   SimpleFormalParameterImpl
      List<String> hellos
      List<String> listarg
[AST]
   BinaryExpressionImpl
      value + 100
      i < length
      strip_counter != 0
      (MIN_COL - TITLE_L) ~/ 2
	
________________________________________________________
 
                   AST Tokens
                  

[AST]
   SimpleStringLiteralImpl
   [EX]
      'Sample'
      " "
      'string'
      
[AST]
   SimpleToken
   [EX]
         ;
         }
         =
         @
         >
         )
         =>
         ]
         *

[AST]
   TypeNameImpl
   [Description]
      includes return type, parameter type, predefined function type using typedef,
      class type, fields type...
   [EX]
      void
      SampleApp
      int
      String
      Iterable<List<T>>
      T

[AST]
   KeywordToken
   [EX]
      class
      typedef
      enum
      show
      var
      static
      const
      extends
      get
      final
      ...
[AST]
   BeginToken
   [EX]
      {
      <
      (
      [
      ${
*/

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

class DMasterB {
   static String currentName = null;
   static Map currentOptions = null;
   final String name;
   final Map options;
   
   const DMasterB({this.name, this.options = const {}});
}

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

class SampleApp {}


class ClsExtendFromImport extends Colorize with SampleApp{

}

class ClsExtendFromDeclAs extends _.FN with SampleApp{

}

@DMasterB(name: 'hellB')
@DMaster(name: 'hell')
class Sample extends SampleApp {
   @DSub(type: 'string')
   int name = 54;
   int value;
   
   @DSub(type: 'method')
   void hello() {
      print('hello');
   }
   
   @DSub(type: 'computed')
   int get v => value;
   
   int argtype(List<String> listarg, Map<String, int> maparg) {
      return value + 100;
   }
   
   void namedArg({String name, int value, List<String> data}) {
      return;
   }
   
   static String NAME = 'Sample';
   
   @DSub(type: 'computed')
   @DMaster(name: 'static', options: {'hello': 'world'})
   static String findName() {
      return 'x';
   }
   
   SampleApp simple(SampleApp request) {
      return null;
   }
   
   void Function(String arg) closureRet() {
      void localScopeFunction() {
      
      };
      return (arg) {
      
      };
   }
}



/*
*
*
*
*
*
*
* */



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
const LEVEL1 = [ELevel.info, ELevel.error, ELevel.debug, ELevel.warning, ELevel.critical];
const LEVEL2 = [ELevel.error, ELevel.debug, ELevel.warning, ELevel.critical];
const LEVEL3 = [ELevel.error, ELevel.warning, ELevel.critical];
const LEVEL4 = [ELevel.error, ELevel.critical];
const LEVELS = [
   ELevel.error, ELevel.debug, ELevel.warning, ELevel.critical
];

class Logger {
   List<ELevel> levels;
   String name;
   
   Logger({this.name, this.levels = LEVELS}) {
      var error = () {
         if (levels.length > 1)
            throw Exception("Collection levels 'level0~level4' can't be used combining with regular level 'log, info, erro...'");
      };
      if (levels.contains(ELevel.level0)) {
         error();
         levels = LEVEL0;
      } else if (levels.contains(ELevel.level1)) {
         error();
         levels = LEVEL1;
      } else if (levels.contains(ELevel.level2)) {
         error();
         levels = LEVEL2;
      } else if (levels.contains(ELevel.level3)) {
         error();
         levels = LEVEL3;
      } else if (levels.contains(ELevel.level4)) {
         error();
         levels = LEVEL4;
      }
   }
   
   get moduleText {
      var c = Colorize('[$name] ');
      c.apply(Styles.DEFAULT);
      return c.toString();
   }
   
   void call(String msg, [ELevel level = ELevel.info]) {
      if (levels.contains(level)) {
         switch (level) {
            case ELevel.warning:
               warning(msg);
               break;
            case ELevel.error:
               error(msg);
               break;
            case ELevel.critical:
               error(msg);
               break;
            case ELevel.debug:
               debug(msg);
               break;
            case ELevel.info:
               info(msg);
               break;
            default:
               log(msg);
               break;
         }
      }
   }
   
   void log(String msg) {
      stdout.write(moduleText);
      color(msg, front: Styles.DARK_GRAY, isBold: false, isItalic: false, isUnderline: false);
   }
   
   void info(String msg) {
      stdout.write(moduleText);
      color(msg, front: Styles.LIGHT_GRAY, isBold: false, isItalic: false, isUnderline: false);
   }
   
   void debug(String msg) {
      stdout.write(moduleText);
      color(msg, front: Styles.LIGHT_BLUE, isBold: false, isItalic: false, isUnderline: false);
   }
   
   void critical(String msg) {
      stdout.write(moduleText);
      color(msg, front: Styles.LIGHT_RED, isBold: true, isItalic: false, isUnderline: false);
   }
   
   void error(String msg) {
      stdout.write(moduleText);
      color(msg, front: Styles.RED, isBold: false, isItalic: false, isUnderline: false);
   }
   
   void warning(String msg) {
      stdout.write(moduleText);
      color(msg, front: Styles.YELLOW, isBold: true, isItalic: false, isUnderline: false);
   }
}

final _log = Logger(name: 'common', levels: [ELevel.level3]);

void tryRaise(Function expression, [Object message]) {
   try {
      try {
         expression();
      } catch (e, s) {
         _log("[AnError] $message\n$e \n$s", ELevel.error);
         rethrow;
      }
   } catch (e) {}
}

void raise(Object message) {
   try {
      try {
         throw(message);
      } catch (e, s) {
         _log("[AnError] $message\n$e \n$s", ELevel.error);
         rethrow;
      }
   } catch (e) {}
}

void GP(String message, Function(String _) cb, [int level = 1]) {
   const String H = '-';
   const String S = ' ';
   final int TITLE_L = message.length;
   final int MIN_COL = TITLE_L <= 36
                       ? TITLE_L % 2 == 0
                         ? TITLE_L
                         : 36 + 1
                       : TITLE_L;
   final HEADING = (MIN_COL - TITLE_L) ~/ 2; //note: ~/2 indicates divide by 2 and transform it into int;
   final HORIZONTAL = H * MIN_COL;
   final TITLE = S * HEADING + message;
   print(HORIZONTAL);
   print(TITLE);
   print(HORIZONTAL);
   cb('\t' * level);
}



class Triple<F, M, C> {
   F father;
   M mother;
   C child;
   
   Triple(this.father, this.mother, this.child);
}

class IS {
   bool string(source) {
      if (source is String) return true;
      return false;
   }
   
   bool Num(source) {
      if (source is num) return true;
      if (source is String) {
         return double.tryParse(source) != null;
      }
      return false;
   }
   
   bool Int(source) {
      if (source is int) return true;
      if (source is num) return false;
      if (source is String) {
         return int.tryParse(source) != null;
      }
      return false;
   }
   
   bool empty(source) {
      if (source is String) return source.isEmpty;
      return false;
   }
}

class FN {
   static T
   remove<T>(List<T> array, T element) {
      return array.removeAt(array.indexOf(element));
   }
   
   static int
   findIndex<T>(List<T> data, bool search(T element)) {
      int result;
      FN.forEach(data, (el, [i]) {
         if (search(el)) {
            result = i;
            return true;
         }
         return false;
      });
      return result;
   }
   
   //todo:
   static Iterable<T>
   flatten<T>(List<T> elts){
      throw Exception('not implemented yet');
   }
   static Iterable<List<T>>
   zip<T>(Iterable<Iterable<T>> iterables) sync* {
      if (iterables.isEmpty) return;
      final iterators = iterables.map((e) => e.iterator).toList(growable: false);
      while (iterators.every((e) => e.moveNext())) {
         yield iterators.map((e) => e.current).toList(growable: false);
      }
   }
   
   static List<T>
   sorted<T>(List<T> data, [int compare(T a, T b)]) {
      if (data.isEmpty) return data;
      final iterators = data.toList(growable: false);
      iterators.sort(compare);
      return iterators;
   }
   
   static void
   forEach<T>(List<T> list, bool Function(T member, [int index]) cb) {
      var length = list.length;
      for (var i = 0; i < length; ++i) {
         if (cb(list[i], i)) return;
      }
   }
   
   static String
   _strip(String source, List<String> stripper,
          int srlen, int stlen,
          _TEndsStartsWith conditioning, _TSubstring substring) {
      var strip_counter = -1;
      while (strip_counter != 0) {
         strip_counter = 0;
         print('$source, ${conditioning == source.endsWith}, ${conditioning == source.startsWith}');
         for (var i = 0; i < stlen; ++i) {
            print('1) ends with ${stripper[i]} ${conditioning(source, stripper[i])}');
            
            if (conditioning(source, stripper[i])) {
               source = substring(source, 0, source.length - 1);
               strip_counter ++;
            }
         }
      }
      return source;
   }
   
   static String
   _stripRight(String source, List<String> stripper, int srlen, int stlen, _TEndsStartsWith conditioning, _TSubstring substring) {
      return _strip(source, stripper, srlen, stlen, conditioning, substring);
   }
   
   static String
   _stripLeft(String source, List<String> stripper, int srlen, int stlen, _TEndsStartsWith conditioning, _TSubstring substring) {
      return _strip(source, stripper, srlen, stlen, conditioning, substring);
   }
   
   static String
   _stripLR(String source, String stripper,
            String Function(String source, List<String> stripper, int srlen, int stlen, _TEndsStartsWith conditioning, _TSubstring substring) pathway,
            _TEndsStartsWith conditioning, _TSubstring substring) {
      var l = stripper.length;
      if (l == 0) return source;
      if (l == 1) {
         if (conditioning(source, stripper)) {
            return substring(source, 0, source.length - 1);
         }
      } else {
         return pathway(source, stripper.split(''), source.length, stripper.length, conditioning, substring);
      }
      return source;
   } //@fmt:on
   
   static String
   stripLeft(String source, [String stripper = " "]) {
      return _stripLR(source, stripper, _stripLeft,
            (String s, String end) => s.startsWith(end),
            (String s, int start, int end) => s.substring(s.length - end));
   }
   
   static String
   stripRight(String source, [String stripper = " "]) {
      return _stripLR(source, stripper, _stripRight,
            (String s, String end) => s.endsWith(end),
            (String s, int start, int end) => s.substring(start, end));
   }
   
   static String
   strip(String source, [String stripper = " "]) {
      return stripLeft(stripRight(source, stripper), stripper);
   }
}

@JS('console')
class console {
   external static log([a, b, c, d, e, f, g, h, i, j, k]);
   external static warn([a, b, c, d, e, f, g, h, i, j, k]);
}



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
abstract class Empty{

}

abstract class IVue extends Empty{
   String el;
   String template;
   Map components;
}



@Component(el: '#app', template: './src/test.vue', components: {'list': 'hello'})
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



/*
*
*
*           designed to be transform into following codes
*
*
* */
@anonymous
@JS()
class _Data extends VueData {
   int    sum     = 0;
   int    x       = 1927;
   String hello   = 'Curtis';
}

@anonymous
@JS()
class _Watchers extends VueWatchers {
   int      sum;
   int      x;
   String   hello;
   _Watchers(this.sum, this.x, this.hello);
}

@anonymous
@JS()
class _Props extends VueProps{
   String Color = 'RED';
   int    Num   = 24;
}

@anonymous
@JS()
class VueProperty<T>{
   String name;
   T      defaults;
   bool   required;
   bool Function(T value) validator;
   VueProperty({this.name, this.defaults, this.required, this.validator});
}

abstract class IPropertiesDefinition {
   VueProperty<String>  Color;
   VueProperty<int>     Num;
   Init(){
      Color = VueProperty(name:'Color', defaults: 'RED', required: false, validator: validateColor);
      Num   = VueProperty(name:'Num'  , defaults: 12   , required: false);
   }
   bool validateColor(String value);
}

mixin PropertyValidation{
   bool
   validateColor(String value){
      return ['RED', 'GREEN'].contains(value);
   }
}

//note: user defined class, extends a generated interface: IPropertyManager
class PropertiesDefinition extends IPropertiesDefinition with PropertyValidation{
}


class OriginalComponentB
<D extends _Data, W extends _Watchers, P extends _Props>  extends VueApp<D, W, P> {
   /*
   *      [PrivateField]
   *      private fields are dart fields.
   *
   */
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
   D $data = _Data() as D;
   
   int get sum {
      return $data.sum;
   }
   
   void set sum(int v) {
      $data.sum = v;
   }
   
   int get x {
      return $data.x;
   }
   
   void set x(int v) {
      $data.x = v;
   }
   
   String get hello {
      return $data.hello;
   }
   
   void set hello(String v) {
      $data.hello = v;
   }
   
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
   String CompName;
   
   void printInfo(){
      print('info...');
   }
   
   P $props = _Props() as P;
   
   String get Color {
      return $props.Color;
   }
   
   //NOTE: properties cannot be set or better not be set from within vue instance
   //      ,so properties are readonly properties.
   //   void set Color (String v) {
   //      $props.Color = v;
   //   }
   
   int get Num {
      return $props.Num;
   }
   
   //NOTE: properties cannot be set or better not be set from within vue instance
   //      ,so properties are readonly properties.
   //   void set Num(int v) {
   //      $props.Num = v;
   //   }
   
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
   // transform during initializing vue instance
   // EX: instance.parentGetMap = parentInst.getMap
   @Inject()
   String Function() parentGetMap;
   
   /*
   *
   *     [@On, and @Once] - event listener
   *
   *     inject code within mounted - todo: low priority
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











