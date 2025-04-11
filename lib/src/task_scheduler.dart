import 'dart:async';

import 'package:workspace_scripts/src/notifier/aggregate_notifier.dart';
import 'package:workspace_scripts/src/notifier/task_notifier.dart';
import 'package:workspace_scripts/src/task_lifecycle_hooks.dart';
import 'package:workspace_scripts/src/task_status_wrapper.dart';

import 'task.dart';

/// The task scheduler is used to schedule task.
/// Its the heart of the concurrency features in the package
class TaskScheduler implements OnWorkCompleteHook {
  final _tasks = <Task>[];

  int get length => _tasks.length;
  final int _maxConcurrency;

  final _runningTasks = <Future>[];

  final _incompleteTasks = <Task, Completer<void>>{};

  int get _numberOfIncompleteTasks => _incompleteTasks.length;

  late final TaskNotifier _notifier;

  /// Creates a [TaskScheduler].
  ///
  /// [notifier] is used to notify about task updates and other events.
  /// [maxConcurrency] specifies the maximum number of tasks that can run
  /// concurrently. 0 means no limit.
  /// [onWorkCompletePattern] is an optional pattern used by the
  /// [TaskStatusWrapper] to filter tasks or handle specific cases when tasks
  /// are completed.
  ///
  /// The constructor initializes an [_AggregateNotifierWithHooks] that combines the
  /// [TaskStatusWrapper] and the provided [notifier] to handle task lifecycle events.
  TaskScheduler(
    TaskNotifier notifier, {
    required int maxConcurrency,
    String? onWorkCompletePattern,
  }) : _maxConcurrency = maxConcurrency {
    _notifier = AggregateNotifierWithHooks([
      TaskStatusWrapper(this, onWorkCompletePattern: onWorkCompletePattern),
      notifier,
    ]);
  }

  /// Adds multiple tasks to the scheduler.
  void addAll(List<Task> tasks) {
    _tasks.addAll(tasks);
  }

  /// Start processing the tasks
  Future<void> start() async {
    for (var task in _tasks) {
      _startTask(task);
      await _checkMaxConcurrency();
    }

    await Future.wait(_runningTasks);
  }

  void _startTask(Task task) {
    _notifier.notify(task, 'Starting task.');

    _incompleteTasks[task] = Completer();
    var runningTask = task.run(_notifier).then((_) => onWorkComplete(task));
    _runningTasks.add(runningTask);
  }

  Future<void> _checkMaxConcurrency() async {
    if (_numberOfIncompleteTasks == _maxConcurrency) {
      await Future.any(_incompleteTasks.values.map((x) => x.future));
      _incompleteTasks.removeWhere((k, v) => v.isCompleted);
    }
  }

  @override
  void onWorkComplete(Task task) {
    if (_incompleteTasks[task]?.isCompleted == false) {
      _notifier.notify(task, 'Task completed.');
      _incompleteTasks[task]!.complete();
    }
  }
}
