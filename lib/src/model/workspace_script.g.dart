// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_script.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkspaceScript _$WorkspaceScriptFromJson(Map<String, dynamic> json) =>
    WorkspaceScript(
      command: json['command'] as String,
      arguments:
          (json['arguments'] as List<dynamic>).map((e) => e as String).toList(),
      checks:
          json['checks'] == null
              ? const TaskLifecycleChecks()
              : TaskLifecycleChecks.fromJson(
                json['checks'] as Map<String, dynamic>,
              ),
      concurrency: (json['concurrency'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WorkspaceScriptToJson(WorkspaceScript instance) =>
    <String, dynamic>{
      'command': instance.command,
      'arguments': instance.arguments,
      'concurrency': instance.concurrency,
      'checks': instance.checks,
    };
