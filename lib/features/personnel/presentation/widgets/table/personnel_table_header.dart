import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_table_header.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/table/pgys_table_header_cell.dart';

class PersonnelTableHeader extends StatelessWidget {
  const PersonnelTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const PGYSTableHeader(
      children: [
        PGYSTableHeaderCell(title: "Sicil", sortable: true),

        PGYSTableHeaderCell(title: "Ad Soyad", flex: 2, sortable: true),

        PGYSTableHeaderCell(title: "Rütbe", sortable: true),

        PGYSTableHeaderCell(title: "Büro", flex: 2, sortable: true),

        PGYSTableHeaderCell(title: "Telefon"),

        PGYSTableHeaderCell(title: "Durum"),

        PGYSTableHeaderCell(title: "İşlemler"),
      ],
    );
  }
}
