import 'dart:io';

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:astMacro/src/ast.parsers.dart';
import 'package:astMacro/src/ast.transformers.dart';
import 'package:astMacro/src/ast.utils.dart';
import 'package:common/src/common.dart' as _;
import 'package:test/test.dart';
import 'package:IO/src/io.dart' as io;

import 'package:astMacro/src/package_resolver.dart';

final TEST        = io.getScriptPath(Platform.script);
final PROJECT     = io.Path.join(TEST, '../');
final COMMON      = io.Path.join(PROJECT, '../common');
final default_cfg = io.Path.rectifyPath(io.Path.join(PROJECT, '.packages'));
final cfgB        = io.Path.rectifyPath(io.Path.join(COMMON, '.packages'));


TestCase_PackageResolverTest(){
   print('TEST $TEST');
   print('PROJECT $PROJECT');
   
   group('Reolve default package configs', (){
      var resA = PackageResolver();
      var resB = PackageResolver(cfg_path: cfgB);
      
      test('validate config path', (){
         expect(PackageResolver.configs.keys.toList(), [default_cfg, cfgB]);
      });
      
      test('get package path from default cfg', (){
         expect(
            resA.getPathFromPkgName('common'),
            io.Path.join(COMMON, './lib/'),
         );
         
      });
      
      test('parse package path', (){
         expect(
            resA.getRealPathFromImport('package:common/src/common.dart', ''),
            io.Path.join(COMMON, './lib/src/common.dart')
         );
         expect(
            resA.getRealPathFromImport('package:IO/src/io.dart', ''),
            io.Path.join(COMMON, '../IO/lib/src/io.dart')
         );
      });
      
      test('parse rel import path', (){
         var file = io.Path.join(COMMON, './lib/src/common.dart');
         var rel_path = '../src/common.log.dart';
         expect(
            resA.getRealPathFromImport(rel_path, file),
            io.Path.join(COMMON, './lib/src/common.log.dart')
         );
      });
      
      test ('keys on resA and keys on resB', (){
         var akeys = resA.packages.keys.toList();
         var bkeys = resB.packages.keys.toList();
         expect(
            akeys[0] == bkeys[0], isFalse
         );
      });
      
   });
}

