import 'package:flutter_test/flutter_test.dart';
import 'package:lighter/core/contracts.dart';

void main() {
  test('weekly masks select the expected local weekdays', () {
    expect(
      TaskSchedule.includesWeekday(TaskSchedule.everyDay, DateTime.sunday),
      isTrue,
    );
    expect(
      TaskSchedule.includesWeekday(TaskSchedule.workdays, DateTime.friday),
      isTrue,
    );
    expect(
      TaskSchedule.includesWeekday(TaskSchedule.workdays, DateTime.saturday),
      isFalse,
    );
    expect(
      TaskSchedule.includesWeekday(TaskSchedule.weekend, DateTime.saturday),
      isTrue,
    );
    expect(
      TaskSchedule.includesWeekday(TaskSchedule.weekend, DateTime.monday),
      isFalse,
    );
  });

  test('custom weekday masks never depend on locale labels', () {
    var mask = 0;
    mask = TaskSchedule.toggleWeekday(mask, DateTime.tuesday);
    mask = TaskSchedule.toggleWeekday(mask, DateTime.thursday);

    expect(TaskSchedule.includesWeekday(mask, DateTime.tuesday), isTrue);
    expect(TaskSchedule.includesWeekday(mask, DateTime.wednesday), isFalse);
    expect(TaskSchedule.includesWeekday(mask, DateTime.thursday), isTrue);
  });

  test('goal type wire parsing has a safe fallback', () {
    expect(taskGoalTypeFromWire('duration'), TaskGoalType.duration);
    expect(taskGoalTypeFromWire('future_unknown_type'), TaskGoalType.check);
  });
}
