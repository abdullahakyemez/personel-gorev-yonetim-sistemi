import 'package:flutter/material.dart';

class PersonnelInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const PersonnelInfoTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),

        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
