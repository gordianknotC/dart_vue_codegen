@JS()
library vue;

import "package:js/js.dart";
import "router.dart" show VueRouter, Route, NavigationGuard;

/// Augment the typings of Vue.js

// Module vue/types/vue
@anonymous
@JS()
abstract class Vue {
  external VueRouter get $router;
  external set $router(VueRouter v);
  external Route get $route;
  external set $route(Route v);
  external factory Vue({VueRouter $router, Route $route});
}

// End module vue/types/vue

// Module vue/types/options
@anonymous
@JS()
abstract class ComponentOptions<V extends Vue> {
  external VueRouter get router;
  external set router(VueRouter v);
  external NavigationGuard<V> get beforeRouteEnter;
  external set beforeRouteEnter(NavigationGuard<V> v);
  external NavigationGuard<V> get beforeRouteLeave;
  external set beforeRouteLeave(NavigationGuard<V> v);
  external NavigationGuard<V> get beforeRouteUpdate;
  external set beforeRouteUpdate(NavigationGuard<V> v);
  external factory ComponentOptions(
      {VueRouter router,
      NavigationGuard<V> beforeRouteEnter,
      NavigationGuard<V> beforeRouteLeave,
      NavigationGuard<V> beforeRouteUpdate});
}

// End module vue/types/options
