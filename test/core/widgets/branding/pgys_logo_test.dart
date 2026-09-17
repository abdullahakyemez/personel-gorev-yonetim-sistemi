import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/branding/pgys_logo.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_about_dialog.dart';

void main() {
  group('PGYSLogo Widget Tests', () {
    testWidgets('renders compact variant with emblem only', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: PGYSLogo(
                variant: PGYSLogoVariant.compact,
                size: 48,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.text('PGYS'), findsNothing);
      expect(find.text('Personel & Görev Yönetim Sistemi'), findsNothing);
    });

    testWidgets('renders horizontal variant with emblem, title and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: PGYSLogo(
                variant: PGYSLogoVariant.horizontal,
                size: 40,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.text('PGYS'), findsOneWidget);
      expect(find.text('Personel & Görev Yönetim Sistemi'), findsOneWidget);
    });

    testWidgets('renders horizontal variant without subtitle when showSubtitle is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: PGYSLogo(
                variant: PGYSLogoVariant.horizontal,
                size: 40,
                showSubtitle: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('PGYS'), findsOneWidget);
      expect(find.text('Personel & Görev Yönetim Sistemi'), findsNothing);
    });

    testWidgets('renders stacked variant with centered emblem and vertical text hierarchy', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: PGYSLogo(
                variant: PGYSLogoVariant.stacked,
                size: 80,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.text('PGYS'), findsOneWidget);
      expect(find.text('Personel ve Görev Yönetim Sistemi'), findsOneWidget);
    });

    testWidgets('renders properly in dark mode with custom colors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: Center(
              child: PGYSLogo(
                variant: PGYSLogoVariant.horizontal,
                primaryColor: Colors.cyan,
                accentColor: Colors.amber,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PGYSLogo), findsOneWidget);
      expect(find.text('PGYS'), findsOneWidget);
    });
  });

  group('PGYSAboutDialog Widget Tests', () {
    testWidgets('renders about dialog with logo, version, system metrics and close button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => showPGYSAboutDialog(context),
                  child: const Text('Hakkında Aç'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Hakkında Aç'));
      await tester.pumpAndSettle();

      expect(find.byType(PGYSAboutDialog), findsOneWidget);
      expect(find.text('v1.0.0 • Kurumsal Sürüm'), findsOneWidget);
      expect(find.text('Veritabanı'), findsOneWidget);
      expect(find.text('Ağ Modu'), findsOneWidget);
      expect(find.text('Yetkilendirme'), findsOneWidget);
      expect(find.text('Platform'), findsOneWidget);

      await tester.tap(find.text('Kapat'));
      await tester.pumpAndSettle();

      expect(find.byType(PGYSAboutDialog), findsNothing);
    });
  });
}
