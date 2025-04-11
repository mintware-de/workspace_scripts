import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:workspace_scripts/src/model/task_lifecycle_checks.dart';

part 'workspace_script.g.dart';

/// This file represents a single workspace script
@JsonSerializable()
class WorkspaceScript {
  /// The command to execute
  /// For example "flutter"
  final String command;

  /// The list of arguments for the command
  /// For example ["pub", "get"]
  final List<String> arguments;

  /// The maximum concurrency for processing the tasks
  /// concurrency = 0 means no limit.
  ///
  /// The default value is the number of processors.
  final int concurrency;

  final TaskLifecycleChecks checks;

  /// Creates a new workspace script
  WorkspaceScript({
    required this.command,
    required this.arguments,
    this.checks = const TaskLifecycleChecks(),
    int? concurrency,
  }) : concurrency = concurrency ?? Platform.numberOfProcessors;

  /// Creates a new workspace script from json
  factory WorkspaceScript.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceScriptFromJson(json);

  /// Serialize the workspace script as a map
  Map<String, dynamic> toJson() => _$WorkspaceScriptToJson(this);
}
