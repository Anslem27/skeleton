import 'package:hive_ce_flutter/adapters.dart';
import 'package:logger/logger.dart';

import 'models/log.dart';

/// Global [Logger] instance for Kity Pay App.
final logger = LogService.logger;

abstract class LogService {
  LogService._();

  static const String _boxName = 'logs';
  static Box<LogEntry>? _box;
  static Logger? _logger;

  static Future<void> initialize() async {
    await Hive.initFlutter();

    _box = await Hive.openBox<LogEntry>(_boxName);
  }

  static void setupLogger({
    LogFilter? filter,
    LogPrinter? printer,
    LogOutput? output,
    Level? level,
  }) {
    _logger = Logger(
      filter: filter,
      printer: printer,
      output: output,
      level: level,
    );

    // Add listener to capture all log events
    Logger.addLogListener((logEvent) {
      _storeLogEvent(logEvent);
    });
  }

  static Logger get logger {
    if (_logger == null) {
      setupLogger();
    }
    return _logger!;
  }

  static void _storeLogEvent(dynamic logEvent) {
    if (_box != null) {
      final entry = LogEntry.fromLogEvent(logEvent);
      _box!.add(entry);
    }
  }

  static List<LogEntry> getAllLogs() {
    return _box?.values.toList() ?? [];
  }

  static List<LogEntry> getLogsByLevel(String level) {
    return _box?.values.where((log) => log.level == level).toList() ?? [];
  }

  static List<LogEntry> getLogsByDateRange(DateTime start, DateTime end) {
    return _box?.values
            .where(
              (log) =>
                  log.timestamp.isAfter(start) && log.timestamp.isBefore(end),
            )
            .toList() ??
        [];
  }

  static Future<void> clearAllLogs() async {
    await _box?.clear();
  }

  static Future<void> clearLogsByLevel(String level) async {
    if (_box != null) {
      final keysToDelete = <dynamic>[];
      for (var i = 0; i < _box!.length; i++) {
        final log = _box!.getAt(i);
        if (log?.level == level) {
          keysToDelete.add(_box!.keyAt(i));
        }
      }
      await _box!.deleteAll(keysToDelete);
    }
  }

  static Future<void> deleteLog(LogEntry log) async {
    await log.delete();
  }

  static int get logCount => _box?.length ?? 0;

  static Future<void> close() async {
    await _box?.close();
  }
}
