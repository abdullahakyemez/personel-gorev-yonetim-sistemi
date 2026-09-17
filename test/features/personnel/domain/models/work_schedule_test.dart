import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/work_schedule.dart';

void main() {
  group('WorkSchedule Tests', () {
    test('cycleLength and label calculations', () {
      final schedule = WorkSchedule(
        type: WorkScheduleType.twoPlusOne,
        dutyDays: 2,
        restDays: 1,
        startDate: DateTime(2026, 1, 1),
      );
      expect(schedule.cycleLength, equals(3));
      expect(schedule.label, equals('2+1'));
    });

    group('2+1 Work Schedule cycle behavior', () {
      final schedule = WorkSchedule(
        type: WorkScheduleType.twoPlusOne,
        dutyDays: 2,
        restDays: 1,
        startDate: DateTime(2026, 1, 1),
      );

      test('Day 0 (Start Date) is Duty Day', () {
        expect(schedule.isDutyDay(DateTime(2026, 1, 1)), isTrue);
        expect(schedule.isRestDay(DateTime(2026, 1, 1)), isFalse);
      });

      test('Day 1 is Duty Day', () {
        expect(schedule.isDutyDay(DateTime(2026, 1, 2)), isTrue);
        expect(schedule.isRestDay(DateTime(2026, 1, 2)), isFalse);
      });

      test('Day 2 is Rest Day', () {
        expect(schedule.isDutyDay(DateTime(2026, 1, 3)), isFalse);
        expect(schedule.isRestDay(DateTime(2026, 1, 3)), isTrue);
      });

      test('Day 3 (Next cycle start) is Duty Day', () {
        expect(schedule.isDutyDay(DateTime(2026, 1, 4)), isTrue);
        expect(schedule.isRestDay(DateTime(2026, 1, 4)), isFalse);
      });

      test('Date before schedule start is neither Duty nor Rest Day', () {
        expect(schedule.isDutyDay(DateTime(2025, 12, 31)), isFalse);
        expect(schedule.isRestDay(DateTime(2025, 12, 31)), isFalse);
      });

      test('Ignores hours/minutes component on date parameter', () {
        expect(schedule.isDutyDay(DateTime(2026, 1, 1, 23, 59, 59)), isTrue);
        expect(schedule.isRestDay(DateTime(2026, 1, 3, 14, 30, 0)), isTrue);
      });
    });

    group('5+2 Work Schedule cycle behavior', () {
      final schedule = WorkSchedule(
        type: WorkScheduleType.fivePlusTwo,
        dutyDays: 5,
        restDays: 2,
        startDate: DateTime(2026, 1, 5), // Monday
      );

      test('Days 0..4 are Duty Days', () {
        for (int i = 0; i < 5; i++) {
          final date = DateTime(2026, 1, 5 + i);
          expect(schedule.isDutyDay(date), isTrue, reason: 'Day $i should be duty');
          expect(schedule.isRestDay(date), isFalse);
        }
      });

      test('Days 5 and 6 are Rest Days', () {
        expect(schedule.isDutyDay(DateTime(2026, 1, 10)), isFalse);
        expect(schedule.isRestDay(DateTime(2026, 1, 10)), isTrue);

        expect(schedule.isDutyDay(DateTime(2026, 1, 11)), isFalse);
        expect(schedule.isRestDay(DateTime(2026, 1, 11)), isTrue);
      });

      test('Day 7 (Next cycle start) is Duty Day', () {
        expect(schedule.isDutyDay(DateTime(2026, 1, 12)), isTrue);
        expect(schedule.isRestDay(DateTime(2026, 1, 12)), isFalse);
      });
    });

    test('Zero cycle length does not throw division by zero', () {
      final invalidSchedule = WorkSchedule(
        type: WorkScheduleType.custom,
        dutyDays: 0,
        restDays: 0,
        startDate: DateTime(2026, 1, 1),
      );
      expect(invalidSchedule.isDutyDay(DateTime(2026, 1, 1)), isFalse);
      expect(invalidSchedule.isRestDay(DateTime(2026, 1, 1)), isTrue);
    });
  });
}
