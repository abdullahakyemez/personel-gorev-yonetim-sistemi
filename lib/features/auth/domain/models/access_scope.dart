enum AccessScope {
  all, // Tüm personel ve sistem verileri (Admin, Amir Yrd., Büro Memuru)
  groupOrDuty, // Kendi grubu veya günün aktif personeli (Grup Amiri)
  dutyOnly, // Sadece çalıştığı gün aktif/nöbetçi olan personel (Mukayyit)
  selfOnly, // Sadece kendisi (Ekip Memuru)
}

extension AccessScopeExtension on AccessScope {
  String get label => switch (this) {
        AccessScope.all => 'Tüm Veriler',
        AccessScope.groupOrDuty => 'Grup ve Nöbetçi Kadro',
        AccessScope.dutyOnly => 'Günün Aktif Kadrosu',
        AccessScope.selfOnly => 'Sadece Kendi Bilgileri',
      };
}
