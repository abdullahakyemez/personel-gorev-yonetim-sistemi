import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';

void main() {
  group('PGYSFeedback Widget Tests', () {
    Widget buildTestApp({Widget? child}) {
      return MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        home: Scaffold(
          body: child ??
              Builder(
                builder: (context) => Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        PGYSFeedback.showSuccess(
                          context,
                          'İşlem başarıyla tamamlandı.',
                          title: 'Başarılı İşlem',
                        );
                      },
                      child: const Text('Show Success'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        PGYSFeedback.showError(
                          context,
                          'Bir hata meydana geldi.',
                          title: 'Hata Bildirimi',
                        );
                      },
                      child: const Text('Show Error'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        PGYSFeedback.showWarning(
                          context,
                          'Dikkat edilmesi gereken durum.',
                        );
                      },
                      child: const Text('Show Warning'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        PGYSFeedback.showInfo(
                          context,
                          'Bilgilendirme notu.',
                        );
                      },
                      child: const Text('Show Info'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        PGYSFeedback.hide(context);
                      },
                      child: const Text('Hide'),
                    ),
                  ],
                ),
              ),
        ),
      );
    }

    testWidgets('shows success feedback with icon, title and message', (tester) async {
      await tester.pumpWidget(buildTestApp());

      await tester.tap(find.text('Show Success'));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(milliseconds: 300)); // Complete slide-in

      expect(find.text('Başarılı İşlem'), findsOneWidget);
      expect(find.text('İşlem başarıyla tamamlandı.'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    });

    testWidgets('shows error feedback with error icon and message', (tester) async {
      await tester.pumpWidget(buildTestApp());

      await tester.tap(find.text('Show Error'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Hata Bildirimi'), findsOneWidget);
      expect(find.text('Bir hata meydana geldi.'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets('shows warning feedback with warning icon', (tester) async {
      await tester.pumpWidget(buildTestApp());

      await tester.tap(find.text('Show Warning'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Dikkat edilmesi gereken durum.'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets('shows info feedback with info icon', (tester) async {
      await tester.pumpWidget(buildTestApp());

      await tester.tap(find.text('Show Info'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Bilgilendirme notu.'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
    });

    testWidgets('tapping close button dismisses the feedback immediately', (tester) async {
      await tester.pumpWidget(buildTestApp());

      await tester.tap(find.text('Show Success'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('İşlem başarıyla tamamlandı.'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump(); // trigger hide
      await tester.pump(const Duration(milliseconds: 300)); // complete fade/slide out

      expect(find.text('İşlem başarıyla tamamlandı.'), findsNothing);
    });

    testWidgets('hide method dismisses active feedback', (tester) async {
      await tester.pumpWidget(buildTestApp());

      await tester.tap(find.text('Show Warning'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Dikkat edilmesi gereken durum.'), findsOneWidget);

      await tester.tap(find.text('Hide'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Dikkat edilmesi gereken durum.'), findsNothing);
    });

    testWidgets('triggers via rootScaffoldMessengerKey when context is null', (tester) async {
      await tester.pumpWidget(buildTestApp(
        child: ElevatedButton(
          onPressed: () {
            PGYSFeedback.showSuccess(
              null,
              'Global key üzerinden bildirim',
            );
          },
          child: const Text('Show Global'),
        ),
      ));

      await tester.tap(find.text('Show Global'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Global key üzerinden bildirim'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
    });

    testWidgets('consecutive show calls instantly replace previous snackbar', (tester) async {
      await tester.pumpWidget(buildTestApp());

      await tester.tap(find.text('Show Success'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('İşlem başarıyla tamamlandı.'), findsOneWidget);

      // Now immediately show warning
      await tester.tap(find.text('Show Warning'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Dikkat edilmesi gereken durum.'), findsOneWidget);
      expect(find.text('İşlem başarıyla tamamlandı.'), findsNothing);
    });
  });
}
