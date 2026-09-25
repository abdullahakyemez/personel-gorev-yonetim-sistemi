import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_filter_bar.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('tr_TR', null);
  });

  Widget createWidgetUnderTest({
    List<Personnel>? personnel,
    Set<AppPermission>? permissions,
  }) {
    return ProviderScope(
      overrides: [
        currentPermissionsProvider.overrideWith(
          (ref) => permissions ?? AppPermission.values.toSet(),
        ),
        personnelListProvider.overrideWith(
          (ref) async => personnel ?? [],
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PersonnelFilterBar(),
          ),
        ),
      ),
    );
  }

  group('PersonnelFilterBar Widget Tests', () {
    testWidgets('renders all controls and clear button is initially disabled', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1280, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(PersonnelFilterBar), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Tüm Rütbeler'), findsOneWidget);
      expect(find.text('Tüm Bürolar'), findsOneWidget);
      expect(find.text('Excel Aktar'), findsOneWidget);
      expect(find.text('Personel Ekle'), findsOneWidget);

      final clearButtonFinder = find.widgetWithIcon(
        IconButton,
        Icons.filter_alt_off,
      );
      expect(clearButtonFinder, findsOneWidget);

      final IconButton clearButton = tester.widget(clearButtonFinder);
      expect(clearButton.onPressed, isNull);
    });

    testWidgets(
      'entering search text enables clear button and tapping it resets filter',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1280, 800));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Search text gir
        await tester.enterText(find.byType(TextField), 'Ahmet');
        await tester.pumpAndSettle();

        // Buton aktif olmalı
        final clearFinder = find.widgetWithIcon(
          IconButton,
          Icons.filter_alt_off,
        );
        IconButton clearButton = tester.widget(clearFinder);
        expect(clearButton.onPressed, isNotNull);

        // Temizle butonuna bas
        await tester.tap(clearFinder);
        await tester.pumpAndSettle();

        // TextField boşalmış ve buton inaktif olmalı
        expect(find.text('Ahmet'), findsNothing);
        clearButton = tester.widget(clearFinder);
        expect(clearButton.onPressed, isNull);
      },
    );

    testWidgets('selecting rank enables clear button and resets properly', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1280, 800));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Rütbe açılır menüsünü tıkla
      await tester.tap(find.text('Tüm Rütbeler'));
      await tester.pumpAndSettle();

      // 'Polis Memuru' seç
      await tester.tap(find.text('Polis Memuru').last);
      await tester.pumpAndSettle();

      // Filtre temizle butonu aktif olmalı
      final clearFinder = find.widgetWithIcon(
        IconButton,
        Icons.filter_alt_off,
      );
      IconButton clearButton = tester.widget(clearFinder);
      expect(clearButton.onPressed, isNotNull);

      // Temizle butonuna bas
      await tester.tap(clearFinder);
      await tester.pumpAndSettle();

      // Tekrar Tüm Rütbeler seçili olmalı ve buton inaktif olmalı
      expect(find.text('Tüm Rütbeler'), findsOneWidget);
      clearButton = tester.widget(clearFinder);
      expect(clearButton.onPressed, isNull);
    });

    testWidgets('renders wrap layout on narrow screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 900));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(Wrap), findsOneWidget);
      expect(find.byType(PersonnelFilterBar), findsOneWidget);
    });
  });
}
