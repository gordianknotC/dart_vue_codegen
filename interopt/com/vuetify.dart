@JS()
library vuetify;
import "package:js/js_util.dart";
import "package:js/js.dart";
import "vuetify/lang.dart" show VuetifyLanguage;
import "package:func2/func.dart";
import "vue.mod.dart" show Vue, DirectiveOptions, ComponentOptions;
import "common.dart" show JsMap, JsObj, Promise;

/*@JS()
external Vuetify
    get Vuetify;*/ /* WARNING: export assignment not yet supported. */

typedef PluginFunction<E> = void Function(Vue vue, E options);

@anonymous
@JS()
abstract class Vuetify {
  external PluginFunction<VuetifyUseOptions> get install;
  external set install(PluginFunction<VuetifyUseOptions> v);
  external String get version;
  external set version(String v);
  external factory Vuetify(
      {PluginFunction<VuetifyUseOptions> install, String version});
}

/*export type ComponentOrPack = Component & { $_vuetify_subcomponents?: JsMap<string, ComponentOrPack> }*/
@anonymous
@JS()
abstract class VuetifyUseOptions {
  external JsMap<String, Vue> get transitions;
  external set transitions(JsMap<String, Vue> v);
  external JsMap<String, DirectiveOptions> get directives;
  external set directives(JsMap<String, DirectiveOptions> v);
  external JsMap<String,
     ComponentOptions /*Component&{ $_vuetify_subcomponents?: JsMap<string, ComponentOrPack> }*/ >
      get components;
  external set components(
      JsMap<String,
         ComponentOptions /*Component&{ $_vuetify_subcomponents?: JsMap<string, ComponentOrPack> }*/ > v);

  /// @see https://vuetifyjs.com/style/theme
  external dynamic /*Partial<VuetifyTheme>|*/ get theme;
  external set theme(dynamic /*Partial<VuetifyTheme>|*/ v);
  external get JS$false;
  external set JS$false(v);

  /// Select a base icon font to use. Note that none of these are included, you must install them yourself
  /// md: <a href="https://material.io/icons">material.io</a> (default)
  /// mdi: <a href="https://materialdesignicons.com">MDI</a>
  /// fa: <a href="https://fontawesome.com/get-started/web-fonts-with-css">FontAwesome 5</a>
  /// fa4: <a href="">FontAwesome 4</a> TODO: link
  external String /*'md'|'mdi'|'fa'|'fa4'*/ get iconfont;
  external set iconfont(String /*'md'|'mdi'|'fa'|'fa4'*/ v);

  /// Override specific icon names. You can also specify your own custom ones that can then be accessed from v-icon
  /// @example &lt;v-icon&gt;$vuetify.icons.(name)&lt;/v-icon&gt;
  external VuetifyIcons get icons;
  external set icons(VuetifyIcons v);

  /// @see https://vuetifyjs.com/style/theme#options
  external VuetifyOptions get options;
  external set options(VuetifyOptions v);
  external VuetifyLanguage get lang;
  external set lang(VuetifyLanguage v);
  external bool get rtl;
  external set rtl(bool v);
  external factory VuetifyUseOptions(
      {JsMap<String, Vue> transitions,
      JsMap<String, DirectiveOptions> directives,
      JsMap<String,
          ComponentOptions /*Component&{ $_vuetify_subcomponents?: JsMap<string, ComponentOrPack> }*/ > components,
      dynamic /*Partial<VuetifyTheme>|*/ theme,
      JS$false,
      String /*'md'|'mdi'|'fa'|'fa4'*/ iconfont,
         VuetifyIcons icons,
         VuetifyOptions options,
         VuetifyLanguage lang,
      bool rtl});
}

@anonymous
@JS()
abstract class VuetifyObject implements Vue {
  external VuetifyBreakpoint get breakpoint;
  external set breakpoint(VuetifyBreakpoint v);
  external bool get dark;
  external set dark(bool v);
  external Func2Opt1<dynamic/*=T*/, VuetifyGoToOptions, Promise<dynamic/*=T*/ >>
      get goTo;
  external set goTo(
      Func2Opt1<dynamic/*=T*/, VuetifyGoToOptions, Promise<dynamic/*=T*/ >> v);
  external List<VuetifyLanguage> get t;
  external set t(List<VuetifyLanguage> v);
  external factory VuetifyObject(
      {VuetifyBreakpoint breakpoint,
      bool dark,
      Func2Opt1<dynamic/*=T*/, VuetifyGoToOptions,
          Promise<dynamic/*=T*/ >> goTo,
      List<VuetifyLanguage> t});
}

// Module vue/types/vue
@anonymous
@JS()
abstract class Vue {
  external VuetifyObject get $vuetify;
  external set $vuetify(VuetifyObject v);
  external factory Vue({VuetifyObject $vuetify});
}

// End module vue/types/vue
@anonymous
@JS()
abstract class VuetifyIcons {
  /* Index signature is not yet supported by JavaScript interop. */
  external String get cancel;
  external set cancel(String v);
  external String get close;
  external set close(String v);
  external String get delete;
  external set delete(String v);
  external String get clear;
  external set clear(String v);
  external String get success;
  external set success(String v);
  external String get info;
  external set info(String v);
  external String get warning;
  external set warning(String v);
  external String get error;
  external set error(String v);
  external String get prev;
  external set prev(String v);
  external String get next;
  external set next(String v);
  external String get checkboxOn;
  external set checkboxOn(String v);
  external String get checkboxOff;
  external set checkboxOff(String v);
  external String get checkboxIndeterminate;
  external set checkboxIndeterminate(String v);
  external String get delimiter;
  external set delimiter(String v);
  external String get sort;
  external set sort(String v);
  external String get expand;
  external set expand(String v);
  external String get menu;
  external set menu(String v);
  external String get subgroup;
  external set subgroup(String v);
  external String get dropdown;
  external set dropdown(String v);
  external String get radioOn;
  external set radioOn(String v);
  external String get radioOff;
  external set radioOff(String v);
  external String get edit;
  external set edit(String v);
  external String get ratingEmpty;
  external set ratingEmpty(String v);
  external String get ratingFull;
  external set ratingFull(String v);
  external String get ratingHalf;
  external set ratingHalf(String v);
}

@anonymous
@JS()
abstract class VuetifyApplication {
  external num get bar;
  external set bar(num v);
  external num get bottom;
  external set bottom(num v);
  external num get footer;
  external set footer(num v);
  external num get left;
  external set left(num v);
  external num get right;
  external set right(num v);
  external num get top;
  external set top(num v);
  external void bind(num uid, String target, num value);
  external void unbind(num uid, String target);
  external void update(String target);
}

@anonymous
@JS()
abstract class VuetifyBreakpoint {
  external num get height;
  external set height(num v);
  external bool get lg;
  external set lg(bool v);
  external bool get lgAndDown;
  external set lgAndDown(bool v);
  external bool get lgAndUp;
  external set lgAndUp(bool v);
  external bool get lgOnly;
  external set lgOnly(bool v);
  external bool get md;
  external set md(bool v);
  external bool get mdAndDown;
  external set mdAndDown(bool v);
  external bool get mdAndUp;
  external set mdAndUp(bool v);
  external bool get mdOnly;
  external set mdOnly(bool v);
  external String get name;
  external set name(String v);
  external bool get sm;
  external set sm(bool v);
  external bool get smAndDown;
  external set smAndDown(bool v);
  external bool get smAndUp;
  external set smAndUp(bool v);
  external bool get smOnly;
  external set smOnly(bool v);
  external num get width;
  external set width(num v);
  external bool get xl;
  external set xl(bool v);
  external bool get xlOnly;
  external set xlOnly(bool v);
  external bool get xs;
  external set xs(bool v);
  external bool get xsOnly;
  external set xsOnly(bool v);
  external factory VuetifyBreakpoint(
      {num height,
      bool lg,
      bool lgAndDown,
      bool lgAndUp,
      bool lgOnly,
      bool md,
      bool mdAndDown,
      bool mdAndUp,
      bool mdOnly,
      String name,
      bool sm,
      bool smAndDown,
      bool smAndUp,
      bool smOnly,
      num width,
      bool xl,
      bool xlOnly,
      bool xs,
      bool xsOnly});
}

/*export type VuetifyThemeItem = string | number | {
  base: string | number
  lighten5: string | number
  lighten4: string | number
  lighten3: string | number
  lighten2: string | number
  lighten1: string | number
  darken1: string | number
  darken2: string | number
  darken3: string | number
  darken4: string | number
}*/
@anonymous
@JS()
abstract class VuetifyTheme {
  /* Index signature is not yet supported by JavaScript interop. */
  external dynamic
      /*String|num|{
  base: string | number
  lighten5: string | number
  lighten4: string | number
  lighten3: string | number
  lighten2: string | number
  lighten1: string | number
  darken1: string | number
  darken2: string | number
  darken3: string | number
  darken4: string | number
}*/
      get primary;
  external set primary(
      dynamic /*String|num|{
  base: string | number
  lighten5: string | number
  lighten4: string | number
  lighten3: string | number
  lighten2: string | number
  lighten1: string | number
  darken1: string | number
  darken2: string | number
  darken3: string | number
  darken4: string | number
}*/
      v);
  external dynamic
      /*String|num|{
  base: string | number
  lighten5: string | number
  lighten4: string | number
  lighten3: string | number
  lighten2: string | number
  lighten1: string | number
  darken1: string | number
  darken2: string | number
  darken3: string | number
  darken4: string | number
}*/
      get accent;
  external set accent(
      dynamic /*String|num|{
  base: string | number
  lighten5: string | number
  lighten4: string | number
  lighten3: string | number
  lighten2: string | number
  lighten1: string | number
  darken1: string | number
  darken2: string | number
  darken3: string | number
  darken4: string | number
}*/
      v);
  external dynamic
      /*String|num|{
  base: string | number
  lighten5: string | number
  lighten4: string | number
  lighten3: string | number
  lighten2: string | number
  lighten1: string | number
  darken1: string | number
  darken2: string | number
  darken3: string | number
  darken4: string | number
}*/
      get secondary;
  external set secondary(
      dynamic /*String|num|{
  base: string | number
  lighten5: string | number
  lighten4: string | number
  lighten3: string | number
  lighten2: string | number
  lighten1: string | number
  darken1: string | number
  darken2: string | number
  darken3: string | number
  darken4: string | number
}*/
      v);
  external dynamic
      /*String|num|{
  base: string | number
  lighten5: string | number
  lighten4: string | number
  lighten3: string | number
  lighten2: string | number
  lighten1: string | number
  darken1: string | number
  darken2: string | number
  darken3: string | number
  darken4: string | number
}*/
      get info;
  external set info(
      dynamic /*String|num|{
  base: string | number
  lighten5: string | number
  lighten4: string | number
  lighten3: string | number
  lighten2: string | number
  lighten1: string | number
  darken1: string | number
  darken2: string | number
  darken3: string | number
  darken4: string | number
}*/
      v);
  external dynamic
      /*String|num|{
  base: string | number
  lighten5: string | number
  lighten4: string | number
  lighten3: string | number
  lighten2: string | number
  lighten1: string | number
  darken1: string | number
  darken2: string | number
  darken3: string | number
  darken4: string | number
}*/
      get warning;
  external set warning(
      dynamic /*String|num|{
  base: string | number
  lighten5: string | number
  lighten4: string | number
  lighten3: string | number
  lighten2: string | number
  lighten1: string | number
  darken1: string | number
  darken2: string | number
  darken3: string | number
  darken4: string | number
}*/
      v);
  external dynamic
      /*String|num|{
  base: string | number
  lighten5: string | number
  lighten4: string | number
  lighten3: string | number
  lighten2: string | number
  lighten1: string | number
  darken1: string | number
  darken2: string | number
  darken3: string | number
  darken4: string | number
}*/
      get error;
  external set error(
      dynamic /*String|num|{
  base: string | number
  lighten5: string | number
  lighten4: string | number
  lighten3: string | number
  lighten2: string | number
  lighten1: string | number
  darken1: string | number
  darken2: string | number
  darken3: string | number
  darken4: string | number
}*/
      v);
  external dynamic
      /*String|num|{
  base: string | number
  lighten5: string | number
  lighten4: string | number
  lighten3: string | number
  lighten2: string | number
  lighten1: string | number
  darken1: string | number
  darken2: string | number
  darken3: string | number
  darken4: string | number
}*/
      get success;
  external set success(
      dynamic /*String|num|{
  base: string | number
  lighten5: string | number
  lighten4: string | number
  lighten3: string | number
  lighten2: string | number
  lighten1: string | number
  darken1: string | number
  darken2: string | number
  darken3: string | number
  darken4: string | number
}*/
      v);
}

@anonymous
@JS()
abstract class VuetifyThemeCache {
  external Func1<VuetifyTheme, String /*String|Null*/ > get JS$get;
  external set JS$get(Func1<VuetifyTheme, String /*String|Null*/ > v);
  external VoidFunc2<VuetifyTheme, String> get JS$set;
  external set JS$set(VoidFunc2<VuetifyTheme, String> v);
  external factory VuetifyThemeCache(
      {Func1<VuetifyTheme, String /*String|Null*/ > JS$get,
      VoidFunc2<VuetifyTheme, String> JS$set});
}

@anonymous
@JS()
abstract class VuetifyOptions {
  external Func1<String, String> /*Func1<String, String>|Null*/ get minifyTheme;
  external set minifyTheme(
      Func1<String, String> /*Func1<String, String>|Null*/ v);
  external VuetifyThemeCache /*VuetifyThemeCache|Null*/ get themeCache;
  external set themeCache(VuetifyThemeCache /*VuetifyThemeCache|Null*/ v);
  external bool get customProperties;
  external set customProperties(bool v);

  /// @see https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/script-src#Unsafe_inline_script
  external String /*String|Null*/ get cspNonce;
  external set cspNonce(String /*String|Null*/ v);
  external factory VuetifyOptions(
      {Func1<String, String> /*Func1<String, String>|Null*/ minifyTheme,
      VuetifyThemeCache /*VuetifyThemeCache|Null*/ themeCache,
      bool customProperties,
      String /*String|Null*/ cspNonce});
}

/*export type VuetifyGoToEasing =
  ((t: number) => number) |
  'linear' |
  'easeInQuad' |
  'easeOutQuad' |
  'easeInOutQuad' |
  'easeInCubic' |
  'easeOutCubic' |
  'easeInOutCubic' |
  'easeInQuart' |
  'easeOutQuart' |
  'easeInOutQuart' |
  'easeInQuint' |
  'easeOutQuint' |
  'easeInOutQuint'*/
@anonymous
@JS()
abstract class VuetifyGoToOptions {
  external num get duration;
  external set duration(num v);
  external num get offset;
  external set offset(num v);
  external dynamic /*Func1<num, num>|'linear'|'easeInQuad'|'easeOutQuad'|'easeInOutQuad'|'easeInCubic'|'easeOutCubic'|'easeInOutCubic'|'easeInQuart'|'easeOutQuart'|'easeInOutQuart'|'easeInQuint'|'easeOutQuint'|'easeInOutQuint'*/ get easing;
  external set easing(
      dynamic /*Func1<num, num>|'linear'|'easeInQuad'|'easeOutQuad'|'easeInOutQuad'|'easeInCubic'|'easeOutCubic'|'easeInOutCubic'|'easeInQuart'|'easeOutQuart'|'easeInOutQuart'|'easeInQuint'|'easeOutQuint'|'easeInOutQuint'*/ v);
  external factory VuetifyGoToOptions(
      {num duration,
      num offset,
      dynamic /*Func1<num, num>|'linear'|'easeInQuad'|'easeOutQuad'|'easeInOutQuad'|'easeInCubic'|'easeOutCubic'|'easeInOutCubic'|'easeInQuart'|'easeOutQuart'|'easeInOutQuart'|'easeInQuint'|'easeOutQuint'|'easeInOutQuint'*/ easing});
}
