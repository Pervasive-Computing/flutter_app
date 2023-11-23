import 'package:flutter/material.dart';
import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:provider/provider.dart';

class OwnThemeFields {
  late final Flavor flavor;

  late final Color base;
  late final Color text;
  late final Color mantle;
  late final Color crust;
  late final Color blue;
  late final Color pink;
  late final Color red;
  late final Color sky;
  late final Color teal;
  late final Color yellow;
  late final Color sapphire;
  late final Color rosewater;
  late final Color lavender;
  late final Color flamingo;
  late final Color maroon;
  late final Color mauve;
  late final Color peach;
  late final Color surface0;
  late final Color surface1;
  late final Color surface2;
  late final Color subtext0;
  late final Color subtext1;
  late final Color overlay0;
  late final Color overlay1;
  late final Color overlay2;

  OwnThemeFields(
    this.flavor,
  ) {
    // final colorMap = getColorMap(flavor);
    base = flavor.base;
    text = flavor.text;
    mantle = flavor.mantle;
    crust = flavor.crust;
    blue = flavor.blue;
    pink = flavor.pink;
    red = flavor.red;
    sky = flavor.sky;
    teal = flavor.teal;
    yellow = flavor.yellow;
    sapphire = flavor.sapphire;
    rosewater = flavor.rosewater;
    lavender = flavor.lavender;
    flamingo = flavor.flamingo;
    maroon = flavor.maroon;
    mauve = flavor.mauve;
    peach = flavor.peach;
    surface0 = flavor.surface0;
    surface1 = flavor.surface1;
    surface2 = flavor.surface2;
    subtext0 = flavor.subtext0;
    subtext1 = flavor.subtext1;
    overlay0 = flavor.overlay0;
    overlay1 = flavor.overlay1;
    overlay2 = flavor.overlay2;
  }
}

extension ThemeDataExtensions on ThemeData {
  static final Map<InputDecorationTheme, OwnThemeFields> _own = {};

  void addOwn(OwnThemeFields own) {
    // can't use reference to ThemeData since Theme.of() can create a new localized instance from the original theme. Use internal fields, in this case InputDecoreationTheme reference which is not deep copied but simply a reference is copied
    _own[inputDecorationTheme] = own;
  }

  static OwnThemeFields? empty;

  OwnThemeFields own(Flavor flavor) {
    var o = _own[inputDecorationTheme];
    if (o == null) {
      empty ??= OwnThemeFields(flavor);
      o = empty;
    }
    return o!;
  }
}

ThemeData catppuccinTheme(Flavor flavor, {required BuildContext context}) {
  Color primaryColor = flavor.lavender;
  Color secondaryColor = flavor.mauve;
  // Color secondaryColor = flavor.yellow;
  return ThemeData(
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      elevation: 0,
      titleTextStyle: TextStyle(color: flavor.text, fontSize: 20, fontWeight: FontWeight.bold),
      backgroundColor: flavor.crust,
      foregroundColor: flavor.mantle,
    ),
    colorScheme: ColorScheme(
      background: flavor.base,
      brightness: flavor.base.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark,
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
  )..addOwn(
      OwnThemeFields(flavor),
    );
}

// OwnThemeFields ownTheme(BuildContext context) => Theme.of(context).own();

class CatppuccinThemeData {
  final Flavor flavor;
  final BuildContext context;

  CatppuccinThemeData({
    required this.context,
    required this.flavor,
  });

  ThemeData get materialTheme {
    Color primaryColor = flavor.lavender;
    Color secondaryColor = flavor.mauve;
    return ThemeData(
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        elevation: 0,
        titleTextStyle: TextStyle(color: flavor.text, fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: flavor.crust,
        foregroundColor: flavor.mantle,
      ),
      colorScheme: ColorScheme(
        background: flavor.base,
        brightness: flavor.base.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark,
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
    );
  }
}

class CatppuccinTheme extends StatelessWidget {
  final Widget child;
  final Flavor flavor;

  const CatppuccinTheme({
    super.key,
    required this.child,
    required this.flavor,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = CatppuccinThemeData(
      context: context,
      flavor: flavor,
    );
    return Provider.value(
      value: themeData,
      child: child,
    );
  }
}

extension BuildContextExtension on BuildContext {
  CatppuccinThemeData get catppuccinTheme {
    return watch<CatppuccinThemeData>();
  }
}
