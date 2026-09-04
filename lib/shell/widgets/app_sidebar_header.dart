import 'package:flutter/material.dart';

class AppSidebarHeader extends StatelessWidget {
  final IconData icon;
  final String header;
  final String text;
  final bool isExpanded;

  const AppSidebarHeader({
    super.key,
    required this.isExpanded,
    this.icon = Icons.shield,
    this.header = "PGYS",
    this.text = "Personel ve Görev Yönetim Sistemi",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: isExpanded ? Alignment.centerLeft : Alignment.center,
      child: Row(
        children: [
          Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
          if (isExpanded && MediaQuery.of(context).size.width > 150) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    header,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
