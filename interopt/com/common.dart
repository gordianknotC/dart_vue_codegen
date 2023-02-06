@JS()
library window;
import 'dart:js_util';
import 'package:js/js.dart' show JS, anonymous;
import 'dart:js'    show JsObject, allowInteropCaptureThis,
allowInterop, JsFunction, JsArray, context;
import 'dart:html'  show Notification, Element, ElementList, Window, HtmlDocument;
import 'dart:async' show Completer, Timer;

import 'dart:collection';


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



class JsMap<K, V> extends MapMixin<K, V> {
   @JS('Object.keys')
   external static List<K> _getKeys<K>(jsObject);
   @JS('Object.values')
   external static List<V> _getValues<V>(jsObject);
   
   var _jsObject;
   JsMap(this._jsObject);
   
   V operator [](Object key) => getProperty(_jsObject, key);
   operator []=(K key, V value) => setProperty(_jsObject, key, value);
   
   remove(Object key) {
      final value = this[key];
      throw Exception('object remove not implemented yet');
      //deleteProperty(_jsObject, key);
      _jsObject.remove();
      return value;
   }
   
   Iterable<K> get keys => _getKeys<K>(_jsObject);
   Iterable<V> get values => _getValues<V>(_jsObject);
   
   bool containsKey(Object key) => hasProperty(_jsObject, key);
   
   void clear() => throw Exception('object clear not implemented yet');
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

Promise<T>
promiseFromFuture<T>(Future<T> myFuture){
   return new Promise<T>(allowInterop((resolve, reject) {
      myFuture.then(resolve, onError: reject);
   }));
}

Future<T>
futureFromPromise<T>(Promise<T> myPromise){
   final completer = new Completer<T>();
   myPromise.then(allowInterop(completer.complete),
      allowInterop(completer.completeError));
   return completer.future;
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
