import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/toolbar/pgys_toolbar.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/toolbar/pgys_toolbar_button.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/toolbar/pgys_toolbar_search.dart';

class TaskToolbar extends StatelessWidget {
  const TaskToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return PGYSToolbar(
      child: Row(
        children: [
          PGYSToolbarSearch(hintText: "Görev Ara...", onChanged: (value) {}),

          const Spacer(),

          PGYSToolbarButton(
            text: "Yeni Görev",
            icon: Icons.add,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
