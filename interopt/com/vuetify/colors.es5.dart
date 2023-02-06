@JS()
library colors.es5;

import "package:js/js.dart";

// Module vuetify/es5/util/colors
@anonymous
@JS()
abstract class BaseColor {
  external String get base;
  external set base(String v);
  external String get lighten5;
  external set lighten5(String v);
  external String get lighten4;
  external set lighten4(String v);
  external String get lighten3;
  external set lighten3(String v);
  external String get lighten2;
  external set lighten2(String v);
  external String get lighten1;
  external set lighten1(String v);
  external String get darken1;
  external set darken1(String v);
  external String get darken2;
  external set darken2(String v);
  external String get darken3;
  external set darken3(String v);
  external String get darken4;
  external set darken4(String v);
  external factory BaseColor(
      {String base,
      String lighten5,
      String lighten4,
      String lighten3,
      String lighten2,
      String lighten1,
      String darken1,
      String darken2,
      String darken3,
      String darken4});
}

@anonymous
@JS()
abstract class Color implements BaseColor {
  external String get accent1;
  external set accent1(String v);
  external String get accent2;
  external set accent2(String v);
  external String get accent3;
  external set accent3(String v);
  external String get accent4;
  external set accent4(String v);
  external factory Color(
      {String accent1,
      String accent2,
      String accent3,
      String accent4,
      String base,
      String lighten5,
      String lighten4,
      String lighten3,
      String lighten2,
      String lighten1,
      String darken1,
      String darken2,
      String darken3,
      String darken4});
}

@anonymous
@JS()
abstract class Shade {
  external String get black;
  external set black(String v);
  external String get white;
  external set white(String v);
  external String get transparent;
  external set transparent(String v);
  external factory Shade({String black, String white, String transparent});
}

@anonymous
@JS()
abstract class Colors {
  external Color get red;
  external set red(Color v);
  external Color get pink;
  external set pink(Color v);
  external Color get purple;
  external set purple(Color v);
  external Color get deepPurple;
  external set deepPurple(Color v);
  external Color get indigo;
  external set indigo(Color v);
  external Color get blue;
  external set blue(Color v);
  external Color get lightBlue;
  external set lightBlue(Color v);
  external Color get cyan;
  external set cyan(Color v);
  external Color get teal;
  external set teal(Color v);
  external Color get green;
  external set green(Color v);
  external Color get lightGreen;
  external set lightGreen(Color v);
  external Color get lime;
  external set lime(Color v);
  external Color get yellow;
  external set yellow(Color v);
  external Color get amber;
  external set amber(Color v);
  external Color get orange;
  external set orange(Color v);
  external Color get deepOrange;
  external set deepOrange(Color v);
  external BaseColor get brown;
  external set brown(BaseColor v);
  external BaseColor get blueGrey;
  external set blueGrey(BaseColor v);
  external BaseColor get grey;
  external set grey(BaseColor v);
  external Shade get shades;
  external set shades(Shade v);
  external factory Colors(
      {Color red,
      Color pink,
      Color purple,
      Color deepPurple,
      Color indigo,
      Color blue,
      Color lightBlue,
      Color cyan,
      Color teal,
      Color green,
      Color lightGreen,
      Color lime,
      Color yellow,
      Color amber,
      Color orange,
      Color deepOrange,
      BaseColor brown,
      BaseColor blueGrey,
      BaseColor grey,
      Shade shades});
}

@JS("vuetify/es5/util/colors.colors")
external Colors get colors; /* WARNING: export assignment not yet supported. */

// End module vuetify/es5/util/colors
