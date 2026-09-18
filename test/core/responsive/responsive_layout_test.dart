import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/responsive/breakpoints.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/layout/master_detail_layout.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/application/auth_state_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_user.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/presentation/pages/app_shell.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/widgets/app_sidebar.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/widgets/app_topbar.dart';

void main() {
  group('AppBreakpoints Tests', () {
    test('standard breakpoint constants are properly configured', () {
      expect(AppBreakpoints.mobile, equals(768.0));
      expect(AppBreakpoints.tablet, equals(1100.0));
      expect(AppBreakpoints.desktop, equals(1100.0));

      expect(
        AppBreakpoints.isNarrow(const BoxConstraints(maxWidth: 600)),
        isTrue,
      );
      expect(
        AppBreakpoints.isNarrow(const BoxConstraints(maxWidth: 800)),
        isFalse,
      );
    });

    testWidgets('breakpoint context helpers identify mobile vs desktop',
        (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      bool? isMobileDetected;
      bool? isDesktopDetected;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              isMobileDetected = AppBreakpoints.isMobile(context);
              isDesktopDetected = AppBreakpoints.isDesktop(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(isMobileDetected, isTrue);
      expect(isDesktopDetected, isFalse);

      // Şimdi masaüstü boyutuna geç
      tester.view.physicalSize = const Size(1280, 900);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              isMobileDetected = AppBreakpoints.isMobile(context);
              isDesktopDetected = AppBreakpoints.isDesktop(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(isMobileDetected, isFalse);
      expect(isDesktopDetected, isTrue);
    });
  });

  group('MasterDetailLayout Responsive Tests', () {
    testWidgets(
        'Mobile mode (< 768px): shows only master when detailVisible is false',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 800));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MasterDetailLayout(
              master: Text('Master_Panel_Listesi'),
              detail: Text('Detail_Panel_Detayi'),
              detailVisible: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Master_Panel_Listesi'), findsOneWidget);
      expect(find.text('Detail_Panel_Detayi'), findsNothing);
      expect(find.text('Listeye Dön'), findsNothing);
    });

    testWidgets(
        'Mobile mode (< 768px): shows single-pane detail with back button when detailVisible is true',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 800));

      bool backClicked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MasterDetailLayout(
              master: const Text('Master_Panel_Listesi'),
              detail: const Text('Detail_Panel_Detayi'),
              detailVisible: true,
              onBack: () => backClicked = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Detail_Panel_Detayi'), findsOneWidget);
      expect(find.text('Master_Panel_Listesi'), findsNothing);
      expect(find.text('Listeye Dön'), findsOneWidget);

      await tester.tap(find.text('Listeye Dön'));
      await tester.pump();

      expect(backClicked, isTrue);
    });

    testWidgets(
        'Desktop mode (>= 768px): shows both master and detail simultaneously when detailVisible is true',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MasterDetailLayout(
              master: Text('Master_Panel_Listesi'),
              detail: Text('Detail_Panel_Detayi'),
              detailVisible: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Masaüstünde her iki panel aynı anda görünür
      expect(find.text('Master_Panel_Listesi'), findsOneWidget);
      expect(find.text('Detail_Panel_Detayi'), findsOneWidget);
      // Masaüstünde geri dönüş butonu olmaz (çünkü her iki panel açık)
      expect(find.text('Listeye Dön'), findsNothing);
    });
  });

  group('AppShell Responsive Navigation Tests', () {
    final testUser = AppUser(
      id: 1,
      username: '430558',
      fullName: 'Abdullah HAKYEMEZ',
      role: UserRole.admin,
      requiresPasswordChange: false,
      createdAt: DateTime.now(),
    );

    testWidgets(
        'Mobile (< 768px): AppShell provides Drawer and opens drawer via menu button',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(480, 850));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => testUser),
          ],
          child: const MaterialApp(
            home: AppShell(
              child: Text('Sayfa_Govdesi'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sayfa_Govdesi'), findsOneWidget);

      // Mobilde menü butonu Drawer'ı açmalı
      final menuButton = find.widgetWithIcon(IconButton, Icons.menu);
      expect(menuButton, findsOneWidget);

      // Drawer henüz kapalı
      expect(find.byType(Drawer), findsNothing);

      // Menü butonuna tıkla
      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      // Drawer artık açık
      expect(find.byType(Drawer), findsOneWidget);
      expect(find.byType(AppSidebar), findsOneWidget);
    });

    testWidgets(
        'Desktop (>= 768px): AppShell has no Drawer and renders sidebar inline',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => testUser),
          ],
          child: const MaterialApp(
            home: AppShell(
              child: Text('Sayfa_Govdesi'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sayfa_Govdesi'), findsOneWidget);

      // Masaüstünde kalıcı AppSidebar doğrudan gövdede vardır
      expect(find.byType(AppSidebar), findsOneWidget);
      expect(find.byType(Drawer), findsNothing);

      // Topbar kullanıcı bilgilerini ve ikonları doğrudan gösterir
      expect(find.byType(AppTopbar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppTopbar),
          matching: find.text('Abdullah HAKYEMEZ'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AppTopbar),
          matching: find.text('Büro Amiri (Admin)'),
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
    });
  });
}
