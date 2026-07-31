import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/pgys_card.dart';

class PersonnelInformationSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const PersonnelInformationSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return PGYSCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 16),

          ...children,
        ],
      ),
    );
  }
}
