import './window.dart' show win, doc, JsObj, TDescriptor;
import 'dart:js_util' show getProperty, setProperty;
import 'dart:html' show
Element, HtmlElement, ElementList, Events, Notification,
EventTarget, MutationObserver, MutationRecord;

typedef TForeachFn<T> = dynamic Function(T child, [int i]);
typedef TCloneGtrStr = Function Function({Function get, Function set});

void forEach<T>(List<T> list, TForeachFn<T> fn) {
   var l = list.length;
   for (var i = 0; i < l; i++) {
      fn(list[i], i);
   }
}

T cloneCls<T>(dynamic source, dynamic target, String level, List<String> _filtered_list, [TCloneGtrStr cb]) {
   List<String> propnames;
   List<String> filtered_list;
   propnames = JsObj.getOwnPropertyNames(target);
   filtered_list = IS.Null(level)
      ? ["length", "name"] + _filtered_list
      : ["length", "name", "prototype"] + _filtered_list;
   propnames.where((prop) => !filtered_list.contains(prop)).forEach((name) {
      var desc = JsObj.getOwnPropertyDescriptor(source, name);
      var get, set;
      if (desc != null) {
         if (desc.value != null) {
            target[source.name][name] = desc.value;
         } else {
            get = cb == null ? desc.get : cb(get: desc.get);
            set = cb == null ? desc.set : cb(set: desc.set);
            JsObj.defineProperty(target, source.name, TDescriptor(get: get, set: set));
         }
      }
   });
   return (target as T);
}
//@formatter:off
class _IS {
   bool set (Set set)             => !IS.set(set);
   bool string (String s)         => !IS.string(s);
   bool array (List<dynamic> arr) => !IS.array(arr);
   bool number (String n)         => !IS.number(n);
   bool Int (String n)            => !IS.Int(n);
   bool Null (dynamic a)          => !IS.Null(a);
   bool present(dynamic a)        => !IS.present(a);
}

class IS {
   static _IS _not;
   static get not {
      if(_not == null){
         _not = _IS();
      }
      return _not;
   }
   static bool empty(dynamic s) {
      if (s is Set) return s.isEmpty;
      if (s is String) return s.length <= 0;
      if (s is List) return s.length <= 0;
      return s == null || s == 0;
   }
   
   static bool set     (Set<dynamic> set)  => set is Set;
   static bool string  (String text)       => text is String;
   static bool array   (List<dynamic> arr) => arr is List;
   static bool Null    (dynamic a)         => a == null;
   static bool present (dynamic a)         => a != null;
   
   static bool number  (dynamic text) =>
      text is String
         ? double.parse(text) != null
         : text is num;
   
   static bool Int     (dynamic text) =>
      text is String
         ? int.parse (text) != null
         : text is int;
}
//@formatter:on
class WatchDom_OnChange {
   static final mutationObserver = getProperty(win, 'MutationObserver')
      ? MutationObserver
      : getProperty(win, 'WebKitMutationObserver');
   
   void call(Element elt, Function callback) {
      if (mutationObserver) {
         MutationObserver((List mutations, MutationObserver observer) {
            var m = (mutations[0] as MutationRecord);
            if (m.addedNodes.length > 0 || m.removedNodes.length > 0)
               callback();
         }).observe(elt, childList: true, subtree: true);
      } else {
         elt.addEventListener('DOMNodeInserted', callback, false);
         elt.addEventListener('DOMNodeRemoved', callback, false);
      }
   }
}


class TNotifyOpt {
   Function onclick;
   Function onclose;
   Function ondenied;
   String tag;
   String body;
   String icon;
   String start_url;
   String lang;
   String dir;
   
   TNotifyOpt({this.tag, this.body, this.icon, this.start_url, this.onclick, this.onclose, this.ondenied});
}

final _NOTIFY_TITLES = Set();

void notify({String title, TNotifyOpt option, bool blockReplicate = false}) {
   switch (Notification.permission) {
      case 'default':
         Notification.requestPermission().then((String permission) {
            notify(title: title, option: option);
         });
         break;
      case 'granted':
         if (title == null) break;
         if (_NOTIFY_TITLES.contains(title) && blockReplicate == true) {} else {
            _NOTIFY_TITLES.add(title);
            var o = option;
            var n = Notification(title, tag: o.tag, body: o.body, lang: o.lang, dir: o.dir, icon: o.icon);
            setProperty(n, 'onclick', () {
               o?.onclick(n);
               n.close();
            });
            setProperty(n, 'onclose', () {
               o?.onclose(n);
            });
         }
         break;
      case 'denied':
         option?.ondenied(notify); // JS: ondenied(this)
         break;
   }
}


