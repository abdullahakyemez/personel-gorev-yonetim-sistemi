import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/features/reports/presentation/widgets/report_date_filter.dart';

void main() {
  Widget buildTestWidget({
    DateTime? startDate,
    DateTime? endDate,
    VoidCallback? onStartDateTap,
    VoidCallback? onEndDateTap,
    VoidCallback? onClear,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ReportDateFilter(
            startDate: startDate,
            endDate: endDate,
            onStartDateTap: onStartDateTap ?? () {},
            onEndDateTap: onEndDateTap ?? () {},
            onClear: onClear ?? () {},
          ),
        ),
      ),
    );
  }

  group('ReportDateFilter Widget Tests', () {
    testWidgets('displays formatted dates correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          startDate: DateTime(2025, 9, 1),
          endDate: DateTime(2026, 8, 31),
        ),
      );

      expect(find.text('01.09.2025'), findsOneWidget);
      expect(find.text('31.08.2026'), findsOneWidget);
    });

    testWidgets('displays empty fields when dates are null', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          startDate: null,
          endDate: null,
        ),
      );

      expect(find.text('Başlangıç tarihi'), findsOneWidget);
      expect(find.text('Bitiş tarihi'), findsOneWidget);
    });

    testWidgets('triggers callbacks on tap and clear', (tester) async {
      var startTapped = false;
      var endTapped = false;
      var clearTapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          startDate: DateTime(2025, 9, 1),
          endDate: DateTime(2026, 8, 31),
          onStartDateTap: () => startTapped = true,
          onEndDateTap: () => endTapped = true,
          onClear: () => clearTapped = true,
        ),
      );

      await tester.tap(find.text('01.09.2025'));
      expect(startTapped, isTrue);

      await tester.tap(find.text('31.08.2026'));
      expect(endTapped, isTrue);

      await tester.tap(find.byIcon(Icons.filter_alt_off));
      expect(clearTapped, isTrue);
    });

    testWidgets('updates controller text when dates change in parent rebuild', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          startDate: DateTime(2025, 9, 1),
          endDate: DateTime(2026, 8, 31),
        ),
      );

      expect(find.text('01.09.2025'), findsOneWidget);

      await tester.pumpWidget(
        buildTestWidget(
          startDate: DateTime(2026, 1, 15),
          endDate: DateTime(2026, 6, 30),
        ),
      );

      expect(find.text('15.01.2026'), findsOneWidget);
      expect(find.text('30.06.2026'), findsOneWidget);
    });
  });
}
