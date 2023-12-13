import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:catppuccin_flutter/catppuccin_flutter.dart';

class CatppuccinTheme extends ThemeExtension<CatppuccinTheme> {
  late final Flavor? flavor;
  late final Color? rosewater;
  late final Color? flamingo;
  late final Color? pink;
  late final Color? mauve;
  late final Color? red;
  late final Color? maroon;
  late final Color? peach;
  late final Color? yellow;
  late final Color? green;
  late final Color? teal;
  late final Color? sky;
  late final Color? sapphire;
  late final Color? blue;
  late final Color? lavender;

  late final Color? text;
  late final Color? subtext1;
  late final Color? subtext0;

  late final Color? overlay2;
  late final Color? overlay1;
  late final Color? overlay0;

  late final Color? surface2;
  late final Color? surface1;
  late final Color? surface0;

  late final Color? base;
  late final Color? mantle;
  late final Color? crust;

  CatppuccinTheme({
    this.flavor,
    Color? rosewater,
    Color? flamingo,
    Color? pink,
    Color? mauve,
    Color? red,
    Color? maroon,
    Color? peach,
    Color? yellow,
    Color? green,
    Color? teal,
    Color? sky,
    Color? sapphire,
    Color? blue,
    Color? lavender,
    Color? text,
    Color? subtext1,
    Color? subtext0,
    Color? overlay2,
    Color? overlay1,
    Color? overlay0,
    Color? surface2,
    Color? surface1,
    Color? surface0,
    Color? base,
    Color? mantle,
    Color? crust,
  }) {
    // assign flavor colour unless the colour is specified
    // this.rosewater = rosewater ?? flavor?.rosewater;
    this.rosewater = rosewater ?? flavor?.rosewater;
    this.flamingo = flamingo ?? flavor?.flamingo;
    this.pink = pink ?? flavor?.pink;
    this.mauve = mauve ?? flavor?.mauve;
    this.red = red ?? flavor?.red;
    this.maroon = maroon ?? flavor?.maroon;
    this.peach = peach ?? flavor?.peach;
    this.yellow = yellow ?? flavor?.yellow;
    this.green = green ?? flavor?.green;
    this.teal = teal ?? flavor?.teal;
    this.sky = sky ?? flavor?.sky;
    this.sapphire = sapphire ?? flavor?.sapphire;
    this.blue = blue ?? flavor?.blue;
    this.lavender = lavender ?? flavor?.lavender;

    this.text = text ?? flavor?.text;
    this.subtext1 = subtext1 ?? flavor?.subtext1;
    this.subtext0 = subtext0 ?? flavor?.subtext0;

    this.overlay2 = overlay2 ?? flavor?.overlay2;
    this.overlay1 = overlay1 ?? flavor?.overlay1;
    this.overlay0 = overlay0 ?? flavor?.overlay0;

    this.surface2 = surface2 ?? flavor?.surface2;
    this.surface1 = surface1 ?? flavor?.surface1;
    this.surface0 = surface0 ?? flavor?.surface0;

    this.base = base ?? flavor?.base;
    this.mantle = mantle ?? flavor?.mantle;
    this.crust = crust ?? flavor?.crust;
  }

  @override
  CatppuccinTheme copyWith({
    Flavor? flavor,
    Color? rosewater,
    Color? flamingo,
    Color? pink,
    Color? mauve,
    Color? red,
    Color? maroon,
    Color? peach,
    Color? yellow,
    Color? green,
    Color? teal,
    Color? sky,
    Color? sapphire,
    Color? blue,
    Color? lavender,
    Color? text,
    Color? subtext1,
    Color? subtext0,
    Color? overlay2,
    Color? overlay1,
    Color? overlay0,
    Color? surface2,
    Color? surface1,
    Color? surface0,
    Color? base,
    Color? mantle,
    Color? crust,
  }) {
    return CatppuccinTheme(
      flavor: flavor,
      rosewater: rosewater ?? flavor?.rosewater,
      flamingo: flamingo ?? flavor?.flamingo,
      pink: pink ?? flavor?.pink,
      mauve: mauve ?? flavor?.mauve,
      red: red ?? flavor?.red,
      maroon: maroon ?? flavor?.maroon,
      peach: peach ?? flavor?.peach,
      yellow: yellow ?? flavor?.yellow,
      green: green ?? flavor?.green,
      teal: teal ?? flavor?.teal,
      sky: sky ?? flavor?.sky,
      sapphire: sapphire ?? flavor?.sapphire,
      blue: blue ?? flavor?.blue,
      lavender: lavender ?? flavor?.lavender,
      text: text ?? flavor?.text,
      subtext1: subtext1 ?? flavor?.subtext1,
      subtext0: subtext0 ?? flavor?.subtext0,
      overlay2: overlay2 ?? flavor?.overlay2,
      overlay1: overlay1 ?? flavor?.overlay1,
      overlay0: overlay0 ?? flavor?.overlay0,
      surface2: surface2 ?? flavor?.surface2,
      surface1: surface1 ?? flavor?.surface1,
      surface0: surface0 ?? flavor?.surface0,
      base: base ?? flavor?.base,
      mantle: mantle ?? flavor?.mantle,
      crust: crust ?? flavor?.crust,
    );
  }

  // lerp
  @override
  ThemeExtension<CatppuccinTheme> lerp(
      ThemeExtension<CatppuccinTheme>? other, double t) {
    if (other == null) return this;
    if (other is CatppuccinTheme) {
      return CatppuccinTheme(
        flavor: flavor,
        rosewater: Color.lerp(rosewater, other.rosewater, t),
        flamingo: Color.lerp(flamingo, other.flamingo, t),
        pink: Color.lerp(pink, other.pink, t),
        mauve: Color.lerp(mauve, other.mauve, t),
        red: Color.lerp(red, other.red, t),
        maroon: Color.lerp(maroon, other.maroon, t),
        peach: Color.lerp(peach, other.peach, t),
        yellow: Color.lerp(yellow, other.yellow, t),
        green: Color.lerp(green, other.green, t),
        teal: Color.lerp(teal, other.teal, t),
        sky: Color.lerp(sky, other.sky, t),
        sapphire: Color.lerp(sapphire, other.sapphire, t),
        blue: Color.lerp(blue, other.blue, t),
        lavender: Color.lerp(lavender, other.lavender, t),
        text: Color.lerp(text, other.text, t),
        subtext1: Color.lerp(subtext1, other.subtext1, t),
        subtext0: Color.lerp(subtext0, other.subtext0, t),
        overlay2: Color.lerp(overlay2, other.overlay2, t),
        overlay1: Color.lerp(overlay1, other.overlay1, t),
        overlay0: Color.lerp(overlay0, other.overlay0, t),
        surface2: Color.lerp(surface2, other.surface2, t),
        surface1: Color.lerp(surface1, other.surface1, t),
        surface0: Color.lerp(surface0, other.surface0, t),
        base: Color.lerp(base, other.base, t),
        mantle: Color.lerp(mantle, other.mantle, t),
        crust: Color.lerp(crust, other.crust, t),
      );
    }
    return this;
  }
}

class LampTheme extends ThemeExtension<LampTheme> {
  late final Brightness? brightness;
  late final Color? lampColor;

  LampTheme({
    this.brightness,
    Color? lampColor,
  }) {
    this.lampColor = lampColor ?? Colors.yellow;
  }

  @override
  LampTheme copyWith({
    Brightness? brightness,
  }) {
    return LampTheme(
      brightness: brightness ?? this.brightness,
      lampColor: lampColor,
    );
  }

  @override
  ThemeExtension<LampTheme> lerp(ThemeExtension<LampTheme>? other, double t) {
    if (other == null) return this;
    if (other is LampTheme) {
      return LampTheme(
        brightness: brightness,
        lampColor: Color.lerp(lampColor, other.lampColor, t),
      );
    }
    return this;
  }
}

ThemeData catppuccinTheme(Flavor flavor, {required BuildContext context}) {
  Color primaryColor = flavor.lavender;
  Color secondaryColor = flavor.mauve;
  Brightness brightness =
      flavor.base.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark;

  return ThemeData(
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      elevation: 0,
      titleTextStyle: TextStyle(
          color: flavor.text, fontSize: 20, fontWeight: FontWeight.bold),
      backgroundColor: flavor.crust,
      foregroundColor: flavor.mantle,
    ),
    colorScheme: ColorScheme(
      background: flavor.base,
      brightness: brightness,
      error: flavor.surface2,
      onBackground: flavor.text,
      onError: flavor.red,
      onPrimary: primaryColor,
      onSecondary: secondaryColor,
      onSurface: flavor.text,
      primary: flavor.crust,
      secondary: flavor.mantle,
      surface: flavor.surface0,
    ),
    textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Inter',
          bodyColor: flavor.text,
          displayColor: primaryColor,
        ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
    ),
    extensions: <ThemeExtension<dynamic>>[
      CatppuccinTheme(flavor: flavor),
      LampTheme(
          brightness: brightness,
          lampColor: brightness == Brightness.light
              ? flavor.yellow
              : catppuccin.latte.yellow.brighten(0.25)),
    ],
  );
}
