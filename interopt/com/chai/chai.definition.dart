@JS()
library chai;

import "package:js/js.dart";
import "dart:js_util" show getProperty;

/// Type definitions for chai 4.1
/// Project: http://chaijs.com/
/// Definitions by: Jed Mao <https://github.com/jedmao>,
/// Bart van der Schoor <https://github.com/Bartvds>,
/// Andrew Brown <https://github.com/AGBrown>,
/// Olivier Chevet <https://github.com/olivr70>,
/// Matt Wistrand <https://github.com/mwistrand>,
/// Josh Goldberg <https://github.com/joshuakgoldberg>
/// Shaun Luttin <https://github.com/shaunluttin>
/// Gintautas Miselis <https://github.com/Naktibalda>
/// Satana Charuwichitratana <https://github.com/micksatana>
/// Erik Schierboom <https://github.com/ErikSchierboom>
/// Definitions: https://github.com/DefinitelyTyped/DefinitelyTyped
// Module Chai
@anonymous
@JS()
abstract class ChaiStatic {
   external ExpectStatic get expect;
   
   external set expect(ExpectStatic v);
   
   external Should should();
   
   /// Provides a way to extend the internals of Chai
   external ChaiStatic use(void fn(dynamic chai, dynamic utils));
   
   external AssertStatic get JS$assert;
   
   external set JS$assert(AssertStatic v);
   
   external Config get config;
   
   external set config(Config v);
   
   external dynamic get AssertionError;
   
   external set AssertionError(dynamic v);
   
   external String get version;
   
   external set version(String v);
   
   AssertStatic get $assert {
      return getProperty(this, 'assert');
   }
}

@anonymous
@JS()
abstract class ExpectStatic
   implements Function   {
   external void fail([dynamic actual, dynamic expected, String message, String JS$operator]);
}

@anonymous
@JS()
abstract class AssertStatic
   implements Assert {}

typedef Assertion AssertionStatic(dynamic target,
                                  [String message]); /*export type Operator = string;*/
/*export type OperatorComparable = boolean | null | number | string | undefined | Date;*/
@anonymous
@JS()
abstract class ShouldAssertion {
   external void equal(dynamic value1, dynamic value2, [String message]);
   
   external ShouldThrow get Throw;
   
   external set Throw(ShouldThrow v);
   
   external ShouldThrow get JS$throw;
   
   external set JS$throw(ShouldThrow v);
   
   external void exist(dynamic value, [String message]);
}

@anonymous
@JS()
abstract class Should
   implements ShouldAssertion {
   external ShouldAssertion get not;
   
   external set not(ShouldAssertion v);
   
   external void fail(dynamic actual, dynamic expected,
                      [String message, String JS$operator]);
}

@anonymous
@JS()
abstract class ShouldThrow {
   /*external void call(Function actual, [String|RegExp expected, String message]);*/
   /*external void call(Function actual, Error|Function constructor, [String|RegExp expected, String message]);*/
   external void call(Function actual,
                      [dynamic /*String|RegExp|Error|Function*/ expected_constructor,
                         dynamic /*String|RegExp*/ message_expected,
                         String message]);
}

@anonymous
@JS()
abstract class T_Throw {
   /*external Assertion call([String|RegExp expected, String message]);*/
   /*external Assertion call(Error|Function constructor, [String|RegExp expected, String message]);*/
   external Assertion call([dynamic /*String|RegExp|Error|Function*/ expected_constructor,
                              dynamic /*String|RegExp*/ message_expected,
                              String message]);
}

@anonymous
@JS()
abstract class Assertion
   implements LanguageChains, NumericComparison, TypeComparison {
   external Assertion get not;
   
   external set not(Assertion v);
   
   external Deep get deep;
   
   external set deep(Deep v);
   
   external Ordered get ordered;
   
   external set ordered(Ordered v);
   
   external Nested get nested;
   
   external set nested(Nested v);
   
   external KeyFilter get any;
   
   external set any(KeyFilter v);
   
   external KeyFilter get all;
   
   external set all(KeyFilter v);
   
   external TypeComparison get a;
   
   external set a(TypeComparison v);
   
   external TypeComparison get an;
   
   external set an(TypeComparison v);
   
   external Include get include;
   
   external set include(Include v);
   
   external Include get includes;
   
   external set includes(Include v);
   
   external Include get contain;
   
   external set contain(Include v);
   
   external Include get contains;
   
   external set contains(Include v);
   
   external Assertion get ok;
   
   external set ok(Assertion v);
   
   external Assertion get JS$true;
   
   external set JS$true(Assertion v);
   
   external Assertion get JS$false;
   
   external set JS$false(Assertion v);
   
   external Assertion get JS$null;
   
   external set JS$null(Assertion v);
   
   external Assertion get undefined;
   
   external set undefined(Assertion v);
   
   external Assertion get NaN;
   
   external set NaN(Assertion v);
   
   external Assertion get exist;
   
   external set exist(Assertion v);
   
   external Assertion get empty;
   
   external set empty(Assertion v);
   
   external Assertion get arguments;
   
   external set arguments(Assertion v);
   
   external Assertion get Arguments;
   
   external set Arguments(Assertion v);
   
   external Equal get equal;
   
   external set equal(Equal v);
   
   external Equal get equals;
   
   external set equals(Equal v);
   
   external Equal get eq;
   
   external set eq(Equal v);
   
   external Equal get eql;
   
   external set eql(Equal v);
   
   external Equal get eqls;
   
   external set eqls(Equal v);
   
   external Property get property;
   
   external set property(Property v);
   
   external OwnProperty get ownProperty;
   
   external set ownProperty(OwnProperty v);
   
   external OwnProperty get haveOwnProperty;
   
   external set haveOwnProperty(OwnProperty v);
   
   external OwnPropertyDescriptor get ownPropertyDescriptor;
   
   external set ownPropertyDescriptor(OwnPropertyDescriptor v);
   
   external OwnPropertyDescriptor get haveOwnPropertyDescriptor;
   
   external set haveOwnPropertyDescriptor(OwnPropertyDescriptor v);
   
   external Length get length;
   
   external set length(Length v);
   
   external Length get lengthOf;
   
   external set lengthOf(Length v);
   
   external Match get match;
   
   external set match(Match v);
   
   external Match get matches;
   
   external set matches(Match v);
   
   external Assertion string(String string, [String message]);
   
   external Keys get keys;
   
   external set keys(Keys v);
   
   external Assertion key(String string);
   
   external T_Throw get JS$throw;
   
   external set JS$throw(T_Throw v);
   
   external T_Throw get throws;
   
   external set throws(T_Throw v);
   
   external T_Throw get Throw;
   
   external set Throw(T_Throw v);
   
   external RespondTo get respondTo;
   
   external set respondTo(RespondTo v);
   
   external RespondTo get respondsTo;
   
   external set respondsTo(RespondTo v);
   
   external Assertion get itself;
   
   external set itself(Assertion v);
   
   external Satisfy get satisfy;
   
   external set satisfy(Satisfy v);
   
   external Satisfy get satisfies;
   
   external set satisfies(Satisfy v);
   
   external CloseTo get closeTo;
   
   external set closeTo(CloseTo v);
   
   external CloseTo get approximately;
   
   external set approximately(CloseTo v);
   
   external Members get members;
   
   external set members(Members v);
   
   external PropertyChange get increase;
   
   external set increase(PropertyChange v);
   
   external PropertyChange get increases;
   
   external set increases(PropertyChange v);
   
   external PropertyChange get decrease;
   
   external set decrease(PropertyChange v);
   
   external PropertyChange get decreases;
   
   external set decreases(PropertyChange v);
   
   external PropertyChange get change;
   
   external set change(PropertyChange v);
   
   external PropertyChange get changes;
   
   external set changes(PropertyChange v);
   
   external Assertion get extensible;
   
   external set extensible(Assertion v);
   
   external Assertion get sealed;
   
   external set sealed(Assertion v);
   
   external Assertion get frozen;
   
   external set frozen(Assertion v);
   
   external Assertion oneOf(List<dynamic> list, [String message]);
}

@anonymous
@JS()
abstract class LanguageChains {
   external Assertion get to;
   
   external set to(Assertion v);
   
   external Assertion get be;
   
   external set be(Assertion v);
   
   external Assertion get been;
   
   external set been(Assertion v);
   
   external Assertion get JS$is;
   
   external set JS$is(Assertion v);
   
   external Assertion get that;
   
   external set that(Assertion v);
   
   external Assertion get which;
   
   external set which(Assertion v);
   
   external Assertion get and;
   
   external set and(Assertion v);
   
   external Assertion get has;
   
   external set has(Assertion v);
   
   external Assertion get have;
   
   external set have(Assertion v);
   
   external Assertion get JS$with;
   
   external set JS$with(Assertion v);
   
   external Assertion get at;
   
   external set at(Assertion v);
   
   external Assertion get of;
   
   external set of(Assertion v);
   
   external Assertion get same;
   
   external set same(Assertion v);
   
   external Assertion get but;
   
   external set but(Assertion v);
   
   external Assertion get does;
   
   external set does(Assertion v);
   
   external factory LanguageChains({Assertion to,
                                      Assertion be,
                                      Assertion been,
                                      Assertion JS$is,
                                      Assertion that,
                                      Assertion which,
                                      Assertion and,
                                      Assertion has,
                                      Assertion have,
                                      Assertion JS$with,
                                      Assertion at,
                                      Assertion of,
                                      Assertion same,
                                      Assertion but,
                                      Assertion does});
}

@anonymous
@JS()
abstract class NumericComparison {
   external NumberComparer get above;
   
   external set above(NumberComparer v);
   
   external NumberComparer get gt;
   
   external set gt(NumberComparer v);
   
   external NumberComparer get greaterThan;
   
   external set greaterThan(NumberComparer v);
   
   external NumberComparer get least;
   
   external set least(NumberComparer v);
   
   external NumberComparer get gte;
   
   external set gte(NumberComparer v);
   
   external NumberComparer get below;
   
   external set below(NumberComparer v);
   
   external NumberComparer get lt;
   
   external set lt(NumberComparer v);
   
   external NumberComparer get lessThan;
   
   external set lessThan(NumberComparer v);
   
   external NumberComparer get most;
   
   external set most(NumberComparer v);
   
   external NumberComparer get lte;
   
   external set lte(NumberComparer v);
   
   /*external Assertion within(num start, num finish, [String message]);*/
   /*external Assertion within(DateTime start, DateTime finish, [String message]);*/
   external Assertion within(dynamic /*num|DateTime*/ start, dynamic /*num|DateTime*/ finish,
                             [String message]);
}

typedef Assertion NumberComparer(dynamic /*num|DateTime*/ value,
                                 [String message]);

@anonymous
@JS()
abstract class TypeComparison {
   external Assertion call(String type, [String message]);
   
   external InstanceOf get instanceof;
   
   external set instanceof(InstanceOf v);
   
   external InstanceOf get instanceOf;
   
   external set instanceOf(InstanceOf v);
}

typedef Assertion InstanceOf(Object constructor, [String message]);
typedef Assertion CloseTo(num expected, num delta, [String message]);

@anonymous
@JS()
abstract class Nested {
   external Include get include;
   
   external set include(Include v);
   
   external Property get property;
   
   external set property(Property v);
   
   external Members get members;
   
   external set members(Members v);
   
   external factory Nested({Include include, Property property, Members members});
}

@anonymous
@JS()
abstract class Deep {
   external Equal get equal;
   
   external set equal(Equal v);
   
   external Equal get equals;
   
   external set equals(Equal v);
   
   external Equal get eq;
   
   external set eq(Equal v);
   
   external Include get include;
   
   external set include(Include v);
   
   external Property get property;
   
   external set property(Property v);
   
   external Members get members;
   
   external set members(Members v);
   
   external Ordered get ordered;
   
   external set ordered(Ordered v);
   
   external Nested get nested;
   
   external set nested(Nested v);
   
   external factory Deep({Equal equal,
                            Equal equals,
                            Equal eq,
                            Include include,
                            Property property,
                            Members members,
                            Ordered ordered,
                            Nested nested});
}

@anonymous
@JS()
abstract class Ordered {
   external Members get members;
   
   external set members(Members v);
   
   external factory Ordered({Members members});
}

@anonymous
@JS()
abstract class KeyFilter {
   external Keys get keys;
   
   external set keys(Keys v);
   
   external factory KeyFilter({Keys keys});
}

typedef Assertion Equal(dynamic value, [String message]);
typedef Assertion Property(String name, [dynamic value, String message]);
typedef Assertion OwnProperty(String name, [String message]);

@anonymous
@JS()
abstract class OwnPropertyDescriptor {
   /*external Assertion call(String name, PropertyDescriptor descriptor,
    [String message]);*/
   /*external Assertion call(String name, [String message]);*/
   external Assertion call(String name,
                           [dynamic /*PropertyDescriptor|String*/ descriptor_message,
                              String message]);
}

typedef Assertion Length(num length, [String message]);

@anonymous
@JS()
abstract class Include {
   external Assertion call(dynamic /*Object|String|num*/ value,
                           [String message]);
   
   external Keys get keys;
   
   external set keys(Keys v);
   
   external Deep get deep;
   
   external set deep(Deep v);
   
   external Ordered get ordered;
   
   external set ordered(Ordered v);
   
   external Members get members;
   
   external set members(Members v);
   
   external KeyFilter get any;
   
   external set any(KeyFilter v);
   
   external KeyFilter get all;
   
   external set all(KeyFilter v);
}

typedef Assertion Match(RegExp regexp, [String message]);

@anonymous
@JS()
abstract class Keys {
   /*external Assertion call(
    [String keys1, String keys2, String keys3, String keys4, String keys5]);*/
   /*external Assertion call(List<dynamic>|Object keys);*/
   external Assertion call(dynamic /*List<String>|List<dynamic>|Object*/ keys);
}

typedef Assertion RespondTo(String method, [String message]);
typedef Assertion Satisfy(Function matcher, [String message]);
typedef Assertion Members(List<dynamic> JS$set, [String message]);
typedef Assertion PropertyChange(Object object, String property,
                                 [String message]);

@anonymous
@JS()
abstract class Assert {
   external void call(dynamic expression, [String message]);
   
   /// Throws a failure.
   /// @type T   Type of the objects.
   /// @remarks Node.js assert module-compatible.
   external void fail/*<T>*/([dynamic/*=T*/ actual,
                                dynamic/*=T*/ expected,
                                String message,
                                String JS$operator]);
   
   /// Asserts that object is truthy.
   /// @type T   Type of object.
   external void isOk/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that object is truthy.
   /// @type T   Type of object.
   external void ok/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that object is falsy.
   /// @type T   Type of object.
   external void isNotOk/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that object is falsy.
   /// @type T   Type of object.
   external void notOk/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts non-strict equality (==) of actual and expected.
   /// @type T   Type of the objects.
   external void equal/*<T>*/(dynamic/*=T*/ actual, dynamic/*=T*/ expected,
                              [String message]);
   
   /// Asserts non-strict inequality (==) of actual and expected.
   /// @type T   Type of the objects.
   external void notEqual/*<T>*/(dynamic/*=T*/ actual, dynamic/*=T*/ expected,
                                 [String message]);
   
   /// Asserts strict equality (===) of actual and expected.
   /// @type T   Type of the objects.
   external void strictEqual/*<T>*/(dynamic/*=T*/ actual, dynamic/*=T*/ expected,
                                    [String message]);
   
   /// Asserts strict inequality (==) of actual and expected.
   /// @type T   Type of the objects.
   external void notStrictEqual/*<T>*/(dynamic/*=T*/ actual, dynamic/*=T*/ expected,
                                       [String message]);
   
   /// Asserts that actual is deeply equal (==) to expected.
   /// @type T   Type of the objects.
   external void deepEqual/*<T>*/(dynamic/*=T*/ actual, dynamic/*=T*/ expected,
                                  [String message]);
   
   /// Asserts that actual is not deeply equal (==) to expected.
   /// @type T   Type of the objects.
   external void notDeepEqual/*<T>*/(dynamic/*=T*/ actual, dynamic/*=T*/ expected,
                                     [String message]);
   
   /// Asserts that actual is deeply strict equal (===) to expected.
   /// @type T   Type of the objects.
   external void deepStrictEqual/*<T>*/(dynamic/*=T*/ actual, dynamic/*=T*/ expected,
                                        [String message]);
   
   /// Asserts valueToCheck is strictly greater than (>) valueToBeAbove.
   external void isAbove(num valueToCheck, num valueToBeAbove, [String message]);
   
   /// Asserts valueToCheck is greater than or equal to (>=) valueToBeAtLeast.
   external void isAtLeast(num valueToCheck, num valueToBeAtLeast,
                           [String message]);
   
   /// Asserts valueToCheck is strictly less than (<) valueToBeBelow.
   external void isBelow(num valueToCheck, num valueToBeBelow, [String message]);
   
   /// Asserts valueToCheck is greater than or equal to (>=) valueToBeAtMost.
   external void isAtMost(num valueToCheck, num valueToBeAtMost,
                          [String message]);
   
   /// Asserts that value is true.
   /// @type T   Type of value.
   external void isTrue/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is false.
   /// @type T   Type of value.
   external void isFalse/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is not true.
   /// @type T   Type of value.
   external void isNotTrue/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is not false.
   /// @type T   Type of value.
   external void isNotFalse/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is null.
   /// @type T   Type of value.
   external void isNull/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is not null.
   /// @type T   Type of value.
   external void isNotNull/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is not null.
   /// @type T   Type of value.
   external void isNaN/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is not null.
   /// @type T   Type of value.
   external void isNotNaN/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that the target is neither null nor undefined.
   /// @type T   Type of value.
   external void exists/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that the target is either null or undefined.
   /// @type T   Type of value.
   external void notExists/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is undefined.
   /// @type T   Type of value.
   external void isUndefined/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is not undefined.
   /// @type T   Type of value.
   external void isDefined/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is a function.
   /// @type T   Type of value.
   external void isFunction/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is not a function.
   /// @type T   Type of value.
   external void isNotFunction/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is an object of type 'Object'
   /// (as revealed by Object.prototype.toString).
   /// @type T   Type of value.
   /// @remarks The assertion does not match subclassed objects.
   external void isObject/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is not an object of type 'Object'
   /// (as revealed by Object.prototype.toString).
   /// @type T   Type of value.
   external void isNotObject/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is an array.
   /// @type T   Type of value.
   external void isArray/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is not an array.
   /// @type T   Type of value.
   external void isNotArray/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is a string.
   /// @type T   Type of value.
   external void isString/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is not a string.
   /// @type T   Type of value.
   external void isNotString/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is a number.
   /// @type T   Type of value.
   external void isNumber/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is not a number.
   /// @type T   Type of value.
   external void isNotNumber/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is a boolean.
   /// @type T   Type of value.
   external void isBoolean/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value is not a boolean.
   /// @type T   Type of value.
   external void isNotBoolean/*<T>*/(dynamic/*=T*/ value, [String message]);
   
   /// Asserts that value's type is name, as determined by Object.prototype.toString.
   /// @type T   Type of value.
   external void typeOf/*<T>*/(dynamic/*=T*/ value, String name,
                               [String message]);
   
   /// Asserts that value's type is not name, as determined by Object.prototype.toString.
   /// @type T   Type of value.
   external void notTypeOf/*<T>*/(dynamic/*=T*/ value, String name,
                                  [String message]);
   
   /// Asserts that value is an instance of constructor.
   /// @type T   Type of value.
   external void instanceOf/*<T>*/(dynamic/*=T*/ value, Function constructor,
                                   [String message]);
   
   /// Asserts that value is not an instance of constructor.
   /// @type T   Type of value.
   external void notInstanceOf/*<T>*/(dynamic/*=T*/ value, Function type,
                                      [String message]);
   
   /// Asserts that haystack includes needle.
   /*external void include(String haystack, String needle, [String message]);*/
   
   /// Asserts that haystack includes needle.
   /// @type T   Type of values in haystack.
   /*external void include<T>(List<T> haystack, T needle, [String message]);*/
   external void include/*<T>*/(dynamic /*String|List<T>*/ haystack, dynamic /*String|T*/ needle,
                                [String message]);
   
   /// Asserts that haystack does not include needle.
   external void notInclude(dynamic /*String|List<dynamic>*/ haystack, dynamic needle,
                            [String message]);
   
   /// Asserts that haystack includes needle. Can be used to assert the inclusion of a value in an array or a subset of properties in an object. Deep equality is used.
   /*external void deepInclude(String haystack, String needle, [String message]);*/
   
   /// Asserts that haystack includes needle. Can be used to assert the inclusion of a value in an array or a subset of properties in an object. Deep equality is used.
   /*external void deepInclude<T>(dynamic haystack, dynamic needle, [String message]);*/
   external void deepInclude/*<T>*/(dynamic /*String|dynamic*/ haystack, dynamic /*String|dynamic*/ needle,
                                    [String message]);
   
   /// Asserts that haystack does not include needle. Can be used to assert the absence of a value in an array or a subset of properties in an object. Deep equality is used.
   external void notDeepInclude(dynamic /*String|List<dynamic>*/ haystack, dynamic needle,
                                [String message]);
   
   /// Asserts that ‘haystack’ includes ‘needle’. Can be used to assert the inclusion of a subset of properties in an object.
   /// Enables the use of dot- and bracket-notation for referencing nested properties.
   /// ‘[]’ and ‘.’ in property names can be escaped using double backslashes.Asserts that ‘haystack’ includes ‘needle’.
   /// Can be used to assert the inclusion of a subset of properties in an object.
   /// Enables the use of dot- and bracket-notation for referencing nested properties.
   /// ‘[]’ and ‘.’ in property names can be escaped using double backslashes.
   external void nestedInclude(dynamic haystack, dynamic needle,
                               [String message]);
   
   /// Asserts that ‘haystack’ does not include ‘needle’. Can be used to assert the absence of a subset of properties in an object.
   /// Enables the use of dot- and bracket-notation for referencing nested properties.
   /// ‘[]’ and ‘.’ in property names can be escaped using double backslashes.Asserts that ‘haystack’ includes ‘needle’.
   /// Can be used to assert the inclusion of a subset of properties in an object.
   /// Enables the use of dot- and bracket-notation for referencing nested properties.
   /// ‘[]’ and ‘.’ in property names can be escaped using double backslashes.
   external void notNestedInclude(dynamic haystack, dynamic needle,
                                  [String message]);
   
   /// Asserts that ‘haystack’ includes ‘needle’. Can be used to assert the inclusion of a subset of properties in an object while checking for deep equality
   /// Enables the use of dot- and bracket-notation for referencing nested properties.
   /// ‘[]’ and ‘.’ in property names can be escaped using double backslashes.Asserts that ‘haystack’ includes ‘needle’.
   /// Can be used to assert the inclusion of a subset of properties in an object.
   /// Enables the use of dot- and bracket-notation for referencing nested properties.
   /// ‘[]’ and ‘.’ in property names can be escaped using double backslashes.
   external void deepNestedInclude(dynamic haystack, dynamic needle,
                                   [String message]);
   
   /// Asserts that ‘haystack’ does not include ‘needle’. Can be used to assert the absence of a subset of properties in an object while checking for deep equality.
   /// Enables the use of dot- and bracket-notation for referencing nested properties.
   /// ‘[]’ and ‘.’ in property names can be escaped using double backslashes.Asserts that ‘haystack’ includes ‘needle’.
   /// Can be used to assert the inclusion of a subset of properties in an object.
   /// Enables the use of dot- and bracket-notation for referencing nested properties.
   /// ‘[]’ and ‘.’ in property names can be escaped using double backslashes.
   external void notDeepNestedInclude(dynamic haystack, dynamic needle,
                                      [String message]);
   
   /// Asserts that ‘haystack’ includes ‘needle’. Can be used to assert the inclusion of a subset of properties in an object while ignoring inherited properties.
   external void ownInclude(dynamic haystack, dynamic needle, [String message]);
   
   /// Asserts that ‘haystack’ includes ‘needle’. Can be used to assert the absence of a subset of properties in an object while ignoring inherited properties.
   external void notOwnInclude(dynamic haystack, dynamic needle,
                               [String message]);
   
   /// Asserts that ‘haystack’ includes ‘needle’. Can be used to assert the inclusion of a subset of properties in an object while ignoring inherited properties and checking for deep
   external void deepOwnInclude(dynamic haystack, dynamic needle,
                                [String message]);
   
   /// Asserts that ‘haystack’ includes ‘needle’. Can be used to assert the absence of a subset of properties in an object while ignoring inherited properties and checking for deep equality.
   external void notDeepOwnInclude(dynamic haystack, dynamic needle,
                                   [String message]);
   
   /// Asserts that value matches the regular expression regexp.
   external void match(String value, RegExp regexp, [String message]);
   
   /// Asserts that value does not match the regular expression regexp.
   external void notMatch(dynamic expected, RegExp regexp, [String message]);
   
   /// Asserts that object has a property named by property.
   /// @type T   Type of object.
   external void property/*<T>*/(dynamic/*=T*/ object, String property,
                                 [String message]);
   
   /// Asserts that object has a property named by property.
   /// @type T   Type of object.
   external void notProperty/*<T>*/(dynamic/*=T*/ object, String property,
                                    [String message]);
   
   /// Asserts that object has a property named by property, which can be a string
   /// using dot- and bracket-notation for deep reference.
   /// @type T   Type of object.
   external void deepProperty/*<T>*/(dynamic/*=T*/ object, String property,
                                     [String message]);
   
   /// Asserts that object does not have a property named by property, which can be a
   /// string using dot- and bracket-notation for deep reference.
   /// @type T   Type of object.
   external void notDeepProperty/*<T>*/(dynamic/*=T*/ object, String property,
                                        [String message]);
   
   /// Asserts that object has a property named by property with value given by value.
   /// @type T   Type of object.
   /// @type V   Type of value.
   external void propertyVal/*<T, V>*/(dynamic/*=T*/ object, String property, dynamic/*=V*/ value,
                                       [String message]);
   
   /// Asserts that object has a property named by property with value given by value.
   /// @type T   Type of object.
   /// @type V   Type of value.
   external void propertyNotVal/*<T, V>*/(dynamic/*=T*/ object, String property, dynamic/*=V*/ value,
                                          [String message]);
   
   /// Asserts that object has a property named by property, which can be a string
   /// using dot- and bracket-notation for deep reference.
   /// @type T   Type of object.
   /// @type V   Type of value.
   external void deepPropertyVal/*<T, V>*/(dynamic/*=T*/ object, String property, dynamic/*=V*/ value,
                                           [String message]);
   
   /// Asserts that object does not have a property named by property, which can be a
   /// string using dot- and bracket-notation for deep reference.
   /// @type T   Type of object.
   /// @type V   Type of value.
   external void deepPropertyNotVal/*<T, V>*/(dynamic/*=T*/ object, String property, dynamic/*=V*/ value,
                                              [String message]);
   
   /// Asserts that object has a length property with the expected value.
   /// @type T   Type of object.
   external void lengthOf (dynamic  object, num length,
                                                                      [String message]);
   
   /// Asserts that fn will throw an error.
   /*external void JS$throw(Function fn, [String message]);*/
   
   /// Asserts that function will throw an error with message matching regexp.
   /*external void JS$throw(Function fn, RegExp regExp);*/
   
   /// Asserts that function will throw an error that is an instance of constructor.
   /*external void JS$throw(Function fn, Function constructor, [String message]);*/
   
   /// Asserts that function will throw an error that is an instance of constructor
   /// and an error with message matching regexp.
   /*external void JS$throw(Function fn, Function constructor, RegExp regExp);*/
   external void JS$throw(Function fn,
                          [dynamic /*String|RegExp|Function*/ message_regExp_constructor,
                             dynamic /*String|RegExp*/ message_regExp]);
   
   /// Asserts that fn will throw an error.
   /*external void throws(Function fn, [String message]);*/
   
   /// Asserts that function will throw an error with message matching regexp.
   /*external void throws(Function fn, RegExp|Function errType, [String message]);*/
   
   /// Asserts that function will throw an error that is an instance of constructor
   /// and an error with message matching regexp.
   /*external void throws(Function fn, Function errType, RegExp regExp);*/
   external void throws(Function fn,
                        [dynamic /*String|RegExp|Function*/ message_errType,
                           dynamic /*String|RegExp*/ message_regExp]);
   
   /// Asserts that fn will throw an error.
   /*external void Throw(Function fn, [String message]);*/
   
   /// Asserts that function will throw an error with message matching regexp.
   /*external void Throw(Function fn, RegExp regExp);*/
   
   /// Asserts that function will throw an error that is an instance of constructor.
   /*external void Throw(Function fn, Function errType, [String message]);*/
   
   /// Asserts that function will throw an error that is an instance of constructor
   /// and an error with message matching regexp.
   /*external void Throw(Function fn, Function errType, RegExp regExp);*/
   external void Throw(Function fn,
                       [dynamic /*String|RegExp|Function*/ message_regExp_errType,
                          dynamic /*String|RegExp*/ message_regExp]);
   
   /// Asserts that fn will not throw an error.
   /*external void doesNotThrow(Function fn, [String message]);*/
   
   /// Asserts that function will throw an error with message matching regexp.
   /*external void doesNotThrow(Function fn, RegExp regExp);*/
   
   /// Asserts that function will throw an error that is an instance of constructor.
   /*external void doesNotThrow(Function fn, Function errType, [String message]);*/
   
   /// Asserts that function will throw an error that is an instance of constructor
   /// and an error with message matching regexp.
   /*external void doesNotThrow(Function fn, Function errType, RegExp regExp);*/
   external void doesNotThrow(Function fn,
                              [dynamic /*String|RegExp|Function*/ message_regExp_errType,
                                 dynamic /*String|RegExp*/ message_regExp]);
   
   /// Compares two values using operator.
   external void JS$operator(dynamic /*bool|Null|num|String|dynamic|DateTime*/ val1,
                             String JS$operator,
                             dynamic /*bool|Null|num|String|dynamic|DateTime*/ val2,
                             [String message]);
   
   /// Asserts that the target is equal to expected, to within a +/- delta range.
   external void closeTo(num actual, num expected, num delta, [String message]);
   
   /// Asserts that the target is equal to expected, to within a +/- delta range.
   external void approximately(num act, num exp, num delta, [String message]);
   
   /// Asserts that set1 and set2 have the same members. Order is not take into account.
   /// @type T   Type of set values.
   external void sameMembers/*<T>*/(List<dynamic /*=T*/> set1, List<dynamic /*=T*/> set2,
                                    [String message]);
   
   /// Asserts that set1 and set2 have the same members using deep equality checking.
   /// Order is not take into account.
   /// @type T   Type of set values.
   external void sameDeepMembers/*<T>*/(List<dynamic /*=T*/> set1, List<dynamic /*=T*/> set2,
                                        [String message]);
   
   /// Asserts that set1 and set2 have the same members in the same order.
   /// Uses a strict equality check (===).
   /// @type T   Type of set values.
   external void sameOrderedMembers/*<T>*/(List<dynamic /*=T*/> set1, List<dynamic /*=T*/> set2,
                                           [String message]);
   
   /// Asserts that set1 and set2 don’t have the same members in the same order.
   /// Uses a strict equality check (===).
   /// @type T   Type of set values.
   external void notSameOrderedMembers/*<T>*/(List<dynamic /*=T*/> set1, List<dynamic /*=T*/> set2,
                                              [String message]);
   
   /// Asserts that set1 and set2 have the same members in the same order.
   /// Uses a deep equality check.
   /// @type T   Type of set values.
   external void sameDeepOrderedMembers/*<T>*/(List<dynamic /*=T*/> set1, List<dynamic /*=T*/> set2,
                                               [String message]);
   
   /// Asserts that set1 and set2 don’t have the same members in the same order.
   /// Uses a deep equality check.
   /// @type T   Type of set values.
   external void notSameDeepOrderedMembers/*<T>*/(List<dynamic /*=T*/> set1, List<dynamic /*=T*/> set2,
                                                  [String message]);
   
   /// Asserts that subset is included in superset in the same order beginning with the first element in superset.
   /// Uses a strict equality check (===).
   /// @type T   Type of set values.
   external void includeOrderedMembers/*<T>*/(List<dynamic /*=T*/> superset, List<dynamic /*=T*/> subset,
                                              [String message]);
   
   /// Asserts that subset isn’t included in superset in the same order beginning with the first element in superset.
   /// Uses a strict equality check (===).
   /// @type T   Type of set values.
   external void notIncludeOrderedMembers/*<T>*/(List<dynamic /*=T*/> superset, List<dynamic /*=T*/> subset,
                                                 [String message]);
   
   /// Asserts that subset is included in superset in the same order beginning with the first element in superset.
   /// Uses a deep equality check.
   /// @type T   Type of set values.
   external void includeDeepOrderedMembers/*<T>*/(List<dynamic /*=T*/> superset, List<dynamic /*=T*/> subset,
                                                  [String message]);
   
   /// Asserts that subset isn’t included in superset in the same order beginning with the first element in superset.
   /// Uses a deep equality check.
   /// @type T   Type of set values.
   external void notIncludeDeepOrderedMembers/*<T>*/(List<dynamic /*=T*/> superset, List<dynamic /*=T*/> subset,
                                                     [String message]);
   
   /// Asserts that subset is included in superset. Order is not take into account.
   /// @type T   Type of set values.
   external void includeMembers/*<T>*/(List<dynamic /*=T*/> superset, List<dynamic /*=T*/> subset,
                                       [String message]);
   
   /// Asserts that subset is included in superset using deep equality checking.
   /// Order is not take into account.
   /// @type T   Type of set values.
   external void includeDeepMembers/*<T>*/(List<dynamic /*=T*/> superset, List<dynamic /*=T*/> subset,
                                           [String message]);
   
   /// Asserts that non-object, non-array value inList appears in the flat array list.
   /// @type T   Type of list values.
   external void oneOf/*<T>*/(dynamic/*=T*/ inList, List<dynamic /*=T*/> list,
                              [String message]);
   
   /// Asserts that a function changes the value of a property.
   /// @type T   Type of object.
   external void changes/*<T>*/(Function modifier, dynamic/*=T*/ object, String property,
                                [String message]);
   
   /// Asserts that a function does not change the value of a property.
   /// @type T   Type of object.
   external void doesNotChange/*<T>*/(Function modifier, dynamic/*=T*/ object, String property,
                                      [String message]);
   
   /// Asserts that a function increases an object property.
   /// @type T   Type of object.
   external void increases/*<T>*/(Function modifier, dynamic/*=T*/ object, String property,
                                  [String message]);
   
   /// Asserts that a function does not increase an object property.
   /// @type T   Type of object.
   external void doesNotIncrease/*<T>*/(Function modifier, dynamic/*=T*/ object, String property,
                                        [String message]);
   
   /// Asserts that a function decreases an object property.
   /// @type T   Type of object.
   external void decreases/*<T>*/(Function modifier, dynamic/*=T*/ object, String property,
                                  [String message]);
   
   /// Asserts that a function does not decrease an object property.
   /// @type T   Type of object.
   external void doesNotDecrease/*<T>*/(Function modifier, dynamic/*=T*/ object, String property,
                                        [String message]);
   
   /// Asserts if value is not a false value, and throws if it is a true value.
   /// @type T   Type of object.
   /// @remarks This is added to allow for chai to be a drop-in replacement for
   /// Node’s assert class.
   external void ifError/*<T>*/(dynamic/*=T*/ object, [String message]);
   
   /// Asserts that object is extensible (can have new properties added to it).
   /// @type T   Type of object
   external void isExtensible/*<T>*/(dynamic/*=T*/ object, [String message]);
   
   /// Asserts that object is extensible (can have new properties added to it).
   /// @type T   Type of object
   external void extensible/*<T>*/(dynamic/*=T*/ object, [String message]);
   
   /// Asserts that object is not extensible.
   /// @type T   Type of object
   external void isNotExtensible/*<T>*/(dynamic/*=T*/ object, [String message]);
   
   /// Asserts that object is not extensible.
   /// @type T   Type of object
   external void notExtensible/*<T>*/(dynamic/*=T*/ object, [String message]);
   
   /// Asserts that object is sealed (can have new properties added to it
   /// and its existing properties cannot be removed).
   /// @type T   Type of object
   external void isSealed/*<T>*/(dynamic/*=T*/ object, [String message]);
   
   /// Asserts that object is sealed (can have new properties added to it
   /// and its existing properties cannot be removed).
   /// @type T   Type of object
   external void sealed/*<T>*/(dynamic/*=T*/ object, [String message]);
   
   /// Asserts that object is not sealed.
   /// @type T   Type of object
   external void isNotSealed/*<T>*/(dynamic/*=T*/ object, [String message]);
   
   /// Asserts that object is not sealed.
   /// @type T   Type of object
   external void notSealed/*<T>*/(dynamic/*=T*/ object, [String message]);
   
   /// Asserts that object is frozen (cannot have new properties added to it
   /// and its existing properties cannot be removed).
   /// @type T   Type of object
   external void isFrozen/*<T>*/(dynamic/*=T*/ object, [String message]);
   
   /// Asserts that object is frozen (cannot have new properties added to it
   /// and its existing properties cannot be removed).
   /// @type T   Type of object
   external void frozen/*<T>*/(dynamic/*=T*/ object, [String message]);
   
   /// Asserts that object is not frozen (cannot have new properties added to it
   /// and its existing properties cannot be removed).
   /// @type T   Type of object
   external void isNotFrozen/*<T>*/(dynamic/*=T*/ object, [String message]);
   
   /// Asserts that object is not frozen (cannot have new properties added to it
   /// and its existing properties cannot be removed).
   /// @type T   Type of object
   external void notFrozen/*<T>*/(dynamic/*=T*/ object, [String message]);
   
   /// Asserts that the target does not contain any values. For arrays and
   /// strings, it checks the length property. For Map and Set instances, it
   /// checks the size property. For non-function objects, it gets the count
   /// of own enumerable string keys.
   /// @type T   Type of object
   external void isEmpty/*<T>*/(dynamic/*=T*/ object, [String message]);
   
   /// Asserts that the target contains values. For arrays and strings, it checks
   /// the length property. For Map and Set instances, it checks the size property.
   /// For non-function objects, it gets the count of own enumerable string keys.
   /// @type T   Type of object.
   external void isNotEmpty/*<T>*/(dynamic/*=T*/ object, [String message]);
   
   /// Asserts that `object` has at least one of the `keys` provided.
   /// You can also provide a single object instead of a `keys` array and its keys
   /// will be used as the expected set of keys.
   /// @type T   Type of object.
   external void hasAnyKeys/*<T>*/(dynamic/*=T*/ object,
                                   dynamic /*List<Object|String>|JSMap of <String,dynamic>*/ keys,
                                   [String message]);
   
   /// Asserts that `object` has all and only all of the `keys` provided.
   /// You can also provide a single object instead of a `keys` array and its keys
   /// will be used as the expected set of keys.
   /// @type T   Type of object.
   external void hasAllKeys/*<T>*/(dynamic/*=T*/ object,
                                   dynamic /*List<Object|String>|JSMap of <String,dynamic>*/ keys,
                                   [String message]);
   
   /// Asserts that `object` has all of the `keys` provided but may have more keys not listed.
   /// You can also provide a single object instead of a `keys` array and its keys
   /// will be used as the expected set of keys.
   /// @type T   Type of object.
   external void containsAllKeys/*<T>*/(dynamic/*=T*/ object,
                                        dynamic /*List<Object|String>|JSMap of <String,dynamic>*/ keys,
                                        [String message]);
   
   /// Asserts that `object` has none of the `keys` provided.
   /// You can also provide a single object instead of a `keys` array and its keys
   /// will be used as the expected set of keys.
   /// @type T   Type of object.
   external void doesNotHaveAnyKeys/*<T>*/(dynamic/*=T*/ object,
                                           dynamic /*List<Object|String>|JSMap of <String,dynamic>*/ keys,
                                           [String message]);
   
   /// Asserts that `object` does not have at least one of the `keys` provided.
   /// You can also provide a single object instead of a `keys` array and its keys
   /// will be used as the expected set of keys.
   /// @type T   Type of object.
   external void doesNotHaveAllKeys/*<T>*/(dynamic/*=T*/ object,
                                           dynamic /*List<Object|String>|JSMap of <String,dynamic>*/ keys,
                                           [String message]);
   
   /// Asserts that `object` has at least one of the `keys` provided.
   /// Since Sets and Maps can have objects as keys you can use this assertion to perform
   /// a deep comparison.
   /// You can also provide a single object instead of a `keys` array and its keys
   /// will be used as the expected set of keys.
   /// @type T   Type of object.
   external void hasAnyDeepKeys/*<T>*/(dynamic/*=T*/ object,
                                       dynamic /*List<Object|String>|JSMap of <String,dynamic>*/ keys,
                                       [String message]);
   
   /// Asserts that `object` has all and only all of the `keys` provided.
   /// Since Sets and Maps can have objects as keys you can use this assertion to perform
   /// a deep comparison.
   /// You can also provide a single object instead of a `keys` array and its keys
   /// will be used as the expected set of keys.
   /// @type T   Type of object.
   external void hasAllDeepKeys/*<T>*/(dynamic/*=T*/ object,
                                       dynamic /*List<Object|String>|JSMap of <String,dynamic>*/ keys,
                                       [String message]);
   
   /// Asserts that `object` contains all of the `keys` provided.
   /// Since Sets and Maps can have objects as keys you can use this assertion to perform
   /// a deep comparison.
   /// You can also provide a single object instead of a `keys` array and its keys
   /// will be used as the expected set of keys.
   /// @type T   Type of object.
   external void containsAllDeepKeys/*<T>*/(dynamic/*=T*/ object,
                                            dynamic /*List<Object|String>|JSMap of <String,dynamic>*/ keys,
                                            [String message]);
   
   /// Asserts that `object` contains all of the `keys` provided.
   /// Since Sets and Maps can have objects as keys you can use this assertion to perform
   /// a deep comparison.
   /// You can also provide a single object instead of a `keys` array and its keys
   /// will be used as the expected set of keys.
   /// @type T   Type of object.
   external void doesNotHaveAnyDeepKeys/*<T>*/(dynamic/*=T*/ object,
                                               dynamic /*List<Object|String>|JSMap of <String,dynamic>*/ keys,
                                               [String message]);
   
   /// Asserts that `object` contains all of the `keys` provided.
   /// Since Sets and Maps can have objects as keys you can use this assertion to perform
   /// a deep comparison.
   /// You can also provide a single object instead of a `keys` array and its keys
   /// will be used as the expected set of keys.
   /// @type T   Type of object.
   external void doesNotHaveAllDeepKeys/*<T>*/(dynamic/*=T*/ object,
                                               dynamic /*List<Object|String>|JSMap of <String,dynamic>*/ keys,
                                               [String message]);
   
   /// Asserts that object has a direct or inherited property named by property,
   /// which can be a string using dot- and bracket-notation for nested reference.
   /// @type T   Type of object.
   external void nestedProperty/*<T>*/(dynamic/*=T*/ object, String property,
                                       [String message]);
   
   /// Asserts that object does not have a property named by property,
   /// which can be a string using dot- and bracket-notation for nested reference.
   /// The property cannot exist on the object nor anywhere in its prototype chain.
   /// @type T   Type of object.
   external void notNestedProperty/*<T>*/(dynamic/*=T*/ object, String property,
                                          [String message]);
   
   /// Asserts that object has a property named by property with value given by value.
   /// property can use dot- and bracket-notation for nested reference. Uses a strict equality check (===).
   /// @type T   Type of object.
   external void nestedPropertyVal/*<T>*/(dynamic/*=T*/ object, String property, dynamic value,
                                          [String message]);
   
   /// Asserts that object does not have a property named by property with value given by value.
   /// property can use dot- and bracket-notation for nested reference. Uses a strict equality check (===).
   /// @type T   Type of object.
   external void notNestedPropertyVal/*<T>*/(dynamic/*=T*/ object, String property, dynamic value,
                                             [String message]);
   
   /// Asserts that object has a property named by property with a value given by value.
   /// property can use dot- and bracket-notation for nested reference. Uses a deep equality check.
   /// @type T   Type of object.
   external void deepNestedPropertyVal/*<T>*/(dynamic/*=T*/ object, String property, dynamic value,
                                              [String message]);
   
   /// Asserts that object does not have a property named by property with value given by value.
   /// property can use dot- and bracket-notation for nested reference. Uses a deep equality check.
   /// @type T   Type of object.
   external void notDeepNestedPropertyVal/*<T>*/(dynamic/*=T*/ object, String property, dynamic value,
                                                 [String message]);
}

@anonymous
@JS()
abstract class Config {
   /// Default: false
   external bool get includeStack;
   
   external set includeStack(bool v);
   
   /// Default: true
   external bool get showDiff;
   
   external set showDiff(bool v);
   
   /// Default: 40
   external num get truncateThreshold;
   
   external set truncateThreshold(num v);
   
   external factory Config({bool includeStack, bool showDiff, num truncateThreshold});
}

@JS("Chai.AssertionError")
class AssertionError {
   // @Ignore
   AssertionError.fakeConstructor$();
   
   external factory AssertionError(String message,
                                   [dynamic JS$_props, Function ssf]);
   
   external String get name;
   
   external set name(String v);
   
   external String get message;
   
   external set message(String v);
   
   external bool get showDiff;
   
   external set showDiff(bool v);
   
   external String get stack;
   
   external set stack(String v);
}
// End module Chai
@JS()
external ChaiStatic get chai;
// Module chai
/* WARNING: export assignment not yet supported. */
// End module chai
@anonymous
@JS()
abstract class Object {
   external Assertion get should;
   
   external set should(Assertion v);
}
