import 'dart:io';

import '../../workspace_scripts.dart';

/// Writes the notifications to std out
class StdOutProcessNotifier implements TaskNotifier {
  final int _maxTaskNameLength;

  /// Creates the StdOutProcessNotifier
  StdOutProcessNotifier(this._maxTaskNameLength);

  @override
  void notify(Task task, String text) {
    final prefix = _getPrefix(task);
    stdout.writeln('$prefix ${text.trim()}');
  }

  String _getPrefix(Task task) =>
      '[${task.name}]'.padRight(_maxTaskNameLength + 2, ' ');
}
