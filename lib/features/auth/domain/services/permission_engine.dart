import '../../../personnel/domain/models/work_schedule.dart';
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
    WorkSchedule? targetSchedule,
    WorkSchedule? chiefSchedule,
  }) {
    if (!hasPermission(user.role, AppPermission.viewPersonnel)) return false;

    return switch (getScope(user.role)) {
      AccessScope.all => true,
      AccessScope.groupOrDuty => _canGroupChiefViewPersonnel(
          user,
          targetPersonnelId: targetPersonnelId,
          isTargetDutyToday: isTargetDutyToday,
          targetGroup: targetGroup,
          targetSchedule: targetSchedule,
          chiefSchedule: chiefSchedule,
        ),
      AccessScope.dutyOnly => isTargetDutyToday,
      AccessScope.selfOnly => user.personnelId == targetPersonnelId,
    };
  }

  static bool _canGroupChiefViewPersonnel(
    AppUser user, {
    required int targetPersonnelId,
    required bool isTargetDutyToday,
    String? targetGroup,
    WorkSchedule? targetSchedule,
    WorkSchedule? chiefSchedule,
  }) {
    // 1. Grup Amiri daima kendisini görebilir
    if (user.personnelId != null && user.personnelId == targetPersonnelId) {
      return true;
    }

    // 2. Grup filtresi kontrolü (Amirin kullanıcı hesabına atanmış bir grup varsa)
    final hasGroupFilter =
        user.groupName != null && user.groupName!.trim().isNotEmpty;
    if (hasGroupFilter && targetGroup != null && targetGroup.trim().isNotEmpty) {
      if (user.groupName!.trim().toLowerCase() !=
          targetGroup.trim().toLowerCase()) {
        return false;
      }
    }

    // 3. 1+1 Döngü Eşleşmesi Kontrolü
    // Eğer amirin 1+1 takvimi biliniyorsa:
    if (chiefSchedule != null && chiefSchedule.isOnePlusOne) {
      if (targetSchedule == null || !targetSchedule.isOnePlusOne) {
        return false;
      }
      return chiefSchedule.hasSameCycleAs(targetSchedule);
    }

    // Amirin takvim verisi doğrudan bilinmiyorsa ancak hedef personelin takvimi varsa:
    if (targetSchedule != null) {
      if (!targetSchedule.isOnePlusOne) {
        return false;
      }
      // Amirin takvim referansı yoksa ancak grup ismi eşleşiyorsa izin verilir
      if (hasGroupFilter) {
        return targetGroup != null &&
            user.groupName!.trim().toLowerCase() ==
                targetGroup.trim().toLowerCase();
      }
      return true;
    }

    // 4. Takvim verisi bulunamayan durumlar (testler ve eski kayıtlar için fallback):
    // Asla başka grupları göstermez, sadece kendi grubundaki personeli gösterir
    if (hasGroupFilter) {
      return targetGroup != null &&
          user.groupName!.trim().toLowerCase() ==
              targetGroup.trim().toLowerCase();
    }

    return false;
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
    Set<int>? allowedPersonnelIds,
  }) {
    if (!hasPermission(user.role, AppPermission.viewTasks)) return false;

    return switch (getScope(user.role)) {
      AccessScope.all => true,
      AccessScope.selfOnly => user.personnelId != null &&
          assignedPersonnelIds.contains(user.personnelId),
      AccessScope.groupOrDuty => _canGroupChiefViewTask(
          user,
          assignedPersonnelIds: assignedPersonnelIds,
          personnelGroupMap: personnelGroupMap,
          allowedPersonnelIds: allowedPersonnelIds,
        ),
      AccessScope.dutyOnly => isTaskActiveToday,
    };
  }

  static bool _canGroupChiefViewTask(
    AppUser user, {
    required List<int> assignedPersonnelIds,
    required Map<int, String?> personnelGroupMap,
    Set<int>? allowedPersonnelIds,
  }) {
    if (user.personnelId != null &&
        assignedPersonnelIds.contains(user.personnelId)) {
      return true;
    }

    if (allowedPersonnelIds != null) {
      return assignedPersonnelIds
          .any((pId) => allowedPersonnelIds.contains(pId));
    }

    if (user.groupName != null && user.groupName!.trim().isNotEmpty) {
      final userGroup = user.groupName!.trim().toLowerCase();
      return assignedPersonnelIds.any((pId) {
        final pGroup = personnelGroupMap[pId]?.trim().toLowerCase();
        return pGroup != null && pGroup == userGroup;
      });
    }

    return false;
  }

  /// Kullanıcının belirli bir izin kaydını görüntüleme yetkisini doğrular.
  static bool canViewLeave(
    AppUser user, {
    required int targetPersonnelId,
    required String? targetGroup,
    required bool isLeaveActiveToday,
    bool? isTargetPersonnelAllowed,
  }) {
    if (!hasPermission(user.role, AppPermission.viewLeaves)) return false;

    return switch (getScope(user.role)) {
      AccessScope.all => true,
      AccessScope.selfOnly => user.personnelId == targetPersonnelId,
      AccessScope.groupOrDuty => _canGroupChiefViewLeave(
          user,
          targetPersonnelId: targetPersonnelId,
          targetGroup: targetGroup,
          isTargetPersonnelAllowed: isTargetPersonnelAllowed,
        ),
      AccessScope.dutyOnly => isLeaveActiveToday,
    };
  }

  static bool _canGroupChiefViewLeave(
    AppUser user, {
    required int targetPersonnelId,
    required String? targetGroup,
    bool? isTargetPersonnelAllowed,
  }) {
    if (user.personnelId != null && user.personnelId == targetPersonnelId) {
      return true;
    }

    if (isTargetPersonnelAllowed != null) {
      return isTargetPersonnelAllowed;
    }

    if (user.groupName != null &&
        targetGroup != null &&
        user.groupName!.trim().isNotEmpty) {
      return user.groupName!.trim().toLowerCase() ==
          targetGroup.trim().toLowerCase();
    }

    return false;
  }
}
