import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';

class PersonFormController {
  final registryController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();

  String? selectedRank;
  String? selectedBranch;
  String? selectedDepartment;

  void load(Personnel person) {
    registryController.text = person.registryNumber;
    fullNameController.text = person.fullName;
    phoneController.text = person.phone;

    selectedRank = person.rank;
    selectedBranch = person.branch;
    selectedDepartment = person.department;
  }

  void dispose() {
    registryController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
  }
}
