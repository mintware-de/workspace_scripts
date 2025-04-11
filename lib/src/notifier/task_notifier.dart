import '../task.dart';

/// Describes an object that accepts notifications from a task.
abstract interface class TaskNotifier {
  /// Send a text, for example a line in a terminal, to the notifier.
  void notify(Task task, String text);
}
