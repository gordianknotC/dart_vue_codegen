import 'dart:io';

import 'package:astMacro/src/ast.vue.template.dart';
import 'package:astMacro/src/io.dart';

import '../lib/src/ast.vue.template.parser.dart';
import 'package:test/test.dart';
import 'package:html/parser.dart' show parseFragment, parse;

var template = r"""
<template>
  <div id="app">
    getvalue:{{ getValue("hello_world", "hello world my friend", $take) - beeter }}, px:{{ px }}, x via _x:{{ x }}, hello():
    {{ hello([list, identifiers]) + foo({obj_label: obj_ident}) }}
    <div id="divA" class="list-title">Text list</div>
    <List id="ListA" :items="listItems">
      <div slot-scope="best" class="list-item1">{{ best.item.text }}</div>
    </List>
    hello world text
    <div class="list-separator"></div>

    <div class="list-title">Text & icons</div>
    <List :items="listItems" id="ListB">
      <div slot-scope="row" class="list-item2">
        <i :class="row.item.icon"></i> &nbsp {{ row.item.text[some_ident] }}
      </div>
    </List>
  </div>
</template>
""";
var template2 = r"""
<template>
   <div id="app">
      getvalue:{{ getValue("hello_world", "hello world my friend", $take) - beeter }}, px:{{ px }}, x via _x:{{ x }}, hello():
      {{ hello([list, identifiers]) + foo({obj_label: obj_ident}) }}
      <div id="divA" class="list-title">Text list</div>
      <List id="ListA" :items="listItems">
         <div slot-scope="best" class="list-item1">{{ best.item.text }}</div>
      </List>
      hello world text
      <div class="list-separator"></div>

      <div class="list-title">Text & icons</div>
      <List :items="listItems" id="ListB">
         <div slot-scope="row" class="list-item2">
            <i :class="row.item.icon"></i> &nbsp {{ row.item.text[some_ident] }}
         </div>
      </List>
   </div>
</template>

<script>
   import app from "./App.js";
   export default app;
</script>

<style lang="scss">
   $primary-color: #66615b;
   .list-item1 {
      height: 50px;
      padding-left: 20px;
      display: flex;
      align-items: center;
      box-shadow: 0 6px 10px -4px rgba(0, 0, 0, 0.15);
      color: $primary-color;
   }

   .list-item2 {
      @extend .list-item1;
      &:hover {
         transform: translateY(-2px);
         transition: transform 0.2s ease-out;
         background-color: $primary-color;
         color: white;
         cursor: pointer;
      }
   }
   .list-separator {
      margin-top: 50px;
   }
   .list-title {
      color: $primary-color;
      font-size: 18px;
      padding-left: 20px;
      margin-bottom: 10px;
   }
</style>
""";


void main(){
   /*group("Basic Test for VueTemplateVariableParser", () {
      var parser = VueTemplateVariableParser();
      //note: number
      test('parsing number', (){
         var expected = '123.45';
         var result   = parser.number.parse(expected);
         expect(result.value, expected, reason: 'expected to be $expected');

         expected = '0.235';
         result   = parser.number.parse(expected);
         expect(result.value, expected, reason: 'expected to be $expected');

         expected = '1';
         result   = parser.number.parse(expected);
         expect(result.value, expected, reason: 'expected to be $expected');
      });
      //note: double quoted string
      test('parsing String - dq_text1', (){
         var expected = "hello world's one, two! or some?";
         var result = parser.dq_text.parse(expected);
         expect(result.value, expected, reason: 'expected to be $expected');
      });
      
      test('parsing String - dq_text2', (){
         var expected = 'hello world\"s one, two! or some?';
         var result = parser.dq_text.parse(expected);
         expect(result.value, 'hello world', reason: 'expected to be $expected');
      });
      
      test('parsing String - dq_str', (){
         var expected = '"hello world\'s one, two! or some?"';
         var result = parser.dq_str.parse(expected);
         expect(result.value, expected, reason: 'expected to be $expected');
      });
      //note: single quoted string
      test('parsing String - sq_str', (){
         var expected = "'hello world\"s one, two! or some?'";
         var result = parser.sq_str.parse(expected);
         expect(result.value, expected, reason: 'expected to be $expected');
      });
      //note: variable
      test('parsing variable - 1', (){
         var expected = "best_ofMyLife_var13";
         var result = parser.variable.parse(expected);
         expect(result.value, expected, reason: 'expected to be $expected');

         expected = 'h3a_world';
         result   = parser.variable.parse(expected);
         expect(result.value, expected, reason: 'expected to be $expected');
         
         expected = 'hello_world13';
         result   = parser.variable.parse(expected);
         expect(result.value, expected, reason: 'expected to be $expected');
      });

      test('parsing variable - 2', (){
         var expected = r"$best_ofMyLife_var13";
         var result = parser.variable.parse(expected);
         result.failure('parsing sq_str failed');
         expect(result.value, expected, reason: 'expected to be $expected');
      });
      // note: propertyAccess
      test('parsing propertyAccs - 1', (){
         var expected = "target.subtarget.property";
         var result = parser.propacc.parse(expected);
         expect(result.value[1], 'property', reason: 'expected to be property');
         expect(result.value[0][0], 'target', reason: 'expected to be property');
         expect(result.value[0][1], 'subtarget', reason: 'expected to be property');
      });

      test('parsing propertyAccs - 2', (){
         var expected = "target.subtarget";
         var result = parser.propacc.parse(expected);
         expect(result.value[1], 'subtarget', reason: 'expected to be $expected');
         expect(result.value[0][0], 'target', reason: 'expected to be property');
      });
      //note: argument
      test('parsing arg', (){
         var expected = ['1', '21.34', '"better ideas in"', 'hello_world13' ];
         expected.forEach((arg){
            print('parsing arg: $arg');
            var result = parser.arg.parse(arg);
            expect(result.value, arg, reason: 'expected to be $arg');
         });
      });
      //note: method invocation
      test('parsing invoke', (){
         var expected = """hello()""";
         var result = parser.invoke.parse(expected);
         expect(result.value, ['hello', '(', null, ')'], reason: 'expected to be $expected');

         expected = """hello(1, 2, 'world')""";
         result = parser.invoke.parse(expected);
         expect(result.value, ['hello', '(', ['1','2', '\'world\''], ')'], reason: 'expected to be $expected');
      });
      //note: list
      test('parsing list', (){
         var expected = """[1,21.34, "better ideas in", hello_world13]""";
         var result = parser.list.parse(expected);
         expect(result.value, ['1', '21.34', '"better ideas in"', 'hello_world13'], reason: 'expected to be $expected');
      });
      //note: object (map)
      test('parsing label: value pairs', (){
         var expected = """hello: 'world', foo: 'bar'""";
         var result = parser.opairs.parse(expected);
         expect(result.value, [['hello', "'world'"], ['foo', "'bar'"]], reason: 'expected to be $expected');
      });
 
      test('parsing object', (){
         var expected = """{hello: 'world', foo: 'bar'}""";
         var result = parser.object.parse(expected);
         expect(result.value, [['hello', "'world'"], ['foo', "'bar'"]], reason: 'expected to be $expected');
      });
      
      test('parsing code', (){
         var expected = template;
         var result = parser.filtered_code_blocks.parse(expected);
         print('result: $result');
         
         expect(result.value.map((v) => v.value).toList(), [
            r'getValue("hello_world", "hello world my friend", $take) - beeter',
            'px',
            'x',
            'hello([list, identifiers]) + foo({obj_label: obj_ident})',
            'best.item.text',
            'row.item.text[some_ident]'
         ], reason: 'expected to be $expected');
      });

      test('parsing idents', (){
         var expected = [
            r'getValue("hello_world", $take) - beeter',
            'px',
            'x',
            'hello([list, identifiers]) + foo({obj_label: obj_ident})',
            'best.item.text',
            'row.item.text.hello_world[some_ident]'
         ];
         var expr = expected[0];
         print('parsing expr: $expr');
         var result = parser.getIdentifiers(expr);
         expect(result.toList(),
            ['getValue', r'$take', 'beeter'], reason: 'expected to be $expr');
         
         expr = expected[1];
         print('parsing expr: $expr');
         result = parser.getIdentifiers(expr);
         expect(result.toList(),
            ['px'], reason: 'expected to be $expr');

         expr = expected[2];
         print('parsing expr: $expr');
         result = parser.getIdentifiers(expr);
         expect(result.toList(),
            ['x'], reason: 'expected to be $expr');
   
         expr = expected[3];
         print('parsing expr: $expr');
         result = parser.getIdentifiers(expr);
         expect(result.toList(),
            ['hello', 'list', 'identifiers', 'foo','obj_label', 'obj_ident'], reason: 'expected to be $expr');
         
         expr = expected[4];
         print('parsing expr: $expr');
         result = parser.getIdentifiers(expr);
         expect(result.toList(),
            ['best'], reason: 'expected to be $expr');

         expr = expected[5];
         print('parsing expr: $expr');
         result = parser.getIdentifiers(expr);
         expect(result.toList(),
            ['row', 'some_ident'], reason: 'expected to be $expr');
      });
   });*/
   group('Parsing XML by XMLGrammarParser', (){
      var parserB = XMLGrammarParser();
      var parserA = XMLGrammarDefinition();

      test('parsing node2 - #ListB', (){
         var node = parseFragment(template);
         var code = node.querySelector('#ListB').outerHtml;
         print('code: $code');
         
         XTag parsed_xml = parserB.parse(code).value;
         
         expect(parsed_xml.tagname , equals('list'));
         expect(parsed_xml.attrs , equals({':items': '"listItems"', 'id': '"ListB"'}));
         expect(parsed_xml.texts, equals(null));
         
         print(parsed_xml.children.length);
         var ch1 = parsed_xml.children[0];
         print('\nch1: $ch1');
         expect(ch1.tag.tagname, equals('div'));
         expect(ch1.text.texts, equals(['&nbsp; {{ row.item.text[some_ident] }}']));
         
         print(ch1.children.length);
         var ch2 = ch1.children[0];
         print('\nch2: $ch2');
         expect(ch2.tag.tagname, equals('i'));
      });
      
      test('test parsing template', (){
         var node = parseFragment(template);
         var code = node.outerHtml;
         print('code: $code');
   
         XTag parsed_xml = parserB.parse(code).value;
   
         expect(parsed_xml.tagname , equals('template'));
         expect(parsed_xml.attrs , equals(null));
         expect(parsed_xml.texts, equals(null));
   
         var ch1 = parsed_xml.children[0];
         print('\nch1: $ch1');
         expect(ch1.tag.tagname , equals('div'));
         expect(ch1.attrs.attrs , equals({'id': '"app"'}));
         /*expect(ch1.text.texts, equals(
            [
               r'getvalue:{{ getValue("hello_world", "hello world my friend", $take) - beeter }}, px:{{ px }}, x via _x:{{ x }}, hello():\n'
                +  '    {{ hello([list, identifiers]) + foo({obj_label: obj_ident}) }}',
               'hello world text'
            ]
         ));*/
         var ch2 = ch1.children[0];
         print('\nch2: $ch2');
         expect(ch2.tag.tagname , equals('div'));
         expect(ch2.attrs.attrs , equals({'id': '"divA"', 'class': '"list-title"'}));
         expect(ch2.text.texts, equals(['Text list']));
      });

      test('test parsing template2', (){
         var node = parseFragment('<vue>$template2</vue>');
         var code = node.querySelector('vue').querySelector('template').outerHtml;
         print('code: $code');
   
         XTag parsed_xml = parserB.parse(code).value;
   
         expect(parsed_xml.tagname , equals('template'));
         expect(parsed_xml.attrs , equals(null));
         expect(parsed_xml.texts, equals(null));
   
         var ch1 = parsed_xml.children[0];
         print('\nch1: $ch1');
         expect(ch1.tag.tagname , equals('div'));
         expect(ch1.attrs.attrs , equals({'id': '"app"'}));
         /*expect(ch1.text.texts, equals(
            [
               r'getvalue:{{ getValue("hello_world", "hello world my friend", $take) - beeter }}, px:{{ px }}, x via _x:{{ x }}, hello():\n'
                +  '    {{ hello([list, identifiers]) + foo({obj_label: obj_ident}) }}',
               'hello world text'
            ]
         ));*/
         var ch2 = ch1.children[0];
         print('\nch2: $ch2');
         expect(ch2.tag.tagname , equals('div'));
         expect(ch2.attrs.attrs , equals({'id': '"divA"', 'class': '"list-title"'}));
         expect(ch2.text.texts, equals(['Text list']));
      });
   });
   
   
   
   group('Test for VueTemplateParser', (){
      var block_parser = VueMustacheBlockParser();
      var block_grammar = VueMustacheBlockGrammarDefinition();
      var vars_parser  = VueVariableParser();
      var vars_grammar     = VueVariableGrammarDefinition();
      
      test('parsing arguments', (){
         var parser = vars_grammar.build(start: vars_grammar.args);
         var codeB = r'"hello_world","hello_world", "hello world my friend", $take';
         var result = parser.parse(codeB).value as TArgs;
         print('result: $result');
         expect((result.idents), equals([
             r'$take'
         ]));
      });
      
      test('parsing invocation', (){
         var parser = vars_grammar.build(start: vars_grammar.invoke);
         var code = r'getValue("hello_world", "hello world my friend", $take) - beeter';
         var result = parser.parse(code).value as TInvoke;
         
         print('result: $result');
         expect((result.references), equals([
            'getValue', r'$take'
         ]));
      });
      
      test('fetching references by vars_parser', (){
         var code = r'  hello():   getvalueB:{{ getValue("hello_world", "hello world my friend", $take) - beeter }}, px:{{if( k == 3) px}}, x via _x:{{ x }}, hello():';
         var parser = block_grammar.build(start: block_grammar.code_blocks);
         var result = parser.parse(code).value.map((v) => v.value).toList();
         var r0 = vars_parser.parse(result[0]).value;
         print('r0: $r0');
         
         expect(r0, unorderedEquals([
            'getValue', r'$take', 'beeter'
         ]));
      });

      test('fetching references on code', (){
         var code = r'  hello():   getvalueB:{{ getValue("hello_world", "hello world my friend", $take) - beeter }}, px:{{if( k == 3) px}}, x via _x:{{ x }}, hello():';
         var result = block_parser.parse(code).value;
         print('result: $result');
         expect(result, unorderedEquals([
            'x', 'k', 'px', 'getValue', r'$take', 'beeter'
         ]));
      });
   });
   
   group('Test VueTemplateParser for parsing Vue File', (){
      //todo;
      var filename   = 'assets.vue_templateA.vue';
      var vue_string = readFileAsStringSync(getScriptPath(Platform.script), filename);
      var vue_dom    = parse(vue_string);
      var script_dom = vue_dom.querySelector('script');
      
      print('vue_string: $vue_string');
      var parser = VueTemplate(raw_data:vue_string);
      test('basic test', (){
      
      });
   });
}
























