import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:workspace_scripts/workspace_scripts.dart';

import 'mocks.mocks.dart';

class _DemoTask implements Task {
  final Future<void> isDone;

  @override
  final String name = 'Demo';

  _DemoTask(this.isDone);

  @override
  Future<void> run(TaskNotifier notifier) async {
    notifier.notify(this, 'Compilation started');
    await isDone;
    notifier.notify(this, 'Compilation done');
  }
}

void main() {
  test('calls on work complete', () async {
    var originalNotifier = MockOnWorkCompleteHook();
    final notifier = TaskStatusWrapper(
      originalNotifier,
      onWorkCompletePattern: "Compilation done",
    );
    expect(notifier, TypeMatcher<TaskNotifier>());

    var completer = Completer<void>();

    final task = _DemoTask(completer.future);

    task.run(notifier);
    await Future.delayed(Duration(milliseconds: 100));
    verifyNever(originalNotifier.onWorkComplete(task));

    completer.complete();
    await Future.delayed(Duration(milliseconds: 100));
    verify(originalNotifier.onWorkComplete(task));
  });
}
