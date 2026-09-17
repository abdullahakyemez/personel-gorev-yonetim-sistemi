import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/access_scope.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/app_permission.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/models/user_role.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/services/permission_engine.dart';

void main() {
  group('UserRole and AccessScope Tests', () {
    test('all 6 roles have valid labels, descriptions and hierarchy levels', () {
      for (final role in UserRole.values) {
        expect(role.label, isNotEmpty);
        expect(role.description, isNotEmpty);
        expect(role.hierarchyLevel, isPositive);
      }

      expect(UserRole.admin.isAdmin, isTrue);
      expect(UserRole.assistantChief.isAdmin, isFalse);
      expect(UserRole.groupChief.isAdmin, isFalse);
      expect(UserRole.officeClerk.isAdmin, isFalse);
      expect(UserRole.deskOfficer.isAdmin, isFalse);
      expect(UserRole.teamOfficer.isAdmin, isFalse);

      expect(UserRole.admin.hierarchyLevel, greaterThan(UserRole.assistantChief.hierarchyLevel));
      expect(UserRole.assistantChief.hierarchyLevel, greaterThan(UserRole.groupChief.hierarchyLevel));
      expect(UserRole.groupChief.hierarchyLevel, greaterThan(UserRole.officeClerk.hierarchyLevel));
      expect(UserRole.officeClerk.hierarchyLevel, greaterThan(UserRole.deskOfficer.hierarchyLevel));
      expect(UserRole.deskOfficer.hierarchyLevel, greaterThan(UserRole.teamOfficer.hierarchyLevel));
    });

    test('AccessScope labels are properly defined', () {
      for (final scope in AccessScope.values) {
        expect(scope.label, isNotEmpty);
      }
    });

    test('AppPermission labels are properly defined', () {
      for (final permission in AppPermission.values) {
        expect(permission.label, isNotEmpty);
      }
    });

    test('UserRole access scopes are mapped correctly', () {
      expect(PermissionEngine.getScope(UserRole.admin), AccessScope.all);
      expect(PermissionEngine.getScope(UserRole.assistantChief), AccessScope.all);
      expect(PermissionEngine.getScope(UserRole.officeClerk), AccessScope.all);
      expect(PermissionEngine.getScope(UserRole.groupChief), AccessScope.groupOrDuty);
      expect(PermissionEngine.getScope(UserRole.deskOfficer), AccessScope.dutyOnly);
      expect(PermissionEngine.getScope(UserRole.teamOfficer), AccessScope.selfOnly);
    });
  });
}
