import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';
// Text Themes

final Map<String, TextTheme> textThemesMap = {
  'default': const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
    ),
  )
};

Map<String, ThemeData> buildThemeDataMap(BuildContext context, String textThemeName) {
  final Map<String, ThemeData> themeDataMap = {};
  for (final themeName in colorSchemesMap.keys) {
    themeDataMap[themeName] = buildThemeData(themeName, textThemeName);
  }
  return themeDataMap;
}

ThemeData buildThemeData(String themeName, String textThemeName) {
  final ColorScheme colorScheme = colorSchemesMap[themeName]!;
  final TextTheme textTheme = textThemesMap[textThemeName]!;

  return ThemeData(
    colorScheme: colorScheme,
    textTheme: textTheme,
    scrollbarTheme: buildScrollbarThemeData(colorScheme),
    sliderTheme: buildSliderThemeData(colorScheme, textTheme),
  );
}

ScrollbarThemeData buildScrollbarThemeData(ColorScheme colorScheme) {
  return ScrollbarThemeData(
    trackColor: MaterialStateColor.resolveWith(
      (states) => colorScheme.onBackground.withOpacity(0.5),
    ),
    thickness: MaterialStateProperty.all(0),
  );
}

SliderThemeData buildSliderThemeData(ColorScheme colorScheme, TextTheme textTheme) {
  return SliderThemeData(
    // track and thumb shape are same height to "hide" the thumb, but keep it rounded
    trackHeight: 0.5,
    thumbShape: const RoundSliderThumbShape(
      enabledThumbRadius: 5,
      elevation: 0,
      pressedElevation: 0,
      disabledThumbRadius: 0,
    ),
    thumbColor: colorScheme.secondary.withOpacity(1),

    // small overlay shape to not add additional unecessary padding
    overlayShape: const RoundSliderOverlayShape(
      overlayRadius: 1,
    ),
    // Opacity 0 with these to hide the overlay
    overlayColor: colorScheme.secondary.withOpacity(0),

    // track colors
    activeTrackColor: colorScheme.secondary.withOpacity(1),
    inactiveTrackColor: colorScheme.secondary.withOpacity(1),
    // disabledInactiveTrackColor: colorScheme.secondary.withOpacity(0.5),
    // disabledActiveTrackColor: colorScheme.secondary.withOpacity(0.5),

    // track shapes
    // trackShape: const RoundedRectSliderTrackShape(), // RoundedRectSliderTrackShape
    // rangeTrackShape: const RectangularRangeSliderTrackShape(),

    // tick marks
    activeTickMarkColor: Colors.transparent,
    inactiveTickMarkColor: Colors.transparent,

    // Opacity 0 with these to hide the value indicator
    valueIndicatorColor: colorScheme.secondary.withOpacity(0),
    valueIndicatorTextStyle: textTheme.bodySmall?.copyWith(
      color: colorScheme.onBackground.withOpacity(0),
    ),
  );
}

final Map<String, ColorScheme> colorSchemesMap = {
  ...lightColorSchemesMap,
  ...darkColorSchemesMap,
};

final Map<String, ColorScheme> lightColorSchemesMap = {
  // Light Default 'monochromatic'
  'light': const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 0, 0, 0),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
    secondary: Color.fromARGB(255, 0, 0, 0),
    onSecondary: Color.fromARGB(255, 255, 255, 255),
    background: Color.fromARGB(255, 255, 255, 255),
    onBackground: Color.fromARGB(255, 0, 0, 0),
    error: Color.fromARGB(255, 255, 0, 0),
    onError: Color.fromARGB(255, 255, 255, 255),
    surface: Color.fromARGB(255, 255, 255, 255),
    onSurface: Color.fromARGB(255, 0, 0, 0),
  ),
};

final Map<String, ColorScheme> darkColorSchemesMap = {
  'dark': const ColorScheme(
    // Dark Blue
    brightness: Brightness.dark,
    primary: Color.fromARGB(255, 223, 229, 231),
    onPrimary: Color.fromARGB(255, 33, 33, 33),
    secondary: Color.fromARGB(255, 141, 145, 150),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    background: Color.fromARGB(255, 0, 0, 0),
    onBackground: Color.fromARGB(255, 214, 222, 224),
    error: Color.fromARGB(255, 206, 53, 73),
    onError: Color.fromARGB(255, 216, 216, 216),
    surface: Color.fromARGB(255, 41, 42, 43),
    onSurface: Color.fromARGB(255, 128, 128, 128),
  ),
};

// map string catppuccin flavors to catppuccin flavors
final Map<String, Flavor> flavorMap = {
  'latte': catppuccin.latte,
  'frappe': catppuccin.frappe,
  'macchiato': catppuccin.macchiato,
  'mocha': catppuccin.mocha,
};

ThemeData catppuccinTheme(Flavor flavor, {required BuildContext context}) {
  Color primaryColor = flavor.lavender;
  Color secondaryColor = flavor.pink;
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
    // floatingActionButtonTheme: const FloatingActionButtonThemeData(
    //   elevation: 0,
    // ),
  );
}

Map<String, Color> getColorMap(Flavor flavor) {
  Map<String, Color> colorMap = {
    "rosewater": flavor.rosewater,
    "flamingo": flavor.flamingo,
    "pink": flavor.pink,
    "mauve": flavor.mauve,
    "red": flavor.red,
    "maroon": flavor.maroon,
    "peach": flavor.peach,
    "yellow": flavor.yellow,
    "green": flavor.green,
    "teal": flavor.teal,
    "sky": flavor.sky,
    "sapphire": flavor.sapphire,
    "blue": flavor.blue,
    "lavender": flavor.lavender,
    "text": flavor.text,
    "subtext1": flavor.subtext1,
    "subtext0": flavor.subtext0,
    "overlay2": flavor.overlay2,
    "overlay1": flavor.overlay1,
    "overlay0": flavor.overlay0,
    "surface2": flavor.surface2,
    "surface1": flavor.surface1,
    "surface0": flavor.surface0,
    "crust": flavor.crust,
    "mantle": flavor.mantle,
    "base": flavor.base,
  };
  return colorMap;
}
