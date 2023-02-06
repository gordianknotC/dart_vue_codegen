@JS()
library mocha;
import '../../common/window.dart' show Promise;

import "dart:js_util" show getProperty, setProperty;
import "package:js/js.dart";
import "dart:html" show LIElement, Window;

/// Type definitions for mocha 5.2
/// Project: http://mochajs.org/
/// Definitions by: Kazi Manzur Rashid <https://github.com/kazimanzurrashid>
/// otiai10 <https://github.com/otiai10>
/// jt000 <https://github.com/jt000>
/// Vadim Macagon <https://github.com/enlight>
/// Andrew Bradley <https://github.com/cspotcode>
/// Dmitrii Sorin <https://github.com/1999>
/// Definitions: https://github.com/DefinitelyTyped/DefinitelyTyped
/// TypeScript Version: 2.1

/// Mocha API
/// @see https://mochajs.org/api/mocha
@JS()
class Mocha {
   // @Ignore
   Mocha .fakeConstructor$();
   
   external get JS$_growl;
   
   external set JS$_growl(v);
   
   external get JS$_reporter;
   
   external set JS$_reporter(v);
   
   external get JS$_ui;
   
   external set JS$_ui(v);
   
   external factory Mocha([MochaOptions options]);
   
   external Suite get suite;
   
   external set suite(Suite v);
   
   external List<String> get files;
   
   external set files(List<String> v);
   
   external MochaInstanceOptions get options;
   
   external set options(MochaInstanceOptions v);
   
   /// Enable or disable bailing on the first failure.
   /// @see https://mochajs.org/api/mocha#bail
   external Mocha bail([bool bail]);
   
   /// Add test `file`.
   /// @see https://mochajs.org/api/mocha#addFile
   external Mocha addFile(String file);
   
   /// Set reporter to one of the built-in reporters.
   /// @see https://mochajs.org/api/mocha#reporter
   /*external Mocha reporter(dynamic reporter, [dynamic reporterOptions]);*/
   
   /// Set reporter to the provided constructor, one of the built-in reporters, or loads a reporter
   /// from a module path. Defaults to `"spec"`.
   /// @see https://mochajs.org/api/mocha#reporter
   /*external Mocha reporter([String|ReporterConstructor reporter, dynamic reporterOptions]);*/
   external Mocha reporter([dynamic/*dynamic|String|ReporterConstructor*/ reporter, dynamic reporterOptions]);
   
   /// Set test UI to one of the built-in test interfaces.
   /// @see https://mochajs.org/api/mocha#ui
   /*external Mocha ui(dynamic name);*/
   
   /// Set test UI to one of the built-in test interfaces or loads a test interface from a module
   /// path. Defaults to `"bdd"`.
   /// @see https://mochajs.org/api/mocha#ui
   /*external Mocha ui([String name]);*/
   external Mocha ui([dynamic/*dynamic|String*/ name]);
   
   /// Escape string and add it to grep as a RegExp.
   /// @see https://mochajs.org/api/mocha#fgrep
   external Mocha fgrep(String str);
   
   /// Add regexp to grep, if `re` is a string it is escaped.
   /// @see https://mochajs.org/api/mocha#grep
   external Mocha grep(dynamic/*String|RegExp*/ re);
   
   /// Invert `.grep()` matches.
   /// @see https://mochajs.org/api/mocha#invert
   external Mocha invert();
   
   /// Ignore global leaks.
   /// @see https://mochajs.org/api/mocha#ignoreLeaks
   external Mocha ignoreLeaks(bool ignore);
   
   /// Enable global leak checking.
   /// @see https://mochajs.org/api/mocha#checkLeaks
   external Mocha checkLeaks();
   
   /// Display long stack-trace on failing
   /// @see https://mochajs.org/api/mocha#fullTrace
   external Mocha fullTrace();
   
   /// Enable growl support.
   /// @see https://mochajs.org/api/mocha#growl
   external Mocha growl();
   
   /// Ignore `globals` array or string.
   /// @see https://mochajs.org/api/mocha#globals
   external Mocha globals(dynamic/*String|ReadonlyArray<String>*/ globals);
   
   /// Emit color output.
   /// @see https://mochajs.org/api/mocha#useColors
   external Mocha useColors(bool colors);
   
   /// Use inline diffs rather than +/-.
   /// @see https://mochajs.org/api/mocha#useInlineDiffs
   external Mocha useInlineDiffs(bool inlineDiffs);
   
   /// Do not show diffs at all.
   /// @see https://mochajs.org/api/mocha#hideDiff
   external Mocha hideDiff(bool hideDiff);
   
   /// Set the timeout in milliseconds.
   /// @see https://mochajs.org/api/mocha#timeout
   external Mocha timeout(dynamic/*String|num*/ timeout);
   
   /// Set the number of times to retry failed tests.
   /// @see https://mochajs.org/api/mocha#retries
   external Mocha retries(num n);
   
   /// Set slowness threshold in milliseconds.
   /// @see https://mochajs.org/api/mocha#slow
   external Mocha slow(dynamic/*String|num*/ slow);
   
   /// Enable timeouts.
   /// @see https://mochajs.org/api/mocha#enableTimeouts
   external Mocha enableTimeouts([bool enabled]);
   
   /// Makes all tests async (accepting a callback)
   /// @see https://mochajs.org/api/mocha#asyncOnly.
   external Mocha asyncOnly();
   
   /// Disable syntax highlighting (in browser).
   /// @see https://mochajs.org/api/mocha#noHighlighting
   external Mocha noHighlighting();
   
   /// Enable uncaught errors to propagate (in browser).
   /// @see https://mochajs.org/api/mocha#allowUncaught
   external bool allowUncaught();
   
   /// Delay root suite execution.
   /// @see https://mochajs.org/api/mocha#delay
   external bool delay();
   
   /// Tests marked only fail the suite
   /// @see https://mochajs.org/api/mocha#forbidOnly
   external bool forbidOnly();
   
   /// Pending tests and tests marked skip fail the suite
   /// @see https://mochajs.org/api/mocha#forbidPending
   external bool forbidPending();
   
   /// Run tests and invoke `fn()` when complete.
   /// Note that `run` relies on Node's `require` to execute
   /// the test interface functions and will be subject to the
   /// cache - if the files are already in the `require` cache,
   /// they will effectively be skipped. Therefore, to run tests
   /// multiple times or to run tests in files that are already
   /// in the `require` cache, make sure to clear them from the
   /// cache first in whichever manner best suits your needs.
   /// @see https://mochajs.org/api/mocha#run
   external Runner run([void fn(num failures)]);
   
   /// Load registered files.
   /// @see https://mochajs.org/api/mocha#loadFiles
   external void loadFiles([void fn()]);
}

// Module Mocha

// Module utils
/// Compute a slug from the given `str`.
/// @see https://mochajs.org/api/module-utils.html#.slug
@JS("Mocha.utils.slug")
external String slug(String str);

/// Strip the function definition from `str`, and re-indent for pre whitespace.
/// @see https://mochajs.org/api/module-utils.html#.clean
@JS("Mocha.utils.clean")
external String clean(String str);

/// Highlight the given string of `js`.
@JS("Mocha.utils.highlight")
external String highlight(String js);

/// Takes some variable and asks `Object.prototype.toString()` what it thinks it is.
@JS("Mocha.utils.type")
external String type(dynamic value);

/// Stringify `value`. Different behavior depending on type of value:
/// - If `value` is undefined or null, return `'[undefined]'` or `'[null]'`, respectively.
/// - If `value` is not an object, function or array, return result of `value.toString()` wrapped in double-quotes.
/// - If `value` is an *empty* object, function, or array, returns `'{}'`, `'[Function]'`, or `'[]'` respectively.
/// - If `value` has properties, call canonicalize} on it, then return result of `JSON.stringify()`
/// @see https://mochajs.org/api/module-utils.html#.stringify
@JS("Mocha.utils.stringify")
external String stringify(dynamic value);

/// Return a new Thing that has the keys in sorted order. Recursive.
/// If the Thing...
/// - has already been seen, return string `'[Circular]'`
/// - is `undefined`, return string `'[undefined]'`
/// - is `null`, return value `null`
/// - is some other primitive, return the value
/// - is not a primitive or an `Array`, `Object`, or `Function`, return the value of the Thing's `toString()` method
/// - is a non-empty `Array`, `Object`, or `Function`, return the result of calling this function again.
/// - is an empty `Array`, `Object`, or `Function`, returns `'[]'`, `'{}'`, or `'[Function]'` respectively.
/// @see https://mochajs.org/api/module-utils.html#.canonicalize
@JS("Mocha.utils.canonicalize")
external dynamic canonicalize(dynamic value, List<dynamic> stack, String typeHint);

/// Lookup file names at the given `path`.
/// @see https://mochajs.org/api/Mocha.utils.html#.exports.lookupFiles
@JS("Mocha.utils.lookupFiles")
external List<String> lookupFiles(String filepath, [List<String> extensions, bool recursive]);

/// Generate an undefined error with a message warning the user.
/// @see https://mochajs.org/api/module-utils.html#.undefinedError
@JS("Mocha.utils.undefinedError")
external Error undefinedError();

/// Generate an undefined error if `err` is not defined.
/// @see https://mochajs.org/api/module-utils.html#.getError
@JS("Mocha.utils.getError")
external Error getError(dynamic/*Error|dynamic*/ err);

/// When invoking this function you get a filter function that get the Error.stack as an
/// input, and return a prettify output. (i.e: strip Mocha and internal node functions from
/// stack trace).
/// @see https://mochajs.org/api/module-utils.html#.stackTraceFilter
@JS("Mocha.utils.stackTraceFilter")
external String Function(String stack) stackTraceFilter();
// End module utils

// Module interfaces
@JS("Mocha.interfaces.bdd")
external void bdd(Suite suite);

@JS("Mocha.interfaces.tdd")
external void tdd(Suite suite);

@JS("Mocha.interfaces.qunit")
external void qunit(Suite suite);

@JS("Mocha.interfaces.exports")
external void exports(Suite suite);
// End module interfaces
/// #region Test interface augmentations
@anonymous
@JS()
abstract class HookFunction {
   /// [bdd, qunit, tdd] Describe a "hook" to execute the given callback `fn`. The name of the
   /// function is used as the name of the hook.
   /// - _Only available when invoked via the mocha CLI._
   /*external void call(Func fn);*/
   
   /// [bdd, qunit, tdd] Describe a "hook" to execute the given callback `fn`. The name of the
   /// function is used as the name of the hook.
   /// - _Only available when invoked via the mocha CLI._
   /*external void call(AsyncFunc fn);*/
   
   /// [bdd, qunit, tdd] Describe a "hook" to execute the given `title` and callback `fn`.
   /// - _Only available when invoked via the mocha CLI._
   /*external void call(String name, [Func fn]);*/
   
   /// [bdd, qunit, tdd] Describe a "hook" to execute the given `title` and callback `fn`.
   /// - _Only available when invoked via the mocha CLI._
   /*external void call(String name, [AsyncFunc fn]);*/
   external void call(String fn_name, [fn]);
}

@anonymous
@JS()
abstract class SuiteFunction {
   /// [bdd, tdd] Describe a "suite" with the given `title` and callback `fn` containing
   /// nested suites.
   /// - _Only available when invoked via the mocha CLI._
   /*external Suite call(String title, void fn(Suite JS$this));*/
   
   /// [qunit] Describe a "suite" with the given `title`.
   /// - _Only available when invoked via the mocha CLI._
   /*external Suite call(String title);*/
   external Suite call(String title, [void fn(/*Suite this*/)]);
   
   /// [bdd, tdd, qunit] Indicates this suite should be executed exclusively.
   /// - _Only available when invoked via the mocha CLI._
   external ExclusiveSuiteFunction get only;
   
   external set only(ExclusiveSuiteFunction v);
   
   /// [bdd, tdd] Indicates this suite should not be executed.
   /// - _Only available when invoked via the mocha CLI._
   external PendingSuiteFunction get skip;
   
   external set skip(PendingSuiteFunction v);
}

@anonymous
@JS()
abstract class ExclusiveSuiteFunction {
   /// [bdd, tdd] Describe a "suite" with the given `title` and callback `fn` containing
   /// nested suites. Indicates this suite should be executed exclusively.
   /// - _Only available when invoked via the mocha CLI._
   /*external Suite call(String title, void fn(Suite JS$this));*/
   
   /// [qunit] Describe a "suite" with the given `title`. Indicates this suite should be executed
   /// exclusively.
   /// - _Only available when invoked via the mocha CLI._
   /*external Suite call(String title);*/
   external Suite call(String title, [void fn(/*Suite this*/)]);
}

/// [bdd, tdd] Describe a "suite" with the given `title` and callback `fn` containing
/// nested suites. Indicates this suite should not be executed.
/// - _Only available when invoked via the mocha CLI._
typedef dynamic/*Suite|Null*/ PendingSuiteFunction(String title, void fn(/*Suite this*/));

@anonymous
@JS()
abstract class TestFunction {
   /// Describe a specification or test-case with the given callback `fn` acting as a thunk.
   /// The name of the function is used as the name of the test.
   /// - _Only available when invoked via the mocha CLI._
   /*external Test call(Func fn);*/
   
   /// Describe a specification or test-case with the given callback `fn` acting as a thunk.
   /// The name of the function is used as the name of the test.
   /// - _Only available when invoked via the mocha CLI._
   /*external Test call(AsyncFunc fn);*/
   
   /// Describe a specification or test-case with the given `title` and callback `fn` acting
   /// as a thunk.
   /// - _Only available when invoked via the mocha CLI._
   /*external Test call(String title, [Func fn]);*/
   
   /// Describe a specification or test-case with the given `title` and callback `fn` acting
   /// as a thunk.
   /// - _Only available when invoked via the mocha CLI._
   /*external Test call(String title, [AsyncFunc fn]);*/
   external Test call(String fn_title, [fn]);
   
   /// Indicates this test should be executed exclusively.
   /// - _Only available when invoked via the mocha CLI._
   external ExclusiveTestFunction get only;
   
   external set only(ExclusiveTestFunction v);
   
   /// Indicates this test should not be executed.
   /// - _Only available when invoked via the mocha CLI._
   external PendingTestFunction get skip;
   
   external set skip(PendingTestFunction v);
   
   /// Number of attempts to retry.
   /// - _Only available when invoked via the mocha CLI._
   external void retries(num n);
}

@anonymous
@JS()
abstract class ExclusiveTestFunction {
   /// [bdd, tdd, qunit] Describe a specification or test-case with the given callback `fn`
   /// acting as a thunk. The name of the function is used as the name of the test. Indicates
   /// this test should be executed exclusively.
   /// - _Only available when invoked via the mocha CLI._
   /*external Test call(Func fn);*/
   
   /// [bdd, tdd, qunit] Describe a specification or test-case with the given callback `fn`
   /// acting as a thunk. The name of the function is used as the name of the test. Indicates
   /// this test should be executed exclusively.
   /// - _Only available when invoked via the mocha CLI._
   /*external Test call(AsyncFunc fn);*/
   
   /// [bdd, tdd, qunit] Describe a specification or test-case with the given `title` and
   /// callback `fn` acting as a thunk. Indicates this test should be executed exclusively.
   /// - _Only available when invoked via the mocha CLI._
   /*external Test call(String title, [Func fn]);*/
   
   /// [bdd, tdd, qunit] Describe a specification or test-case with the given `title` and
   /// callback `fn` acting as a thunk. Indicates this test should be executed exclusively.
   /// - _Only available when invoked via the mocha CLI._
   /*external Test call(String title, [AsyncFunc fn]);*/
   external Test call(String fn_title, [fn]);
}

@anonymous
@JS()
abstract class PendingTestFunction {
   /// [bdd, tdd, qunit] Describe a specification or test-case with the given callback `fn`
   /// acting as a thunk. The name of the function is used as the name of the test. Indicates
   /// this test should not be executed.
   /// - _Only available when invoked via the mocha CLI._
   /*external Test call(Func fn);*/
   
   /// [bdd, tdd, qunit] Describe a specification or test-case with the given callback `fn`
   /// acting as a thunk. The name of the function is used as the name of the test. Indicates
   /// this test should not be executed.
   /// - _Only available when invoked via the mocha CLI._
   /*external Test call(AsyncFunc fn);*/
   
   /// [bdd, tdd, qunit] Describe a specification or test-case with the given `title` and
   /// callback `fn` acting as a thunk. Indicates this test should not be executed.
   /// - _Only available when invoked via the mocha CLI._
   /*external Test call(String title, [Func fn]);*/
   
   /// [bdd, tdd, qunit] Describe a specification or test-case with the given `title` and
   /// callback `fn` acting as a thunk. Indicates this test should not be executed.
   /// - _Only available when invoked via the mocha CLI._
   /*external Test call(String title, [AsyncFunc fn]);*/
   external Test call(String fn_title, [fn]);
}

/// Execute after each test case.
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#afterEach
@JS("Mocha.afterEach")
external HookFunction get afterEach;

@JS("Mocha.afterEach")
external set afterEach(HookFunction v);

/// Execute after running tests.
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#after
@JS("Mocha.after")
external HookFunction get after;

@JS("Mocha.after")
external set after(HookFunction v);

/// Execute before each test case.
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#beforeEach
@JS("Mocha.beforeEach")
external HookFunction get beforeEach;

@JS("Mocha.beforeEach")
external set beforeEach(HookFunction v);

/// Execute before running tests.
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#before
@JS("Mocha.before")
external HookFunction get before;

@JS("Mocha.before")
external set before(HookFunction v);

/// Describe a "suite" containing nested suites and tests.
/// - _Only available when invoked via the mocha CLI._
@JS("Mocha.describe")
external SuiteFunction get describe;

@JS("Mocha.describe")
external set describe(SuiteFunction v);

/// Describes a test case.
/// - _Only available when invoked via the mocha CLI._
@JS("Mocha.it")
external TestFunction get it;

@JS("Mocha.it")
external set it(TestFunction v);

/// Describes a pending test case.
/// - _Only available when invoked via the mocha CLI._
@JS("Mocha.xit")
external PendingTestFunction get xit;

@JS("Mocha.xit")
external set xit(PendingTestFunction v);

/// Execute before each test case.
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#beforeEach
@JS("Mocha.setup")
external HookFunction get setup;

@JS("Mocha.setup")
external set setup(HookFunction v);

/// Execute before running tests.
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#before
@JS("Mocha.suiteSetup")
external HookFunction get suiteSetup;

@JS("Mocha.suiteSetup")
external set suiteSetup(HookFunction v);

/// Execute after running tests.
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#after
@JS("Mocha.suiteTeardown")
external HookFunction get suiteTeardown;

@JS("Mocha.suiteTeardown")
external set suiteTeardown(HookFunction v);

/// Describe a "suite" containing nested suites and tests.
/// - _Only available when invoked via the mocha CLI._
@JS("Mocha.suite")
external SuiteFunction get suite;

@JS("Mocha.suite")
external set suite(SuiteFunction v);

/// Execute after each test case.
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#afterEach
@JS("Mocha.teardown")
external HookFunction get teardown;

@JS("Mocha.teardown")
external set teardown(HookFunction v);

/// Describes a test case.
/// - _Only available when invoked via the mocha CLI._
@JS("Mocha.test")
external TestFunction get test;

@JS("Mocha.test")
external set test(TestFunction v);

/// Triggers root suite execution.
/// - _Only available if flag --delay is passed into Mocha._
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#runWithSuite
@JS("Mocha.run")
external void run();

/// #endregion Test interface augmentations

// Module reporters
/// Initialize a new `Base` reporter.
/// All other reporters generally inherit from this reporter, providing stats such as test duration,
/// number of tests passed / failed, etc.
/// @see https://mochajs.org/api/Mocha.reporters.Base.html
@JS("Mocha.reporters.Base")
class Base {
   // @Ignore
   Base .fakeConstructor$();
   
   /*external factory Base(Runner runner, [MochaOptions options]);*/
   
   /// Use the overload that accepts `Mocha.Runner` instead.
   /*external factory Base(IRunner runner, [MochaOptions options]);*/
   external factory Base(dynamic/*Runner|IRunner*/ runner, [MochaOptions options]);
   
   /// Test run statistics
   external Stats get stats;
   
   external set stats(Stats v);
   
   /// Test failures
   external List<Test> get failures;
   
   external set failures(List<Test> v);
   
   /// The configured runner
   external Runner get runner;
   
   external set runner(Runner v);
   
   /// Output common epilogue used by many of the bundled reporters.
   /// @see https://mochajs.org/api/Mocha.reporters.Base.html#.Base#epilogue
   external void epilogue();
   
   external void done(num failures, [void fn(num failures)]);
}

// Module Base
/// Enables coloring by default
/// @see https://mochajs.org/api/module-base#.useColors
@JS("Mocha.reporters.Base.useColors")
external bool get useColors;

@JS("Mocha.reporters.Base.useColors")
external set useColors(bool v);

/// Inline diffs instead of +/-
/// @see https://mochajs.org/api/module-base#.inlineDiffs
@JS("Mocha.reporters.Base.inlineDiffs")
external bool get inlineDiffs;

@JS("Mocha.reporters.Base.inlineDiffs")
external set inlineDiffs(bool v);

/// Default color map
/// @see https://mochajs.org/api/module-base#.colors
@JS("Mocha.reporters.Base.colors")
external ColorMap get colors;

/// Default color map
/// @see https://mochajs.org/api/module-base#.colors
@anonymous
@JS()
abstract class ColorMap {
   /// added by Base
   index(String name, [value]) {
      if (value == null)
         return getProperty(this, name);
      setProperty(this, name, value);
   }
   
   external num get pass;
   
   external set pass(num v);
   
   external num get fail;
   
   external set fail(num v);
   
   num get bright_pass {
      return index("bright pass");
   }
   
   void set bright_pass(num v) {
      index("bright pass", v);
   }
   
   num get bright_fail {
      return index("bright fail");
   }
   
   void set bright_fail(num v) {
      index("bright fail", v);
   }
   
   num get bright_yellow {
      return index("bright yellow");
   }
   
   void set bright_yellow(num v) {
      index("bright yellow", v);
   }
   
   external num get pending;
   
   external set pending(num v);
   
   external num get suite;
   
   external set suite(num v);
   
   num get error_title {
      return index("error title");
   }
   
   void set error_title(num v) {
      index("error title", v);
   }
   
   num get error_message {
      return index("error message");
   }
   
   void set error_message(num v) {
      index("error message", v);
   }
   
   num get error_stack {
      return index("error stack");
   }
   
   void set error_stack(num v) {
      index("error stack", v);
   }
   
   external num get checkmark;
   
   external set checkmark(num v);
   
   external num get fast;
   
   external set fast(num v);
   
   external num get medium;
   
   external set medium(num v);
   
   external num get slow;
   
   external set slow(num v);
   
   external num get green;
   
   external set green(num v);
   
   external num get light;
   
   external set light(num v);
   
   num get diff_gutter {
      return index("diff gutter");
   }
   
   void set diff_gutter(num v) {
      index("diff gutter", v);
   }
   
   num get diff_added {
      return index("diff added");
   }
   
   void set diff_added(num v) {
      index("diff added", v);
   }
   
   num get diff_removed {
      return index("diff removed");
   }
   
   void set diff_removed(num v) {
      index("diff removed", v);
   }
   
   /// added by Progress
   external num get progress;
   
   external set progress(num v);
   
   /// added by Landing
   external num get plane;
   
   external set plane(num v);
   
   num get plane_crash {
      return index("plane crash");
   }
   
   void set plane_crash(num v) {
      index("plane crash", v);
   }
   
   external num get runway;
   
   external set runway(num v);
/* Index signature is not yet supported by JavaScript interop. */
}

/// Default symbol map
/// @see https://mochajs.org/api/module-base#.symbols
@JS("Mocha.reporters.Base.symbols")
external SymbolMap get symbols;

/// Default symbol map
/// @see https://mochajs.org/api/module-base#.symbols
@anonymous
@JS()
abstract class SymbolMap {
   external String get ok;
   
   external set ok(String v);
   
   external String get err;
   
   external set err(String v);
   
   external String get dot;
   
   external set dot(String v);
   
   external String get comma;
   
   external set comma(String v);
   
   external String get bang;
   
   external set bang(String v);
/* Index signature is not yet supported by JavaScript interop. */
}

/// Color `str` with the given `type` (from `colors`)
/// @see https://mochajs.org/api/module-base#.color
@JS("Mocha.reporters.Base.color")
external String color(String type, String str);

/// Expose terminal window size
/// @see https://mochajs.org/api/module-base#.window
@JS("Mocha.reporters.Base.window")
external dynamic/*{
                width: number;
            }*/
get window;

/// ANSI TTY control sequences common among reporters.
/// @see https://mochajs.org/api/module-base#.cursor

// Module cursor
/// Hides the cursor
@JS("Mocha.reporters.Base.cursor.hide")
external void hide();

/// Shows the cursor
@JS("Mocha.reporters.Base.cursor.show")
external void show();

/// Deletes the current line
@JS("Mocha.reporters.Base.cursor.deleteLine")
external void deleteLine();

/// Moves to the beginning of the line
@JS("Mocha.reporters.Base.cursor.beginningOfLine")
external void beginningOfLine();

/// Clears the line and moves to the beginning of the line.
@JS("Mocha.reporters.Base.cursor.CR")
external void CR();
// End module cursor
/// Returns a diff between two strings with colored ANSI output.
/// @see https://mochajs.org/api/module-base#.generateDiff
@JS("Mocha.reporters.Base.generateDiff")
external String generateDiff(String actual, String expected);

/// Output the given `failures` as a list.
/// @see https://mochajs.org/api/Mocha.reporters.Base.html#.exports.list1
@JS("Mocha.reporters.Base.list")
external void list(List<Test> failures);
// End module Base
/// Initialize a new `Dot` matrix test reporter.
/// @see https://mochajs.org/api/Mocha.reporters.Dot.html
@JS("Mocha.reporters.Dot")
class Dot extends Base {
   // @Ignore
   Dot .fakeConstructor$() : super.fakeConstructor$();
}

/// Initialize a new `Doc` reporter.
/// @see https://mochajs.org/api/Mocha.reporters.Doc.html
@JS("Mocha.reporters.Doc")
class Doc extends Base {
   // @Ignore
   Doc .fakeConstructor$() : super.fakeConstructor$();
}

/// Initialize a new `TAP` test reporter.
/// @see https://mochajs.org/api/Mocha.reporters.TAP.html
@JS("Mocha.reporters.TAP")
class TAP extends Base {
   // @Ignore
   TAP .fakeConstructor$() : super.fakeConstructor$();
}

/// Initialize a new `JSON` reporter
/// @see https://mochajs.org/api/Mocha.reporters.JSON.html
@JS("Mocha.reporters.JSON")
class JSON extends Base {
   // @Ignore
   JSON .fakeConstructor$() : super.fakeConstructor$();
}

/// Initialize a new `HTML` reporter.
/// - _This reporter cannot be used on the console._
/// @see https://mochajs.org/api/Mocha.reporters.HTML.html
@JS("Mocha.reporters.HTML")
class HTML extends Base {
   // @Ignore
   HTML .fakeConstructor$() : super.fakeConstructor$();
   
   /// Provide suite URL.
   /// @see https://mochajs.org/api/Mocha.reporters.HTML.html#suiteURL
   external String suiteURL(Suite suite);
   
   /// Provide test URL.
   /// @see https://mochajs.org/api/Mocha.reporters.HTML.html#testURL
   external String testURL(Test test);
   
   /// Adds code toggle functionality for the provided test's list element.
   /// @see https://mochajs.org/api/Mocha.reporters.HTML.html#addCodeToggle
   external void addCodeToggle(LIElement el, String contents);
}

/// Initialize a new `List` test reporter.
/// @see https://mochajs.org/api/Mocha.reporters.List.html
@JS("Mocha.reporters.List")
class MList extends Base {
   // @Ignore
   MList.fakeConstructor$() : super.fakeConstructor$();
}

/// Initialize a new `Min` minimal test reporter (best used with --watch).
/// @see https://mochajs.org/api/Mocha.reporters.Min.html
@JS("Mocha.reporters.Min")
class Min extends Base {
   // @Ignore
   Min .fakeConstructor$() : super.fakeConstructor$();
}

/// Initialize a new `Spec` test reporter.
/// @see https://mochajs.org/api/Mocha.reporters.Spec.html
@JS("Mocha.reporters.Spec")
class Spec extends Base {
   // @Ignore
   Spec .fakeConstructor$() : super.fakeConstructor$();
}

/// Initialize a new `NyanCat` test reporter.
/// @see https://mochajs.org/api/Mocha.reporters.Nyan.html
@JS("Mocha.reporters.Nyan")
class Nyan extends Base {
   // @Ignore
   Nyan .fakeConstructor$() : super.fakeConstructor$();
   
   external get colorIndex;
   
   external set colorIndex(v);
   
   external get numberOfLines;
   
   external set numberOfLines(v);
   
   external get rainbowColors;
   
   external set rainbowColors(v);
   
   external get scoreboardWidth;
   
   external set scoreboardWidth(v);
   
   external get tick;
   
   external set tick(v);
   
   external get trajectories;
   
   external set trajectories(v);
   
   external get trajectoryWidthMax;
   
   external set trajectoryWidthMax(v);
   
   external get draw;
   
   external set draw(v);
   
   external get drawScoreboard;
   
   external set drawScoreboard(v);
   
   external get appendRainbow;
   
   external set appendRainbow(v);
   
   external get drawRainbow;
   
   external set drawRainbow(v);
   
   external get drawNyanCat;
   
   external set drawNyanCat(v);
   
   external get face;
   
   external set face(v);
   
   external get cursorUp;
   
   external set cursorUp(v);
   
   external get cursorDown;
   
   external set cursorDown(v);
   
   external get generateColors;
   
   external set generateColors(v);
   
   external get rainbowify;
   
   external set rainbowify(v);
}

/// Initialize a new `XUnit` test reporter.
/// @see https://mochajs.org/api/Mocha.reporters.XUnit.html
@JS("Mocha.reporters.XUnit")
class XUnit extends Base {
   // @Ignore
   XUnit .fakeConstructor$() : super.fakeConstructor$();
   
   /*external factory XUnit(Runner runner, [XUnit_MochaOptions options]);*/
   
   /// Use the overload that accepts `Mocha.Runner` instead.
   /*external factory XUnit(IRunner runner, [XUnit_MochaOptions options]);*/
   external factory XUnit(dynamic/*Runner|IRunner*/ runner, [XUnit_MochaOptions options]);
   
   /// Override done to close the stream (if it's a file).
   /// @see https://mochajs.org/api/Mocha.reporters.XUnit.html#done
   external void done(num failures, [void fn(num failures)]);
   
   //external void done(num failures, [void fn(num failures)]);
   
   /// Write out the given line.
   /// @see https://mochajs.org/api/Mocha.reporters.XUnit.html#write
   external void write(String line);
   
   /// Output tag for the given `test.`
   /// @see https://mochajs.org/api/Mocha.reporters.XUnit.html#test
   external void test(Test test);
}

// Module XUnit
@anonymous
@JS()
abstract class XUnit_MochaOptions
   implements MochaOptions {
   external ReporterOptions get reporterOptions;
   
   //external set reporterOptions(dynamic v);
   external set reporterOptions(ReporterOptions v);
   
   external factory XUnit_MochaOptions({ ReporterOptions reporterOptions, dynamic
   
   /// Test interfaces ("bdd", "tdd", "exports", etc.).
   ui, dynamic/*String|ReporterConstructor*/
   
   /// Reporter constructor, built-in reporter name, or reporter module path. Defaults to
   /// `"spec"`.
   reporter, List<String>
   
   /// Array of accepted globals.
   globals, num
   
   /// timeout in milliseconds.
   timeout, bool enableTimeouts, num
   
   /// number of times to retry failed tests.
   retries, bool
   
   /// bail on the first test failure.
   bail, num
   
   /// milliseconds to wait before considering a test slow.
   slow, bool
   
   /// ignore global leaks.
   ignoreLeaks, bool
   
   /// display the full stack trace on failure.
   fullStackTrace, dynamic/*String|RegExp*/
   
   /// string or regexp to filter tests with.
   grep, bool
   
   /// Enable growl support.
   growl, bool
   
   /// Emit color output.
   useColors, bool
   
   /// Use inline diffs rather than +/-.
   inlineDiffs, bool
   
   /// Do not show diffs at all.
   hideDiff, bool asyncOnly, bool delay, bool forbidOnly, bool forbidPending, bool noHighlighting, bool allowUncaught});
}

@anonymous
@JS()
abstract class ReporterOptions {
   external String get output;
   
   external set output(String v);
   
   external String get suiteName;
   
   external set suiteName(String v);
   
   external factory ReporterOptions({ String output, String suiteName});
}

// End module XUnit
@JS("Mocha.reporters.Markdown")
class Markdown extends Base {
   // @Ignore
   Markdown .fakeConstructor$() : super.fakeConstructor$();
}

@JS("Mocha.reporters.Progress")
class Progress extends Base {
   // @Ignore
   Progress .fakeConstructor$() : super.fakeConstructor$();
   
   /*external factory Progress(Runner runner, [Progress_MochaOptions options]);*/
   /*external factory Progress(IRunner runner, [Progress_MochaOptions options]);*/
   external factory Progress(dynamic/*Runner|IRunner*/ runner, [Progress_MochaOptions options]);
}

// Module Progress
@anonymous
@JS()
abstract class Progress_MochaOptions
   implements MochaOptions {
   external ReporterOptions get reporterOptions;
   
   external set reporterOptions(ReporterOptions v);
   
   //external set reporterOptions(Progress_ReporterOptions v);
   external factory Progress_MochaOptions({ Progress_ReporterOptions reporterOptions, dynamic ui, dynamic/*String|ReporterConstructor*/ reporter, List<
      String> globals, num timeout, bool enableTimeouts, num retries, bool bail, num slow, bool ignoreLeaks, bool fullStackTrace, dynamic/*String|RegExp*/ grep, bool growl, bool useColors, bool inlineDiffs, bool hideDiff, bool asyncOnly, bool delay, bool forbidOnly, bool forbidPending, bool noHighlighting, bool allowUncaught});
}

@anonymous
@JS()
abstract class Progress_ReporterOptions {
   external String get open;
   
   external set open(String v);
   
   external String get complete;
   
   external set complete(String v);
   
   external String get incomplete;
   
   external set incomplete(String v);
   
   external String get close;
   
   external set close(String v);
   
   external bool get verbose;
   
   external set verbose(bool v);
   
   external factory Progress_ReporterOptions({ String open, String complete, String incomplete, String close, bool verbose});
}

// End module Progress
@JS("Mocha.reporters.Landing")
class Landing extends Base {
   // @Ignore
   Landing .fakeConstructor$() : super.fakeConstructor$();
}

@JS("Mocha.reporters.JSONStream")
class JSONStream extends Base {
   // @Ignore
   JSONStream .fakeConstructor$() : super.fakeConstructor$();
}

@JS("Mocha.reporters.base")
external dynamic get base;

@JS("Mocha.reporters.dot")
external dynamic get dot;

@JS("Mocha.reporters.doc")
external dynamic get doc;

@JS("Mocha.reporters.tap")
external dynamic get tap;

@JS("Mocha.reporters.json")
external dynamic get json;

@JS("Mocha.reporters.html")
external dynamic get html;

@JS("Mocha.reporters.list")
external dynamic get reporters_list;

@JS("Mocha.reporters.spec")
external dynamic get spec;

@JS("Mocha.reporters.nyan")
external dynamic get nyan;

@JS("Mocha.reporters.xunit")
external dynamic get xunit;

@JS("Mocha.reporters.markdown")
external dynamic get markdown;

@JS("Mocha.reporters.progress")
external dynamic get progress;

@JS("Mocha.reporters.landing")
external dynamic get landing;
// End module reporters
@JS("Mocha.Runnable")
class Runnable {
   // @Ignore
   Runnable .fakeConstructor$();
   
   external get JS$_slow;
   
   external set JS$_slow(v);
   
   external get JS$_enableTimeouts;
   
   external set JS$_enableTimeouts(v);
   
   external get JS$_retries;
   
   external set JS$_retries(v);
   
   external get JS$_currentRetry;
   
   external set JS$_currentRetry(v);
   
   external get JS$_timeout;
   
   external set JS$_timeout(v);
   
   external get JS$_timeoutError;
   
   external set JS$_timeoutError(v);
   
   external factory Runnable(String title, [dynamic/*Func|AsyncFunc*/ fn]);
   
   external String get title;
   
   external set title(String v);
   
   external dynamic/*Func|AsyncFunc|dynamic*/ get fn;
   
   external set fn(dynamic/*Func|AsyncFunc|dynamic*/ v);
   
   external String get body;
   
   external set body(String v);
   
   external bool get JS$async;
   
   external set JS$async(bool v);
   
   external bool get JS$sync;
   
   external set JS$sync(bool v);
   
   external bool get timedOut;
   
   external set timedOut(bool v);
   
   external bool get pending;
   
   external set pending(bool v);
   
   external num get duration;
   
   external set duration(num v);
   
   external Suite get parent;
   
   external set parent(Suite v);
   
   external String/*'failed'|'passed'*/ get state;
   
   external set state(String/*'failed'|'passed'*/ v);
   
   external dynamic get timer;
   
   external set timer(dynamic v);
   
   external Context get ctx;
   
   external set ctx(Context v);
   
   external Done get callback;
   
   external set callback(Done v);
   
   external bool get allowUncaught;
   
   external set allowUncaught(bool v);
   
   external String get file;
   
   external set file(String v);
   
   /*external num timeout();*/
   /*external Runnable timeout(String|num ms);*/
   external dynamic/*num|Runnable*/ timeout([dynamic/*String|num*/ ms]);
   
   /*external num slow();*/
   /*external Runnable slow(String|num ms);*/
   external dynamic/*num|Runnable*/ slow([dynamic/*String|num*/ ms]);
   
   /*external bool enableTimeouts();*/
   /*external Runnable enableTimeouts(bool enabled);*/
   external dynamic/*bool|Runnable*/ enableTimeouts([bool enabled]);
   
   external void skip();
   
   external bool isPending();
   
   external bool isFailed();
   
   external bool isPassed();
   
   /*external num retries();*/
   /*external void retries(num n);*/
   external dynamic/*num|Null*/ retries([num n]);
   
   /*external num currentRetry();*/
   /*external void currentRetry(num n);*/
   external dynamic/*num|Null*/ currentRetry([num n]);
   
   external String fullTitle();
   
   external List<String> titlePath();
   
   external void clearTimeout();
   
   external String inspect();
   
   external void resetTimeout();
   
   /*external List<String> globals();*/
   /*external void globals(ReadonlyArray<String> globals);*/
   external dynamic/*List<String>|Null*/ globals([List<String> globals]);
   
   external void run(Done fn);
   
   external Runnable on(String/*'error'*/ event, void listener(dynamic error));
   
   external Runnable once(String/*'error'*/ event, void listener(dynamic error));
   
   external Runnable addListener(String/*'error'*/ event, void listener(dynamic error));
   
   external Runnable removeListener(String/*'error'*/ event, void listener(dynamic error));
   
   external Runnable prependListener(String/*'error'*/ event, void listener(dynamic error));
   
   external Runnable prependOnceListener(String/*'error'*/ event, void listener(dynamic error));
   
   external bool emit(String/*'error'*/ name, dynamic error);
}

//@anonymous
//@JS()
//abstract class Runnable
//   implements EventEmitter {
//   external Runnable on(String event, Function/*(...args: any[]) => void*/ listener);
//
//   external Runnable once(String event, Function/*(...args: any[]) => void*/ listener);
//
//   external Runnable addListener(String event, Function/*(...args: any[]) => void*/ listener);
//
//   external Runnable removeListener(String event, Function/*(...args: any[]) => void*/ listener);
//
//   external Runnable prependListener(String event, Function/*(...args: any[]) => void*/ listener);
//
//   external Runnable prependOnceListener(String event, Function/*(...args: any[]) => void*/ listener);
//
//   external bool emit(String name, [dynamic args1, dynamic args2, dynamic args3, dynamic args4, dynamic args5]);
//}

@JS("Mocha.Context")
class Context {
   // @Ignore
   Context .fakeConstructor$();
   
   external get JS$_runnable;
   
   external set JS$_runnable(v);
   
   external Runnable get test;
   
   external set test(Runnable v);
   
   external Test get currentTest;
   
   external set currentTest(Test v);
   
   /*external Runnable runnable();*/
   /*external Context runnable(Runnable runnable);*/
   /*external Context runnable(IRunnable runnable);*/
   external dynamic/*Runnable|Context*/ runnable([dynamic/*Runnable|IRunnable*/ runnable]);
   
   /*external num timeout();*/
   /*external Context timeout(String|num ms);*/
   external dynamic/*num|Context*/ timeout([dynamic/*String|num*/ ms]);
   
   /*external bool enableTimeouts();*/
   /*external Context enableTimeouts(bool enabled);*/
   external dynamic/*bool|Context*/ enableTimeouts([bool enabled]);
   
   /*external num slow();*/
   /*external Context slow(String|num ms);*/
   external dynamic/*num|Context*/ slow([dynamic/*String|num*/ ms]);
   
   external void skip();
   
   /*external num retries();*/
   /*external Context retries(num n);*/
   external dynamic/*num|Context*/ retries([num n]);
/* Index signature is not yet supported by JavaScript interop. */
}

@JS("Mocha.Runner")
class Runner {
   // @Ignore
   Runner .fakeConstructor$();
   
   external get JS$_globals;
   
   external set JS$_globals(v);
   
   external get JS$_abort;
   
   external set JS$_abort(v);
   
   external get JS$_delay;
   
   external set JS$_delay(v);
   
   external get JS$_defaultGrep;
   
   external set JS$_defaultGrep(v);
   
   external get next;
   
   external set next(v);
   
   external get hookErr;
   
   external set hookErr(v);
   
   external get prevGlobalsLength;
   
   external set prevGlobalsLength(v);
   
   external get nextSuite;
   
   external set nextSuite(v);
   
   /*external factory Runner(Suite suite, bool delay);*/
   /*external factory Runner(ISuite suite, bool delay);*/
   external factory Runner(dynamic/*Suite|ISuite*/ suite, bool delay);
   
   external Suite get suite;
   
   external set suite(Suite v);
   
   external bool get started;
   
   external set started(bool v);
   
   external num get total;
   
   external set total(num v);
   
   external num get failures;
   
   external set failures(num v);
   
   external bool get asyncOnly;
   
   external set asyncOnly(bool v);
   
   external bool get allowUncaught;
   
   external set allowUncaught(bool v);
   
   external bool get fullStackTrace;
   
   external set fullStackTrace(bool v);
   
   external bool get forbidOnly;
   
   external set forbidOnly(bool v);
   
   external bool get forbidPending;
   
   external set forbidPending(bool v);
   
   external bool get ignoreLeaks;
   
   external set ignoreLeaks(bool v);
   
   external Test get test;
   
   external set test(Test v);
   
   external Runnable get currentRunnable;
   
   external set currentRunnable(Runnable v);
   
   external Stats get stats;
   
   external set stats(Stats v);
   
   external Runner grep(RegExp re, bool invert);
   
   /*external num grepTotal(Suite suite);*/
   /*external num grepTotal(ISuite suite);*/
   external num grepTotal(dynamic/*Suite|ISuite*/ suite);
   
   /*external List<String> globals();*/
   /*external Runner globals(ReadonlyArray<String> arr);*/
   external dynamic/*List<String>|Runner*/ globals([List<String> arr]);
   
   external Runner run([void fn(num failures)]);
   
   external Runner abort();
   
   external void uncaught(dynamic err);
   
   external static void immediately(Function callback);
   
   external List<String> globalProps();
   
   external void checkGlobals(Test test);
   
   external void fail(Test test, dynamic err);
   
   external void failHook(Hook hook, dynamic err);
   
   external void hook(String name, void fn());
   
   external void hooks(String name, List<Suite> suites, void fn([dynamic err, Suite errSuite]));
   
   external void hookUp(String name, void fn([dynamic err, Suite errSuite]));
   
   external void hookDown(String name, void fn([dynamic err, Suite errSuite]));
   
   external List<Suite> parents();
   
   external dynamic runTest(Done fn);
   
   external void runTests(Suite suite, void fn([Suite errSuite]));
   
   external void runSuite(Suite suite, void fn([Suite errSuite]));
   
   /*external Runner on('waiting' event, void listener(Suite rootSuite));*/
   /*external Runner on('end' event, void listener());*/
   /*external Runner on('suite end' event, void listener(Suite suite));*/
   /*external Runner on('test end' event, void listener(Test test));*/
   /*external Runner on('hook end' event, void listener(Hook hook));*/
   /*external Runner on('fail' event, void listener(Test test, dynamic err));*/
   /*external Runner on(String event, (...args: any[]) => void listener);*/
   external Runner on(String/*'waiting'|'end'|'suite end'|'test end'|'hook end'|'fail'|String*/ event,
                      Function/*VoidFunc1<Suite>|VoidFunc0|VoidFunc1<Test>|VoidFunc1<Hook>|VoidFunc2<Test, dynamic>|(...args: any[]) => void*/ listener);
   
   /*external Runner once('waiting' event, void listener(Suite rootSuite));*/
   /*external Runner once('end' event, void listener());*/
   /*external Runner once('suite end' event, void listener(Suite suite));*/
   /*external Runner once('test end' event, void listener(Test test));*/
   /*external Runner once('hook end' event, void listener(Hook hook));*/
   /*external Runner once('fail' event, void listener(Test test, dynamic err));*/
   /*external Runner once(String event, (...args: any[]) => void listener);*/
   external Runner once(String/*'waiting'|'end'|'suite end'|'test end'|'hook end'|'fail'|String*/ event,
                        Function/*VoidFunc1<Suite>|VoidFunc0|VoidFunc1<Test>|VoidFunc1<Hook>|VoidFunc2<Test, dynamic>|(...args: any[]) => void*/ listener);
   
   /*external Runner addListener('waiting' event, void listener(Suite rootSuite));*/
   /*external Runner addListener('end' event, void listener());*/
   /*external Runner addListener('suite end' event, void listener(Suite suite));*/
   /*external Runner addListener('test end' event, void listener(Test test));*/
   /*external Runner addListener('hook end' event, void listener(Hook hook));*/
   /*external Runner addListener('fail' event, void listener(Test test, dynamic err));*/
   /*external Runner addListener(String event, (...args: any[]) => void listener);*/
   external Runner addListener(String/*'waiting'|'end'|'suite end'|'test end'|'hook end'|'fail'|String*/ event,
                               Function/*VoidFunc1<Suite>|VoidFunc0|VoidFunc1<Test>|VoidFunc1<Hook>|VoidFunc2<Test, dynamic>|(...args: any[]) => void*/ listener);
   
   /*external Runner removeListener('waiting' event, void listener(Suite rootSuite));*/
   /*external Runner removeListener('end' event, void listener());*/
   /*external Runner removeListener('suite end' event, void listener(Suite suite));*/
   /*external Runner removeListener('test end' event, void listener(Test test));*/
   /*external Runner removeListener('hook end' event, void listener(Hook hook));*/
   /*external Runner removeListener('fail' event, void listener(Test test, dynamic err));*/
   /*external Runner removeListener(String event, (...args: any[]) => void listener);*/
   external Runner removeListener(String/*'waiting'|'end'|'suite end'|'test end'|'hook end'|'fail'|String*/ event,
                                  Function/*VoidFunc1<Suite>|VoidFunc0|VoidFunc1<Test>|VoidFunc1<Hook>|VoidFunc2<Test, dynamic>|(...args: any[]) => void*/ listener);
   
   /*external Runner prependListener('waiting' event, void listener(Suite rootSuite));*/
   /*external Runner prependListener('end' event, void listener());*/
   /*external Runner prependListener('suite end' event, void listener(Suite suite));*/
   /*external Runner prependListener('test end' event, void listener(Test test));*/
   /*external Runner prependListener('hook end' event, void listener(Hook hook));*/
   /*external Runner prependListener('fail' event, void listener(Test test, dynamic err));*/
   /*external Runner prependListener(String event, (...args: any[]) => void listener);*/
   external Runner prependListener(String/*'waiting'|'end'|'suite end'|'test end'|'hook end'|'fail'|String*/ event,
                                   Function/*VoidFunc1<Suite>|VoidFunc0|VoidFunc1<Test>|VoidFunc1<Hook>|VoidFunc2<Test, dynamic>|(...args: any[]) => void*/ listener);
   
   /*external Runner prependOnceListener('waiting' event, void listener(Suite rootSuite));*/
   /*external Runner prependOnceListener('end' event, void listener());*/
   /*external Runner prependOnceListener('suite end' event, void listener(Suite suite));*/
   /*external Runner prependOnceListener('test end' event, void listener(Test test));*/
   /*external Runner prependOnceListener('hook end' event, void listener(Hook hook));*/
   /*external Runner prependOnceListener('fail' event, void listener(Test test, dynamic err));*/
   /*external Runner prependOnceListener(String event, (...args: any[]) => void listener);*/
   external Runner prependOnceListener(String/*'waiting'|'end'|'suite end'|'test end'|'hook end'|'fail'|String*/ event,
                                       Function/*VoidFunc1<Suite>|VoidFunc0|VoidFunc1<Test>|VoidFunc1<Hook>|VoidFunc2<Test, dynamic>|(...args: any[]) => void*/ listener);
   
   /*external bool emit('waiting' name, Suite rootSuite);*/
   /*external bool emit('end' name);*/
   /*external bool emit('suite end' name, Suite suite);*/
   /*external bool emit('test end' name, Test test);*/
   /*external bool emit('hook end' name, Hook hook);*/
   /*external bool emit('fail' name, Test test, dynamic err);*/
   /*external bool emit(String name,
    [dynamic args1,
    dynamic args2,
    dynamic args3,
    dynamic args4,
    dynamic args5]);*/
   external bool emit(String/*'waiting'|'end'|'suite end'|'test end'|'hook end'|'fail'|String*/ name,
                      [dynamic/*Suite|Test|Hook|List<dynamic>*/ rootSuite_suite_test_hook_args, dynamic err]);
}

//@anonymous
//@JS()
//abstract class Runner
//   implements EventEmitter {
//   external Runner on(String/*'start'*/ event, void listener());
//
//   external Runner once(String/*'start'*/ event, void listener());
//
//   external Runner addListener(String/*'start'*/ event, void listener());
//
//   external Runner removeListener(String/*'start'*/ event, void listener());
//
//   external Runner prependListener(String/*'start'*/ event, void listener());
//
//   external Runner prependOnceListener(String/*'start'*/ event, void listener());
//
//   external bool emit(String/*'start'*/ name);
//}

//@anonymous
//@JS()
//abstract class Runner
//   implements EventEmitter {
//   external Runner on(String/*'suite'*/ event, void listener(Suite suite));
//
//   external Runner once(String/*'suite'*/ event, void listener(Suite suite));
//
//   external Runner addListener(String/*'suite'*/ event, void listener(Suite suite));
//
//   external Runner removeListener(String/*'suite'*/ event, void listener(Suite suite));
//
//   external Runner prependListener(String/*'suite'*/ event, void listener(Suite suite));
//
//   external Runner prependOnceListener(String/*'suite'*/ event, void listener(Suite suite));
//
//   external bool emit(String/*'suite'*/ name, Suite suite);
//}
//
//@anonymous
//@JS()
//abstract class Runner
//   implements EventEmitter {
//   external Runner on(String/*'test'*/ event, void listener(Test test));
//
//   external Runner once(String/*'test'*/ event, void listener(Test test));
//
//   external Runner addListener(String/*'test'*/ event, void listener(Test test));
//
//   external Runner removeListener(String/*'test'*/ event, void listener(Test test));
//
//   external Runner prependListener(String/*'test'*/ event, void listener(Test test));
//
//   external Runner prependOnceListener(String/*'test'*/ event, void listener(Test test));
//
//   external bool emit(String/*'test'*/ name, Test test);
//}
//
//@anonymous
//@JS()
//abstract class Runner
//   implements EventEmitter {
//   external Runner on(String/*'hook'*/ event, void listener(Hook hook));
//
//   external Runner once(String/*'hook'*/ event, void listener(Hook hook));
//
//   external Runner addListener(String/*'hook'*/ event, void listener(Hook hook));
//
//   external Runner removeListener(String/*'hook'*/ event, void listener(Hook hook));
//
//   external Runner prependListener(String/*'hook'*/ event, void listener(Hook hook));
//
//   external Runner prependOnceListener(String/*'hook'*/ event, void listener(Hook hook));
//
//   external bool emit(String/*'hook'*/ name, Hook hook);
//}
//
//@anonymous
//@JS()
//abstract class Runner
//   implements EventEmitter {
//   external Runner on(String/*'pass'*/ event, void listener(Test test));
//
//   external Runner once(String/*'pass'*/ event, void listener(Test test));
//
//   external Runner addListener(String/*'pass'*/ event, void listener(Test test));
//
//   external Runner removeListener(String/*'pass'*/ event, void listener(Test test));
//
//   external Runner prependListener(String/*'pass'*/ event, void listener(Test test));
//
//   external Runner prependOnceListener(String/*'pass'*/ event, void listener(Test test));
//
//   external bool emit(String/*'pass'*/ name, Test test);
//}
//
//@anonymous
//@JS()
//abstract class Runner
//   implements EventEmitter {
//   external Runner on(String/*'pending'*/ event, void listener(Test test));
//
//   external Runner once(String/*'pending'*/ event, void listener(Test test));
//
//   external Runner addListener(String/*'pending'*/ event, void listener(Test test));
//
//   external Runner removeListener(String/*'pending'*/ event, void listener(Test test));
//
//   external Runner prependListener(String/*'pending'*/ event, void listener(Test test));
//
//   external Runner prependOnceListener(String/*'pending'*/ event, void listener(Test test));
//
//   external bool emit(String/*'pending'*/ name, Test test);
//}

@JS("Mocha.Suite")
class Suite {
   // @Ignore
   Suite .fakeConstructor$();
   
   external get JS$_beforeEach;
   
   external set JS$_beforeEach(v);
   
   external get JS$_beforeAll;
   
   external set JS$_beforeAll(v);
   
   external get JS$_afterEach;
   
   external set JS$_afterEach(v);
   
   external get JS$_afterAll;
   
   external set JS$_afterAll(v);
   
   external get JS$_timeout;
   
   external set JS$_timeout(v);
   
   external get JS$_enableTimeouts;
   
   external set JS$_enableTimeouts(v);
   
   external get JS$_slow;
   
   external set JS$_slow(v);
   
   external get JS$_bail;
   
   external set JS$_bail(v);
   
   external get JS$_retries;
   
   external set JS$_retries(v);
   
   external get JS$_onlyTests;
   
   external set JS$_onlyTests(v);
   
   external get JS$_onlySuites;
   
   external set JS$_onlySuites(v);
   
   /*external factory Suite(String title, [Context parentContext]);*/
   /*external factory Suite(String title, [IContext parentContext]);*/
   external factory Suite(String title, [dynamic/*Context|IContext*/ parentContext]);
   
   external Context get ctx;
   
   external set ctx(Context v);
   
   external List<Suite> get suites;
   
   external set suites(List<Suite> v);
   
   external List<Test> get tests;
   
   external set tests(List<Test> v);
   
   external bool get pending;
   
   external set pending(bool v);
   
   external String get file;
   
   external set file(String v);
   
   external bool get root;
   
   external set root(bool v);
   
   external bool get delayed;
   
   external set delayed(bool v);
   
   external dynamic/*Suite|dynamic*/ get parent;
   
   external set parent(dynamic/*Suite|dynamic*/ v);
   
   external String get title;
   
   external set title(String v);
   
   /*external static Suite create(Suite parent, String title);*/
   /*external static Suite create(ISuite parent, String title);*/
   external Suite create(dynamic/*Suite|ISuite*/ parent, String title);
   
   external Suite clone();
   
   /*external num timeout();*/
   /*external Suite timeout(String|num ms);*/
   external dynamic/*num|Suite*/ timeout([dynamic/*String|num*/ ms]);
   
   /*external num retries();*/
   /*external Suite retries(String|num n);*/
   external dynamic/*num|Suite*/ retries([dynamic/*String|num*/ n]);
   
   /*external bool enableTimeouts();*/
   /*external Suite enableTimeouts(bool enabled);*/
   external dynamic/*bool|Suite*/ enableTimeouts([bool enabled]);
   
   /*external num slow();*/
   /*external Suite slow(String|num ms);*/
   external dynamic/*num|Suite*/ slow([dynamic/*String|num*/ ms]);
   
   /*external bool bail();*/
   /*external Suite bail(bool bail);*/
   external dynamic/*bool|Suite*/ bail([bool bail]);
   
   external bool isPending();
   
   /*external Suite beforeAll([Func fn]);*/
   /*external Suite beforeAll([AsyncFunc fn]);*/
   /*external Suite beforeAll(String title, [Func fn]);*/
   /*external Suite beforeAll(String title, [AsyncFunc fn]);*/
   external Suite beforeAll([String fn_title, fn]);
   
   /*external Suite afterAll([Func fn]);*/
   /*external Suite afterAll([AsyncFunc fn]);*/
   /*external Suite afterAll(String title, [Func fn]);*/
   /*external Suite afterAll(String title, [AsyncFunc fn]);*/
   external Suite afterAll([String fn_title, fn]);
   
   /*external Suite beforeEach([Func fn]);*/
   /*external Suite beforeEach([AsyncFunc fn]);*/
   /*external Suite beforeEach(String title, [Func fn]);*/
   /*external Suite beforeEach(String title, [AsyncFunc fn]);*/
   external Suite beforeEach([String fn_title, fn]);
   
   /*external Suite afterEach([Func fn]);*/
   /*external Suite afterEach([AsyncFunc fn]);*/
   /*external Suite afterEach(String title, [Func fn]);*/
   /*external Suite afterEach(String title, [AsyncFunc fn]);*/
   external Suite afterEach([String fn_title, fn]);
   
   /*external Suite addSuite(Suite suite);*/
   /*external Suite addSuite(ISuite suite);*/
   external Suite addSuite(dynamic/*Suite|ISuite*/ suite);
   
   /*external Suite addTest(Test test);*/
   /*external Suite addTest(ITest test);*/
   external Suite addTest(dynamic/*Test|ITest*/ test);
   
   external String fullTitle();
   
   external List<String> titlePath();
   
   external num total();
   
   external Suite eachTest(void fn(Test test));
   
   external void run();
   
   external Hook JS$_createHook(String title, [dynamic/*Func|AsyncFunc*/ fn]);
}

//@anonymous
//@JS()
//abstract class Suite
//   implements EventEmitter {
//   /*external Suite on('beforeAll' event, void listener(Hook hook));*/
//   /*external Suite on('afterAll' event, void listener(Hook hook));*/
//   /*external Suite on('afterEach' event, void listener(Hook hook));*/
//   /*external Suite on('test' event, void listener(Test test));*/
//   /*external Suite on('pre-require' event, void listener(MochaGlobals context, String file, Mocha mocha));*/
//   /*external Suite on('post-require' event, void listener(MochaGlobals context, String file, Mocha mocha));*/
//   external Suite on(String/*'beforeAll'|'afterAll'|'afterEach'|'test'|'pre-require'|'post-require'*/ event,
//                     Function/*VoidFunc1<Hook>|VoidFunc1<Test>|VoidFunc3<MochaGlobals, String, Mocha>*/ listener);
//
//   /*external Suite once('beforeAll' event, void listener(Hook hook));*/
//   /*external Suite once('afterAll' event, void listener(Hook hook));*/
//   /*external Suite once('afterEach' event, void listener(Hook hook));*/
//   /*external Suite once('test' event, void listener(Test test));*/
//   /*external Suite once('pre-require' event, void listener(MochaGlobals context, String file, Mocha mocha));*/
//   /*external Suite once('post-require' event, void listener(MochaGlobals context, String file, Mocha mocha));*/
//   external Suite once(String/*'beforeAll'|'afterAll'|'afterEach'|'test'|'pre-require'|'post-require'*/ event,
//                       Function/*VoidFunc1<Hook>|VoidFunc1<Test>|VoidFunc3<MochaGlobals, String, Mocha>*/ listener);
//
//   /*external Suite addListener('beforeAll' event, void listener(Hook hook));*/
//   /*external Suite addListener('afterAll' event, void listener(Hook hook));*/
//   /*external Suite addListener('afterEach' event, void listener(Hook hook));*/
//   /*external Suite addListener('test' event, void listener(Test test));*/
//   /*external Suite addListener('pre-require' event, void listener(MochaGlobals context, String file, Mocha mocha));*/
//   /*external Suite addListener('post-require' event, void listener(MochaGlobals context, String file, Mocha mocha));*/
//   external Suite addListener(String/*'beforeAll'|'afterAll'|'afterEach'|'test'|'pre-require'|'post-require'*/ event,
//                              Function/*VoidFunc1<Hook>|VoidFunc1<Test>|VoidFunc3<MochaGlobals, String, Mocha>*/ listener);
//
//   /*external Suite removeListener('beforeAll' event, void listener(Hook hook));*/
//   /*external Suite removeListener('afterAll' event, void listener(Hook hook));*/
//   /*external Suite removeListener('afterEach' event, void listener(Hook hook));*/
//   /*external Suite removeListener('test' event, void listener(Test test));*/
//   /*external Suite removeListener('pre-require' event, void listener(MochaGlobals context, String file, Mocha mocha));*/
//   /*external Suite removeListener('post-require' event, void listener(MochaGlobals context, String file, Mocha mocha));*/
//   external Suite removeListener(String/*'beforeAll'|'afterAll'|'afterEach'|'test'|'pre-require'|'post-require'*/ event,
//                                 Function/*VoidFunc1<Hook>|VoidFunc1<Test>|VoidFunc3<MochaGlobals, String, Mocha>*/ listener);
//
//   /*external Suite prependListener('beforeAll' event, void listener(Hook hook));*/
//   /*external Suite prependListener('afterAll' event, void listener(Hook hook));*/
//   /*external Suite prependListener('afterEach' event, void listener(Hook hook));*/
//   /*external Suite prependListener('test' event, void listener(Test test));*/
//   /*external Suite prependListener('pre-require' event, void listener(MochaGlobals context, String file, Mocha mocha));*/
//   /*external Suite prependListener('post-require' event, void listener(MochaGlobals context, String file, Mocha mocha));*/
//   external Suite prependListener(String/*'beforeAll'|'afterAll'|'afterEach'|'test'|'pre-require'|'post-require'*/ event,
//                                  Function/*VoidFunc1<Hook>|VoidFunc1<Test>|VoidFunc3<MochaGlobals, String, Mocha>*/ listener);
//
//   /*external Suite prependOnceListener('beforeAll' event, void listener(Hook hook));*/
//   /*external Suite prependOnceListener('afterAll' event, void listener(Hook hook));*/
//   /*external Suite prependOnceListener('afterEach' event, void listener(Hook hook));*/
//   /*external Suite prependOnceListener('test' event, void listener(Test test));*/
//   /*external Suite prependOnceListener('pre-require' event, void listener(MochaGlobals context, String file, Mocha mocha));*/
//   /*external Suite prependOnceListener('post-require' event, void listener(MochaGlobals context, String file, Mocha mocha));*/
//   external Suite prependOnceListener(String/*'beforeAll'|'afterAll'|'afterEach'|'test'|'pre-require'|'post-require'*/ event,
//                                      Function/*VoidFunc1<Hook>|VoidFunc1<Test>|VoidFunc3<MochaGlobals, String, Mocha>*/ listener);
//
//   /*external bool emit('beforeAll' name, Hook hook);*/
//   /*external bool emit('afterAll' name, Hook hook);*/
//   /*external bool emit('afterEach' name, Hook hook);*/
//   /*external bool emit('test' name, Test test);*/
//   /*external bool emit('pre-require' name, MochaGlobals context, String file, Mocha mocha);*/
//   /*external bool emit('post-require' name, MochaGlobals context, String file, Mocha mocha);*/
//   external bool emit(String/*'beforeAll'|'afterAll'|'afterEach'|'test'|'pre-require'|'post-require'*/ name,
//                      dynamic/*Hook|Test|MochaGlobals*/ hook_test_context, [String file, Mocha mocha]);
//}

//@anonymous
//@JS()
//abstract class Suite
//   implements EventEmitter {
//   external Suite on(String/*'beforeEach'*/ event, void listener(Hook hook));
//
//   external Suite once(String/*'beforeEach'*/ event, void listener(Hook hook));
//
//   external Suite addListener(String/*'beforeEach'*/ event, void listener(Hook hook));
//
//   external Suite removeListener(String/*'beforeEach'*/ event, void listener(Hook hook));
//
//   external Suite prependListener(String/*'beforeEach'*/ event, void listener(Hook hook));
//
//   external Suite prependOnceListener(String/*'beforeEach'*/ event, void listener(Hook hook));
//
//   external bool emit(String/*'beforeEach'*/ name, Hook hook);
//}
//
//@anonymous
//@JS()
//abstract class Suite
//   implements EventEmitter {
//   external Suite on(String/*'suite'*/ event, void listener(Suite suite));
//
//   external Suite once(String/*'suite'*/ event, void listener(Suite suite));
//
//   external Suite addListener(String/*'suite'*/ event, void listener(Suite suite));
//
//   external Suite removeListener(String/*'suite'*/ event, void listener(Suite suite));
//
//   external Suite prependListener(String/*'suite'*/ event, void listener(Suite suite));
//
//   external Suite prependOnceListener(String/*'suite'*/ event, void listener(Suite suite));
//
//   external bool emit(String/*'suite'*/ name, Suite suite);
//}
//
//@anonymous
//@JS()
//abstract class Suite
//   implements EventEmitter {
//   external Suite on(String/*'run'*/ event, void listener());
//
//   external Suite once(String/*'run'*/ event, void listener());
//
//   external Suite addListener(String/*'run'*/ event, void listener());
//
//   external Suite removeListener(String/*'run'*/ event, void listener());
//
//   external Suite prependListener(String/*'run'*/ event, void listener());
//
//   external Suite prependOnceListener(String/*'run'*/ event, void listener());
//
//   external bool emit(String/*'run'*/ name);
//}
//
//@anonymous
//@JS()
//abstract class Suite
//   implements EventEmitter {
//   external Suite on(String/*'require'*/ event, void listener(dynamic module, String file, Mocha mocha));
//
//   external Suite once(String/*'require'*/ event, void listener(dynamic module, String file, Mocha mocha));
//
//   external Suite addListener(String/*'require'*/ event, void listener(dynamic module, String file, Mocha mocha));
//
//   external Suite removeListener(String/*'require'*/ event, void listener(dynamic module, String file, Mocha mocha));
//
//   external Suite prependListener(String/*'require'*/ event, void listener(dynamic module, String file, Mocha mocha));
//
//   external Suite prependOnceListener(String/*'require'*/ event, void listener(dynamic module, String file, Mocha mocha));
//
//   external bool emit(String/*'require'*/ name, dynamic module, String file, Mocha mocha);
//}
//
//@anonymous
//@JS()
//abstract class Suite
//   implements EventEmitter {
//   external Suite on(String event, Function/*(...args: any[]) => void*/ listener);
//
//   external Suite once(String event, Function/*(...args: any[]) => void*/ listener);
//
//   external Suite addListener(String event, Function/*(...args: any[]) => void*/ listener);
//
//   external Suite removeListener(String event, Function/*(...args: any[]) => void*/ listener);
//
//   external Suite prependListener(String event, Function/*(...args: any[]) => void*/ listener);
//
//   external Suite prependOnceListener(String event, Function/*(...args: any[]) => void*/ listener);
//
//   external bool emit(String name, [dynamic args1, dynamic args2, dynamic args3, dynamic args4, dynamic args5]);
//}

@JS("Mocha.Hook")
class Hook extends Runnable {
   // @Ignore
   Hook .fakeConstructor$() : super.fakeConstructor$();
   
   external get JS$_error;
   
   external set JS$_error(v);
   
   external String/*'hook'*/ get type;
   
   external set type(String/*'hook'*/ v);
   
   external String get originalTitle;
   
   external set originalTitle(String v);
   
   /*external dynamic error();*/
   /*external void error(dynamic err);*/
   external dynamic/*dynamic|Null*/ error([dynamic err]);
}

@JS("Mocha.Test")
class Test extends Runnable {
   // @Ignore
   Test .fakeConstructor$() : super.fakeConstructor$();
   
   external String/*'test'*/ get type;
   
   external set type(String/*'test'*/ v);
   
   external String/*'slow'|'medium'|'fast'*/ get speed;
   
   external set speed(String/*'slow'|'medium'|'fast'*/ v);
   
   external Error get err;
   
   external set err(Error v);
   
   external Test clone();
}

@anonymous
@JS()
abstract class Stats {
   external num get suites;
   
   external set suites(num v);
   
   external num get tests;
   
   external set tests(num v);
   
   external num get passes;
   
   external set passes(num v);
   
   external num get pending;
   
   external set pending(num v);
   
   external num get failures;
   
   external set failures(num v);
   
   external DateTime get start;
   
   external set start(DateTime v);
   
   external DateTime get end;
   
   external set end(DateTime v);
   
   external num get duration;
   
   external set duration(num v);
   
   external factory Stats({ num suites, num tests, num passes, num pending, num failures, DateTime start, DateTime end, num duration});
}

typedef void TestInterface(Suite suite);

@anonymous
@JS()
abstract class ReporterConstructor {
   // Constructors on anonymous interfaces are not yet supported.
   /*external factory ReporterConstructor(Runner runner, { reporterOptions?: any; } options);*/
}

typedef void Done([dynamic err]);
typedef void Func(/*Context this*/ Done done);
typedef dynamic AsyncFunc(/*Context this*/);

typedef Promise<void> TestBody();

@anonymous
@JS()
abstract class MochaOptions {
   external dynamic get ui;
   
   external set ui(dynamic v);
   
   external dynamic/*String|ReporterConstructor*/ get reporter;
   
   external set reporter(dynamic/*String|ReporterConstructor*/ v);
   
   external dynamic get reporterOptions;
   
   //   external set reporterOptions(dynamic v);
   external set reporterOptions(ReporterOptions v);
   
   external List<String> get globals;
   
   external set globals(List<String> v);
   
   external num get timeout;
   
   external set timeout(num v);
   
   external bool get enableTimeouts;
   
   external set enableTimeouts(bool v);
   
   external num get retries;
   
   external set retries(num v);
   
   external bool get bail;
   
   external set bail(bool v);
   
   external num get slow;
   
   external set slow(num v);
   
   external bool get ignoreLeaks;
   
   external set ignoreLeaks(bool v);
   
   external bool get fullStackTrace;
   
   external set fullStackTrace(bool v);
   
   external dynamic/*String|RegExp*/ get grep;
   
   external set grep(dynamic/*String|RegExp*/ v);
   
   external bool get growl;
   
   external set growl(bool v);
   
   external bool get useColors;
   
   external set useColors(bool v);
   
   external bool get inlineDiffs;
   
   external set inlineDiffs(bool v);
   
   external bool get hideDiff;
   
   external set hideDiff(bool v);
   
   external bool get asyncOnly;
   
   external set asyncOnly(bool v);
   
   external bool get delay;
   
   external set delay(bool v);
   
   external bool get forbidOnly;
   
   external set forbidOnly(bool v);
   
   external bool get forbidPending;
   
   external set forbidPending(bool v);
   
   external bool get noHighlighting;
   
   external set noHighlighting(bool v);
   
   external bool get allowUncaught;
   
   external set allowUncaught(bool v);
   
   external factory MochaOptions({ dynamic ui, dynamic/*String|ReporterConstructor*/ reporter,
                                    dynamic reporterOptions, List<String> globals, num timeout, bool enableTimeouts, num retries,
                                    bool bail, num slow, bool ignoreLeaks, bool fullStackTrace, dynamic/*String|RegExp*/ grep, bool growl,
                                    bool useColors, bool inlineDiffs, bool hideDiff, bool asyncOnly, bool delay,
                                    bool forbidOnly, bool forbidPending, bool noHighlighting, bool allowUncaught});
}

@anonymous
@JS()
abstract class MochaInstanceOptions
   implements MochaOptions {
   external List<String> get files;
   
   external set files(List<String> v);
   
   external factory MochaInstanceOptions({ List<String> files, dynamic ui,
                                            dynamic/*String|ReporterConstructor*/ reporter, dynamic reporterOptions, List<String> globals,
                                            num timeout, bool enableTimeouts, num retries, bool bail, num slow, bool ignoreLeaks, bool fullStackTrace,
                                            dynamic/*String|RegExp*/ grep, bool growl, bool useColors, bool inlineDiffs, bool hideDiff, bool asyncOnly,
                                            bool delay, bool forbidOnly, bool forbidPending, bool noHighlighting, bool allowUncaught });
}

/// Variables added to the global scope by Mocha when run in the CLI.
@anonymous
@JS()
abstract class MochaGlobals {
   /// Execute before running tests.
   /// - _Only available when invoked via the mocha CLI._
   /// @see https://mochajs.org/api/global.html#before
   external HookFunction get before;
   
   external set before(HookFunction v);
   
   /// Execute after running tests.
   /// - _Only available when invoked via the mocha CLI._
   /// @see https://mochajs.org/api/global.html#after
   external HookFunction get after;
   
   external set after(HookFunction v);
   
   /// Execute before each test case.
   /// - _Only available when invoked via the mocha CLI._
   /// @see https://mochajs.org/api/global.html#beforeEach
   external HookFunction get beforeEach;
   
   external set beforeEach(HookFunction v);
   
   /// Execute after each test case.
   /// - _Only available when invoked via the mocha CLI._
   /// @see https://mochajs.org/api/global.html#afterEach
   external HookFunction get afterEach;
   
   external set afterEach(HookFunction v);
   
   /// Describe a "suite" containing nested suites and tests.
   /// - _Only available when invoked via the mocha CLI._
   external SuiteFunction get describe;
   
   external set describe(SuiteFunction v);
   
   /// Describe a "suite" containing nested suites and tests.
   /// - _Only available when invoked via the mocha CLI._
   external SuiteFunction get context;
   
   external set context(SuiteFunction v);
   
   /// Pending suite.
   /// - _Only available when invoked via the mocha CLI._
   external PendingSuiteFunction get xdescribe;
   
   external set xdescribe(PendingSuiteFunction v);
   
   /// Pending suite.
   /// - _Only available when invoked via the mocha CLI._
   external PendingSuiteFunction get xcontext;
   
   external set xcontext(PendingSuiteFunction v);
   
   /// Describes a test case.
   /// - _Only available when invoked via the mocha CLI._
   external TestFunction get it;
   
   external set it(TestFunction v);
   
   /// Describes a test case.
   /// - _Only available when invoked via the mocha CLI._
   external TestFunction get specify;
   
   external set specify(TestFunction v);
   
   /// Describes a pending test case.
   /// - _Only available when invoked via the mocha CLI._
   external PendingTestFunction get xit;
   
   external set xit(PendingTestFunction v);
   
   /// Describes a pending test case.
   /// - _Only available when invoked via the mocha CLI._
   external PendingTestFunction get xspecify;
   
   external set xspecify(PendingTestFunction v);
   
   /// Execute before running tests.
   /// - _Only available when invoked via the mocha CLI._
   /// @see https://mochajs.org/api/global.html#before
   external HookFunction get suiteSetup;
   
   external set suiteSetup(HookFunction v);
   
   /// Execute after running tests.
   /// - _Only available when invoked via the mocha CLI._
   /// @see https://mochajs.org/api/global.html#after
   external HookFunction get suiteTeardown;
   
   external set suiteTeardown(HookFunction v);
   
   /// Execute before each test case.
   /// - _Only available when invoked via the mocha CLI._
   /// @see https://mochajs.org/api/global.html#beforeEach
   external HookFunction get setup;
   
   external set setup(HookFunction v);
   
   /// Execute after each test case.
   /// - _Only available when invoked via the mocha CLI._
   /// @see https://mochajs.org/api/global.html#afterEach
   external HookFunction get teardown;
   
   external set teardown(HookFunction v);
   
   /// Describe a "suite" containing nested suites and tests.
   /// - _Only available when invoked via the mocha CLI._
   external SuiteFunction get suite;
   
   external set suite(SuiteFunction v);
   
   /// Describes a test case.
   /// - _Only available when invoked via the mocha CLI._
   external TestFunction get test;
   
   external set test(TestFunction v);
   
   external dynamic get run;
   
   external set run(dynamic v);
   
   external factory MochaGlobals({ HookFunction before, HookFunction after, HookFunction beforeEach, HookFunction afterEach,
                                    SuiteFunction describe, SuiteFunction context, PendingSuiteFunction xdescribe,
                                    PendingSuiteFunction xcontext, TestFunction it, TestFunction specify, PendingTestFunction xit,
                                    PendingTestFunction xspecify, HookFunction suiteSetup, HookFunction suiteTeardown,
                                    HookFunction setup, HookFunction teardown, SuiteFunction suite, TestFunction test, dynamic run});
}

/// Third-party declarations that want to add new entries to the `Reporter` union can
/// contribute names here.
@anonymous
@JS()
abstract class ReporterContributions {
   external void get Base;
   
   external set Base(void v);
   
   external void get base;
   
   external set base(void v);
   
   external void get Dot;
   
   external set Dot(void v);
   
   external void get dot;
   
   external set dot(void v);
   
   external void get TAP;
   
   external set TAP(void v);
   
   external void get tap;
   
   external set tap(void v);
   
   external void get JSON;
   
   external set JSON(void v);
   
   external void get json;
   
   external set json(void v);
   
   external void get HTML;
   
   external set HTML(void v);
   
   external void get html;
   
   external set html(void v);
   
   external void get List;
   
   external set List(void v);
   
   external void get list;
   
   external set list(void v);
   
   external void get Min;
   
   external set Min(void v);
   
   external void get min;
   
   external set min(void v);
   
   external void get Spec;
   
   external set Spec(void v);
   
   external void get spec;
   
   external set spec(void v);
   
   external void get Nyan;
   
   external set Nyan(void v);
   
   external void get nyan;
   
   external set nyan(void v);
   
   external void get XUnit;
   
   external set XUnit(void v);
   
   external void get xunit;
   
   external set xunit(void v);
   
   external void get Markdown;
   
   external set Markdown(void v);
   
   external void get markdown;
   
   external set markdown(void v);
   
   external void get Progress;
   
   external set Progress(void v);
   
   external void get progress;
   
   external set progress(void v);
   
   external void get Landing;
   
   external set Landing(void v);
   
   external void get landing;
   
   external set landing(void v);
   
   external void get JSONStream;
   
   external set JSONStream(void v);
   
   external void get String /*"json-stream"*/;
   
   external set String /*"json-stream"*/(void v);
   
   external factory ReporterContributions(
      { void Base, void base, void Dot, void dot, void TAP, void tap, void JSON, void json, void HTML, void html, void List, void list, void Min, void min, void Spec, void spec, void Nyan, void nyan, void XUnit, void xunit, void Markdown, void markdown, void Progress, void progress, void Landing, void landing, void JSONStream, void String /*"json-stream"*/
      });
}

/// Third-party declarations that want to add new entries to the `Interface` union can
/// contribute names here.
@anonymous
@JS()
abstract class InterfaceContributions {
   external void get bdd;
   
   external set bdd(void v);
   
   external void get tdd;
   
   external set tdd(void v);
   
   external void get qunit;
   
   external set qunit(void v);
   
   external void get exports;
   
   external set exports(void v);
   
   external factory InterfaceContributions({ void bdd, void tdd, void qunit, void exports});
}

/// #region Deprecations
/// use `Mocha.Context` instead.
@anonymous
@JS()
abstract class IContext {
   external IRunnable get test;
   
   external set test(IRunnable v);
   
   /*external IRunnable|dynamic runnable();*/
   
   /// `.runnable()` returns `this` in `Mocha.Context`.
   /*external IContext runnable(IRunnable runnable);*/
   external dynamic/*IRunnable|dynamic|IContext*/ runnable([IRunnable runnable]);
   
   /*external num timeout();*/
   
   /// `.timeout()` returns `this` in `Mocha.Context`.
   /*external IContext timeout(num timeout);*/
   external dynamic/*num|IContext*/ timeout([num timeout]);
   
   /// `.enableTimeouts()` has additional overloads in `Mocha.Context`.
   /// `.enableTimeouts()` returns `this` in `Mocha.Context`.
   external IContext enableTimeouts(bool enableTimeouts);
   
   /// `.slow()` has additional overloads in `Mocha.Context`.
   /// `.slow()` returns `this` in `Mocha.Context`.
   external IContext slow(num slow);
   
   /// `.skip()` returns `never` in `Mocha.Context`.
   external IContext skip();
   
   /*external num retries();*/
   
   /// `.retries()` returns `this` in `Mocha.Context`.
   /*external IContext retries(num retries);*/
   external dynamic/*num|IContext*/ retries([num retries]);
}

/// use `Mocha.Suite` instead.
@anonymous
@JS()
abstract class ISuiteCallbackContext {
   /// `.timeout()` has additional overloads in `Mocha.Suite`.
   external ISuiteCallbackContext timeout(dynamic/*num|String*/ ms);
   
   /// `.retries()` has additional overloads in `Mocha.Suite`.
   external ISuiteCallbackContext retries(num n);
   
   /// `.slow()` has additional overloads in `Mocha.Suite`.
   external ISuiteCallbackContext slow(num ms);
}

/// use `Mocha.Context` instead.
@anonymous
@JS()
abstract class IHookCallbackContext {
   /// `.skip()` returns `never` in `Mocha.Context`.
   external IHookCallbackContext skip();
   
   /// `.timeout()` has additional overloads in `Mocha.Context`.
   external IHookCallbackContext timeout(dynamic/*num|String*/ ms);
/* Index signature is not yet supported by JavaScript interop. */
}

/// use `Mocha.Context` instead.
@anonymous
@JS()
abstract class ITestCallbackContext {
   /// `.skip()` returns `never` in `Mocha.Context`.
   external ITestCallbackContext skip();
   
   /// `.timeout()` has additional overloads in `Mocha.Context`.
   external ITestCallbackContext timeout(dynamic/*num|String*/ ms);
   
   /// `.retries()` has additional overloads in `Mocha.Context`.
   external ITestCallbackContext retries(num n);
   
   /// `.slow()` has additional overloads in `Mocha.Context`.
   external ITestCallbackContext slow(num ms);
/* Index signature is not yet supported by JavaScript interop. */
}

/// Partial interface for Mocha's `Runnable` class.
/// use `Mocha.Runnable` instead.
@anonymous
@JS()
abstract class IRunnable
   implements EventEmitter {
   external String get title;
   
   external set title(String v);
   
   /// `.fn` has type `Func | AsyncFunc` in `Mocha.Runnable`.
   external dynamic/*Function|dynamic*/ get fn;
   
   external set fn(dynamic/*Function|dynamic*/ v);
   
   external bool get JS$async;
   
   external set JS$async(bool v);
   
   external bool get JS$sync;
   
   external set JS$sync(bool v);
   
   external bool get timedOut;
   
   external set timedOut(bool v);
   
   /// `.timeout()` has additional overloads in `Mocha.Runnable`.
   external IRunnable timeout(dynamic/*num|String*/ n);
   
   external num get duration;
   
   external set duration(num v);
}

/// Partial interface for Mocha's `Suite` class.
/// use `Mocha.Suite` instead.
@anonymous
@JS()
abstract class ISuite {
   /// `.ctx` has type `Mocha.Context` in `Mocha.Suite`.
   external IContext get ctx;
   
   external set ctx(IContext v);
   
   /// `.parent` has type `Mocha.Suite | undefined` in `Mocha.Suite`.
   external dynamic/*ISuite|dynamic*/ get parent;
   
   external set parent(dynamic/*ISuite|dynamic*/ v);
   
   external bool get root;
   
   external set root(bool v);
   
   external String get title;
   
   external set title(String v);
   
   /// `.suites` has type `Mocha.Suite[]` in `Mocha.Suite`.
   external List<ISuite> get suites;
   
   external set suites(List<ISuite> v);
   
   /// `.tests` has type `Mocha.Test[]` in `Mocha.Suite`.
   external List<ITest> get tests;
   
   external set tests(List<ITest> v);
   
   /*external bool bail();*/
   
   /// `.bail()` returns `this` in `Mocha.Suite`.
   /*external ISuite bail(bool bail);*/
   external dynamic/*bool|ISuite*/ bail([bool bail]);
   
   external String fullTitle();
   
   /*external num retries();*/
   
   /// `.retries()` returns `this` in `Mocha.Suite`.
   /*external ISuite retries(num retries);*/
   external dynamic/*num|ISuite*/ retries([num retries]);
   
   /*external num slow();*/
   
   /// `.slow()` returns `this` in `Mocha.Suite`.
   /*external ISuite slow(num slow);*/
   external dynamic/*num|ISuite*/ slow([num slow]);
   
   /*external num timeout();*/
   
   /// `.timeout()` returns `this` in `Mocha.Suite`.
   /*external ISuite timeout(num timeout);*/
   external dynamic/*num|ISuite*/ timeout([num timeout]);
}

/// Partial interface for Mocha's `Test` class.
/// use `Mocha.Test` instead.
@anonymous
@JS()
abstract class ITest
   implements IRunnable {
   external String get body;
   
   external set body(String v);
   
   external String get file;
   
   external set file(String v);
   
   /// `.parent` has type `Mocha.Suite | undefined` in `Mocha.Test`.
   external ISuite get parent;
   
   external set parent(ISuite v);
   
   external bool get pending;
   
   external set pending(bool v);
   
   external String/*'failed'|'passed'*/ get state;
   
   external set state(String/*'failed'|'passed'*/ v);
   
   external String/*'test'*/ get type;
   
   external set type(String/*'test'*/ v);
   
   external String fullTitle();
}

/// use `Mocha.Hook` instead.
@anonymous
@JS()
abstract class IHook
   implements IRunnable {
   /// `.ctx` has type `Mocha.Context` in `Mocha.Runnable`.
   external IContext get ctx;
   
   external set ctx(IContext v);
   
   /// `.parent` has type `Mocha.Suite` in `Mocha.Runnable`.
   external ISuite get parent;
   
   external set parent(ISuite v);
   
   external String/*'hook'*/ get type;
   
   external set type(String/*'hook'*/ v);
   
   /// `.error()` has additional overloads in `Mocha.Hook`.
   external void error(Error err);
}

/// use `Mocha.Context` instead.
@anonymous
@JS()
abstract class IBeforeAndAfterContext
   implements IHookCallbackContext {
   /// `.currentTest` has type `Mocha.Test` in `Mocha.Context`.
   external ITest get currentTest;
   
   external set currentTest(ITest v);
}

/// use `Mocha.Stats` instead.
/*type IStats = Stats;*/

/// Partial interface for Mocha's `Runner` class.
/// use `Mocha.Runner` instead.
@anonymous
@JS()
abstract class IRunner
   implements EventEmitter {
   external bool get asyncOnly;
   
   external set asyncOnly(bool v);
   
   external Stats get stats;
   
   external set stats(Stats v);
   
   external bool get started;
   
   external set started(bool v);
   
   /// `.suite` has type `Mocha.Suite` in `Mocha.Runner`.
   external ISuite get suite;
   
   external set suite(ISuite v);
   
   external num get total;
   
   external set total(num v);
   
   external num get failures;
   
   external set failures(num v);
   
   external bool get forbidOnly;
   
   external set forbidOnly(bool v);
   
   external bool get forbidPending;
   
   external set forbidPending(bool v);
   
   external bool get fullStackTrace;
   
   external set fullStackTrace(bool v);
   
   external bool get ignoreLeaks;
   
   external set ignoreLeaks(bool v);
   
   external IRunner grep(RegExp re, bool invert);
   
   /// Parameter `suite` has type `Mocha.Suite` in `Mocha.Runner`.
   external num grepTotal(ISuite suite);
   
   /// `.globals()` has different overloads in `Mocha.Runner`.
   external dynamic/*IRunner|List<String>*/ globals(List<String> arr);
   
   external IRunner abort();
   
   external IRunner run([void fn(num failures)]);
}

/// use `Mocha.SuiteFunction` instead.
@anonymous
@JS()
abstract class IContextDefinition {
   /// use `Mocha.SuiteFunction` instead.
   external ISuite call(String description, void callback(/*ISuiteCallbackContext this*/));
   
   /// use `Mocha.SuiteFunction` instead.
   external ISuite only(String description, void callback(/*ISuiteCallbackContext this*/));
   
   /// use `Mocha.SuiteFunction` instead.
   external void skip(String description, void callback(/*ISuiteCallbackContext this*/));
}

/// use `Mocha.TestFunction` instead.
@anonymous
@JS()
abstract class ITestDefinition {
   /// use `Mocha.TestFunction` instead.
   /// `Mocha.TestFunction` does not allow mixing `done` with a return type of `PromiseLike<any>`.
   external ITest call(String expectation, [dynamic/*PromiseLike<dynamic>|Null*/ callback(/*ITestCallbackContext this*/ Done done)]);
   
   /// use `Mocha.TestFunction` instead.
   /// `Mocha.TestFunction#only` does not allow mixing `done` with a return type of `PromiseLike<any>`.
   external ITest only(String expectation, [dynamic/*PromiseLike<dynamic>|Null*/ callback(/*ITestCallbackContext this*/ Done done)]);
   
   /// use `Mocha.TestFunction` instead.
   /// `Mocha.TestFunction#skip` does not allow mixing `done` with a return type of `PromiseLike<any>`.
   external void skip(String expectation, [dynamic/*PromiseLike<dynamic>|Null*/ callback(/*ITestCallbackContext this*/ Done done)]);
}

/*type Reporter = any*/
/*type Interface = any*/

// End module Mocha

/// #region Test interface augmentations

/// Triggers root suite execution.
/// - _Only available if flag --delay is passed into Mocha._
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#runWithSuite
@JS()
external void run2();

/// Execute before running tests.
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#before
@JS()
external HookFunction get before2;

@JS()
external set before2(HookFunction v);

/// Execute before running tests.
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#before
@JS()
external HookFunction get suiteSetup2;

@JS()
external set suiteSetup2(HookFunction v);

/// Execute after running tests.
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#after
@JS()
external HookFunction get after2;

@JS()
external set after2(HookFunction v);

/// Execute after running tests.
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#after
@JS()
external HookFunction get suiteTeardown2;

@JS()
external set suiteTeardown2(HookFunction v);

/// Execute before each test case.
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#beforeEach
@JS()
external HookFunction get beforeEach2;

@JS()
external set beforeEach2(HookFunction v);

/// Execute before each test case.
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#beforeEach
@JS()
external HookFunction get setup2;

@JS()
external set setup2(HookFunction v);

/// Execute after each test case.
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#afterEach
@JS()
external HookFunction get afterEach2;

@JS()
external set afterEach2(HookFunction v);

/// Execute after each test case.
/// - _Only available when invoked via the mocha CLI._
/// @see https://mochajs.org/api/global.html#afterEach
@JS()
external HookFunction get teardown2;

@JS()
external set teardown2(HookFunction v);

/// Describe a "suite" containing nested suites and tests.
/// - _Only available when invoked via the mocha CLI._
@JS()
external SuiteFunction get describe2;

@JS()
external set describe2(SuiteFunction v);

/// Describe a "suite" containing nested suites and tests.
/// - _Only available when invoked via the mocha CLI._
@JS()
external SuiteFunction get context;

@JS()
external set context(SuiteFunction v);

/// Describe a "suite" containing nested suites and tests.
/// - _Only available when invoked via the mocha CLI._
@JS()
external SuiteFunction get suite2;

@JS()
external set suite2(SuiteFunction v);

/// Pending suite.
/// - _Only available when invoked via the mocha CLI._
@JS()
external PendingSuiteFunction get xdescribe;

@JS()
external set xdescribe(PendingSuiteFunction v);

/// Pending suite.
/// - _Only available when invoked via the mocha CLI._
@JS()
external PendingSuiteFunction get xcontext;

@JS()
external set xcontext(PendingSuiteFunction v);

/// Describes a test case.
/// - _Only available when invoked via the mocha CLI._
@JS()
external TestFunction get it2;

@JS()
external set it2(TestFunction v);

/// Describes a test case.
/// - _Only available when invoked via the mocha CLI._
@JS()
external TestFunction get specify;

@JS()
external set specify(TestFunction v);

/// Describes a test case.
/// - _Only available when invoked via the mocha CLI._
@JS()
external TestFunction get test2;

@JS()
external set test2(TestFunction v);

/// Describes a pending test case.
/// - _Only available when invoked via the mocha CLI._
@JS()
external PendingTestFunction get xit2;

@JS()
external set xit2(PendingTestFunction v);

/// Describes a pending test case.
/// - _Only available when invoked via the mocha CLI._
@JS()
external PendingTestFunction get xspecify;

@JS()
external set xspecify(PendingTestFunction v);

/// #endregion Test interface augmentations

/// #region Reporter augmentations

/// Forward declaration for `HTMLLIElement` from lib.dom.d.ts.
/// Required by Mocha.reporters.HTML.
/// NOTE: Mocha *must not* have a direct dependency on DOM types.
/// tslint:disable-next-line no-empty-interface

/* Skipping class HTMLLIElement*/

/// Augments the DOM `Window` object when lib.dom.d.ts is loaded.
/// tslint:disable-next-line no-empty-interface

/* Skipping class Window*/

// Module NodeJS
/// Forward declaration for `NodeJS.EventEmitter` from node.d.ts.
/// Required by Mocha.Runnable, Mocha.Runner, and Mocha.Suite.
/// NOTE: Mocha *must not* have a direct dependency on @types/node.
/// tslint:disable-next-line no-empty-interface
@anonymous
@JS()
abstract class EventEmitter {}

/// Augments NodeJS's `global` object when node.d.ts is loaded
/// tslint:disable-next-line no-empty-interface
@anonymous
@JS()
abstract class Global
   implements MochaGlobals {
   external factory Global({ HookFunction before, HookFunction after, HookFunction beforeEach, HookFunction afterEach,
                              SuiteFunction describe, SuiteFunction context, PendingSuiteFunction xdescribe,
                              PendingSuiteFunction xcontext, TestFunction it, TestFunction specify, PendingTestFunction
      xit, PendingTestFunction xspecify, HookFunction suiteSetup, HookFunction suiteTeardown,
                              HookFunction setup, HookFunction teardown, SuiteFunction suite, TestFunction test, dynamic run});
}

// End module NodeJS

/// #endregion Reporter augmentations

/// #region Browser augmentations

/// Mocha global.
/// - _Only supported in the browser._
@JS()
external BrowserMocha get mocha;

@anonymous
@JS()
abstract class BrowserMocha
   implements Mocha {
   /// Function to allow assertion libraries to throw errors directly into mocha.
   /// This is useful when running tests in a browser because window.onerror will
   /// only receive the 'message' attribute of the Error.
   /// - _Only supported in the browser._
   external void throwError(dynamic err);
   
   /// Setup mocha with the given settings options.
   /// - _Only supported in the browser._
   external BrowserMocha setup([dynamic/*dynamic|MochaSetupOptions*/ opts]);
}

/// Options to pass to `mocha.setup` in the browser.
@anonymous
@JS()
abstract class MochaSetupOptions
   implements MochaOptions {
   /// This is not used by Mocha. Use `files` instead.
   external List<String> get require;
   
   external set require(List<String> v);
   
   external bool get fullTrace;
   
   external set fullTrace(bool v);
   
   external factory MochaSetupOptions(
      { List<String> require, bool fullTrace, dynamic ui, dynamic/*String|ReporterConstructor*/ reporter, dynamic reporterOptions, List<
         String> globals, num timeout, bool enableTimeouts, num retries, bool bail, num slow, bool ignoreLeaks, bool fullStackTrace, dynamic/*String|RegExp*/ grep, bool growl, bool useColors, bool inlineDiffs, bool hideDiff, bool asyncOnly, bool delay, bool forbidOnly, bool forbidPending, bool noHighlighting, bool allowUncaught});
}

/// #endregion Browser augmentations

/// #region Deprecations

/// use `Mocha.Done` instead.
/*type MochaDone = Mocha.Done;*/

/// use `Mocha.ReporterConstructor` instead.
/*type ReporterConstructor = Mocha.ReporterConstructor;*/

/// #endregion Deprecations

// Module mocha
/* WARNING: export assignment not yet supported. */

// End module mocha

// Module mocha/lib/ms
/* WARNING: export assignment not yet supported. */

/// Parse the given `str` and return milliseconds.
/// @see [https://mochajs.org/api/module-milliseconds.html]
/// @see [https://mochajs.org/api/module-milliseconds.html#~parse]
/*external num milliseconds(String val);*/

/// Format for `ms`.
/// @see [https://mochajs.org/api/module-milliseconds.html]
/// @see [https://mochajs.org/api/module-milliseconds.html#~format]
/*external String milliseconds(num val);*/
@JS("mocha/lib/ms.milliseconds")
external dynamic/*num|String*/ milliseconds(dynamic/*String|num*/ val);
// End module mocha/lib/ms

// Module mocha/lib/interfaces/common
/* WARNING: export assignment not yet supported. */
@JS("mocha/lib/interfaces/common.common")
external CommonFunctions common(List<Suite> suites, MochaGlobals context, Mocha mocha);
// Module common
@anonymous
@JS()
abstract class CommonFunctions {
   /// This is only present if flag --delay is passed into Mocha. It triggers
   /// root suite execution.
   external void runWithSuite(Suite suite);
   
   /// Execute before running tests.
   /*external void before([Func|AsyncFunc fn]);*/
   
   /// Execute before running tests.
   /*external void before(String name, [Func|AsyncFunc fn]);*/
   external void before([String fn_name, fn]);
   
   /// Execute after running tests.
   /*external void after([Func|AsyncFunc fn]);*/
   
   /// Execute after running tests.
   /*external void after(String name, [Func|AsyncFunc fn]);*/
   external void after([String fn_name, fn]);
   
   /// Execute before each test case.
   /*external void beforeEach([Func|AsyncFunc fn]);*/
   
   /// Execute before each test case.
   /*external void beforeEach(String name, [Func|AsyncFunc fn]);*/
   external void beforeEach([String fn_name, fn]);
   
   /// Execute after each test case.
   /*external void afterEach([Func|AsyncFunc fn]);*/
   
   /// Execute after each test case.
   /*external void afterEach(String name, [Func|AsyncFunc fn]);*/
   external void afterEach([String fn_name, fn]);
   
   external SuiteFunctions get suite;
   
   external set suite(SuiteFunctions v);
   
   external TestFunctions get test;
   
   external set test(TestFunctions v);
}

@anonymous
@JS()
abstract class CreateOptions {
   /// Title of suite
   external String get title;
   
   external set title(String v);
   
   /// Suite function
   external void Function(Suite self) get fn;
   
   external set fn(void Function(Suite self) v);
   
   /// Is suite pending?
   external bool get pending;
   
   external set pending(bool v);
   
   /// Filepath where this Suite resides
   external String get file;
   
   external set file(String v);
   
   /// Is suite exclusive?
   external bool get isOnly;
   
   external set isOnly(bool v);
   
   external factory CreateOptions({ String title, void Function(Suite self) fn, bool pending, String file, bool isOnly});
}

@anonymous
@JS()
abstract class SuiteFunctions {
   /// Create an exclusive Suite; convenience function
   external Suite only(CreateOptions opts);
   
   /// Create a Suite, but skip it; convenience function
   external Suite skip(CreateOptions opts);
   
   /// Creates a suite.
   external Suite create(CreateOptions opts);
}

@anonymous
@JS()
abstract class TestFunctions {
   /// Exclusive test-case.
   external Test only(Mocha mocha, Test test);
   
   /// Pending test case.
   external void skip(String title);
   
   /// Number of retry attempts
   external void retries(num n);
}

// End module common

// End module mocha/lib/interfaces/common
