import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/constants/personnel_lookup.dart';

class PersonFormController extends ChangeNotifier {
  Personnel? editingPersonnel;

  // Focus
  final fullNameFocus = FocusNode();
  final registryFocus = FocusNode();
  final phoneFocus = FocusNode();

  // Genel Bilgiler
  final registryNumberController = TextEditingController();
  final fullNameController = TextEditingController();
  final rankController = TextEditingController();
  final titleController = TextEditingController();

  // Kurum Bilgileri
  final branchController = TextEditingController();
  final departmentController = TextEditingController();

  // İletişim
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  // Ek Bilgiler
  final bloodTypeController = TextEditingController();
  final relativeNameController = TextEditingController();
  final relativePhoneController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  PersonnelStatus status = PersonnelStatus.duty;

  String? selectedRank;
  String? selectedDepartment;
  String? selectedBranch;
  String? selectedTitle;

  PersonFormController() {
    registryNumberController.addListener(_notify);
    fullNameController.addListener(_notify);
    phoneController.addListener(_notify);
  }

  void _notify() {
    notifyListeners();
  }

  void loadPersonnel(Personnel personnel) {
    editingPersonnel = personnel;

    registryNumberController.text = personnel.registryNumber;
    fullNameController.text = personnel.fullName;
    rankController.text = personnel.rank;
    titleController.text = personnel.title;

    branchController.text = personnel.branch;
    departmentController.text = personnel.department;

    phoneController.text = personnel.phone;
    emailController.text = personnel.email;
    addressController.text = personnel.address;

    bloodTypeController.text = personnel.bloodType ?? '';
    relativeNameController.text = personnel.relativeName ?? '';
    relativePhoneController.text = personnel.relativePhone ?? '';

    startDate = personnel.startDate;
    endDate = personnel.endDate;

    status = personnel.status;

    selectedRank = PersonnelLookup.ranks.contains(personnel.rank)
        ? personnel.rank
        : null;
    selectedTitle = PersonnelLookup.titles.contains(personnel.title)
        ? personnel.title
        : null;

    selectedBranch = PersonnelLookup.branches.contains(personnel.branch)
        ? personnel.branch
        : null;

    selectedDepartment =
        PersonnelLookup.departments.contains(personnel.department)
        ? personnel.department
        : null;

    notifyListeners();
  }

  void load(Personnel personnel) {
    loadPersonnel(personnel);
  }

  Personnel buildPersonnel() {
    return Personnel(
      id: editingPersonnel?.id,

      registryNumber: registryNumberController.text.trim(),
      fullName: fullNameController.text.trim(),
      rank: rankController.text.trim(),
      title: titleController.text.trim(),

      branch: branchController.text.trim(),
      department: departmentController.text.trim(),

      startDate: startDate!,
      endDate: endDate,

      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      address: addressController.text.trim(),

      bloodType: bloodTypeController.text.trim().isEmpty
          ? null
          : bloodTypeController.text.trim(),

      relativeName: relativeNameController.text.trim().isEmpty
          ? null
          : relativeNameController.text.trim(),

      relativePhone: relativePhoneController.text.trim().isEmpty
          ? null
          : relativePhoneController.text.trim(),

      status: status,

      profilePhoto: editingPersonnel?.profilePhoto,
    );
  }

  void clear() {
    editingPersonnel = null;

    registryNumberController.clear();
    fullNameController.clear();
    rankController.clear();
    titleController.clear();

    branchController.clear();
    departmentController.clear();

    phoneController.clear();
    emailController.clear();
    addressController.clear();

    bloodTypeController.clear();
    relativeNameController.clear();
    relativePhoneController.clear();

    startDate = null;
    endDate = null;

    selectedRank = null;
    selectedDepartment = null;
    selectedBranch = null;
    selectedTitle = null;

    status = PersonnelStatus.duty;

    notifyListeners();
  }

  bool get isValid {
    return registryNumberController.text.trim().isNotEmpty &&
        fullNameController.text.trim().isNotEmpty &&
        rankController.text.trim().isNotEmpty &&
        titleController.text.trim().isNotEmpty &&
        branchController.text.trim().isNotEmpty &&
        departmentController.text.trim().isNotEmpty &&
        phoneController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        addressController.text.trim().isNotEmpty &&
        startDate != null;
  }

  void setStartDate(DateTime? value) {
    startDate = value;
    notifyListeners();
  }

  void setEndDate(DateTime? value) {
    endDate = value;
    notifyListeners();
  }

  void setRank(String? value) {
    selectedRank = value;
    rankController.text = value ?? '';
    notifyListeners();
  }

  void setDepartment(String? value) {
    selectedDepartment = value;
    departmentController.text = value ?? '';
    notifyListeners();
  }

  void setBranch(String? value) {
    selectedBranch = value;
    branchController.text = value ?? '';
    notifyListeners();
  }

  void setStatus(PersonnelStatus value) {
    status = value;
    notifyListeners();
  }

  void setTitle(String? value) {
    selectedTitle = value;
    titleController.text = value ?? '';
    notifyListeners();
  }

  @override
  void dispose() {
    registryNumberController.dispose();
    fullNameController.dispose();
    rankController.dispose();
    titleController.dispose();

    branchController.dispose();
    departmentController.dispose();

    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();

    bloodTypeController.dispose();
    relativeNameController.dispose();
    relativePhoneController.dispose();

    fullNameFocus.dispose();
    registryFocus.dispose();
    phoneFocus.dispose();

    super.dispose();
  }
}
