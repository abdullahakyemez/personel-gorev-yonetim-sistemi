import 'package:flutter/material.dart';

Future<T?> showPGYSContextMenu<T>({
  required BuildContext context,
  required TapDownDetails details,
  required List<PopupMenuEntry<T>> items,
}) {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

  return showMenu<T>(
    context: context,
    position: RelativeRect.fromRect(
      details.globalPosition & const Size(40, 40),
      Offset.zero & overlay.size,
    ),
    items: items,
  );
}
