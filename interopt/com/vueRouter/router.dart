@JS()
library router;

import "package:js/js.dart";
import "package:func2/func.dart";
import "vue.dart" show Vue;

/*type Component = ComponentOptions<Vue> | typeof Vue | AsyncComponent;*/
@anonymous
@JS()
abstract class Dictionary<T> {
  /* Index signature is not yet supported by JavaScript interop. */
}

typedef void ErrorHandler(
    Error err); /*export type RouterMode = "hash" | "history" | "abstract";*/
/*export type RawLocation = string | Location;*/
/*export type RedirectOption = RawLocation | ((to: Route) => RawLocation);*/
typedef dynamic NavigationGuard<V extends Vue>(
    Route to, Route from, void next([dynamic/*=String | Location |*/ to]));

@JS()
class VueRouter {
  // @Ignore
  VueRouter.fakeConstructor$();
  external factory VueRouter([RouterOptions options]);
  external Vue get app;
  external set app(Vue v);
  external String /*'hash'|'history'|'abstract'*/ get mode;
  external set mode(String /*'hash'|'history'|'abstract'*/ v);
  external Route get currentRoute;
  external set currentRoute(Route v);
  external Function beforeEach(NavigationGuard guard);
  external Function beforeResolve(NavigationGuard guard);
  external Function afterEach(dynamic hook(Route to, Route from));
  external void push(dynamic /*String|Location*/ location,
      [Function onComplete, ErrorHandler onAbort]);
  external void replace(dynamic /*String|Location*/ location,
      [Function onComplete, ErrorHandler onAbort]);
  external void go(num n);
  external void back();
  external void forward();
  external List<dynamic /*ComponentOptions<Vue>|dynamic|AsyncComponent*/ >
      getMatchedComponents([dynamic /*String|Location|Route*/ to]);
  external void onReady(Function cb, [ErrorHandler errorCb]);
  external void onError(ErrorHandler cb);
  external void addRoutes(List<RouteConfig> routes);
  external dynamic
      /*{
    location: Location;
    route: Route;
    href: string;
    // backwards compat
    normalizedTo: Location;
    resolved: Route;
  }*/
      resolve(dynamic /*String|Location*/ to, [Route current, bool append]);
  external static PluginFunction get install;
  external static set install(PluginFunction v);
}
typedef PluginFunction = void Function(Vue vue, dynamic options);

@anonymous
@JS()
abstract class Position {
  external num get x;
  external set x(num v);
  external num get y;
  external set y(num v);
  external factory Position({num x, num y});
}

/*type PositionResult = Position | { selector: string, offset?: Position } | void;*/
@anonymous
@JS()
abstract class RouterOptions {
  external List<RouteConfig> get routes;
  external set routes(List<RouteConfig> v);
  external String /*'hash'|'history'|'abstract'*/ get mode;
  external set mode(String /*'hash'|'history'|'abstract'*/ v);
  external bool get fallback;
  external set fallback(bool v);
  external String get base;
  external set base(String v);
  external String get linkActiveClass;
  external set linkActiveClass(String v);
  external String get linkExactActiveClass;
  external set linkExactActiveClass(String v);
  external Func1<String, Object> get parseQuery;
  external set parseQuery(Func1<String, Object> v);
  external Func1<Object, String> get stringifyQuery;
  external set stringifyQuery(Func1<Object, String> v);
  external Func3<Route, Route, Null /*Position|Null*/,
          dynamic /*Position|{ selector: string, offset?: Position }|Null|Promise<Position|{ selector: string, offset?: Position }|Null>*/ >
      get scrollBehavior;
  external set scrollBehavior(
      Func3<Route, Route, Null /*Position|Null*/,
          dynamic /*Position|{ selector: string, offset?: Position }|Null|Promise<Position|{ selector: string, offset?: Position }|Null>*/ > v);
  external factory RouterOptions(
      {List<RouteConfig> routes,
      String /*'hash'|'history'|'abstract'*/ mode,
      bool fallback,
      String base,
      String linkActiveClass,
      String linkExactActiveClass,
      Func1<String, Object> parseQuery,
      Func1<Object, String> stringifyQuery,
      Func3<Route, Route, Null /*Position|Null*/,
          dynamic /*Position|{ selector: string, offset?: Position }|Null|Promise<Position|{ selector: string, offset?: Position }|Null>*/ > scrollBehavior});
}

typedef Object RoutePropsFunction(Route route);

@anonymous
@JS()
abstract class PathToRegexpOptions {
  external bool get sensitive;
  external set sensitive(bool v);
  external bool get strict;
  external set strict(bool v);
  external bool get end;
  external set end(bool v);
  external factory PathToRegexpOptions({bool sensitive, bool strict, bool end});
}

@anonymous
@JS()
abstract class RouteConfig {
  external String get path;
  external set path(String v);
  external String get name;
  external set name(String v);
  external dynamic /*ComponentOptions<Vue>|dynamic|AsyncComponent*/ get component;
  external set component(
      dynamic /*ComponentOptions<Vue>|dynamic|AsyncComponent*/ v);
  external Dictionary<dynamic /*ComponentOptions<Vue>|dynamic|AsyncComponent*/ >
      get components;
  external set components(
      Dictionary<dynamic /*ComponentOptions<Vue>|dynamic|AsyncComponent*/ > v);
  external dynamic /*String|Location|Func1<Route, String|Location>*/ get redirect;
  external set redirect(
      dynamic /*String|Location|Func1<Route, String|Location>*/ v);
  external dynamic /*String|List<String>*/ get alias;
  external set alias(dynamic /*String|List<String>*/ v);
  external List<RouteConfig> get children;
  external set children(List<RouteConfig> v);
  external dynamic get meta;
  external set meta(dynamic v);
  external NavigationGuard get beforeEnter;
  external set beforeEnter(NavigationGuard v);
  external dynamic /*bool|Object|RoutePropsFunction*/ get props;
  external set props(dynamic /*bool|Object|RoutePropsFunction*/ v);
  external bool get caseSensitive;
  external set caseSensitive(bool v);
  external PathToRegexpOptions get pathToRegexpOptions;
  external set pathToRegexpOptions(PathToRegexpOptions v);
  external factory RouteConfig(
      {String path,
      String name,
      dynamic /*ComponentOptions<Vue>|dynamic|AsyncComponent*/ component,
      Dictionary<
          dynamic /*ComponentOptions<Vue>|dynamic|AsyncComponent*/ > components,
      dynamic /*String|Location|Func1<Route, String|Location>*/ redirect,
      dynamic /*String|List<String>*/ alias,
      List<RouteConfig> children,
      dynamic meta,
      NavigationGuard beforeEnter,
      dynamic /*bool|Object|RoutePropsFunction*/ props,
      bool caseSensitive,
      PathToRegexpOptions pathToRegexpOptions});
}

@anonymous
@JS()
abstract class RouteRecord {
  external String get path;
  external set path(String v);
  external RegExp get regex;
  external set regex(RegExp v);
  external Dictionary<dynamic /*ComponentOptions<Vue>|dynamic|AsyncComponent*/ >
      get components;
  external set components(
      Dictionary<dynamic /*ComponentOptions<Vue>|dynamic|AsyncComponent*/ > v);
  external Dictionary<Vue> get instances;
  external set instances(Dictionary<Vue> v);
  external String get name;
  external set name(String v);
  external RouteRecord get parent;
  external set parent(RouteRecord v);
  external dynamic /*String|Location|Func1<Route, String|Location>*/ get redirect;
  external set redirect(
      dynamic /*String|Location|Func1<Route, String|Location>*/ v);
  external String get matchAs;
  external set matchAs(String v);
  external dynamic get meta;
  external set meta(dynamic v);
  external Func3<Route, VoidFunc1<dynamic /*String|Location*/ >, VoidFunc0,
      dynamic> get beforeEnter;
  external set beforeEnter(
      Func3<Route, VoidFunc1<dynamic /*String|Location*/ >, VoidFunc0,
          dynamic> v);
  external dynamic /*bool|Object|RoutePropsFunction|Dictionary<bool|Object|RoutePropsFunction>*/ get props;
  external set props(
      dynamic /*bool|Object|RoutePropsFunction|Dictionary<bool|Object|RoutePropsFunction>*/ v);
  external factory RouteRecord(
      {String path,
      RegExp regex,
      Dictionary<
          dynamic /*ComponentOptions<Vue>|dynamic|AsyncComponent*/ > components,
      Dictionary<Vue> instances,
      String name,
      RouteRecord parent,
      dynamic /*String|Location|Func1<Route, String|Location>*/ redirect,
      String matchAs,
      dynamic meta,
      Func3<Route, VoidFunc1<dynamic /*String|Location*/ >, VoidFunc0,
          dynamic> beforeEnter,
      dynamic /*bool|Object|RoutePropsFunction|Dictionary<bool|Object|RoutePropsFunction>*/ props});
}

@anonymous
@JS()
abstract class Location {
  external String get name;
  external set name(String v);
  external String get path;
  external set path(String v);
  external String get hash;
  external set hash(String v);
  external Dictionary<dynamic /*String|List<String>*/ > get query;
  external set query(Dictionary<dynamic /*String|List<String>*/ > v);
  external Dictionary<String> get params;
  external set params(Dictionary<String> v);
  external bool get append;
  external set append(bool v);
  external bool get replace;
  external set replace(bool v);
  external factory Location(
      {String name,
      String path,
      String hash,
      Dictionary<dynamic /*String|List<String>*/ > query,
      Dictionary<String> params,
      bool append,
      bool replace});
}

@anonymous
@JS()
abstract class Route {
  external String get path;
  external set path(String v);
  external String get name;
  external set name(String v);
  external String get hash;
  external set hash(String v);
  external Dictionary<dynamic /*String|List<String>*/ > get query;
  external set query(Dictionary<dynamic /*String|List<String>*/ > v);
  external Dictionary<String> get params;
  external set params(Dictionary<String> v);
  external String get fullPath;
  external set fullPath(String v);
  external List<RouteRecord> get matched;
  external set matched(List<RouteRecord> v);
  external String get redirectedFrom;
  external set redirectedFrom(String v);
  external dynamic get meta;
  external set meta(dynamic v);
  external factory Route(
      {String path,
      String name,
      String hash,
      Dictionary<dynamic /*String|List<String>*/ > query,
      Dictionary<String> params,
      String fullPath,
      List<RouteRecord> matched,
      String redirectedFrom,
      dynamic meta});
}
