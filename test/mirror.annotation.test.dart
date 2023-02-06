import 'dart:mirrors';
import 'package:astMacro/src/common.dart';
import 'package:test/test.dart';


class ApiResource {
   final String name;
   
   const ApiResource({this.name});
}

class ApiMethod {
   final String name;
   final String path;
   final String method;
   final String description;
   
   const ApiMethod({this.name, this.path, this.method: 'GET', this.description});
}

class ApiProperty {
   final String name;
   final String description;
   final String format;
   final bool required;
   final bool ignore;
   final dynamic defaultValue;
   final dynamic minValue;
   final dynamic maxValue;
   final Map<String, String> values;
   
   const ApiProperty({this.name,
                        this.description,
                        this.format,
                        this.required: false,
                        this.ignore: false,
                        this.defaultValue,
                        this.minValue,
                        this.maxValue,
                        this.values});
}

class ApiMessage {
   final bool includeSuper;
   
   const ApiMessage({this.includeSuper: false});
}

class ApiClass {
   final String name;
   final String version;
   final String title;
   final String description;
   
   const ApiClass({this.name, this.version, this.title, this.description});
}

void _addIdSegment(String id) {
}

canonicalName(TypeMirror type) {
   if (type.originalDeclaration == reflectClass(List)) {
      return 'ListOf' + canonicalName(type.typeArguments[0]);
   } else if (type.originalDeclaration == reflectClass(Map)) {
      return 'MapOf' + canonicalName(type.typeArguments[1]);
   }
   return MirrorSystem.getName(type.simpleName);
}

_parsePathParameters(MethodMirror mm, String path) {
   var pathParams = [];
   if (path == null) return pathParams;
   
   for (int i = 0; i < mm.parameters.length; ++i) {
      var pm = mm.parameters[i];
      var methodParamName = MirrorSystem.getName(pm.simpleName);
      if (pm.isOptional || pm.isNamed) {}
      if (pm.type.simpleName != #int &&
         pm.type.simpleName != #String &&
         pm.type.simpleName != #bool) {}
   }
}

parseProperty(TypeMirror propertyType,
              String propertyName, ApiProperty metadata, bool isRequest) {
   if (metadata.ignore) {
      return null;
   }
   if (propertyType.simpleName == #dynamic) {}
   switch (propertyType.reflectedType) {
      case int:
         if (metadata.format == null || metadata.format.endsWith('32')) {} else {}
         break;
      case BigInt:
         if (metadata.format == null || metadata.format.endsWith('32')) {}
         break;
      case double:
         break;
      case bool:
         break;
      case String:
         if (metadata.values != null && metadata.values.isNotEmpty) {
         
         }
         break;
      case DateTime:
         break;
   }
   // TODO: Could support maps that are subclasses rather
   // than only the specific Dart List and Map.
   if (propertyType is ClassMirror && !propertyType.isAbstract) {
   
   } else if (propertyType.originalDeclaration.isSubtypeOf(reflectType(List))) {} else if (propertyType.originalDeclaration == reflectClass(Map)) {}
   return null;
}


parseListSchema(ClassMirror schemaClass, bool isRequest) {
   assert(schemaClass.originalDeclaration == reflectClass(List));
   assert(schemaClass.typeArguments.length == 1);
   var itemsType = schemaClass.typeArguments[0];
   var newSchemaName = MirrorSystem.getName(schemaClass.qualifiedName);
   var name = canonicalName(schemaClass);
   var itemsProperty = parseProperty(itemsType, '${name}Property', new ApiProperty(), isRequest);
}

parseMapSchema(ClassMirror schemaClass, bool isRequest) {
   assert(schemaClass.originalDeclaration == reflectClass(Map));
   assert(schemaClass.typeArguments.length == 2);
   var additionalType = schemaClass.typeArguments[1];
   var name = canonicalName(schemaClass);
   if (schemaClass.typeArguments[0].reflectedType != String) {}
   var newSchemaName = MirrorSystem.getName(schemaClass.qualifiedName);
   var additionalProperty = parseProperty(
      additionalType, '${name}Property', new ApiProperty(), isRequest);
}


_parseMethodReturnType(MethodMirror mm) {
   var returnType = mm.returnType;
   if (returnType.isSubtypeOf(reflectType(Future))) {
      var types = returnType.typeArguments;
      if (types.length == 1) {
         returnType = types[0];
      }
   }
   // Note: I cannot use #void to get the symbol since void is a keyword.
   if (returnType.simpleName == const Symbol('void')) {}
   if (returnType.simpleName == #bool ||
      returnType.simpleName == #int ||
      returnType.simpleName == #num ||
      returnType.simpleName == #double ||
      returnType.simpleName == #String) {
      
   }
   // Check if the return type is a List or Map and handle that explicitly.
   if (returnType.originalDeclaration == reflectClass(List)) {
      // We parse responses as requests if strict parsing is true.
      return parseListSchema(returnType, true);
   }
   if (returnType.originalDeclaration == reflectClass(Map)) {
      // We parse responses as requests if strict parsing is true.
      return parseMapSchema(returnType, true);
   }
   if (returnType is! ClassMirror ||
      returnType.simpleName == #dynamic ||
      (returnType as ClassMirror).isAbstract) {}
   // We parse responses as requests if strict parsing is true.
}

parseSchema(ClassMirror schemaClass, bool isRequest) {
   // TODO: Add support for ApiSchema annotation for overriding default name.
   var name = MirrorSystem.getName(schemaClass.simpleName);
   var newSchemaName = MirrorSystem.getName(schemaClass.qualifiedName);
   
   
   if (isRequest) {
      var methods = schemaClass.declarations.values
         .whereType<MethodMirror>()
         .where((mm) => mm.isConstructor);
      if (!methods.isEmpty &&
         methods
            .where((mm) =>
         (mm.simpleName == schemaClass.simpleName &&
            mm.parameters.isEmpty)).isEmpty) {}
   }
}

parseMethod(MethodMirror mm, ApiMethod metadata, InstanceMirror methodOwner) {
   const List<String> allowedMethods = const [
      'GET',
      'DELETE',
      'PUT',
      'POST',
      'PATCH'
   ];
   
   // Method name is used for error reporting and as a default for the
   // name in the discovery document.
   var methodName = MirrorSystem.getName(mm.simpleName);
   
   // Parse name.
   var name = metadata.name;
   if (name == null || name.isEmpty) {
      // Default method name is method name in camel case.
      name = methodName;
   }
   
   // Parse method parameters. Path parameters must be parsed first followed by
   // either the query string parameters or the request schema.
   var pathParams;
   var queryParams;
   var requestSchema;
   if (metadata.path != null) {
      pathParams = _parsePathParameters(mm, metadata.path);
   }
   // Parse method return type.
   var responseSchema = _parseMethodReturnType(mm);
}

_parseMethods(InstanceMirror classInstance) {
   var methods = [];
   // Parse all methods annotated with the @ApiMethod annotation on this class
   // instance.
   classInstance.type.declarations.values.whereType<MethodMirror>().forEach((dm) {
      var metadata = _getMetadata(dm, ApiMethod);
      if (metadata == null) return null;
      
      if (!dm.isRegularMethod) {
         // The @ApiMethod annotation is only supported on regular methods.
         var name = MirrorSystem.getName(dm.simpleName);
         raise('@ApiMethod annotation on non-method declaration: \'$name\'');
      }
      
      var method = parseMethod(dm, metadata, classInstance);
      methods.add(method);
   });
   return methods;
}

parseResource(String defaultResourceName,
              InstanceMirror resourceInstance, ApiResource metadata) {
   // Recursively parse API sub resources and methods on this resourceInstance.
   var resources = _parseResources(resourceInstance);
   var methods = _parseMethods(resourceInstance);
   var name = metadata.name;
}

_parseResources(InstanceMirror classInstance) {
   var resources = {};
   
   // Scan through the class instance's declarations and parse fields annotated
   // with the @ApiResource annotation.
   classInstance.type.declarations.values.forEach((DeclarationMirror dm) {
      var metadata = _getMetadata(dm, ApiResource);
      if (metadata == null) return; // Not a valid ApiResource.
      
      var fieldName = MirrorSystem.getName(dm.simpleName);
      if (dm is! VariableMirror) {
         // Only fields can have an @ApiResource annotation.
         raise('@ApiResource annotation on non-field: \'$fieldName\'');
         return;
      }
      
      // Parse resource and add it to the map of resources for the containing
      // class.
      var resourceInstance = classInstance.getField(dm.simpleName);
   });
   return resources;
}

//parse (ApiClass)
parse(dynamic api) {
   InstanceMirror apiInstance = reflect(api);
   DeclarationMirror apiClass = apiInstance.type;
   
   // id used for error reporting and part of the discovery doc id for methods.
   var id = MirrorSystem.getName(apiClass.simpleName);
   _addIdSegment(id);
   
   // Parse ApiClass annotation.
   ApiClass metaData = _getMetadata(apiClass, ApiClass);
   if (metaData == null) {
      raise('Missing required @ApiClass annotation.');
      metaData = new ApiClass();
   }
   var name = metaData.name;
   var version = metaData.version;
   
   // Parse API resources and methods.
   var resources = _parseResources(apiInstance);
   var methods = _parseMethods(apiInstance);
}


dynamic _getMetadata(DeclarationMirror dm, Type apiType) {
   var annotations =
   dm.metadata.where((a) => a.reflectee.runtimeType == apiType).toList();
   if (annotations.length == 0) {
      return null;
   } else if (annotations.length > 1) {
      var name = MirrorSystem.getName(dm.simpleName);
      raise('Multiple ${apiType} annotations on declaration \'$name\'.');
      return null;
   }
   return annotations.first.reflectee;
}


@ApiClass(version: 'v1')
class Recursive {
   @ApiMethod(name: 'test1', method: 'POST', path: 'test1')
   void resursiveMethod1(NestedResource request) {
      return null;
   }
   
   @ApiMethod(name: 'test2', method: 'POST', path: 'test2')
   void resursiveMethod2(NestedResource request) {
      return null;
   }
}

@ApiClass(version: 'v1')
class CorrectSimple {
   final String _foo = 'ffo';
   
   final NestedResource _cm = new NestedResource();
   
   NestedResource _cmNonFinal = new NestedResource();
   
   @ApiMethod(path: 'test1/{path}')
   void simple1(String path) {
      return null;
   }
   
   @ApiMethod(method: 'POST', path: 'test2')
   SomeResource simple2(SomeResource request) {
      return null;
   }
   
   // public method which uses private members
   // eliminates analyzer warning about unused private members
   throwAwayPrivateUsage() => [_foo, _cm, _cmNonFinal];
}

class NestedResource {
   @ApiMethod(path: 'nestedResourceMethod')
   void method1() {
      return null;
   }
}

class SomeResource {
   @ApiMethod(path: 'someResourceMethod')
   void method1() {
      return null;
   }
}

class NamedResource {
   @ApiMethod(path: 'namedResourceMethod')
   void method1() {
      return null;
   }
}

@ApiClass(version: 'v1test')
class TesterWithDuplicateResourceNames {
   @ApiResource()
   final SomeResource someResource = new SomeResource();
   
   @ApiResource(name: 'someResource')
   final NamedResource namedResource = new NamedResource();
}

@ApiClass(version: 'v1test')
class TesterWithMultipleResourceAnnotations {
   @ApiResource()
   @ApiResource()
   final SomeResource someResource = new SomeResource();
}

@ApiClass(version: 'v1test')
class MultipleMethodAnnotations {
   @ApiMethod(path: 'multi')
   @ApiMethod(path: 'multi2')
   void multiAnnotations() {
      return null;
   }
}



void main([arguments]) {
   group("Exploring using Mirrors", () {
      MultipleMethodAnnotations inst;
      InstanceMirror apiInstance;
      DeclarationMirror apiClass;
      String classname;
      ApiClass metaData;
      setUp(() {
         inst = MultipleMethodAnnotations();
         apiInstance = reflect(inst);
         apiClass = apiInstance.type;
         classname = MirrorSystem.getName(apiClass.simpleName);
         metaData = _getMetadata(apiClass, ApiClass);
      });
      test('exploring metadata from instance', () {
         inst        = MultipleMethodAnnotations();
         apiInstance = reflect(inst);
         apiClass    = apiInstance.type;
         var clsAnnotatedWithApiClass
          = apiClass.metadata
             .where((InstanceMirror a) => a.reflectee.runtimeType == ApiClass )
             .toList()
             .first;
         
         print('apiInstance: $apiInstance');
         print('apiClass: $apiClass');
         print('classname: $classname');
         print('clsAnnotatedWithApiClass: $clsAnnotatedWithApiClass');
         print('clsAnnotatedWithApiClass.reflectee: ${clsAnnotatedWithApiClass.reflectee}');
         
         
         apiClass.metadata.whereType<ApiClass>();
         
      });
   });
}












