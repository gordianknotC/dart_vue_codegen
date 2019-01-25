//ignore_for_file: unused_shown_name, unused_import

import 'dart:io';

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/standard_ast_factory.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:front_end/src/scanner/token.dart'
   show BeginToken, KeywordToken, SimpleToken, StringToken;
import 'package:quiver/collection.dart' show DelegatingMap;
import 'package:analyzer/src/dart/ast/ast.dart';
//import './ast.vue.parsers.annVer.dart';
import 'package:common/src/common.log.dart' show Logger, ELevel;
import 'package:common/src/common.dart' show FN;




abstract class BaseAstVisitor extends RecursiveAstVisitor {
   List<AstNode> results = [];
   List entries = [];
   RecursiveAstVisitor transformer;
   RecursiveAstVisitor recorder;

   BaseAstVisitor({this.entries, this.transformer, this.recorder});
   
   use({RecursiveAstVisitor transformer, RecursiveAstVisitor recorder}) {
      this.transformer = transformer;
      this.recorder = recorder;
   }
}



class MethodBodyVisitor extends BaseAstVisitor {
   RecursiveAstVisitor transformer;
   RecursiveAstVisitor recorder;
   List<AstNode> results;
   List          entries;
   static const List default_entries = [
      BlockFunctionBodyImpl, BlockImpl, ExpressionStatementImpl,
      VariableDeclarationStatementImpl, AssignmentExpressionImpl, MethodInvocationImpl,
      ThisExpressionImpl
   ];

   factory MethodBodyVisitor({List entries = MethodBodyVisitor.default_entries}) {
      return MethodBodyVisitor(entries: entries);
   }
   
   @override
   visitThisExpression(ThisExpression node) {
      return super.visitThisExpression(node);
   }
   
   @override
   visitMethodInvocation(MethodInvocation node) {
      return super.visitMethodInvocation(node);
   }
   
   @override
   visitAssignmentExpression(AssignmentExpression node) {
      return super.visitAssignmentExpression(node);
   }
   
   @override
   visitVariableDeclarationStatement(VariableDeclarationStatement node) {
      return super.visitVariableDeclarationStatement(node);
   }
   
   @override
   visitExpressionStatement(ExpressionStatement node) {
      return super.visitExpressionStatement(node);
   }
   
   @override
   visitBlock(Block node) {
      return super.visitBlock(node);
   }
   
   @override
   visitBlockFunctionBody(BlockFunctionBody node) {
      return super.visitBlockFunctionBody(node);
   }
}