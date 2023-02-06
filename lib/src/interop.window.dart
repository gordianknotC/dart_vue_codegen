@JS()
library window;
import 'dart:js_util' show setProperty, getProperty, callMethod, jsify;
import 'package:js/js.dart' show JS, anonymous;
import 'dart:html'  show Notification, Element, ElementList, Window, HtmlDocument;
import 'dart:async' show Timer;


@JS('Date')
class Date{
   external static int parse(String date_string);
   external factory Date(int computer_time);
}

@JS('Math')
class Math{
   external static int max(int a , int b);
   external static int min(int a, int b);
}

@JS('console')
class console{
   external static void log(dynamic str, [a,b,c,d,e,f,g]);
   external static void info(dynamic str, [a,b,c,d,e,f,g]);
   external static void warn(dynamic str, [a,b,c,d,e,f,g]);
   external static void error(dynamic str, [a,b,c,d,e,f,g]);
   external static void group(dynamic str, [a,b,c,d,e,f,g]);
   external static void groupEnd(dynamic str, [a,b,c,d,e,f,g]);
}

@JS()
@anonymous
class TDescriptor{
   external dynamic get value;
   external dynamic get get;
   external dynamic get set;
   external factory TDescriptor({bool configurable, bool enumerable, value, bool writable, Function get, Function set});
}

@JS()
@anonymous
class TConstructor{
   external static String get name;
   external static dynamic get prototype;
}

@JS()
@anonymous
class TPrototypeClass{
   external  dynamic get prototype;
   external  TConstructor get constructor;
   external  String get name;
}


@JS('Object')
@anonymous
class JsObj {
   external factory JsObj();
   external operator []=(String key, dynamic value);
   external operator [](String key);
   external static List<String> getOwnPropertyNames(TPrototypeClass obj);
   external static TDescriptor getOwnPropertyDescriptor(TPrototypeClass obj, String name);
   external static void defineProperty(dynamic obj, String name, TDescriptor opt);
}



@JS('JSON.stringify')
external String str(dynamic any);

@JS('document.querySelector')
external Element querySelector(String str);

@JS('document.querySelectorAll')
external ElementList<Element> querySelectorAll(String str);




@JS('window')
external Window get win;

@JS('window.document')
external HtmlDocument get doc;

@JS('Promise')
class Promise<T> {
   external Promise(void executor(void resolve(T result), Function reject));
   external Promise then(void onFulfilled(T result), [Function onRejected]);
}

Element qs(String str, [dynamic _base]){
   Element base = _base ?? doc;
   return base.querySelector(str);
}

ElementList qsAll(String str, [dynamic _base]){
   Element base = _base ?? doc;
   return base.querySelectorAll(str);
}

void jsSet(dynamic obj, String name, dynamic value){
   return setProperty(obj, name, value);
}
dynamic jsGet(dynamic obj, String name){
   return getProperty(obj, name);
}

dynamic jsCall(dynamic obj, String method, List args ){
   return callMethod(obj, method, args);
}

setTimeout(Function fn, int time){
   Timer(Duration(microseconds: 600), fn);
}

//JsObj mapToJs(Map<String, dynamic> map) {
//   final object = new JsObj();
//   var value;
//   for (final key in map.keys){
//      value = map[key]
//         ? map[key] is! Function
//         : allowInteropCaptureThis(map[key]);
//      object[key] = map[key];
//   }
//      //setProperty(object, key, map[key]);
//   return object;
//}

//class J {
//   static JsObj call(){
//      return JsObj();
//   }
//   static from(dynamic object){
//       return JsObject.jsify(object);
//   }
//}


@JS('String')
class TJString {}
@JS('Array')
class TJArray{}
@JS('Object')
class TJObject{}
@JS('Boolean')
class TJBoolean{}
@JS('Number')
class TJNumber{}
@JS('Function')
class TJFunction{}
@JS('Symbol')
class TJSymbol{}
@JS('Date')
class TJDate{}




