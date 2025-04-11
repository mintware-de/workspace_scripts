import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:workspace_scripts/workspace_scripts.dart';

import 'mocks.mocks.dart';

void main() {
  late ProcessTask task;

  setUp(() {
    task = ProcessTask(
      name: 'test',
      command: 'bash',
      arguments: ['-c', 'for i in {1..2}; do echo \$i; sleep 1; done'],
    );
  });
  test('Exists', () {
    expect(task, TypeMatcher<Task>());
  });

  test('Run', () async {
    final mockNotifier = MockTaskNotifier();
    final startTime = DateTime.now();
    await task.run(mockNotifier);
    verifyInOrder([
      mockNotifier.notify(task, "1"),
      mockNotifier.notify(task, "2"),
    ]);
    expect(
      (DateTime.now().difference(startTime)).inSeconds,
      greaterThanOrEqualTo(2),
    );
  });
}
