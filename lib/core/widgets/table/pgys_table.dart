import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/pgys_card.dart';

class PGYSTable extends StatelessWidget {
  final Widget? toolbar;
  final Widget header;
  final List<Widget> rows;
  final Widget? infoBar;

  const PGYSTable({
    super.key,
    this.toolbar,
    required this.header,
    required this.rows,
    this.infoBar,
  });

  @override
  Widget build(BuildContext context) {
    return PGYSCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ?toolbar,
          ?infoBar,
          header,
          Expanded(
            child: ListView.builder(
              itemCount: rows.length,
              itemBuilder: (context, index) {
                return rows[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}
