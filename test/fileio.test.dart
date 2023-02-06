import 'package:astMacro/src/io.codecs.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:yaml/yaml.dart';
import '../lib/src/io.dart';
import "package:glob/glob.dart";
import '../lib/src/common.dart';

//@fmt:off
final ROOT     = Directory.current.path;
final CURRENT  = path.join(ROOT, 'test');
const FOLDER   = 'watchedFolder';
const FILENAME = 'dump.json';
final WATCH_PTH= path.join(CURRENT, FOLDER);
final DUMP_PTH = path.join(CURRENT, FOLDER, FILENAME);
final YAML_PTH = path.join(CURRENT, FOLDER, 'test.yaml');
final data     = {
   'name': 'test for file dumping',
   'list': [
      1, 2, 3, 4.5
   ],
   'object': {
      'name': 'sublayer',
      'type': 'object'
   }
};
//note: dump Map Object to Yaml is not supported;
final YDATA    = loadYaml(r'''
name: vuedart_transformer_setting
variables:
  components: &components ./src/components
  layout    : &layout     ./src/layout
  assets    : &assets     ./src/assets
  modules   : &modules    ./src/lib
  finalized : &finalized  ./src/components/uiState

settings:
  file_pattern:
    - '*.vue'
    - '*.dart'
  folders:
    components: [*components ]
    layout    : [*layout ]
    static    : [*assets ]
  ignored_folders:
    finalized : [*finalized ]
'''); //@fmt:on


void main([List<String> arguments]) {
   print('arguments: $arguments');
   group('Test Platform.script for understanding how script path be resolved', (){
      test('Url what?', (){
         Uri script = Platform.script;
         //expect(script.toFilePath(windows: true), '', reason: 'toFilePath for window platform');
         expect(script.query, '', reason: 'script.query should be empty');
         //expect(script.pathSegments, '', reason: 'script.pathsegments should be');
   
      });
   });
   group('String encryption / decryption / compression / decompression', (){
      final source = "Eternal Vigilance is The Price of Freedom.";
      final key    = "encryptionKey";
      final decrypted = 'Ybx4I4c8SZcXfuAa6x0po9P/7zjEeOaf9OaK/E9mx/947Z+iYyl7JQuzc7ujWaAaOb/J/KF3vl7NGJnkZ0t7mQ==';
      test('test string encryption / decryption', (){
         expect(Str.encrypt(source, key), equals(decrypted));
         expect(Str.decrypt(decrypted, key), equals(source));
      });
      
      test('test string compression', (){
         var s = source * 110;
         var l = s.length;
         var compressed = Str.compress(s);
         /*print('${s.length}:\n$s');
         print('${compressed.length}:\n$compressed');*/
         expect(compressed.length < l, isTrue);
      });
   });
   
   group('dataUri for image', (){
   
   });
   
   group('Validate Paths', () {
      test('path validation', () {
         expect(CURRENT, equals("E:\\MyDocument\\Dart\\astMacro\\test"));
         expect(DUMP_PTH, equals("E:\\MyDocument\\Dart\\astMacro\\test\\$FOLDER\\$FILENAME"));
         expect(ROOT, equals("E:\\MyDocument\\Dart\\astMacro"));
      });
      
      test('Platform.script usage', () {
         var dir = getScriptPath(Platform.script);
         print('CURRENT:$CURRENT');
         print('dir:$dir');
         print('sep: ${path.separator}');
         print('sep2 ${Platform.pathSeparator}');
         expect(CURRENT, equals(dir));
      });
   });
   
   group('YamlConfig Tests from scratch', () {
      var encode_json, file_pattern, folders;
      YamlMap parsedYaml;
      YamlConfig yconfig;
      setUpAll(() async {
         await dumpMapToJSON(data, File(DUMP_PTH));
         await File(YAML_PTH).readAsString().then((str) {
            parsedYaml = loadYaml(str);
            GP('[setUp yaml] - readingAsync', (_) {
               print('$_ is read yaml a string? ${str is String}');
               print('$_ parsed yaml is a Map? ${parsedYaml is Map}');
               encode_json = json.encode(parsedYaml);
               print('$_ is decoded yaml a string? ${encode_json is String}');
               print('$_ is decoded yaml a Map? ${encode_json is Map}');
            }, 1);
            return loadYaml(str);
         });
         print(parsedYaml);
         yconfig = YamlConfig(parsedYaml, YAML_PTH);
         file_pattern = parsedYaml['settings']['file_pattern'];
         folders = parsedYaml['settings']['folders'];
      });
      tearDown(() {
      
      });
      group('Test file io, dump into $DUMP_PTH and read it', () {
         test('Dumping data to JSON and read it', () async {
            readJSONtoMap(File(DUMP_PTH)).then((json_content) {
               expect(json_content, TypeMatcher<Map>());
               expect(json_content['name'], equals(data['name']));
               return json_content;
            });
         });
         
         test('Read data from yaml and check it', () {
            expect(parsedYaml, TypeMatcher<Map>());
            expect(parsedYaml['name'], equals('vuedart_transformer_setting'));
            expect(parsedYaml['variables']['components'], equals('../../lib/src/components/**'));
            expect(parsedYaml['settings']['folders']['components'][0], equals(r'$components'));
         });
         
         test('Dump yaml to json', () async {
            var FILE = File(path.join(CURRENT, FOLDER, 'test.yaml.dump.json'));
            await dumpMapToJSON(Map.from(parsedYaml), FILE).then((data) {
               expect(FILE.existsSync(), equals(true));
            });
         });
         
         test('Check source path of YamlConfig', () {
            expect(yconfig.root_path, equals(path.dirname(YAML_PTH)));
         });
      });
      
      
      group('Test type conversion from Yaml type to General type', () {
         test('Converting raw yaml into YamlConfig', () {
            var cfg = YamlConfig(YAML_PTH);
            expect(cfg.name, 'vuedart_transformer_setting');
            expect(cfg.settings.folders['components'][0],
               equals(r'E:\MyDocument\Dart\astMacro\test\watchedFolder\..\..\lib\src\components\**'));
         });
         
         test('Test converting YamlList into List<dynamic>', () {
            expect(file_pattern, TypeMatcher<YamlList>());
            expect(file_pattern.toList(), TypeMatcher<List>());
         });
         
         test('Test converting YamlMap into Map<String, List>', () {
            expect(folders, TypeMatcher<YamlMap>());
            expect(Map<String, List>.from(folders), TypeMatcher<Map<String, List>>());
         });
         
         test('converting YamList into List<String> turns out tobe List<dynamic>', () {
            var list = file_pattern.map((x) => x.toString()).toList();
            expect(list is List, equals(true));
            expect(list is List<String>, equals(false));
            expect(list, TypeMatcher<List<dynamic>>());
         });
         
         test('converting YamlMap into Map<String, List<String>> turns out tobe List<dynamic>', () {
            var map = Map<String, List<dynamic>>.from(folders);
            expect(map is Map, equals(true));
            expect(map is Map<String, List>, equals(true));
            expect(map is Map<String, List<String>>, equals(false));
            expect(map, TypeMatcher<Map<String, List<dynamic>>>());
            //note:    Which: threw ?:<type 'YamlList' is not a subtype of type 'List<String>'>
            expect(() => Map<String, List<String>>.from(folders), throws);
         });
         
         test('The right way to convert YamlList into List<String>', () {
            var list = List<String>.from(file_pattern);
            expect(list is List, equals(true));
            expect(list is List<String>, equals(true));
            expect(list, TypeMatcher<List<String>>());
         });
         
         test('The right way to convert YamlMap into Map<String, List<String>>', () {
            var map = Map<String, dynamic>.from(folders).map((k, v) =>
               MapEntry<String, List<String>>(k, List<String>.from(v)));
            expect(() =>
            Map<String, List<String>>.from
               (Map<String, List<dynamic>>.from(folders)), throws);
            
            expect(map, TypeMatcher<Map<String, List>>());
            expect(map, TypeMatcher<Map<String, List<String>>>());
         });
         
         test('Test yamlListToList', () {
            var list = yamlListToList<String>(file_pattern);
            expect(list is List, equals(true));
            expect(list is List<String>, equals(true));
            expect(list, TypeMatcher<List<String>>());
         });
      });
      
      group('test YamlConfig for matching files and folders', () {
         setUpAll(() {});
         test('Testing folders for checking if its exists or not', () {
            GP("show flatten path", (_) {
               yconfig.variables.forEach((k, v) {
                  v = GlobPtnRectifier(v).head.join(systemsep);
                  var dir = Directory(v);
                  var exists = dir.existsSync();
                  print('$_ $k: $v ::$exists ::type: ${v.runtimeType}');
               });
               print('\n\n');
            });
            ;
            var sourceExists = Directory(yconfig.settings.folders['source'][0]).existsSync();
            expect(sourceExists, equals(true));
         });
         
         test('test glob pattern matching', () {
            /*var source = yconfig.variables[r'$source'];
            var comp = yconfig.variables[r'$components'];
            var assets = yconfig.variables[r'$assets'];*/
            var glob = new Glob("e:/abc/**");
            expect(glob.matches("e:/abc/foobar/test"), isTrue);
            expect(glob.matches("e:/abc/hello"), isTrue);
            expect(glob.matches("e:/abc/"), isFalse);
            expect(glob.matches("e:/abc"), isFalse);
            expect(glob.matches("e:/abc/*"), isTrue);
            
            glob = new Glob("abc\\**");
            expect(glob.matches("abc\\foobar\\test"), isFalse); //NOTE: window path not supported
            glob = new Glob("E:/MyDocument/Dart/astMacro/test/watchedFolder/lib/src/**");
            expect(glob.matches("E:/MyDocument/Dart/astMacro/test/watchedFolder/lib/src/hello"), isTrue);
            expect(glob.matches("E:/MyDocument/Dart/astMacro/test/watchedFolder/lib/src/*"), isTrue);
         });
         
         test('FN.stripRight and FN.strip', (){
            var s = "!hello??!";
            expect(FN.stripRight(s, '!'),    equals("!hello??"));
            expect(FN.stripRight(s, '?!'),   equals("!hello"));
            expect(FN.stripLeft(s, '!'),     equals("hello??!"));
            expect(FN.stripRight(s, '?!'),   equals("!hello"));
            expect(FN.stripLeft(s, '!h'),    equals("ello??!"));
            expect(FN.strip(s, '?!'),        equals("hello"));
         });
         test('Glob Pattern Rectifier for rectify bugs of glob package', (){
            var pth = "E:/MyDocument/Dart/astMacro/test/./watchedFolder/../../lib/src/**";
            var r = GlobPtnRectifier(pth);
            var pth2 = "E:/MyDocument/Dart/astMacro/test/./watchedFolder/../../lib/src/";
            var r2 = GlobPtnRectifier(pth2);
            expect(r.lastSegment, equals("**"));
            expect(r.path, equals("E:/MyDocument/Dart/astMacro/lib/src/**"));
            expect(r2.lastSegment, equals("src"));
            expect(r2.path, equals("E:/MyDocument/Dart/astMacro/lib/src/*"));
         });
         
         test('test GlobMatcher for validating glob pattern matcher', (){
            
            var folders = yconfig.folders;
            var g = GlobMatcher(includes_pattern:  folders);
            var folder = 'E:/MyDocument/Dart/astMacro/lib/src/components/hellocomp';
            var result = g.isIncluded(folder);
            
            expect(result, isTrue);
            expect(g.isIncluded('E:/MyDocument/Dart/astMacro/lib/src/layout/main.vue'), isTrue);
            expect(g.isIncluded('E:/MyDocument/Dart/astMacro/lib/src'), isTrue);
            expect(g.isIncluded('E:/MyDocument/Dart/astMacro/lib/src/com/allowed'), isTrue);
            expect(g.isIncluded('E:/MyDocument/Dart/'), isFalse);
            expect(g.isIncluded('E:/MyDocument/Dart/astMacro/lib'), isFalse);
         });

         test('test GlobMatcher for validating weather a glob pattern is within '
            'a allowed pattern and excluded by disallowed pattern', (){
            var folder = 'E:/MyDocument/Dart/astMacro/lib/src/components/hellocomp';
            var result = yconfig.isIncluded(folder);
            
            expect(result, isTrue);
            expect(yconfig.isIncluded('E:/MyDocument/Dart/astMacro/lib/src/components/uiState'),       isTrue);
            expect(yconfig.isIncluded('E:/MyDocument/Dart/astMacro/lib/src/components/uiState/hello'), isTrue);
            //excluded in ignored section
            expect(yconfig.isPermitted('E:/MyDocument/Dart/astMacro/lib/src/components/uiState'),       isFalse);
            expect(yconfig.isPermitted('E:/MyDocument/Dart/astMacro/lib/src/components/uiState/hello'), isFalse);
         });
         
         test('using Glob method', (){
            var g = Glob('*.vue');
            print('context: ${g.context}');
            print('pattern: ${g.pattern}');
            
            
            //expect(Glob.quote('*.vue'), equals(''));
            
         });
      });
   });
   
   group('Walking through FileSystem recursively by walkDir', () {
      var fetched;
      var dir;
      void setFetch(v) {
         print('setFetched to: $v');
         print('beforeSet: $fetched');
         fetched = v;
         print('afterSet: $fetched');
      }
   
      setUp(() async {
         dir = Directory(CURRENT);
         await walkDir (dir, recursive: true).then((data) {
            setFetch(data);
            print('fetched files: $data');
         });
      });
   
      test('Read fetched files and check its validity', () {
         print('fetched: $fetched');
         print('dir: $dir');
         expect(fetched.keys, contains('File: ast.test.dart'));
         expect(fetched.keys, contains('File: fileio.test.dart'));
         expect(fetched.keys, contains('Directory: watchedFolder'));
         expect(fetched.keys, unorderedEquals([
            'File: ast.codegen.test.dart',
            'File: ast.parser.test.dart',
            'File: ast.test.dart',
            'File: common.spell.test.dart',
            'File: fileio.test.dart',
            'File: index.html',
            'File: mirror.annotation.test.dart',
            'File: sampleCode.dart',
            'File: staticServer.dart',
            'File: dump.json',
            'File: temp1.txt',
            'File: temp2.txt',
            'File: temp3.txt',
            'File: temp1.txt',
            'File: temp2.txt',
            'File: test.json',
            'File: test.yaml',
            'File: test.yaml.dump.json',
            'Directory: watchedFolder',
            'Directory: subFolder'
         ]));
         //note: in recursive mode, Directories are type of SystemEntity
//         var watchedFolder = fetched['Directory: watchedFolder'];
//         expect(watchedFolder.keys, contains('File: dump.json'));
//         expect(watchedFolder.keys, contains('File: temp1.txt'));
//         expect(watchedFolder.keys, contains('File: temp2.txt'));
//         expect(watchedFolder.keys, contains('File: test.json'));
//         expect(watchedFolder.keys, contains('File: test.yaml'));
//         expect(watchedFolder.keys, contains('Directory: subFolder'));
      });
   
      test('Reading file status', () {
         TFileSystemEntity entity = List.from(fetched.values)[0];
         var stat = entity.entity.statSync();
         print('stat: $stat');
      });
   });
   
   
   group('Test General Functionig for DirectoryWalker and DirectoryWatcher', (){
      const COMP_PATH   = r"E:\MyDocument\Dart\astMacro\lib\src\components";
      YamlMap           parsedYaml;
      YamlConfig        yconfig;
      DirectoryWalker   dwalker;
      DirectoryWatcher  dwatcher;
      List<Directory>   dirs;
      List asset_files;
      List comp_files;
      List lib_files;
      List src_files;
      File appended_txt = File(path.join(WATCH_PTH, "added_for_tests.txt"));
      File appended_vue = File(path.join(COMP_PATH, "added_for_tests.vue"));
      tearDown((){
         if(appended_txt.existsSync())
            appended_txt.deleteSync();
         if(appended_vue.existsSync())
            appended_vue.deleteSync();
      });
      setUp(() async {
         if(appended_txt.existsSync())
            appended_txt.deleteSync();
         if(appended_vue.existsSync())
            appended_vue.deleteSync();
         asset_files = [
            'newsicon.png'
         ];
         comp_files = [
            'testcomp.vue'
         ];
         lib_files = [
            'astMacro.dart', 'sampleCode.dart',
         ];
         src_files = [
            'ast.utils.dart', 'common.dart', 'io.codecs.dart', 'io.dart',
            'io.glob.dart','io.util.dart', 'io.walk.dart', 'io.yamlconfig.dart'
         ];
         dirs = [
            r"E:\MyDocument\Dart\astMacro\lib\src\assets",
            r"E:\MyDocument\Dart\astMacro\lib\src\components",
            r"E:\MyDocument\Dart\astMacro\lib"
         ].map((s) => Directory(s)).toList();
         await File(YAML_PTH).readAsString().then((str) {
            parsedYaml  = loadYaml(str);
            yconfig     = YamlConfig(parsedYaml, YAML_PTH);
         });
      });
      
      test('validate setup', (){
         expect(parsedYaml, isNotNull);
         expect(yconfig, isNotNull);
      });

      group("Test Directory Walker", () {
         test('Testing for walking throught directories', () async {
            dwalker = DirectoryWalker(dirs: dirs, config: yconfig);
            expect(dwalker.root_dir.path, equals(path.join(CURRENT, FOLDER)));
            expect(dwalker.dirs_to_walk, equals(dirs));
         });
         
         test('Test _inferRootDir by clear out _root_dir and _configs', (){
            var configs = dwalker.configs;
            var root_dir = dwalker.root_dir;
            dwalker.configs = null;
            dwalker.root_dir = null;
            expect(dwalker.root_dir.path, equals(r"E:\MyDocument\Dart\astMacro\lib"));
            dwalker.configs = configs;
            dwalker.root_dir = root_dir;
         });
         
         test('Test stream eventA - walking through directories by feeding stream event;'
            '\nLet predefined glob patterns fetching for right patterns and store it as '
            'result by returning true within user callback of onFileWalk and onDirectoryWalk.', () async {
            Completer completer = Completer<TEntity>();
            TEntity result = TEntity(entity: dwalker.root_dir);
            dwalker
               ..onFileWalk((subscription, root, parent, file){
                  switch(parent.path){
                     case r"E:\MyDocument\Dart\astMacro\lib\src\assets":
                        expect(asset_files, contains(path.basename(file.path)));
                        break;
                     case r"E:\MyDocument\Dart\astMacro\lib\src\components":
                        expect(comp_files, contains(path.basename(file.path)));
                        break;
                     case r"E:\MyDocument\Dart\astMacro\lib":
                        expect(lib_files, contains(path.basename(file.path)));
                        break;
                  }
                  print("continuum on file: ${file.path}");
                  return true;
               })
               ..onDirectoryWalk((subscription, root, parent, current){
                  print("continuum on directory: ${current.path}");
                  return true;
               });
            Stream<TEntity> receiver =  dwalker.feed();
            await receiver.listen((TEntity data){
               print("list on keys: ${data.keys}");
               result = data;
            }, onDone:() {
               var keys = result.keys.toList();
               print('onDone, keys: $keys');
               expect(keys, contains("File: ${lib_files[0]}"));
               expect(keys, contains("File: ${lib_files[1]}"));
               expect(keys, contains("Directory: src"));
               
               var src = result['Directory: src'];
               expect(src.keys, unorderedEquals([
                  'File: ast.codegen.dart',
                  'File: ast.parsers.dart',
                  'File: ast.utils.dart',
                  'File: ast.visit.recorder.dart',
                  'File: ast.vue.annotation.dart',
                  'File: ast.vue.dart',
                  'File: ast.vue.parsers.dart',
                  'File: ast.vue.spell.dart',
                  'File: ast.vue.transformers.dart',
                  'File: common.dart',
                  'File: common.spell.dart',
                  'File: io.codecs.dart',
                  'File: io.dart',
                  'File: io.glob.dart',
                  'File: io.simpleserver.dart',
                  'File: io.util.dart',
                  'File: io.walk.dart',
                  'File: io.yamlconfig.dart',
                  'Directory: assets',
                  'Directory: components'
               ]));
               
               var assets = result['Directory: src']['Directory: assets'];
               expect(assets.keys, equals([]), reason: 'expect no file pattern matched within assets folder'); //note: no file patterns matched
               
               var comp = result['Directory: src']['Directory: components'];
               expect(comp.keys, equals(['File: testcomp.vue']), reason: 'expect only testcomp.vue matched within components folder');
               
               completer.complete(result);
            });
            return completer.future;
         } );

         test('Test stream eventB - walking through directories by feeding stream event;'
            '\nSkip predefined glob patterns and let user controlls which patterns should'
            'be included by returning true within user callback of onFileWalk and onDirectoryWalk.', () async {
   
            Completer completer = Completer<TEntity>();
            TEntity result = TEntity(entity: dwalker.root_dir);
            dwalker
               ..onFileWalk((subscription, root, parent, file){
                  return true;
               })
               ..onDirectoryWalk((subscription, root, parent, current){
                  //note: skip glob pattern matching
                  print('repell walking on directory: ${current.path}');
                  return false;
               });
            Stream<TEntity> receiver =  dwalker.feed();
            await receiver.listen((TEntity data){
               result = data;
            }, onDone:() {
               var keys = result.keys.toList();
               print('onDone, keys: $keys');
               var src = result['Directory: src'];
               expect(src.keys, unorderedEquals([
               ]));
               completer.complete(result);
            });
            return completer.future;
         } );
      });
      
      group("Test Directory Watcher", () {
         YamlMap           parsedYaml;
         YamlConfig        yconfig;
         DirectoryWalker   dwalker;
         DirectoryWatcher  dwatcher;
         List<Directory>   dirs;
         List asset_files;
         List comp_files;
         List lib_files;
         List src_files;
         
         setUp(() async {
            asset_files = [
               'newsicon.png'
            ];
            comp_files = [
               'testcomp.vue'
            ];
            lib_files = [
               'astMacro.dart', 'sampleCode.dart', 'vueAnnotation.dart'
            ];
            src_files = [
               'ast.utils.dart', 'common.dart', 'io.codecs.dart', 'io.dart',
               'io.glob.dart','io.util.dart', 'io.walk.dart', 'io.yamlconfig.dart'
            ];
            dirs = [
               r"E:\MyDocument\Dart\astMacro\lib\src\assets",
               r"E:\MyDocument\Dart\astMacro\lib\src\components",
               r"E:\MyDocument\Dart\astMacro\lib"
            ].map((s) => Directory(s)).toList();
            await File(YAML_PTH).readAsString().then((str) {
               parsedYaml  = loadYaml(str);
               yconfig     = YamlConfig(parsedYaml, YAML_PTH);
            });
            dwatcher = DirectoryWatcher(dirs: dirs, config: yconfig);
         });
         test('Test FileSystemEntity.watch, watching on watchedFolder and waiting for changes', () async {
            /*dwatcher
               ..onFileModified((stream, file){
               
               })
               ..onFileCreated((stream, file){
               
               })
               ..watch();
            dump("something temp", path.join())*/
            var created = [];
            var modified = [];
            var deleted = [];
            var now = () => DateTime.now().millisecondsSinceEpoch;
            Directory(WATCH_PTH).watch().listen((FileSystemEvent event){
               if(!event.isDirectory){
                  var file = File(event.path);
                  switch(event.type){
                     case FileSystemEvent.create:
                        print('\tdetect file created: ${file.path}, ${now()}');
                        created.add(file.path);
                        break;
                     case FileSystemEvent.modify:
                        print('\tdetect file modify: ${file.path}, ${now()}');
                        modified.add(file.path);
                        break;
                     case FileSystemEvent.delete:
                        print('\tdetect file delete: ${file.path}, ${now()}');
                        deleted.add(file.path);
                        break;
                     case FileSystemEvent.move:
                        print('\tdetect file move: ${file.path}, ${now()}');
                        break;
                  }
               }
            });

            expect(created, equals([]));
            expect(modified, equals([]));
            expect(deleted, equals([]));
            /*
               create file
            */
            await appended_txt.create();
            await Future.delayed(Duration(milliseconds: 50));
            expect(created,
               equals([r"E:\MyDocument\Dart\astMacro\test\watchedFolder\added_for_tests.txt"]),
               reason:"should be created");
            expect(modified,
               equals([]),
               reason:"shouldn't be modified since only created without any content within");
            expect(deleted,
               equals([]),
               reason: "shouldn't be delete");
            /*
               modify file
            */
            await appended_txt.writeAsString("hello world");
            await Future.delayed(Duration(milliseconds: 50));
            expect(created,
               equals([r"E:\MyDocument\Dart\astMacro\test\watchedFolder\added_for_tests.txt"]),
               reason: "records of created should remain the same");
            expect(modified,
               equals([ r"E:\MyDocument\Dart\astMacro\test\watchedFolder\added_for_tests.txt",
                        r"E:\MyDocument\Dart\astMacro\test\watchedFolder\added_for_tests.txt"]),
               reason: "modified event triggered twice? why?");
            expect(deleted, equals([]));
            /*
               delete file
            */
            await appended_txt.delete();
            await Future.delayed(Duration(milliseconds: 50));
            expect(created, equals([r"E:\MyDocument\Dart\astMacro\test\watchedFolder\added_for_tests.txt"]));
            expect(modified,
               equals([ r"E:\MyDocument\Dart\astMacro\test\watchedFolder\added_for_tests.txt",
               r"E:\MyDocument\Dart\astMacro\test\watchedFolder\added_for_tests.txt"]),
               reason: "modified event triggered twice? why?");
            expect(deleted, equals([r"E:\MyDocument\Dart\astMacro\test\watchedFolder\added_for_tests.txt"]));
         });
         
         test('Test DirectoryWatcher wathcing for changes', () async {
            var created    = [];
            var modified   = [];
            var deleted    = [];
            var now        = () => DateTime.now().millisecondsSinceEpoch;
            dwatcher
               ..onFileModified((stream, file){
                  modified.add(file.path);
                  print('\tDetect file modified: ${file.path}, modified:$modified');
               })
               ..onFileCreated((stream, file){
                  created.add(file.path);
                  print('\tDetect file created: ${file.path}, created:$created');
               })
               ..onFileDeleted((stream, file){
                  deleted.add(file.path);
                  print('\tDetect file deleted: ${file.path}');
               })
               ..watch();

            expect(created, equals([]));
            expect(modified, equals([]));
            expect(deleted, equals([]));
            /*
               create file
            */
            await Future.delayed(Duration(milliseconds: 100));
            await appended_vue.create();
            await Future.delayed(Duration(milliseconds: 50));
            expect(created,
               equals([appended_vue.path]),
               reason:"should be created");
            expect(modified,
               equals([]),
               reason:"shouldn't be modified since only created without any content within");
            expect(deleted,
               equals([]),
               reason: "shouldn't be delete");
            /*
               modify file
            */
            await appended_vue.writeAsString("hello world");
            await Future.delayed(Duration(milliseconds: 50));
            expect(created,
               equals([appended_vue.path]),
               reason: "records of created should remain the same");
            expect(modified,
               equals([ appended_vue.path ]),
               reason: "modified event triggered twice under infrastructure, but repelled by user script");
            expect(deleted, equals([]));
            /*
               delete file
            */
            await appended_vue.delete();
            await Future.delayed(Duration(milliseconds: 50));
            expect(created, equals([appended_vue.path]));
            expect(modified,
               equals([ appended_vue.path ]),
               reason: "modified event triggered twice under infrastructure, but repelled by user script");
            expect(deleted, equals([appended_vue.path]));
         });
      });
      
   });
   
   
}
