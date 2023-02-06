import 'package:astMacro/src/io.dart';
import 'package:yaml/yaml.dart';

import "../lib/src/io.simpleserver.dart";
import "dart:io";
import 'package:path/path.dart';

final ROOT     = Directory.current.path;
final CURRENT  = join(ROOT, 'test');
const FOLDER   = 'watchedFolder';
const FILENAME = 'dump.json';
final WATCH_PTH= join(CURRENT, FOLDER);
final DUMP_PTH = join(CURRENT, FOLDER, FILENAME);
final YAML_PTH = join(CURRENT, FOLDER, 'test.yaml');

YamlMap           parsedYaml;
YamlConfig        yconfig;
DirectoryWatcher  dwatcher;
StaticServer      server;

void main([arguments]) async {
   if (arguments.length == 1 && arguments[0] == '-directRun') {
      await File(YAML_PTH).readAsString().then((str) {
         parsedYaml  = loadYaml(str);
         yconfig     = YamlConfig(parsedYaml, YAML_PTH);
      });
      dwatcher = DirectoryWatcher( config: yconfig);
      dwatcher
         ..onFileModified((stream, file){
            print('\tDetect file modified: ${file.path} ');
         })
         ..onFileCreated((stream, file){
            print('\tDetect file created: ${file.path} ');
         })
         ..onFileDeleted((stream, file){
            print('\tDetect file deleted: ${file.path}');
         })
         ..watch();

      server = StaticServer(rootPath: dirname(Platform.script.toFilePath()));
      server.start();
   }
}
