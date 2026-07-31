import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/keyboard_state_provider.dart';

class PGYSKeyboardShortcuts extends ConsumerWidget {
  final Widget child;

  final VoidCallback? onSelectAll;
  final VoidCallback? onEscape;
  final VoidCallback? onDelete;
  final VoidCallback? onEnter;
  final VoidCallback? onArrowUp;
  final VoidCallback? onArrowDown;
  final VoidCallback? onHome;
  final VoidCallback? onEnd;

  const PGYSKeyboardShortcuts({
    super.key,
    required this.child,
    this.onSelectAll,
    this.onEscape,
    this.onDelete,
    this.onEnter,
    this.onArrowUp,
    this.onArrowDown,
    this.onHome,
    this.onEnd,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyUpEvent) {
          if (event.logicalKey == LogicalKeyboardKey.shiftLeft ||
              event.logicalKey == LogicalKeyboardKey.shiftRight) {
            ref.read(shiftPressedProvider.notifier).state = false;
            return KeyEventResult.handled;
          }

          if (event.logicalKey == LogicalKeyboardKey.controlLeft ||
              event.logicalKey == LogicalKeyboardKey.controlRight) {
            ref.read(ctrlPressedProvider.notifier).state = false;
            return KeyEventResult.handled;
          }

          return KeyEventResult.ignored;
        }

        if (event is! KeyDownEvent) {
          return KeyEventResult.ignored;
        }

        final ctrl = HardwareKeyboard.instance.isControlPressed;

        if (ctrl && event.logicalKey == LogicalKeyboardKey.keyA) {
          onSelectAll?.call();
          return KeyEventResult.handled;
        }

        if (event.logicalKey == LogicalKeyboardKey.escape) {
          onEscape?.call();
          return KeyEventResult.handled;
        }

        if (event.logicalKey == LogicalKeyboardKey.delete) {
          onDelete?.call();
          return KeyEventResult.handled;
        }

        if (event.logicalKey == LogicalKeyboardKey.shiftLeft ||
            event.logicalKey == LogicalKeyboardKey.shiftRight) {
          ref.read(shiftPressedProvider.notifier).state = true;

          return KeyEventResult.handled;
        }

        if (event.logicalKey == LogicalKeyboardKey.controlLeft ||
            event.logicalKey == LogicalKeyboardKey.controlRight) {
          ref.read(ctrlPressedProvider.notifier).state = true;
          return KeyEventResult.handled;
        }

        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          onArrowDown?.call();
          return KeyEventResult.handled;
        }

        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          onArrowUp?.call();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.home) {
          onHome?.call();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.end) {
          onEnd?.call();
          return KeyEventResult.handled;
        }

        if (event.logicalKey == LogicalKeyboardKey.enter) {
          onEnter?.call();
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}
