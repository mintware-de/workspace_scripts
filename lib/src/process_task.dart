import 'dart:convert';
import 'dart:io';

import 'notifier/task_notifier.dart';
import 'task.dart';

/// This implementation is used for running processes
class ProcessTask implements Task {
  @override
  final String name;

  /// The command to execute.
  final String command;

  /// The list of arguments to pass to the [command]
  final List<String> arguments;

  /// The working directory where the command should be executed.
  final String? workingDirectory;

  /// Creates a new ProcessTask to execute
  ProcessTask({
    required this.name,
    required this.command,
    required this.arguments,
    this.workingDirectory,
  });

  @override
  Future<void> run(TaskNotifier notifier) async {
    var proc = await Process.start(
      command,
      arguments,
      workingDirectory: workingDirectory,
      mode: ProcessStartMode.normal,
      includeParentEnvironment: true,
      runInShell: true,
    );

    proc.stdout
        .transform(utf8.decoder)
        .forEach(
          (l) => l
              .split(Platform.lineTerminator)
              .where((l) => l.isNotEmpty)
              .forEach((x) => notifier.notify(this, x.trim())),
        );

    await proc.exitCode;
  }
}
