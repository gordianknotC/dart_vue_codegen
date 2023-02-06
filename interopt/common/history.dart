import './window.dart' show Math, console;
import './util.dart' show IS, forEach;

typedef TWalkAct = bool Function(Nodes node, [int layer, int i]);
typedef TWalkPth = List<Nodes> Function(Nodes node, [int layer]);
typedef TForeachFn<T> = dynamic Function(T child, [int i]);
typedef TCloneGtrStr = Function Function({Function get, Function set});

class Nodes {
   //@formatter:off
   int __deepest_level          = null;
   int __left                   = 0;
   int __level                  = null;
   int __sum                    = null;
   List<Nodes> _childrenNodes   = [];
   Nodes __rootNode             = null;
   Nodes _parentNode            = null;
   String _nodeName             = '';

   //@formatter:on

   static final Map<int, List<Nodes>> __cacheSiblings = {};

   static Map<int, List<Nodes>> get _cacheSiblings {
      return Nodes.__cacheSiblings;
   }

   int
   get _deepest_level {
      return this._defaults('__deepest_level');
   }

   set _deepest_level(int v) {
      bool positive;
      TWalkAct action;
      TWalkPth _path;
      TWalkPth path;
      if (this.__deepest_level != v) {
         positive = v - _deepest_level > 0;
         __deepest_level = v;
         action = (Nodes node, [l, i]) {
            node.__deepest_level = positive
               ? Math.max(v, node.__deepest_level)
               : Math.min(v, node.__deepest_level);
         };
         path = (Nodes node, [l]) => node._childrenNodes;
         _path = (Nodes node, [l]) => [node._parentNode];
         Nodes._walkChildren(this, action, path);
         Nodes._walkParent(this, action, _path);
      }
   }

   int
   get _left {
      return __left;
   }

   set _left(int number) {
      __left = number;
   }

   int
   get _level {
      return this._defaults('__level');
   }

   set _level(int v) {
      if (this.__level != v) {
         console.log('setLevel: , $_nodeName,  v: , $v');
      }
   }

   int
   get index {
      var l = _parentNode?._childrenNodes?.length;
      return l > 0
         ? _parentNode._childrenNodes.indexOf(this)
         : 0;
   }

   int
   get _sum {
      return _defaults('__sum');
   }

   set _sum(int v) {
      int deviance;
      TWalkAct action;
      TWalkPth path;
      if (__sum != v) {
         deviance = v - _sum;
         __sum = v;
         action = (node, [l, i]) {
            node.__sum += deviance;
         };
         path = (node, [i]) => [node._parentNode];
         console.log('add sum: $_nodeName, v: $v, dev: $deviance');
         if (_parentNode != null) {
            Nodes._walkParent(this, action, path);
         }
      }
   }

   Nodes
   get _rootNode {
      if (IS.not.Null(__rootNode)) return __rootNode;
      __rootNode = _findRoot();
      return __rootNode;
   }

   set _rootNode(Nodes v) {
      this.__rootNode = v;
   }

   Nodes
   get _next {
      var l = _parentNode?._childrenNodes?.length;
      if (l > 0) {
         return (index < l - 1) && (index >= 0)
            ? _parentNode._childrenNodes[index - 1]
            : null;
      }
      return null;
   }

   Nodes
   get _prev {
      var l = _parentNode?._childrenNodes?.length;
      if (l > 0) {
         return (index <= l - 1) && (index > 0)
            ? _parentNode._childrenNodes[index - 1]
            : null;
      }
      return null;
   }

   static void _walkParent(Nodes node, TWalkAct action, TWalkPth path, [int layer = 0]) {
      var parent = path(node, layer)?.first;
      if (parent != null) {
         layer += 1;
         if (action(parent, layer)) return;
         return Nodes._walkParent(parent, action, path, layer);
      }
   }

   static void _walkChildren(Nodes node, TWalkAct action, TWalkPth path, [int layer = 0]) {
      var children = path(node, layer);
      forEach<Nodes>(children, (ch, [i]) {
         if (action(ch, layer, i)) return;
         return Nodes._walkChildren(node, action, path, layer);
      });
   }

   static void _walkSiblings(Nodes node, TWalkAct act) {
      int level;
      TWalkPth path;
      TWalkAct action;
      level = node._level;
      path = (node, [l]) =>
         node._childrenNodes
            .where((c) => c._deepest_level >= level && c._level <= level);
      action = (node, [l, i]) {
         if (node._level == level) {
            return act(node, l, i);
         }
         console.log('walkSiblings, node: $node._nodeName');
      };
      Nodes._walkChildren(node._rootNode, action, path);
   }

   static List<Nodes> _getSiblings(Nodes node) {
      var ret = [],
         level = node._level;
      if (IS.Null(Nodes._cacheSiblings[level])) {
         Nodes._walkSiblings(node, (_node, [layer, i]) {
            ret.add(_node);
         });
         Nodes._cacheSiblings[level] = ret.length > 0
            ? ret
            : null;
      }
      return Nodes._cacheSiblings[level];
   }

   static Nodes _getLastSibling(Nodes node) {
      var siblings = Nodes._getSiblings(node);
      if (IS.not.Null(siblings)) {
         var id = Math.max(0, siblings.indexOf(node) - 1);
         return id > 0
            ? siblings[id]
            : null;
      }
   }

   static _findLeft(Nodes ch) {
      var parent = ch._parentNode;
      if (ch._prev != null) return ch._prev.__left + 1;
      if (ch._parentNode == null) return 0;
      if (parent._prev == null) {
         return 0;
      } else {
         if (parent._parentNode != null) {
            var last_sib = Nodes._getLastSibling(ch);
            // console.log('find last sib:', last_sib)
            if (last_sib != null) return last_sib.__left + 1;
            return 0;
         } else {
            throw Exception('Uncaught Error');
         }
      }
   }

   operator []=(String index, int value) {
      switch (index) {
         case '__level':
            this.__level = value;
            return;
         case '__deepest_level':
            this.__deepest_level = value;
            return;
         case '__sum' :
            this.__sum = value;
            return;
      }
   }

   operator [](String index) {
      switch (index) {
         case '__level':
            return this.__level;
         case '__deepest_level':
            return this.__deepest_level;
         case '__sum' :
            return this.__sum;
      }
   }

   int
   _defaults(String name) {
      if (this[name] != null) return this[name];
      this[name] = 0;
      return this[name];
   }

   Nodes
   _findRoot([int id = 0]) {
      if (IS.Null(_parentNode)) return this;
      return _findRoot(id + 1);
   }

   Nodes
   _findNode(int level, int left, int index) {
      if (level == 0) return _rootNode;
      Nodes ret;
      TWalkPth path;
      TWalkAct action;
      path = (node, [l]) => node._childrenNodes.where((c) => c._deepest_level >= level);
      action = (ch, [l, i]) {
         if (ch._level == level) {
            if (ch.__left == left && ch.index == index) {
               ret = ch;
            }
         }
      };
      Nodes._walkChildren(_rootNode, action, path);
      if (IS.Null(ret)) {
         throw Exception('Node not found,level:$level, left:$left, index:$index');
      }
      return ret;
   }

   void
   _addChildren(List<Nodes> children) {
      for (var ch in children) {
         _addChild(ch);
      }
   }

   void
   _addChild(Nodes ch) {
      var sum;
      ch._parentNode = this;
      _childrenNodes.add(ch);
      ch._level = __level + 1;
      ch._deepest_level = ch.__level + ch._deepest_level;
      ch.__left = Nodes._findLeft(ch);
      sum = ch._sum == 0
         ? 1
         : ch._sum + 1;
      _sum += sum;
      if (IS.not.Null(Nodes._cacheSiblings[ch._level]))
         Nodes._cacheSiblings[ch._level] = null;
   }

   void
   _remove() {
      var self = this,
         self_d = __deepest_level,
         self_l = __level;
      TWalkPth path;
      TWalkAct action;
      path = (node, [l]) => [node._parentNode];
      action = (node, [layer, i]) {
         node._sum -= self.__sum + 1;
         if (self_d >= node.__deepest_level) {
            node.__deepest_level = layer > 1
               ? Math.max(
               node.__deepest_level - (self_d - self_l + 1),
               node._childrenNodes.fold(0, (all, x) => Math.max(x._deepest_level, all)))
               : node.__deepest_level - (self_d - self_l + 1);
         }
      };
      Nodes._walkParent(this, action, path);
   }

   Nodes.name(this._nodeName);

   addChild(dynamic ch) {
      if (IS.array(ch)) return _addChildren(ch);
      return _addChild(ch);
   }

   addParent(Nodes parent) {
      parent.addChild(this);
      __rootNode = _findRoot();
   }

   removeParent() {
      var parent = _parentNode;
      if (IS.not.Null(parent?._parentNode)) {
         parent._parentNode.removeChild(parent);
      } else {
         throw Exception('cannot remove a root level node');
      }
   }

   removeChild(Nodes ch) {
      TWalkPth path;
      TWalkAct action;
      var parent = ch._parentNode,
         next = ch._next;
      ch._remove();
      if (IS.not.Null(parent))
         parent._childrenNodes.removeAt(parent._childrenNodes.indexOf(ch));
      if (IS.present(next)) {
         var mod_levels = {};
      }
   }
   
}
//
//class HistoryStack extends Nodes {
//}