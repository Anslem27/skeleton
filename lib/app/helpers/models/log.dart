import 'package:hive_ce_flutter/adapters.dart';

// part 'log.g.dart';

class LogEntry extends HiveObject {
  late String level;

  late String message;

  late DateTime timestamp;

  String? error;

  String? stackTrace;

  LogEntry({
    required this.level,
    required this.message,
    required this.timestamp,
    this.error,
    this.stackTrace,
  });

  LogEntry.fromLogEvent(dynamic logEvent) {
    level = logEvent.level.toString().split('.').last;
    message = logEvent.message.toString();
    timestamp = logEvent.time ?? DateTime.now();
    error = logEvent.error?.toString();
    stackTrace = logEvent.stackTrace?.toString();
  }
}
