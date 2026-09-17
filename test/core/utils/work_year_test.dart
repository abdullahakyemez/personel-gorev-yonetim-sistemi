import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/work_year.dart';

void main() {
  group('WorkYearPeriod & workYearForDate Tests', () {
    test('workYearForDate calculates correct period for 1 September', () {
      final period = workYearForDate(DateTime(2026, 9, 1));
      expect(period.start, equals(DateTime(2026, 9, 1)));
      expect(period.end, equals(DateTime(2027, 8, 31)));
    });

    test('workYearForDate calculates correct period for 31 August', () {
      final period = workYearForDate(DateTime(2026, 8, 31));
      expect(period.start, equals(DateTime(2025, 9, 1)));
      expect(period.end, equals(DateTime(2026, 8, 31)));
    });

    test('workYearForDate calculates correct period for mid-year (January)', () {
      final period = workYearForDate(DateTime(2026, 1, 15));
      expect(period.start, equals(DateTime(2025, 9, 1)));
      expect(period.end, equals(DateTime(2026, 8, 31)));
    });

    test('workYearForDate calculates correct period for December', () {
      final period = workYearForDate(DateTime(2025, 12, 31));
      expect(period.start, equals(DateTime(2025, 9, 1)));
      expect(period.end, equals(DateTime(2026, 8, 31)));
    });

    test('WorkYearPeriod.label format is dd.MM.yyyy - dd.MM.yyyy', () {
      final period = WorkYearPeriod(
        start: DateTime(2025, 9, 1),
        end: DateTime(2026, 8, 31),
      );
      expect(period.label, equals('01.09.2025 - 31.08.2026'));
    });

    group('WorkYearPeriod.contains boundaries', () {
      final period = WorkYearPeriod(
        start: DateTime(2025, 9, 1),
        end: DateTime(2026, 8, 31),
      );

      test('contains start date (1 September)', () {
        expect(period.contains(DateTime(2025, 9, 1)), isTrue);
      });

      test('contains end date (31 August)', () {
        expect(period.contains(DateTime(2026, 8, 31)), isTrue);
      });

      test('contains mid-year date with time components', () {
        expect(period.contains(DateTime(2026, 3, 15, 14, 30, 45)), isTrue);
      });

      test('does not contain day before start (31 August previous year)', () {
        expect(period.contains(DateTime(2025, 8, 31)), isFalse);
      });

      test('does not contain day after end (1 September next year)', () {
        expect(period.contains(DateTime(2026, 9, 1)), isFalse);
      });
    });

    group('WorkYearPeriod.overlaps boundary conditions', () {
      final period = WorkYearPeriod(
        start: DateTime(2025, 9, 1),
        end: DateTime(2026, 8, 31),
      );

      test('overlaps when range is completely inside', () {
        expect(
          period.overlaps(DateTime(2025, 10, 1), DateTime(2025, 10, 15)),
          isTrue,
        );
      });

      test('overlaps when range starts before and ends inside', () {
        expect(
          period.overlaps(DateTime(2025, 8, 20), DateTime(2025, 9, 5)),
          isTrue,
        );
      });

      test('overlaps when range starts inside and ends after', () {
        expect(
          period.overlaps(DateTime(2026, 8, 25), DateTime(2026, 9, 10)),
          isTrue,
        );
      });

      test('overlaps when range encloses the entire period', () {
        expect(
          period.overlaps(DateTime(2025, 8, 1), DateTime(2026, 9, 30)),
          isTrue,
        );
      });

      test('overlaps on exact start boundary (ends on 1 September)', () {
        expect(
          period.overlaps(DateTime(2025, 8, 25), DateTime(2025, 9, 1)),
          isTrue,
        );
      });

      test('overlaps on exact end boundary (starts on 31 August)', () {
        expect(
          period.overlaps(DateTime(2026, 8, 31), DateTime(2026, 9, 5)),
          isTrue,
        );
      });

      test('does not overlap when range is completely before', () {
        expect(
          period.overlaps(DateTime(2025, 7, 1), DateTime(2025, 8, 31)),
          isFalse,
        );
      });

      test('does not overlap when range is completely after', () {
        expect(
          period.overlaps(DateTime(2026, 9, 1), DateTime(2026, 9, 30)),
          isFalse,
        );
      });
    });
  });
}
