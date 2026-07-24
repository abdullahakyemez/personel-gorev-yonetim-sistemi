import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/personnel_info_tile.dart';

class PersonnelInformationSection extends StatelessWidget {
  final Personnel person;

  const PersonnelInformationSection({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PersonnelInfoTile(
          icon: Icons.badge,
          title: "Sicil",
          value: person.registryNumber,
        ),

        PersonnelInfoTile(
          icon: Icons.business,
          title: "Şube",
          value: person.department,
        ),

        PersonnelInfoTile(
          icon: Icons.account_tree,
          title: "Büro",
          value: person.branch,
        ),

        PersonnelInfoTile(
          icon: Icons.phone,
          title: "Telefon",
          value: person.phone,
        ),

        PersonnelInfoTile(
          icon: Icons.verified_user,
          title: "Durum",
          value: person.onDuty ? "Görevde" : "Görevde Değil",
        ),
      ],
    );
  }
}
