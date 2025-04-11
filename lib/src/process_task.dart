import 'dart:convert';
import 'dart:io';

import 'task.dart';
import 'notifier/task_notifier.dart';

class ProcessTask implements Task {
  final String command;
  final List<String> arguments;
  final String? workingDirectory;

  @override
  final String name;

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
