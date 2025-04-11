import '../../workspace_scripts.dart';

/// Writes the notifications to std out
class StdOutProcessNotifier implements TaskNotifier {
  final int maxTaskNameLength;

  StdOutProcessNotifier(this.maxTaskNameLength);

  @override
  void notify(Task task, String text) {
    final prefix = _getPrefix(task);
    print('$prefix ${text.trim()}');
  }

  String _getPrefix(Task task) =>
      '[${task.name}]'.padRight(maxTaskNameLength + 2, ' ');
}
