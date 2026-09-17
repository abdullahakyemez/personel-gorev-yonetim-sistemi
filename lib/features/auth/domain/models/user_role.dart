enum UserRole {
  admin,          // Büro Amiri - Tam Yetki
  assistantChief, // Büro Amir Yardımcısı - Read-only + Export
  groupChief,     // Grup Amiri - Kapsamlı Okuma (Grup/Nöbetçi) + Export
  officeClerk,    // Büro Memuru - Tam Operasyonel Yetki (Personel/Görev/İzin CRUD + Export)
  deskOfficer,    // Mukayyit - Günlük Nöbetçi Kadro Kapsamlı Büro Memuru
  teamOfficer,    // Ekip Memuru - Self-Service (Sadece Kendi Bilgileri)
}

extension UserRoleExtension on UserRole {
  String get label => switch (this) {
        UserRole.admin => 'Büro Amiri (Admin)',
        UserRole.assistantChief => 'Büro Amir Yardımcısı',
        UserRole.groupChief => 'Grup Amiri',
        UserRole.officeClerk => 'Büro Memuru',
        UserRole.deskOfficer => 'Mukayyit',
        UserRole.teamOfficer => 'Ekip Memuru',
      };

  String get description => switch (this) {
        UserRole.admin =>
          'Tüm sistem, personel, görev, izin ve ayarlar üzerinde tam yetkiye sahiptir.',
        UserRole.assistantChief =>
          'Tüm personel, görev ve izin bilgilerini inceleyebilir ve rapor alabilir.',
        UserRole.groupChief =>
          'Kendi grubuna ve günün nöbetçi personeline ait bilgileri görebilir ve rapor alabilir.',
        UserRole.officeClerk =>
          'Personel, görev ve izin işlemlerini tam yetkiyle yönetebilir ve rapor alabilir.',
        UserRole.deskOfficer =>
          'Sadece çalıştığı gün aktif olan personelle ilgili görev ve izin işlemlerini yapabilir.',
        UserRole.teamOfficer =>
          'Yalnızca kendisine ait sicil, görev ve izin durumunu görüntüleyebilir.',
      };

  int get hierarchyLevel => switch (this) {
        UserRole.admin => 100,
        UserRole.assistantChief => 80,
        UserRole.groupChief => 60,
        UserRole.officeClerk => 50,
        UserRole.deskOfficer => 40,
        UserRole.teamOfficer => 10,
      };

  bool get isAdmin => this == UserRole.admin;
}
