import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:test/test.dart';

import '../lib/src/ast.parsers.dart' show ClassDeclParser;
import '../lib/src/ast.vue.parsers.clsVer.dart';
import '../lib/src/ast.codegen.dart';
import '../lib/src/ast.utils.dart';
import '../lib/src/common.dart';



Iterable<ClassDeclarationImpl>
getClasses(CompilationUnitImpl node) {
   return node.declarations.where((d) => d is ClassDeclarationImpl).whereType();
}

Iterable<T>
getClassMembers<T extends ClassMember>(ClassDeclarationImpl node) {
   return node.members.where((member) => member is T).whereType();
}

main() {
   var sources = r'''
   
   }
   ''';
   var AST     = parseCompilationUnit(sources);
   var CLS     = AST.declarations.first as ClassDeclarationImpl;
   var VUE_CLS = VueClassParser(ClassDeclParser(CLS));
   var members = CLS.members;
   
   group('VueClassParser', (){
   
   });
}





































