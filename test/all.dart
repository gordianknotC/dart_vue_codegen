import 'ast.codegen.test.dart' show TestCase_astCodegenTest;
import 'ast.parser.test.dart' show TestCase_astParserTest, TestCase_astParserFileParserTest;
import 'ast.test.dart' show TestCase_astTest;


void main() {
  TestCase_astTest();
  TestCase_astParserTest();
  TestCase_astParserFileParserTest();
  TestCase_astCodegenTest();
}
