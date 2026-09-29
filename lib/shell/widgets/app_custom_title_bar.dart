import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'package:personel_gorev_yonetim_sistemi/core/services/window_service.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/branding/pgys_logo.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_confirm_dialog.dart';

/// Masaüstü için modern, kurumsal ve işletim sistemiyle tam uyumlu özel pencere başlık çubuğu.
class AppCustomTitleBar extends StatefulWidget {
  final double height;

  const AppCustomTitleBar({
    super.key,
    this.height = 36.0,
  });

  @override
  State<AppCustomTitleBar> createState() => _AppCustomTitleBarState();
}

class _AppCustomTitleBarState extends State<AppCustomTitleBar> with WindowListener {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      windowManager.addListener(this);
      _checkMaximized();
    }
  }

  @override
  void dispose() {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  Future<void> _checkMaximized() async {
    try {
      final max = await windowManager.isMaximized();
      if (mounted && max != _isMaximized) {
        setState(() => _isMaximized = max);
      }
    } catch (_) {}
  }

  @override
  void onWindowMaximize() {
    if (mounted) setState(() => _isMaximized = true);
  }

  @override
  void onWindowUnmaximize() {
    if (mounted) setState(() => _isMaximized = false);
  }

  Future<void> _toggleMaximize() async {
    try {
      if (_isMaximized) {
        await windowManager.unmaximize();
      } else {
        await windowManager.maximize();
      }
    } catch (_) {}
  }

  Future<void> _handleClose() async {
    final confirmed = await showPGYSConfirmDialog(
      context: context,
      title: 'Uygulamadan Çık',
      message: 'Personel ve Görev Yönetim Sistemi kapatılacak. Çıkmak istediğinize emin misiniz?',
      confirmText: 'Çıkış Yap',
      cancelText: 'Vazgeç',
      isDestructive: true,
      icon: Icons.power_settings_new_rounded,
    );

    if (confirmed == true) {
      await WindowService.closeApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.35);

    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: borderColor, width: 0.8)),
      ),
      child: Row(
        children: [
          // Sol Kısım: Logo ve Başlık (Tıklanıp taşınabilir)
          Flexible(
            child: DragToMoveArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const PGYSLogo(
                      variant: PGYSLogoVariant.compact,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Personel ve Görev Yönetim Sistemi',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Orta Alan: Boş alana çift tıklandığında büyüt/küçült, sürüklendiğinde taşı
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onDoubleTap: _toggleMaximize,
              child: const DragToMoveArea(
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          // Sağ Kısım: Simge durumuna küçült, Tam ekran yap/Geri yükle, Kapat
          _TitleBarButton(
            icon: Icons.remove_rounded,
            tooltip: 'Simge Durumuna Küçült',
            onTap: () async {
              try {
                await windowManager.minimize();
              } catch (_) {}
            },
          ),
          _TitleBarButton(
            icon: _isMaximized ? Icons.filter_none_rounded : Icons.crop_square_rounded,
            iconSize: _isMaximized ? 12 : 14,
            tooltip: _isMaximized ? 'Önceki Boyut' : 'Ekranı Kapla',
            onTap: _toggleMaximize,
          ),
          _TitleBarButton(
            icon: Icons.close_rounded,
            iconSize: 16,
            tooltip: 'Uygulamayı Kapat',
            isClose: true,
            onTap: _handleClose,
          ),
        ],
      ),
    );
  }
}

class _TitleBarButton extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final String tooltip;
  final bool isClose;
  final VoidCallback onTap;

  const _TitleBarButton({
    required this.icon,
    this.iconSize = 15,
    required this.tooltip,
    this.isClose = false,
    required this.onTap,
  });

  @override
  State<_TitleBarButton> createState() => _TitleBarButtonState();
}

class _TitleBarButtonState extends State<_TitleBarButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor = Colors.transparent;
    Color iconColor = theme.colorScheme.onSurface.withValues(alpha: 0.85);

    if (_isHovered) {
      if (widget.isClose) {
        backgroundColor = const Color(0xFFE81123); // Windows standart kapatma kırmızısı
        iconColor = Colors.white;
      } else {
        backgroundColor = theme.colorScheme.onSurface.withValues(alpha: 0.08);
        iconColor = theme.colorScheme.onSurface;
      }
    }

    return Tooltip(
      message: widget.tooltip,
      waitDuration: const Duration(milliseconds: 600),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 46,
            height: double.infinity,
            color: backgroundColor,
            alignment: Alignment.center,
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
