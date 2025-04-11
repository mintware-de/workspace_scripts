import 'task.dart';

/// Lifecycle hook for OnWorkComplete
abstract interface class OnWorkCompleteHook {
  /// This method should be called when a task has completed.
  /// Completed is not to be confused with finished as the task could be a watch
  /// task that completes multiple times.
  void onWorkComplete(Task task);
}
