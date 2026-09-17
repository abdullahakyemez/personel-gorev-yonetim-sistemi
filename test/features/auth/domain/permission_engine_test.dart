import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_user.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/services/permission_engine.dart';

void main() {
  group('PermissionEngine Tests', () {
    test('Admin (Büro Amiri) has all permissions', () {
      for (final permission in AppPermission.values) {
        expect(
          PermissionEngine.hasPermission(UserRole.admin, permission),
          isTrue,
          reason: 'Admin should have ${permission.name}',
        );
      }
    });

    test('Assistant Chief (Büro Amir Yrd) is strictly read-only + export', () {
      final permissions = PermissionEngine.getPermissions(UserRole.assistantChief);
      expect(permissions, contains(AppPermission.viewPersonnel));
      expect(permissions, contains(AppPermission.viewTasks));
      expect(permissions, contains(AppPermission.viewLeaves));
      expect(permissions, contains(AppPermission.exportReports));

      // No mutation or admin permissions
      expect(permissions, isNot(contains(AppPermission.createPersonnel)));
      expect(permissions, isNot(contains(AppPermission.deletePersonnel)));
      expect(permissions, isNot(contains(AppPermission.createTask)));
      expect(permissions, isNot(contains(AppPermission.deleteTask)));
      expect(permissions, isNot(contains(AppPermission.manageSettings)));
      expect(permissions, isNot(contains(AppPermission.manageUsers)));
    });

    test('Group Chief (Grup Amiri) is read-only + export', () {
      final permissions = PermissionEngine.getPermissions(UserRole.groupChief);
      expect(permissions, contains(AppPermission.viewPersonnel));
      expect(permissions, contains(AppPermission.viewTasks));
      expect(permissions, contains(AppPermission.viewLeaves));
      expect(permissions, contains(AppPermission.exportReports));

      expect(permissions, isNot(contains(AppPermission.createPersonnel)));
      expect(permissions, isNot(contains(AppPermission.editPersonnel)));
      expect(permissions, isNot(contains(AppPermission.manageSettings)));
    });

    test('Office Clerk (Büro Memuru) has full CRUD and export, but no system settings/users', () {
      final permissions = PermissionEngine.getPermissions(UserRole.officeClerk);
      expect(permissions, contains(AppPermission.createPersonnel));
      expect(permissions, contains(AppPermission.editPersonnel));
      expect(permissions, contains(AppPermission.deletePersonnel));
      expect(permissions, contains(AppPermission.createTask));
      expect(permissions, contains(AppPermission.createLeave));
      expect(permissions, contains(AppPermission.exportReports));

      expect(permissions, isNot(contains(AppPermission.manageSettings)));
      expect(permissions, isNot(contains(AppPermission.manageUsers)));
      expect(permissions, isNot(contains(AppPermission.backupRestore)));
    });

    test('Team Officer (Ekip Memuru) has only self-service view, no export or write', () {
      final permissions = PermissionEngine.getPermissions(UserRole.teamOfficer);
      expect(permissions, contains(AppPermission.viewPersonnel));
      expect(permissions, contains(AppPermission.viewTasks));
      expect(permissions, contains(AppPermission.viewLeaves));

      expect(permissions, isNot(contains(AppPermission.exportReports)));
      expect(permissions, isNot(contains(AppPermission.createPersonnel)));
      expect(permissions, isNot(contains(AppPermission.deleteTask)));
    });

    group('canViewPersonnel rules', () {
      final now = DateTime.now();

      final adminUser = AppUser(
        id: 1,
        username: 'admin',
        fullName: 'Büro Amiri',
        role: UserRole.admin,
        createdAt: now,
      );

      final groupChiefUser = AppUser(
        id: 2,
        username: 'grup_amiri',
        fullName: 'Grup Amiri',
        role: UserRole.groupChief,
        groupName: 'A Grubu',
        createdAt: now,
      );

      final deskOfficerUser = AppUser(
        id: 3,
        username: 'mukayyit',
        fullName: 'Mukayyit',
        role: UserRole.deskOfficer,
        createdAt: now,
      );

      final teamOfficerUser = AppUser(
        id: 4,
        username: 'ekip_memuru',
        fullName: 'Ekip Memuru',
        role: UserRole.teamOfficer,
        personnelId: 105,
        createdAt: now,
      );

      test('Admin can view any personnel regardless of duty or group', () {
        expect(
          PermissionEngine.canViewPersonnel(
            adminUser,
            targetPersonnelId: 999,
            isTargetDutyToday: false,
            targetGroup: 'Farklı Grup',
          ),
          isTrue,
        );
      });

      test('Group Chief can view if duty today OR if in same group', () {
        // In same group, even if not duty today: can view
        expect(
          PermissionEngine.canViewPersonnel(
            groupChiefUser,
            targetPersonnelId: 10,
            isTargetDutyToday: false,
            targetGroup: 'A Grubu',
          ),
          isTrue,
        );

        // Not in same group, but duty today: can view
        expect(
          PermissionEngine.canViewPersonnel(
            groupChiefUser,
            targetPersonnelId: 11,
            isTargetDutyToday: true,
            targetGroup: 'B Grubu',
          ),
          isTrue,
        );

        // Neither same group nor duty today: cannot view
        expect(
          PermissionEngine.canViewPersonnel(
            groupChiefUser,
            targetPersonnelId: 12,
            isTargetDutyToday: false,
            targetGroup: 'B Grubu',
          ),
          isFalse,
        );
      });

      test('Mukayyit (Desk Officer) can only view if duty today', () {
        expect(
          PermissionEngine.canViewPersonnel(
            deskOfficerUser,
            targetPersonnelId: 20,
            isTargetDutyToday: true,
          ),
          isTrue,
        );

        expect(
          PermissionEngine.canViewPersonnel(
            deskOfficerUser,
            targetPersonnelId: 20,
            isTargetDutyToday: false,
          ),
          isFalse,
        );
      });

      test('Ekip Memuru can only view own card', () {
        expect(
          PermissionEngine.canViewPersonnel(
            teamOfficerUser,
            targetPersonnelId: 105,
            isTargetDutyToday: false,
          ),
          isTrue,
        );

        expect(
          PermissionEngine.canViewPersonnel(
            teamOfficerUser,
            targetPersonnelId: 106,
            isTargetDutyToday: true,
          ),
          isFalse,
        );
      });
    });

    group('canOperateOnPersonnel rules', () {
      final now = DateTime.now();

      final clerkUser = AppUser(
        id: 1,
        username: 'clerk',
        fullName: 'Büro Memuru',
        role: UserRole.officeClerk,
        createdAt: now,
      );

      final deskOfficerUser = AppUser(
        id: 2,
        username: 'mukayyit',
        fullName: 'Mukayyit',
        role: UserRole.deskOfficer,
        createdAt: now,
      );

      final assistantChiefUser = AppUser(
        id: 3,
        username: 'amir_yrd',
        fullName: 'Amir Yardımcısı',
        role: UserRole.assistantChief,
        createdAt: now,
      );

      test('Büro Memuru can operate on any personnel', () {
        expect(
          PermissionEngine.canOperateOnPersonnel(
            clerkUser,
            AppPermission.createTask,
            targetPersonnelId: 50,
            isTargetDutyToday: false,
          ),
          isTrue,
        );
      });

      test('Mukayyit can only operate on personnel active/duty today', () {
        expect(
          PermissionEngine.canOperateOnPersonnel(
            deskOfficerUser,
            AppPermission.createTask,
            targetPersonnelId: 50,
            isTargetDutyToday: true,
          ),
          isTrue,
        );

        expect(
          PermissionEngine.canOperateOnPersonnel(
            deskOfficerUser,
            AppPermission.createTask,
            targetPersonnelId: 50,
            isTargetDutyToday: false,
          ),
          isFalse,
        );
      });

      test('Read-only roles cannot operate on personnel even if duty today', () {
        expect(
          PermissionEngine.canOperateOnPersonnel(
            assistantChiefUser,
            AppPermission.createLeave,
            targetPersonnelId: 50,
            isTargetDutyToday: true,
          ),
          isFalse,
        );
      });
    });
  });
}
