import 'ast.codegen.test.dart' show TestCase_astCodegenTest;
import 'ast.parser.test.dart' show TestCase_astParserTest, TestCase_astParserFileParserTest;
import 'ast.test.dart' show TestCase_astTest;
import 'package_resolver.test.dart';


void main() {
  TestCase_PackageResolverTest();
  TestCase_astTest();
  TestCase_astParserTest();
  TestCase_astParserFileParserTest();
  TestCase_astCodegenTest();
  
}
