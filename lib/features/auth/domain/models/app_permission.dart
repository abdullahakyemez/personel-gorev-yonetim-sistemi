enum AppPermission {
  // Personel İzinleri
  viewPersonnel,
  createPersonnel,
  editPersonnel,
  deletePersonnel,

  // Görev İzinleri
  viewTasks,
  createTask,
  editTask,
  deleteTask,

  // İzin / Rapor İzinleri
  viewLeaves,
  createLeave,
  editLeave,
  deleteLeave,

  // Rapor & Dışa Aktarma
  exportReports,

  // Sistem & Yönetim
  manageSettings,
  manageUsers,
  backupRestore,
}

extension AppPermissionExtension on AppPermission {
  String get label => switch (this) {
        AppPermission.viewPersonnel => 'Personel Görüntüleme',
        AppPermission.createPersonnel => 'Yeni Personel Ekleme',
        AppPermission.editPersonnel => 'Personel Düzenleme',
        AppPermission.deletePersonnel => 'Personel Silme',
        AppPermission.viewTasks => 'Görevleri Görüntüleme',
        AppPermission.createTask => 'Yeni Görev Tanımlama',
        AppPermission.editTask => 'Görev Düzenleme',
        AppPermission.deleteTask => 'Görev Silme',
        AppPermission.viewLeaves => 'İzinleri Görüntüleme',
        AppPermission.createLeave => 'Yeni İzin Ekleme',
        AppPermission.editLeave => 'İzin Düzenleme',
        AppPermission.deleteLeave => 'İzin Silme',
        AppPermission.exportReports => 'Rapor ve Dışa Aktarma',
        AppPermission.manageSettings => 'Sistem Ayarlarını Yönetme',
        AppPermission.manageUsers => 'Kullanıcı Hesaplarını Yönetme',
        AppPermission.backupRestore => 'Veritabanı Yedekleme & Geri Yükleme',
      };
}
