import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/personnel_information_section.dart';

class GeneralInformationTab extends StatelessWidget {
  final Personnel person;

  const GeneralInformationTab({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return PersonnelInformationSection(person: person);
  }
}
