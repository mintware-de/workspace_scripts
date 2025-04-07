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
  var maxLength =
      (roots.keys.map((k) => k.length).toList()..sort((a, b) => b - a)).first;
  await Future.wait(
    roots.entries.map((kvp) async {
      var proc = await Process.start(
        script.command,
        script.arguments,
        workingDirectory: kvp.value,
        mode: ProcessStartMode.detachedWithStdio,
        includeParentEnvironment: true,
        runInShell: true,
      );
      final prefix = '[${kvp.key}]'.padRight(maxLength + 2, ' ');
      proc.stdout
          .transform(utf8.decoder)
          .forEach(
            (l) => l
                .split(Platform.pathSeparator)
                .forEach((x) => print('$prefix ${x.trim()}')),
          );

      return proc;
    }),
  );
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
