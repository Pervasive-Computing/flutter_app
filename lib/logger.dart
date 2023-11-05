import 'package:logger/logger.dart';

// LEVELS
// 1. verbose
// 2. debug
// 3. info
// 4. warning
// 5. error
// 6. wtf
// 7. nothing

final l = Logger(
  printer: PrettyPrinter(
    methodCount: 1, // Number of method calls to be displayed
    errorMethodCount: 8, // Number of method calls if stacktrace is provided
    lineLength: 120, // Width of the output
    colors: true, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
    printTime: false, // Should each log print contain a timestamp
    noBoxingByDefault: true,
  ),
  level: Level.verbose,
);
