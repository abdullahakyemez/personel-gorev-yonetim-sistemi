import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/cards/pgys_card.dart';

class PGYSTable extends StatelessWidget {
  final Widget? toolbar;
  final Widget header;
  final List<Widget> rows;
  final Widget? infoBar;
  final ScrollController? scrollController;

  const PGYSTable({
    super.key,
    this.toolbar,
    required this.header,
    required this.rows,
    this.infoBar,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return PGYSCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ?toolbar,
          ?infoBar,
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                const minTableWidth = 720.0;
                final needsScroll = constraints.maxWidth < minTableWidth;

                final tableContent = Column(
                  children: [
                    header,
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: rows.length,
                        itemBuilder: (context, index) {
                          return rows[index];
                        },
                      ),
                    ),
                  ],
                );

                if (needsScroll) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: minTableWidth,
                      child: tableContent,
                    ),
                  );
                }

                return tableContent;
              },
            ),
          ),
        ],
      ),
    );
  }
}
