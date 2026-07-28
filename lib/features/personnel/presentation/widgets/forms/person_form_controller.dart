import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';

class PersonFormController extends ChangeNotifier {
  final registryController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final fullNameFocus = FocusNode();
  final registryFocus = FocusNode();
  final phoneFocus = FocusNode();

  final rankFocus = FocusNode();
  final departmentFocus = FocusNode();
  final branchFocus = FocusNode();

  String? selectedRank;
  String? selectedBranch;
  String? selectedDepartment;
  bool onDuty = true;

  PersonFormController() {
    registryController.addListener(_notify);
    fullNameController.addListener(_notify);
    phoneController.addListener(_notify);
  }

  void _notify() {
    notifyListeners();
  }

  void load(Personnel person) {
    registryController.text = person.registryNumber;
    fullNameController.text = person.fullName;
    phoneController.text = person.phone;

    selectedRank = person.rank;
    selectedBranch = person.branch;
    selectedDepartment = person.department;
    onDuty = person.onDuty;
    notifyListeners();
  }

  @override
  void dispose() {
    registryController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    fullNameFocus.dispose();
    registryFocus.dispose();
    phoneFocus.dispose();

    rankFocus.dispose();
    departmentFocus.dispose();
    branchFocus.dispose();
    super.dispose();
  }

  Personnel buildPersonnel({int? id}) {
    return Personnel(
      id: id,
      registryNumber: registryController.text.trim(),
      fullName: fullNameController.text.trim(),
      rank: selectedRank ?? '',
      department: selectedDepartment ?? '',
      branch: selectedBranch ?? '',
      phone: phoneController.text.trim(),
      onDuty: onDuty,
      email: null,
      tcIdentity: null,
      title: null,
      profilePhoto: null,
    );
  }

  void clear() {
    registryController.clear();
    fullNameController.clear();
    phoneController.clear();

    selectedRank = null;
    selectedDepartment = null;
    selectedBranch = null;
    onDuty = true;
    notifyListeners();
  }

  bool get isValid {
    return registryController.text.isNotEmpty &&
        fullNameController.text.isNotEmpty &&
        phoneController.text.trim().isNotEmpty &&
        selectedRank != null &&
        selectedDepartment != null &&
        selectedBranch != null;
  }

  void setRank(String? value) {
    selectedRank = value;
    notifyListeners();
  }

  void setDepartment(String? value) {
    selectedDepartment = value;
    notifyListeners();
  }

  void setBranch(String? value) {
    selectedBranch = value;
    notifyListeners();
  }

  void setOnDuty(bool value) {
    onDuty = value;
  }
}
