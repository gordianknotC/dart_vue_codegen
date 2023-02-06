import 'dart:io';
import 'package:dart_io/dart_io.dart' as io;
import 'package:dart_common/dart_common.dart' as _;


class Nullable {
   const Nullable();
}
const nullable = Nullable();

class PackageResolver{
   static Map<String, PackageResolver>configs = {};
   Map<String, String> packages = {};
   
   factory PackageResolver({String cfg_path}){
      cfg_path ??= Platform.packageConfig;
      if (cfg_path == null){
         var current = io.getScriptPath(Platform.script);
         var cfg = io.Path.join(current, '.packages');
         var founded = File(cfg).existsSync();

         _.raise(
            ".packages config not found!\n"
            "configs.keys: ${configs.keys}\n"
            "try searching config: $cfg in current directory\n"
            "config exists: $founded"
         );
         if (founded)
            cfg_path = cfg;
         else
            throw Exception('.packages not found');
      }
      cfg_path = io.Path.rectifyPath(cfg_path);
      if(configs.containsKey(cfg_path))
         return configs[cfg_path];
      return PackageResolver.init(cfg_path);
   }
   
   bool isRelative(String path){
      if (path.startsWith('file:///') || path.startsWith('[A-Za-z]:')) return false;
      return true;
   }
   
   bool isRelImport(String path){
      return !isPkgImport(path) && !isBuildinImport(path);
   }
   
   bool isPkgImport(String path){
      return path.startsWith('package:');
   }
   
   bool isBuildinImport(String path){
      return path.startsWith('dart:');
   }
   
   void addPackage({String pkgcfg, String pkg_name, String pkg_path}){
      if (pkgcfg != null){
         var resolved = _parseCfgLine(pkgcfg);
         pkg_name ??= resolved[0];
         pkg_path ??= resolved[1];
      }
      packages[pkg_name] = pkg_path;
   }
   
   String getPathFromPkgName(String name){
      return packages[name];
   }
   
   String getRealPathFromImport(String import_path, String file_path){
      var resolved = _parseImportPath(import_path, file_path);
      if (resolved != null)
         return resolved[1];
      return null;
   }
   
   String _resolvePkgNameFromRelImport(String file_path){
   }
   
   @nullable
   List<String> _parseImportPath(String import_path, String file_path){
      var segs = _.FN.split(import_path, ":", 2);
      var isbuilding = isBuildinImport(import_path);
      var ispkg      = isPkgImport(import_path);
      var package_paths = <String>[];
      String base_path, package_name;
      if (isbuilding) return null;
      if (ispkg) {
         package_paths = _.FN.split(segs[1], '/', 1);
         package_name  = package_paths[0];
         base_path     = packages[package_name];
         if (package_paths.length == 0)
            package_paths = ['${package_name}.dart'];
      }else {
         package_name  = _resolvePkgNameFromRelImport(file_path);
         package_paths = [null, import_path];
         base_path     = file_path == null || file_path == ''
                         ? null
                         : io.Path.dirname(file_path);
      }
      
      if (base_path == null || package_name == null){
         if (package_name == null){
            _.raise(
               '\n[Warning] Failed to resolve package name on import clause: $import_path.\n'
               'possibliy caused by an relative import caluse on file: $file_path.\n'
               'package_name: $package_name, base_path: $base_path'
            );
            package_name = '';
         }else{
            _.raise('Resolving package path: ${segs.join(':')} failed.\n'
               'package_name: $package_name, base_path: $base_path');
            return null;
         }
      }
      return [package_name, io.Path.join(base_path, package_paths[1])];
   }
   
   List<String> _parseCfgLine(String pth){
      if (pth.startsWith('package:')){
         //ex:package:astMacro
         return _parseCfgLine(pth.substring(8));
      }else if(pth.startsWith('dart:')){
         //ex: dart:io
         throw Exception('Building path not supported');
      }else{
         if (pth.indexOf(':') == -1){
            //ex astMacro
            throw Exception('invalid path');
         }else{
            // ex: astMacro: e:/src
            var name = pth.substring(0, pth.indexOf(':'));
            var pkg_path = io.Path.rectifyPath(pth.substring(name.length + 1));
            // ensures every paths in configs are absolute paths;
            if (isRelative(pkg_path))
               pkg_path = io.Path.rectifyPath(io.Path.absolute(pkg_path));
            return [name, pkg_path];
         }
      }
   }
   
   Map<String, String> parsePackageCfg(String config_path){
      return _.Dict<String, String>(
         File(io.Path.rectifyPath(config_path))
            .readAsStringSync().trim().split('\n')
            .map((line){
            var name_pth_pair = _parseCfgLine(line);
            var package_name = name_pth_pair[0];
            var package_path = name_pth_pair[1];
            return MapEntry(package_name, package_path);
         }
         ).toList()
      );
   }
   
   PackageResolver.init(String config_path){
      configs[config_path] = this;
      packages = parsePackageCfg(config_path);
   }
}
