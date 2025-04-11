// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) => Config(
  packages:
      (json['workspace'] as List<dynamic>).map((e) => e as String).toList(),
  workspaceScripts: (json['workspace_scripts'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, WorkspaceScript.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
  'workspace': instance.packages,
  'workspace_scripts': instance.workspaceScripts,
};
