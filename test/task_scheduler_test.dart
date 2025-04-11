import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:workspace_scripts/workspace_scripts.dart';

import 'mocks.mocks.dart';

class _DemoTask implements Task {
  @override
  final String name;

  final Future<void>? blocker;

  _DemoTask(this.name, [this.blocker]);

  @override
  Future<void> run(TaskNotifier notifier) async {
    notifier.notify(this, name);
    if (blocker != null) {
      await blocker;
    }
  }
}

void main() {
  late TaskScheduler scheduler;
  late MockTaskNotifier notifier;

  setUp(() {
    notifier = MockTaskNotifier();
    scheduler = TaskScheduler(notifier, maxConcurrency: 2);
  });

  test('addAll adds multiple tasks to the scheduler', () {
    final task1 = _DemoTask('1');
    final task2 = _DemoTask('2');
    scheduler.addAll([task1, task2]);
    expect(scheduler.length, equals(2));
  });

  test('start starts the processing', () async {
    final task1 = _DemoTask('1');
    final task2 = _DemoTask('2');
    scheduler.addAll([task1, task2]);
    await scheduler.start();

    verifyInOrder([notifier.notify(task1, '1'), notifier.notify(task2, '2')]);
  });

  test('exceeding concurrency / test freeing', () async {
    final blocker1 = Completer();
    final blocker2 = Completer();

    final timings = <DateTime>[];
    when(notifier.notify(any, any)).thenAnswer((invocation) {
      timings.add(DateTime.now());
    });

    final task1 = _DemoTask('1', blocker1.future);
    final task2 = _DemoTask('2', blocker2.future);
    final task3 = _DemoTask('3');
    scheduler.addAll([task1, task2, task3]);
    final schedulerFuture = scheduler.start();
    await Future.delayed(Duration(seconds: 2));
    blocker1.complete();
    blocker2.complete();

    await schedulerFuture;

    verifyInOrder([
      notifier.notify(task1, '1'),
      notifier.notify(task2, '2'),
      notifier.notify(task3, '3'),
    ]);

    expect(
      timings.last.difference(timings.first).inSeconds,
      greaterThanOrEqualTo(2),
    );
  });
}
