import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final defaultLogger = !kDebugMode
    ? Logger(
        filter: ProductionFilter(),
        level: Level.info,
        // Firebase Crashlytics only supports Android, iOS, MacOS
        printer: Platform.isAndroid || Platform.isIOS || Platform.isMacOS
            ? ZhscLogCrashlyticsPrinter()
            : null,
      )
    : Logger(
        filter: DevelopmentFilter(),
        level: Level.debug,
        printer: SimplePrinter(printTime: true, colors: true),
      );

var logger = defaultLogger;

/// Printer to save log to Crashlytics
///
/// Note: we use Printer but not Output class because we want to log `error`, `stacktrace` to Crashlytics
/// Those information we can not get in Output class
class ZhscLogCrashlyticsPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    // TODO: log to Firebase Crashlytics

    return const [];
  }
}
