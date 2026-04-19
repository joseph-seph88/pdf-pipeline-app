import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  level: kDebugMode ? Level.all : Level.warning,
  filter: kDebugMode ? DevelopmentFilter() : ProductionFilter(),
  output: ConsoleOutput(),
  printer: PrettyPrinter(
    stackTraceBeginIndex: 1,
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: false,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
);
