@JS("Vue")
library plugin;

import "package:js/js.dart";

typedef void PluginFunction<T>(dynamic Vue, [T options]);

@anonymous
@JS()
abstract class PluginObject<T> {
  external PluginFunction<T> get install;
  external set install(
      PluginFunction<
          T> v); /* Index signature is not yet supported by JavaScript interop. */
}
