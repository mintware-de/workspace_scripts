import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:workspace_scripts/workspace_scripts.dart';
import 'package:yaml/yaml.dart';

/// Run the tool
Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    arguments = ['list'];
  }
  var command = arguments.first;
  switch (command) {
    case 'run':
      await _run(arguments.sublist(1));
      break;

    default:
      print('Unknown command $command');
  }
}

Future<void> _run(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('missing script name');
    return;
  }

  var config = _loadConfig();
  if (config == null) {
    return;
  }

  var scriptName = arguments.first;
  var script = config.workspaceScripts[scriptName];
  if (script == null) {
    print('script not found');
    return;
  }

  var roots = _getProjectRoots(config);

  final tasks =
      roots.entries
          .map(
            (kvp) => ProcessTask(
              name: kvp.key,
              command: script.command,
              arguments: script.arguments,
              workingDirectory: kvp.value,
            ),
          )
          .toList();

  var maxLength =
      (tasks.map((k) => k.name.length).toList()..sort((a, b) => b - a)).first;

  final scheduler = TaskScheduler(
    StdOutProcessNotifier(maxLength),
    maxConcurrency: script.concurrency,
    onWorkCompletePattern: script.checks.onWorkCompletePattern,
  );
  scheduler.addAll(tasks);

  await scheduler.start();
}

Map<String, String> _getProjectRoots(Config config) {
  var projectRoots = <String, String>{};

  for (var path in config.packages) {
    projectRoots[path] = p.join(p.current, path);
  }

  return projectRoots;
}

Config? _loadConfig() {
  var pubspec = File(p.join(p.current, 'pubspec.yaml'));
  if (!pubspec.existsSync()) {
    print('No pubspec.yaml');
    return null;
  }
  var content = loadYaml(pubspec.readAsStringSync());
  var map = jsonDecode(jsonEncode(content)) as Map<String, dynamic>;
  if (!map.containsKey('workspace')) {
    print('No workspace pubspec.yaml');
    return null;
  }

  if (!map.containsKey('workspace_scripts')) {
    print('No workspace scripts found.');
    return null;
  }

  return Config.fromJson(map);
}
