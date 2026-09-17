import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/dialogs/pgys_confirm_dialog.dart';
import '../../../../core/widgets/feedback/pgys_feedback.dart';
import '../../application/auth_state_provider.dart';
import '../../application/user_management_provider.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/user_role.dart';
import '../../domain/repositories/auth_repository.dart';
import '../dialogs/user_create_dialog.dart';
import '../dialogs/user_edit_dialog.dart';

class UserManagementPage extends ConsumerStatefulWidget {
  const UserManagementPage({super.key});

  @override
  ConsumerState<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends ConsumerState<UserManagementPage> {
  String _searchQuery = '';
  UserRole? _roleFilter;
  bool? _statusFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usersAsync = ref.watch(userManagementProvider);
    final currentAdmin = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sayfa Başlığı ve Yeni Kullanıcı Butonu
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 650;
                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Kullanıcı Yönetimi',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sistem kullanıcı hesapları, yetki rolleri ve şifre yönetimi',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      FilledButton.icon(
                        onPressed: () => _openCreateUserDialog(context),
                        icon: const Icon(Icons.person_add_rounded, size: 20),
                        label: const Text('Yeni Kullanıcı Tanımla'),
                      ),
                    ],
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kullanıcı Yönetimi',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sistem kullanıcı hesapları, yetki rolleri ve şifre yönetimi',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    FilledButton.icon(
                      onPressed: () => _openCreateUserDialog(context),
                      icon: const Icon(Icons.person_add_rounded, size: 20),
                      label: const Text('Yeni Kullanıcı Tanımla'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Filtreleme ve Arama Çubuğu
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 700;

                  final searchField = TextField(
                    decoration: InputDecoration(
                      hintText: 'Sicil No veya İsimle Ara...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  );

                  final roleDropdown = DropdownButtonFormField<UserRole?>(
                    initialValue: _roleFilter,
                    isExpanded: true,
                    isDense: true,
                    decoration: InputDecoration(
                      labelText: 'Role Göre Filtrele',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Tüm Roller', overflow: TextOverflow.ellipsis),
                      ),
                      ...UserRole.values.map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text(r.label, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                    onChanged: (val) => setState(() => _roleFilter = val),
                  );

                  final statusDropdown = DropdownButtonFormField<bool?>(
                    initialValue: _statusFilter,
                    isExpanded: true,
                    isDense: true,
                    decoration: InputDecoration(
                      labelText: 'Hesap Durumu',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: null,
                        child: Text('Tümü', overflow: TextOverflow.ellipsis),
                      ),
                      DropdownMenuItem(
                        value: true,
                        child: Text('Yalnızca Aktif', overflow: TextOverflow.ellipsis),
                      ),
                      DropdownMenuItem(
                        value: false,
                        child: Text('Yalnızca Pasif', overflow: TextOverflow.ellipsis),
                      ),
                    ],
                    onChanged: (val) => setState(() => _statusFilter = val),
                  );

                  if (isNarrow) {
                    return Column(
                      children: [
                        searchField,
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(child: roleDropdown),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(child: statusDropdown),
                          ],
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(flex: 2, child: searchField),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(flex: 1, child: roleDropdown),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(flex: 1, child: statusDropdown),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Kullanıcı Tablosu
            Expanded(
              child: usersAsync.when(
                data: (users) {
                  final filtered = users.where((u) {
                    if (_roleFilter != null && u.role != _roleFilter) {
                      return false;
                    }
                    if (_statusFilter != null && u.isActive != _statusFilter) {
                      return false;
                    }
                    if (_searchQuery.isNotEmpty) {
                      final query = _searchQuery.toLowerCase();
                      final matchesName = u.fullName.toLowerCase().contains(query);
                      final matchesUsername = u.username.toLowerCase().contains(query);
                      return matchesName || matchesUsername;
                    }
                    return true;
                  }).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Kriterlere uygun kullanıcı bulunamadı.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      side: BorderSide(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 24,
                          horizontalMargin: 20,
                          columns: const [
                            DataColumn(label: Text('Sicil No (Kullanıcı Adı)')),
                            DataColumn(label: Text('Ad Soyad')),
                            DataColumn(label: Text('Rol')),
                            DataColumn(label: Text('Grup')),
                            DataColumn(label: Text('Şifre Durumu')),
                            DataColumn(label: Text('Durum')),
                            DataColumn(label: Text('Son Giriş')),
                            DataColumn(label: Text('İşlemler')),
                          ],
                          rows: filtered.map((user) {
                            final isSelf = user.id == currentAdmin?.id;

                            return DataRow(
                              cells: [
                                // Sicil No
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.badge_outlined,
                                        size: 16,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        user.username,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Ad Soyad
                                DataCell(
                                  Text(
                                    user.fullName,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                // Rol Rozeti
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getRoleBadgeColor(user.role).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _getRoleBadgeColor(user.role).withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Text(
                                      user.role.label,
                                      style: TextStyle(
                                        color: _getRoleBadgeColor(user.role),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                // Grup
                                DataCell(Text(user.groupName ?? '-')),
                                // Şifre Durumu
                                DataCell(
                                  user.requiresPasswordChange
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amber.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(
                                              color: Colors.amber.withValues(alpha: 0.4),
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.warning_amber_rounded,
                                                size: 14,
                                                color: Colors.amber,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                'İlk Şifre (Pr123456)',
                                                style: TextStyle(
                                                  color: Colors.brown,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const Text(
                                          'Belirlendi',
                                          style: TextStyle(color: Colors.green, fontSize: 12),
                                        ),
                                ),
                                // Durum
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (user.isActive ? Colors.green : Colors.red)
                                          .withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      user.isActive ? 'Aktif' : 'Pasif',
                                      style: TextStyle(
                                        color: user.isActive ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                // Son Giriş
                                DataCell(
                                  Text(
                                    user.lastLoginAt != null
                                        ? DateFormatter.formatDateTime(user.lastLoginAt!)
                                        : 'Giriş Yapılmadı',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                                // İşlemler
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Şifreyi Sıfırla
                                      IconButton(
                                        tooltip: 'Şifreyi Pr123456\'ya Sıfırla',
                                        icon: const Icon(
                                          Icons.lock_reset_rounded,
                                          size: 18,
                                          color: Colors.orange,
                                        ),
                                        onPressed: () => _handleResetPassword(user),
                                      ),
                                      // Düzenle
                                      IconButton(
                                        tooltip: 'Kullanıcıyı Düzenle',
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          size: 18,
                                          color: theme.colorScheme.primary,
                                        ),
                                        onPressed: () => _openEditUserDialog(context, user),
                                      ),
                                      // Sil (Kendi hesabını silemez)
                                      IconButton(
                                        tooltip: isSelf
                                            ? 'Kendi hesabınızı silemezsiniz'
                                            : 'Kullanıcıyı Sil',
                                        icon: Icon(
                                          Icons.delete_outline_rounded,
                                          size: 18,
                                          color: isSelf
                                              ? theme.disabledColor
                                              : theme.colorScheme.error,
                                        ),
                                        onPressed: isSelf
                                            ? null
                                            : () => _handleDeleteUser(
                                                  user,
                                                  currentAdmin!.id,
                                                ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Kullanıcılar yüklenemedi: $e',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleBadgeColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return const Color(0xFFC2185B);
      case UserRole.assistantChief:
        return const Color(0xFF7B1FA2);
      case UserRole.groupChief:
        return const Color(0xFF1976D2);
      case UserRole.officeClerk:
        return const Color(0xFF00796B);
      case UserRole.deskOfficer:
        return const Color(0xFFE65100);
      case UserRole.teamOfficer:
        return const Color(0xFF455A64);
    }
  }

  Future<void> _openCreateUserDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => const UserCreateDialog(),
    );
  }

  Future<void> _openEditUserDialog(BuildContext context, AppUser user) async {
    await showDialog(
      context: context,
      builder: (_) => UserEditDialog(user: user),
    );
  }

  Future<void> _handleResetPassword(AppUser user) async {
    final confirmed = await showPGYSConfirmDialog(
      context: context,
      title: 'Şifreyi Standart Şifreye Sıfırla',
      message:
          '${user.fullName} kullanıcısının şifresi standart ilk şifre olan "Pr123456" olarak sıfırlanacaktır. Kullanıcı ilk girişinde yeni bir şifre belirlemek zorunda olacaktır.',
      confirmText: 'Şifreyi Sıfırla',
      cancelText: 'Vazgeç',
      isDestructive: false,
      icon: Icons.lock_reset_rounded,
    );

    if (confirmed == true && mounted) {
      try {
        await ref
            .read(userManagementProvider.notifier)
            .resetPasswordToDefault(user.id);
        if (mounted) {
          PGYSFeedback.showSuccess(
            context,
            '${user.fullName} kullanıcısının şifresi "Pr123456" olarak sıfırlandı.',
          );
        }
      } on AuthException catch (e) {
        if (mounted) {
          PGYSFeedback.showError(context, e.message);
        }
      }
    }
  }

  Future<void> _handleDeleteUser(
    AppUser user,
    int currentAdminId,
  ) async {
    final confirmed = await showPGYSConfirmDialog(
      context: context,
      title: 'Kullanıcıyı Sil',
      message:
          '${user.fullName} (${user.username}) kullanıcı hesabı sistemden tamamen kaldırılacaktır. Devam etmek istiyor musunuz?',
      confirmText: 'Sil',
      cancelText: 'Vazgeç',
      isDestructive: true,
      icon: Icons.delete_forever_rounded,
    );

    if (confirmed == true && mounted) {
      try {
        await ref
            .read(userManagementProvider.notifier)
            .deleteUser(user.id, currentAdminId);
        if (mounted) {
          PGYSFeedback.showSuccess(
            context,
            '${user.fullName} kullanıcısı başarıyla silindi.',
          );
        }
      } on AuthException catch (e) {
        if (mounted) {
          PGYSFeedback.showError(context, e.message);
        }
      }
    }
  }
}
