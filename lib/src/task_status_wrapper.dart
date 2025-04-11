import 'package:workspace_scripts/src/notifier/task_notifier.dart';
import 'package:workspace_scripts/src/task.dart';
import 'package:workspace_scripts/src/task_lifecycle_hooks.dart';

class TaskStatusWrapper implements TaskNotifier {
  final OnWorkCompleteHook _onWorkCompleteHook;

  final RegExp? _readyPattern;

  TaskStatusWrapper(this._onWorkCompleteHook, {String? onWorkCompletePattern})
    : _readyPattern =
          onWorkCompletePattern != null && onWorkCompletePattern.isNotEmpty
              ? RegExp(onWorkCompletePattern)
              : null;

  @override
  void notify(Task task, String line) {
    if (_readyPattern != null && _readyPattern.hasMatch(line)) {
      _onWorkCompleteHook.onWorkComplete(task);
    }
  }
}
