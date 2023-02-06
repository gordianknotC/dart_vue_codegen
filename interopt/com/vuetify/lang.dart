@JS()
library lang;

import "package:js/js.dart";
import "../common.dart" show JsMap, JsObj;

@anonymous
@JS()
abstract class VuetifyLanguage {
  external JsMap<String, VuetifyLocale> get locales;
  external set locales(JsMap<String, VuetifyLocale> v);
  external String get current;
  external set current(String v);
  external String t(String key, [params1, params2, params3, params4, params5]);
}

/// TODO: complete list of keys?
@anonymous
@JS()
abstract class VuetifyLocale {
  /* Index signature is not yet supported by JavaScript interop. */
}
