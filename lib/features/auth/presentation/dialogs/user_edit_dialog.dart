import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/dialogs/pgys_dialog.dart';
import '../../../../core/widgets/feedback/pgys_feedback.dart';
import '../../application/auth_state_provider.dart';
import '../../application/user_management_provider.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/user_role.dart';
import '../../domain/repositories/auth_repository.dart';

class UserEditDialog extends ConsumerStatefulWidget {
  final AppUser user;

  const UserEditDialog({super.key, required this.user});

  @override
  ConsumerState<UserEditDialog> createState() => _UserEditDialogState();
}

class _UserEditDialogState extends ConsumerState<UserEditDialog> {
  final _formKey = GlobalKey<FormState>();

  late UserRole _selectedRole;
  late final TextEditingController _groupController;
  late bool _isActive;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.user.role;
    _groupController = TextEditingController(text: widget.user.groupName ?? '');
    _isActive = widget.user.isActive;
  }

  @override
  void dispose() {
    _groupController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final currentAdmin = ref.read(currentUserProvider);
    if (widget.user.id == currentAdmin?.id && !_isActive) {
      PGYSFeedback.showWarning(
        context,
        'Kendi yönetici hesabınızı pasif duruma alamazsınız.',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(userManagementProvider.notifier).updateUser(
            widget.user.id,
            role: _selectedRole,
            groupName: _groupController.text.trim().isEmpty
                ? null
                : _groupController.text.trim(),
            isActive: _isActive,
          );

      if (mounted) {
        PGYSFeedback.showSuccess(
          context,
          '${widget.user.fullName} kullanıcısı güncellendi.',
        );
        Navigator.of(context).pop(true);
      }
    } on AuthException catch (e) {
      if (mounted) {
        PGYSFeedback.showError(context, e.message);
      }
    } catch (e) {
      if (mounted) {
        PGYSFeedback.showError(
          context,
          'Kullanıcı güncellenirken bir hata oluştu.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentAdmin = ref.read(currentUserProvider);
    final isSelf = widget.user.id == currentAdmin?.id;

    return PGYSDialog(
      title: 'Kullanıcı Düzenle: ${widget.user.fullName}',
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kullanıcı Adı / Sicil No (Salt Okunur)
              TextFormField(
                initialValue: widget.user.username,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı (Sicil No)',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Rol Seçimi
              DropdownButtonFormField<UserRole>(
                initialValue: _selectedRole,
                decoration: InputDecoration(
                  labelText: 'Sistem Yetki Rolü *',
                  prefixIcon: const Icon(Icons.security_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                isExpanded: true,
                items: UserRole.values.map((role) {
                  return DropdownMenuItem<UserRole>(
                    value: role,
                    child: Text(
                      role.label,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
                onChanged: isSelf
                    ? null
                    : (val) {
                        if (val != null) setState(() => _selectedRole = val);
                      },
              ),
              if (isSelf)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs, left: 12),
                  child: Text(
                    'Kendi rolünüzü değiştiremezsiniz.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),

              // Grup Adı
              TextFormField(
                controller: _groupController,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: 'Grup / Kısım / Ekip',
                  prefixIcon: const Icon(Icons.groups_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Aktiflik Durumu
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Hesap Aktif'),
                subtitle: Text(
                  _isActive
                      ? 'Kullanıcı sisteme giriş yapabilir.'
                      : 'Kullanıcı hesabı dondurulmuş, sisteme giremez.',
                ),
                value: _isActive,
                onChanged: (isSelf || _isLoading)
                    ? null
                    : (val) => setState(() => _isActive = val),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Butonlar
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.of(context).pop(false),
                    child: const Text('Vazgeç'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _handleSubmit,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_rounded, size: 18),
                    label: const Text('Değişiklikleri Kaydet'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
