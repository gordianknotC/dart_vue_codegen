import 'ast.vue.annotation.dart' show VUE_HOOKS;
import 'common.spell.dart' as SP;

final DICT = VUE_HOOKS.map((x) => x).toSet();


/*

   [Description]
      about matcher
      
   [EX]
      s2 = TypoSuggest();
      s3 = TypoSuggest(matcher: (db, typing){
         return db.contains(typing) || typing.contains(db);
      });
      test('Test Spell for camelCase correction', () {
         expect(
            s2.correct('befreDestroyed'),    note: default matcher: compare whole string from Destroyed
            equals(['before'])                     to Destroy, which in turns not found any matches.
         );
         expect(
            s3.correct('befreDestroyed'),    note: custom matcher: search string of Destroy within Destroyed
            equals(['before', 'Destroy'])          or in reversed, which in turn found matches.
         );
      });
*/

class TypoSuggest extends SP.Spell {
   SP.TSpellMatcher matcher;
   bool camelCase;
   bool useCache;
   bool preRender;
   
   factory TypoSuggest({bool camelCase = true, bool useCache = true, bool preRender = true, SP.TSpellMatcher matcher}){
      var ret = TypoSuggest.init(dict: DICT, camelCase: camelCase, useCache: useCache, preRender: preRender, matcher: matcher);
      return ret;
   }
   
   TypoSuggest.init({Set<String> dict, this.camelCase, this.useCache, this.preRender, this.matcher})
      :super.init(dict: dict, camelCase: camelCase, useCache: useCache, preRender: preRender, matcher: matcher);
   
   Iterable<String>
   correct(String typing) {
      return super.correct(typing);
   }
   
   bool
   isCamelCase(String name){
      return SP.isCamelCase(name);
   }
}