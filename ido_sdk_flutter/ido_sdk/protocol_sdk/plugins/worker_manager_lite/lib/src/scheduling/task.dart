import 'dart:async';
import 'runnable.dart';

enum WorkPriority { immediately, veryHigh, high, highRegular, regular, almostLow, low }

class Task<A, B, C, D, O, T> implements Comparable<Task<A, B, C, D, O, T>> {
  final Runnable<A, B, C, D, O, T> runnable;
  final resultCompleter = Completer<O>();
  final int number;
  final WorkPriority workPriority;
  final Function? onUpdateProgress;
  final O Function([bool? stop])? onDispose;

  Task(
      this.number, {
        required this.runnable,
        this.workPriority = WorkPriority.high,
        this.onUpdateProgress,
        this.onDispose
      });

  @override
  int compareTo(Task other) {
    if (other.number == number) {
      return 0;
    }
    if (workPriority.index == other.workPriority.index) {
      return number < other.number ? -1 : 1;
    }
    final index = WorkPriority.values.indexOf;
    return index(workPriority) - index(other.workPriority);
  }

  @override
  bool operator ==(covariant Task other) {
    return other.number == number;
  }

  @override
  int get hashCode => number;
}
