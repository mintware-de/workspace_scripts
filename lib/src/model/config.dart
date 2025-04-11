import 'package:json_annotation/json_annotation.dart';

import 'workspace_script.dart';

part 'config.g.dart';

/// This class represents the configuration.
/// The intended use case is loading the pubspec.yaml and convert it to a map
/// and call Config.fromJson
@JsonSerializable()
class Config {
  @JsonKey(name: 'workspace')
  final List<String> packages;

  @JsonKey(name: 'workspace_scripts')
  final Map<String, WorkspaceScript> workspaceScripts;

  /// Creates a new config
  Config({required this.packages, required this.workspaceScripts});

  /// Creates a new config from json
  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  /// Serialize the workspace script as a map
  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
