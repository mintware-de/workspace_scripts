import '../../workspace_scripts.dart';

/// A notifier that supports using multiple notifiers
class AggregateNotifierWithHooks implements TaskNotifier, OnWorkCompleteHook {
  final List<Object> _notifiers;

  /// Creates a new AggregateNotifierWithHooks
  const AggregateNotifierWithHooks(this._notifiers);

  @override
  void notify(Task task, String text) {
    for (var notifier in _notifiers.whereType<TaskNotifier>()) {
      notifier.notify(task, text);
    }
  }

  @override
  void onWorkComplete(Task task) {
    for (var notifier in _notifiers.whereType<OnWorkCompleteHook>()) {
      notifier.onWorkComplete(task);
    }
  }
}
