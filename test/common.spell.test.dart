import 'dart:io';
import 'package:test/test.dart';
import '../lib/src/common.spell.dart' ;
import '../lib/src/ast.vue.spell.dart' ;



void main() {
   var s = Behaviors.splits("hello").toList();
   group("simple spell correction test", () {
      test('split("hello")', () {
         expect(
            s,
            equals([['h', 'ello'], ['he', 'llo'], ['hel', 'lo'], ['hell', 'o'], ['hello', '']]));
      });
      
      test('deletes("hello")', () {
         print(Behaviors.deletes(Behaviors.splits("hello")).toList());
         expect(
            Behaviors.deletes(s).toList(),
            equals(['hllo', 'helo', 'helo', 'hell']),
            reason: "compare to [['h', 'ello'], ['he', 'llo'], ['hel', 'lo'], ['hell', 'o'], ['hello', '']]"
         );
      });
      
      test('transposes("hello")', () {
         var result = [['h', 'lelo'], ['he', 'llo'], ['hel', 'ol']];
         print(Behaviors.transposes(Behaviors.splits("hello")).toList());
         expect(
            Behaviors.transposes(Behaviors.splits('hello')).toList(),
            equals(['hlelo', 'hello', 'helol']),
            reason: "compare to [['h', 'ello'], ['he', 'llo'], ['hel', 'lo'], ['hell', 'o'], ['hello', '']]"
         );
      });
      test('camelCase SpliterA', () {
         expect(
            CamelCaseTyping("HelloWorldStevenHowking").words,
            orderedEquals(['Hello', 'World', 'Steven', 'Howking'])
         );
      });
      test('camelCase SpliterB', () {
         expect(
            CamelCaseTyping("Helloworldsefwoiejf").words,
            equals(["Helloworldsefwoiejf"])
         );
      });
      test('camelCase SpliterC', () {
         expect(
            CamelCaseTyping("felloworldsefwoiejf").words,
            equals(["felloworldsefwoiejf"])
         );
      });
      test('hybrit camelCase Spliter', () {
         expect(
            CamelCaseTyping("HelloWorld_Steven_Hawking").words,
            orderedEquals(["Hello", 'World', 'Steven', 'Hawking'])
         );
      });
      test('splitDict', () {
         var s = TypoSuggest();
         expect(
            s.split_dict,
            unorderedEquals([
               'before',
               'Create',
               'created',
               'Mounte',
               'mounted',
               'Update',
               'updated',
               'Destroy',
               'destroyed'
            ])
         );
      });
      test('isCamelCase', () {
         expect(
            isCamelCase('helloWorld'),
            isTrue
         );
         expect(
            isCamelCase('HelloWorld'),
            isTrue
         );
         expect(
            isCamelCase('HelloWORLD'),
            isTrue
         );
         expect(
            isCamelCase('helloWORLD'),
            isFalse
         );
      });
      
      test('camelCaseEdit("beforUpdaet")', () {
         var s = TypoSuggest();
         expect(
            s.correct("beforUpdaet").toList(),
            equals(['before', 'Update'])
         );
      });
   });

   group("Test Spell module", () {
      Spell s1;
      TypoSuggest s2, s3;
      setUp((){
         var d1 = ['hello', 'world'];
         var d2 = DICT;
         s1 = Spell(dict:d1.toSet(), camelCase: false, useCache: false, preRender: false);
         s2 = TypoSuggest();
         s3 = TypoSuggest(matcher: (db, typing){
            return db.contains(typing) || typing.contains(db);
         });
      });

      test('Pre-Test Spell for general correction', () {
         var ret1 = s1.filterWordsByKnown(['helol'].toSet());
         var ret2 = s1.filterWordsByKnown(s1.getWordTypos('helol', 1)).toList();
         var ret3 = s1.filterWordsByKnown(s1.getWordTypos('helol', 2)) ;
         expect(
           ret1,
           equals(null),
           reason: 'a typo word "helol" should not contains in dictionary'
         );

         expect(
            ret2,
            equals(['hello']),
            reason: 'a typo word "helol" should be lookup within typo possibilities of hello'
         );

         expect(
            ret3,
            equals(['hello']),
            reason: 'a typo word "helol" should be lookup within typo possibilities of hello'
         );
         
      });
      
      test('Test Spell for general correction', () {
         expect(
            s1.correct('helol'),
            equals(['hello'])
         );
         expect(
           s1.correct('wordl'),
            equals(['world'])
         );
      });
      test('Test Spell for camelCase correction', () {
         expect(
            s2.correct('updaetd'),
            equals(['updated'])
         );
         expect(
            s2.correct('beforUpdaet'),
            equals(['before', 'Update'])
         );
         expect(
            s2.correct('beforeUpdate'),
            equals(['before', 'Update'])
         );
         expect(
            s2.correct('beforedestroyed'),
            equals([])
         );
         expect(
            s2.correct('befreDestroyed'),
            equals(['before'])
         );
         expect(
            s3.correct('befreDestroyed'),
            equals(['before', 'Destroy'])
         );
      });
   });
}