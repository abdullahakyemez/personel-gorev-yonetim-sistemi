class Personnel {
  final int id;
  final String registryNumber;
  final String fullName;
  final String rank;
  final String department;
  final String branch;
  final String phone;
  final bool onDuty;

  final String? email;
  final String? tcIdentity;
  final String? title;
  final String? profilePhoto;

  const Personnel({
    required this.id,
    required this.registryNumber,
    required this.fullName,
    required this.rank,
    required this.department,
    required this.branch,
    required this.phone,
    required this.onDuty,
    this.email,
    this.tcIdentity,
    this.title,
    this.profilePhoto,
  });
}
