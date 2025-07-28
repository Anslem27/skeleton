import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/constants.dart';
import '../helpers/logger.dart';
import '../helpers/models/log.dart';
import 'dart:convert';

class AppLogs extends StatefulWidget {
  const AppLogs({super.key});

  @override
  State<AppLogs> createState() => _AppLogsState();
}

class _AppLogsState extends State<AppLogs> {
  List<LogEntry> _logs = [];
  String _selectedLevel = 'All';
  final List<String> _levels = [
    'All',
    'trace',
    'debug',
    'info',
    'warning',
    'error',
    'fatal',
  ];
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  void _loadLogs() {
    setState(() {
      if (_selectedLevel == 'All') {
        _logs = LogService.getAllLogs();
      } else {
        _logs = LogService.getLogsByLevel(_selectedLevel);
      }

      // Apply date filter if set
      if (_startDate != null && _endDate != null) {
        _logs = _logs
            .where(
              (log) =>
                  log.timestamp.isAfter(_startDate!) &&
                  log.timestamp.isBefore(_endDate!.add(Duration(days: 1))),
            )
            .toList();
      }

      // Sort by timestamp (newest first)
      _logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'trace':
        return Colors.grey;
      case 'debug':
        return Colors.blue;
      case 'info':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'error':
        return Colors.red;
      case 'fatal':
        return Colors.purple;
      default:
        return Colors.black;
    }
  }

  Future<void> _clearLogs() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Logs'),
        content: Text(
          _selectedLevel == 'All'
              ? 'Are you sure you want to clear all logs?'
              : 'Are you sure you want to clear all $_selectedLevel logs?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (_selectedLevel == 'All') {
        await LogService.clearAllLogs();
      } else {
        await LogService.clearLogsByLevel(_selectedLevel);
      }
      _loadLogs();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logs cleared successfully")),
        );
      }
    }
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadLogs();
    }
  }

  void _clearDateFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
    _loadLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${Constants.appName} logs'),
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _loadLogs)],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        borderRadius: BorderRadius.circular(8),
                        dropdownColor: Theme.of(context).cardColor,
                        value: _selectedLevel,
                        decoration: InputDecoration(
                          labelText: 'Log Level',
                          border: OutlineInputBorder(),
                        ),
                        items: _levels.map((level) {
                          return DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLevel = value!;
                          });
                          _loadLogs();
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _clearLogs,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Clear Logs'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _selectDateRange,
                        child: Container(
                          height: 48,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context)
                                    .elevatedButtonTheme
                                    .style
                                    ?.backgroundColor
                                    ?.resolve({}) ??
                                Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.date_range,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _startDate != null && _endDate != null
                                      ? '${DateFormat('MMM dd').format(_startDate!)} - ${DateFormat('MMM dd').format(_endDate!)}'
                                      : 'Select Date Range',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_startDate != null) ...[
                      SizedBox(width: 8),
                      IconButton(
                        onPressed: _clearDateFilter,
                        icon: Icon(Icons.clear),
                        tooltip: 'Clear date filter',
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Logs: ${_logs.length}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  'Storage: ${LogService.logCount} entries',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: _logs.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No logs found',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            'Logs will appear here when your app generates them',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      final log = _logs[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        color: Theme.of(context).cardColor,
                        child: ExpansionTile(
                          leading: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getLevelColor(log.level),
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Text(
                            log.message,
                            maxLines: 2,
                            style: TextStyle(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${log.level.toUpperCase()} • ${DateFormat('MMM dd, HH:mm:ss').format(log.timestamp)}',
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red[900],
                            ),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Log'),
                                  content: Text(
                                    'Are you sure you want to delete this log entry?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed == true) {
                                await LogService.deleteLog(log);
                                _loadLogs();
                              }
                            },
                          ),

                          children: [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Message:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Try to decode as JSON, else show as plain text
                                  () {
                                    try {
                                      final decoded = log.message.trim();
                                      if ((decoded.startsWith('{') &&
                                              decoded.endsWith('}')) ||
                                          (decoded.startsWith('[') &&
                                              decoded.endsWith(']'))) {
                                        final json = log.message;

                                        final prettyJson =
                                            const JsonEncoder.withIndent(
                                              '  ',
                                            ).convert(jsonDecode(json));
                                        return Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            prettyJson,
                                            style: TextStyle(
                                              fontFamily: 'monospace',
                                              fontSize: 11,
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (_) {}
                                    return Text(
                                      log.message,
                                      style: TextStyle(fontSize: 11),
                                    );
                                  }(),
                                  SizedBox(height: 8),
                                  Text(
                                    'Timestamp:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    DateFormat(
                                      'yyyy-MM-dd HH:mm:ss.SSS',
                                    ).format(log.timestamp),
                                  ),
                                  if (log.error != null) ...[
                                    SizedBox(height: 8),
                                    Text(
                                      'Error:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Text(
                                      log.error!,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                  if (log.stackTrace != null) ...[
                                    SizedBox(height: 8),
                                    Text(
                                      'Stack Trace:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        log.stackTrace!,
                                        style: TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
