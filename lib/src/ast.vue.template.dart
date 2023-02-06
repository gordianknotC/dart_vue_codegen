import 'dart:io' show File;
import 'dart:math' as Math;

import 'package:html/dom.dart' show Document, DocumentFragment, Element;
import 'package:html/parser.dart' show parse, parseFragment;

import 'ast.parsers.dart';
import 'ast.vue.parsers.dart';
import 'ast.vue.template.parser.dart';

enum EStyleLang {
   stylus,
   sass,
   scss,
   less,
   css,
   postcss
}

const SUB_FILENAME = '.g.refonly.js';


String convertIntoGeneratedPath(String file_path){
   return file_path.substring(0, file_path.length - '.dart'.length) + SUB_FILENAME;
}

//@fmt:off
class VueTemplate{
   File             js_file;
   DocumentFragment vue_dom;
   VueClassParser   host;
   //--------------------------------
   List<List<String>>  script_fields;
   List<MethodsParser> script_methods;
   List<MethodsParser> script_gets;
   List<MethodsParser> script_sets;
   //--------------------------------
   VueMustacheBlockParser template_parser;
   String                _import_clause;
   Element               _style;
   EStyleLang            style_lang;
   List<String>          refs;
   
   String genRefOnlyScript(){
      if (host == null)
         return '''var app = {
            data(){}, computed(){}, methods(){}
         };
         export default app; ''';
      
      var data_fields   = host.data.data.values.where((v) => v.prop_type.named_type      != null);
      var data_methods  = host.data.data.values.where((v) => v.prop_type.generic_functype!= null);
      var computeds     = host.computed.props.values;
      var computed_sets = computeds.where((v) => v.setter_body != null);
      var computed_gets = computeds.where((v) => v.getter_body != null);
      var methods       = host.method.methods.values;
      
      script_methods ??= <MethodsParser>[]
         + methods.map((m) => m.method_body).toList()
         + data_methods.map((m) => m.method_body).toList();
      script_fields ??= <List<String>>[]
         + data_fields.map((f) => [f.name, f.prop_type.named_type.type.name]).toList();
      script_gets ??= <MethodsParser>[]
         + computed_gets.map((p) => p.getter_body).toList();
      script_sets ??= <MethodsParser>[]
         + computed_sets.map((p) => p.setter_body).toList();
      
      var data_field_codes  = data_fields?.map((f) => _genField(f.name, f.prop_type.named_type.name.name))?.toList() ?? [];
      var data_method_codes = data_methods?.map((f) => _genMethod(f.name, f.method_body))?.toList() ?? [];
      var computed_codes    = computeds.map((c) => _genComputed(c))?.join(',');
      var method_codes      = methods.map((m) => _genMethod(m.name, m.method_body))?.join(',');
      var data_codes        = (data_field_codes + data_method_codes).join(',');
      
      var for_reference_only= '''
var app = {
   data(){
      return {
        $data_codes
      }
   },
   watcher(){
   
   },
   computed(){
      $computed_codes
   },
   methods(){
      $method_codes
   },
};
export default app;
      ''';
      return for_reference_only;
   }
   
   String _genComputed(ComputedMember computed){
      var setter =  _genMethod('set', computed.setter_body);
      var getter =  _genMethod('get', computed.getter_body);
      return '''
      ${computed.name}: \{
         $getter,
         $setter
      \}
      ''';
   }
   
   String _genField(String name, String type){
      var default_value = _getTypeDefault(type);
      return '$name: $default_value,\n';
   }
   
   String _genMethod(String name, MethodsParser method) {
      if (method == null) return '';
      var standard_args = method.params.params?.params?.map((p){
         return p.name.name;
      })?.toList() ?? [];
      var default_args  = method.params.params?.default_params?.map((p){
         return '${p.name.name} = ${p.defaults.toSource()}';
      })?.toList() ?? [];
      var args = (standard_args + default_args).join(',');
      return '${name}($args){},\n';
   }
   
   String _getTypeDefault(String type_name){
      String default_value;
      switch(type_name){
         case "String": default_value = "'null'"; break;
         case "int"   :
         case "num"   : default_value = "0"; break;
         case "Map"   :
         case "Object": default_value = "{}"; break;
         case "List"  : default_value = "[]"; break;
         default:
            default_value = "null";
      }
      return default_value;
   }
   
   _scriptInit(){
      var path;
      if (host == null){
         //fixme: following code
         /*var rng        = Math.Random();
         var random_text= List.generate(5, (i) => ALPHABETIC[rng.nextInt(26)]).join('');*/
         var random_text = 'ckfgy';
         path = convertIntoGeneratedPath('./.\$generated_temp_script_$random_text.$SUB_FILENAME');
         _import_clause = '''import app from "./${path}"; export default app;''';
         js_file        = File(path);
         js_file.writeAsString(genRefOnlyScript());
      }else{
         var file = host.vue_owner; //host: vue class which host this template
         path = convertIntoGeneratedPath(file.file_path);
         _import_clause = '''import app from "./${path}"; export default app;''';
         js_file        = File(path);
         js_file.writeAsString(genRefOnlyScript());
      }
   }
   
   _styleInit(){
      var _style_lang;
      _style      = vue_dom.querySelector('vue').querySelector('style');
      _style_lang = _style.attributes['lang'].toLowerCase();
      switch(_style_lang) {
         case "stylus":
            style_lang = EStyleLang.stylus;
            break;
         case "sass":
            style_lang = EStyleLang.sass;
            break;
         case "scss":
            style_lang = EStyleLang.scss;
            break;
         case "less":
            style_lang = EStyleLang.less;
            break;
         case "postcss":
            style_lang = EStyleLang.postcss;
            break;
         default:
            style_lang = EStyleLang.css;
            break;
      }
   }
   
   _templateInit() {
      var template          = vue_dom.querySelector('vue').querySelector('template').outerHtml;
      template_parser       = VueMustacheBlockParser();
      template_parser.input = template;
      refs = template_parser.references.toList();
   }
   
   VueTemplate ({String raw_data, this.host}){
      vue_dom = parseFragment('<vue>$raw_data</vue>');
      _styleInit();
      _scriptInit();
      _templateInit();
   }
   //@fmt:on
}


