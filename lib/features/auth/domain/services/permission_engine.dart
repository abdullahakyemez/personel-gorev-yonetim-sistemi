import '../models/access_scope.dart';
import '../models/app_permission.dart';
import '../models/app_user.dart';
import '../models/user_role.dart';

class PermissionEngine {
  const PermissionEngine._();

  static const Map<UserRole, Set<AppPermission>> _rolePermissions = {
    // 1. Büro Amiri (Admin) - Tam Yetki
    UserRole.admin: {
      AppPermission.viewPersonnel,
      AppPermission.createPersonnel,
      AppPermission.editPersonnel,
      AppPermission.deletePersonnel,
      AppPermission.viewTasks,
      AppPermission.createTask,
      AppPermission.editTask,
      AppPermission.deleteTask,
      AppPermission.viewLeaves,
      AppPermission.createLeave,
      AppPermission.editLeave,
      AppPermission.deleteLeave,
      AppPermission.exportReports,
      AppPermission.manageSettings,
      AppPermission.manageUsers,
      AppPermission.backupRestore,
    },

    // 2. Büro Amir Yardımcısı - Tüm Bilgileri İnceleme + Export (Read-Only)
    UserRole.assistantChief: {
      AppPermission.viewPersonnel,
      AppPermission.viewTasks,
      AppPermission.viewLeaves,
      AppPermission.exportReports,
    },

    // 3. Grup Amiri - Grup/Nöbetçi Bilgileri İnceleme + Export
    UserRole.groupChief: {
      AppPermission.viewPersonnel,
      AppPermission.viewTasks,
      AppPermission.viewLeaves,
      AppPermission.exportReports,
    },

    // 4. Büro Memuru - Personel, Görev, İzin CRUD + Export
    UserRole.officeClerk: {
      AppPermission.viewPersonnel,
      AppPermission.createPersonnel,
      AppPermission.editPersonnel,
      AppPermission.deletePersonnel,
      AppPermission.viewTasks,
      AppPermission.createTask,
      AppPermission.editTask,
      AppPermission.deleteTask,
      AppPermission.viewLeaves,
      AppPermission.createLeave,
      AppPermission.editLeave,
      AppPermission.deleteLeave,
      AppPermission.exportReports,
    },

    // 5. Mukayyit - Çalıştığı gün aktif personelle ilgili Büro Memuru işlemleri
    UserRole.deskOfficer: {
      AppPermission.viewPersonnel,
      AppPermission.createPersonnel,
      AppPermission.editPersonnel,
      AppPermission.deletePersonnel,
      AppPermission.viewTasks,
      AppPermission.createTask,
      AppPermission.editTask,
      AppPermission.deleteTask,
      AppPermission.viewLeaves,
      AppPermission.createLeave,
      AppPermission.editLeave,
      AppPermission.deleteLeave,
      AppPermission.exportReports,
    },

    // 6. Ekip Memuru - Sadece Kendisi ile ilgili Görüntüleme (Self-Service)
    UserRole.teamOfficer: {
      AppPermission.viewPersonnel,
      AppPermission.viewTasks,
      AppPermission.viewLeaves,
    },
  };

  /// Belirtilen rolün bu izne sahip olup olmadığını döner.
  static bool hasPermission(UserRole role, AppPermission permission) {
    final permissions = _rolePermissions[role];
    return permissions?.contains(permission) ?? false;
  }

  /// Belirtilen rolün tüm izin kümesini döner.
  static Set<AppPermission> getPermissions(UserRole role) {
    return _rolePermissions[role] ?? const {};
  }

  /// Rolün veri kapsamını döner.
  static AccessScope getScope(UserRole role) => switch (role) {
        UserRole.admin => AccessScope.all,
        UserRole.assistantChief => AccessScope.all,
        UserRole.officeClerk => AccessScope.all,
        UserRole.groupChief => AccessScope.groupOrDuty,
        UserRole.deskOfficer => AccessScope.dutyOnly,
        UserRole.teamOfficer => AccessScope.selfOnly,
      };

  /// Kullanıcının belirli bir personel kartını görüntüleme yetkisini doğrular.
  static bool canViewPersonnel(
    AppUser user, {
    required int targetPersonnelId,
    required bool isTargetDutyToday,
    String? targetGroup,
  }) {
    if (!hasPermission(user.role, AppPermission.viewPersonnel)) return false;

    return switch (getScope(user.role)) {
      AccessScope.all => true,
      AccessScope.groupOrDuty => isTargetDutyToday ||
          (user.groupName != null &&
              targetGroup != null &&
              user.groupName!.trim().toLowerCase() ==
                  targetGroup.trim().toLowerCase()),
      AccessScope.dutyOnly => isTargetDutyToday,
      AccessScope.selfOnly => user.personnelId == targetPersonnelId,
    };
  }

  /// Kullanıcının belirli bir personel üzerinde işlem (ekleme, düzenleme, silme, görev, izin) yapıp yapamayacağını doğrular.
  static bool canOperateOnPersonnel(
    AppUser user,
    AppPermission operation, {
    required int targetPersonnelId,
    required bool isTargetDutyToday,
    String? targetGroup,
  }) {
    if (!hasPermission(user.role, operation)) return false;

    // Salt okunur veya self-service roller personel üzerinde değişiklik yapamaz
    if (user.role == UserRole.assistantChief ||
        user.role == UserRole.groupChief ||
        user.role == UserRole.teamOfficer) {
      return false;
    }

    return switch (getScope(user.role)) {
      AccessScope.all => true,
      AccessScope.dutyOnly => isTargetDutyToday,
      AccessScope.groupOrDuty => isTargetDutyToday,
      AccessScope.selfOnly => false,
    };
  }

  /// Kullanıcının belirli bir görevi görüntüleme yetkisini doğrular.
  static bool canViewTask(
    AppUser user,
    List<int> assignedPersonnelIds, {
    required Map<int, String?> personnelGroupMap,
    required bool isTaskActiveToday,
  }) {
    if (!hasPermission(user.role, AppPermission.viewTasks)) return false;

    return switch (getScope(user.role)) {
      AccessScope.all => true,
      AccessScope.selfOnly => user.personnelId != null &&
          assignedPersonnelIds.contains(user.personnelId),
      AccessScope.groupOrDuty =>
        isTaskActiveToday ||
        (user.groupName != null &&
            assignedPersonnelIds.any((pId) {
              final group = personnelGroupMap[pId]?.trim().toLowerCase();
              return group != null &&
                  group == user.groupName!.trim().toLowerCase();
            })),
      AccessScope.dutyOnly => isTaskActiveToday,
    };
  }

  /// Kullanıcının belirli bir izin kaydını görüntüleme yetkisini doğrular.
  static bool canViewLeave(
    AppUser user, {
    required int targetPersonnelId,
    required String? targetGroup,
    required bool isLeaveActiveToday,
  }) {
    if (!hasPermission(user.role, AppPermission.viewLeaves)) return false;

    return switch (getScope(user.role)) {
      AccessScope.all => true,
      AccessScope.selfOnly => user.personnelId == targetPersonnelId,
      AccessScope.groupOrDuty =>
        isLeaveActiveToday ||
        (user.groupName != null &&
            targetGroup != null &&
            user.groupName!.trim().toLowerCase() ==
                targetGroup.trim().toLowerCase()),
      AccessScope.dutyOnly => isLeaveActiveToday,
    };
  }
}
