import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
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

  var yamlContent = _loadPubspec();
  if (yamlContent == null) {
    return;
  }

  var scriptName = arguments.first;
  var script = _getScript(yamlContent, scriptName);
  if (script == null) {
    print('script not found');
    return;
  }
  var roots = _getProjectRoots(yamlContent);

  var command = script['command'];
  var args = (script['arguments'] as List).cast<String>();

  var maxLength =
      (roots.keys.map((k) => k.length).toList()..sort((a, b) => b - a)).first;
  await Future.wait(
    roots.entries.map((kvp) async {
      var proc = await Process.start(
        command,
        args,
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

Map<String, String> _getProjectRoots(Map<String, dynamic> yamlContent) {
  var projectRoots = <String, String>{};

  for (var path in (yamlContent['workspace'] as List).cast<String>()) {
    projectRoots[path] = p.join(p.current, path);
  }

  return projectRoots;
}

Map<String, dynamic> _getScripts(Map<String, dynamic> yamlContent) {
  return yamlContent['workspace_scripts'] as Map<String, dynamic>;
}

Map<String, dynamic>? _getScript(
  Map<String, dynamic> yamlContent,
  String script,
) {
  final scripts = _getScripts(yamlContent);
  if (!scripts.containsKey(script)) {
    return null;
  }
  return scripts[script];
}

Map<String, dynamic>? _loadPubspec() {
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
  return map;
}
