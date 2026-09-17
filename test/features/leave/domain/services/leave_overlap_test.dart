import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/services/leave_overlap.dart';

void main() {
  group('Leave & LeaveOverlap Tests', () {
    group('Leave.dayCount calculations', () {
      test('Single day leave (start == end) returns 1 day', () {
        final leave = Leave(
          id: 'test-1',
          personnelId: 100001,
          startDate: DateTime(2026, 5, 10),
          endDate: DateTime(2026, 5, 10),
          type: LeaveType.annual,
          description: '1 Günlük İzin',
        );
        expect(leave.dayCount, equals(1));
      });

      test('Multi-day leave (inclusive days) calculation', () {
        final leave = Leave(
          id: 'test-2',
          personnelId: 100001,
          startDate: DateTime(2026, 5, 10),
          endDate: DateTime(2026, 5, 14),
          type: LeaveType.annual,
          description: '5 Günlük İzin',
        );
        expect(leave.dayCount, equals(5));
      });

      test('Date with hour/minute differences calculates full calendar days', () {
        final leave = Leave(
          id: 'test-3',
          personnelId: 100001,
          startDate: DateTime(2026, 5, 10, 15, 30),
          endDate: DateTime(2026, 5, 11, 8, 45),
          type: LeaveType.excuse,
          description: 'Saat farkı olan izin',
        );
        expect(leave.dayCount, equals(2));
      });
    });

    group('LeaveOverlap.rangesOverlap boundary tests', () {
      test('Identical date ranges overlap', () {
        expect(
          LeaveOverlap.rangesOverlap(
            DateTime(2026, 5, 10),
            DateTime(2026, 5, 15),
            DateTime(2026, 5, 10),
            DateTime(2026, 5, 15),
          ),
          isTrue,
        );
      });

      test('Partial overlap', () {
        expect(
          LeaveOverlap.rangesOverlap(
            DateTime(2026, 5, 10),
            DateTime(2026, 5, 15),
            DateTime(2026, 5, 12),
            DateTime(2026, 5, 20),
          ),
          isTrue,
        );
      });

      test('Boundary touch (same day end and start) overlaps', () {
        expect(
          LeaveOverlap.rangesOverlap(
            DateTime(2026, 5, 10),
            DateTime(2026, 5, 15),
            DateTime(2026, 5, 15),
            DateTime(2026, 5, 20),
          ),
          isTrue,
        );
      });

      test('Adjacent consecutive days do NOT overlap', () {
        expect(
          LeaveOverlap.rangesOverlap(
            DateTime(2026, 5, 10),
            DateTime(2026, 5, 14),
            DateTime(2026, 5, 15),
            DateTime(2026, 5, 20),
          ),
          isFalse,
        );
      });

      test('Completely disjoint dates do NOT overlap', () {
        expect(
          LeaveOverlap.rangesOverlap(
            DateTime(2026, 5, 1),
            DateTime(2026, 5, 5),
            DateTime(2026, 5, 20),
            DateTime(2026, 5, 25),
          ),
          isFalse,
        );
      });

      test('Ignores hour/minute differences in range comparison', () {
        expect(
          LeaveOverlap.rangesOverlap(
            DateTime(2026, 5, 10, 23, 59),
            DateTime(2026, 5, 15, 8, 0),
            DateTime(2026, 5, 15, 22, 0),
            DateTime(2026, 5, 20, 1, 0),
          ),
          isTrue,
        );
      });
    });

    group('LeaveOverlap.findConflict with synthetic data', () {
      final leaves = [
        Leave(
          id: 'leave-1',
          personnelId: 100001,
          startDate: DateTime(2026, 6, 1),
          endDate: DateTime(2026, 6, 10),
          type: LeaveType.annual,
          description: 'Yıllık İzin',
        ),
        Leave(
          id: 'leave-2',
          personnelId: 100002,
          startDate: DateTime(2026, 6, 5),
          endDate: DateTime(2026, 6, 15),
          type: LeaveType.report,
          description: 'Rapor',
        ),
      ];

      test('Finds conflict for matching personnel with overlapping dates', () {
        final conflict = LeaveOverlap.findConflict(
          leaves: leaves,
          personnelId: 100001,
          startDate: DateTime(2026, 6, 8),
          endDate: DateTime(2026, 6, 12),
        );
        expect(conflict, isNotNull);
        expect(conflict?.id, equals('leave-1'));
      });

      test('No conflict when dates do not overlap for same personnel', () {
        final conflict = LeaveOverlap.findConflict(
          leaves: leaves,
          personnelId: 100001,
          startDate: DateTime(2026, 6, 15),
          endDate: DateTime(2026, 6, 20),
        );
        expect(conflict, isNull);
      });

      test('No conflict when dates overlap with different personnel', () {
        final conflict = LeaveOverlap.findConflict(
          leaves: leaves,
          personnelId: 100003,
          startDate: DateTime(2026, 6, 2),
          endDate: DateTime(2026, 6, 8),
        );
        expect(conflict, isNull);
      });

      test('Ignores self when excludeId is provided (edit flow)', () {
        final conflict = LeaveOverlap.findConflict(
          leaves: leaves,
          personnelId: 100001,
          startDate: DateTime(2026, 6, 1),
          endDate: DateTime(2026, 6, 10),
          excludeId: 'leave-1',
        );
        expect(conflict, isNull);
      });
    });
  });
}
