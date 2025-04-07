import 'package:json_annotation/json_annotation.dart';

part 'workspace_script.g.dart';

/// This file represents a single workspace script
@JsonSerializable()
class WorkspaceScript {
  final String command;
  final List<String> arguments;

  /// Creates a new workspace script
  WorkspaceScript({required this.command, required this.arguments});

  /// Creates a new workspace script from json
  factory WorkspaceScript.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceScriptFromJson(json);

  /// Serialize the workspace script as a map
  Map<String, dynamic> toJson() => _$WorkspaceScriptToJson(this);
}
