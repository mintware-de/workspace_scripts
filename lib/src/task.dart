import 'notifier/task_notifier.dart';

/// Represents the base interface for tasks
abstract interface class Task {
  /// Returns the name of the task
  abstract final String name;

  /// Starts the task
  Future<void> run(TaskNotifier notifier);
}
