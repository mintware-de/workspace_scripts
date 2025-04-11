import 'package:json_annotation/json_annotation.dart';

part 'task_lifecycle_checks.g.dart';

@JsonSerializable()
class TaskLifecycleChecks {
  /// Pass a RegExp pattern that matches the output on a long running task if
  /// the task has completed its work.
  ///
  /// It's used to handle concurrency correctly.
  @JsonKey(name: 'on_work_complete_pattern')
  final String? onWorkCompletePattern;

  /// Creates a new TaskLifecycleChecks object
  const TaskLifecycleChecks({this.onWorkCompletePattern = ''});

  /// Creates a new checks object from json
  factory TaskLifecycleChecks.fromJson(Map<String, dynamic> json) =>
      _$TaskLifecycleChecksFromJson(json);

  /// Serialize the checks object as a map
  Map<String, dynamic> toJson() => _$TaskLifecycleChecksToJson(this);
}
