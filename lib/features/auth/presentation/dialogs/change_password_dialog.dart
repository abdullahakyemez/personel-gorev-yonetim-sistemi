import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/dialogs/pgys_dialog.dart';
import '../../../../core/widgets/feedback/pgys_feedback.dart';
import '../../application/auth_state_provider.dart';
import '../../domain/models/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class ChangePasswordDialog extends ConsumerStatefulWidget {
  final AppUser user;
  final bool isFirstLogin;

  const ChangePasswordDialog({
    super.key,
    required this.user,
    this.isFirstLogin = false,
  });

  @override
  ConsumerState<ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController(
      text: widget.isFirstLogin ? 'Pr123456' : '',
    );
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.changePassword(
        widget.user.id,
        _currentPasswordController.text,
        _newPasswordController.text,
      );

      // Oturumdaki aktif kullanıcının requiresPasswordChange bayrağını güncelle
      final updatedUser = widget.user.copyWith(requiresPasswordChange: false);
      ref.read(currentUserProvider.notifier).state = updatedUser;

      if (mounted) {
        PGYSFeedback.showSuccess(
          context,
          'Şifreniz başarıyla güncellendi.',
        );
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        PGYSFeedback.showError(context, e.message);
      }
    } catch (e) {
      if (mounted) {
        PGYSFeedback.showError(
          context,
          'Şifre güncellenirken beklenmedik bir hata oluştu.',
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

    return PopScope(
      canPop: !widget.isFirstLogin,
      child: PGYSDialog(
        title: widget.isFirstLogin
            ? 'İlk Giriş: Yeni Şifre Belirleme'
            : 'Şifre Değiştir',
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                if (widget.isFirstLogin) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.security_rounded,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Sistem güvenliğiniz için ilk girişinizde standart şifrenizi (Pr123456) değiştirmeniz zorunludur.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Mevcut Şifre
                TextFormField(
                  controller: _currentPasswordController,
                  enabled: !_isLoading,
                  obscureText: _obscureCurrent,
                  decoration: InputDecoration(
                    labelText: 'Mevcut Şifre',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureCurrent
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Mevcut şifrenizi giriniz.' : null,
                ),
                const SizedBox(height: AppSpacing.md),

                // Yeni Şifre
                TextFormField(
                  controller: _newPasswordController,
                  enabled: !_isLoading,
                  obscureText: _obscureNew,
                  decoration: InputDecoration(
                    labelText: 'Yeni Şifre',
                    hintText: 'En az 6 karakter',
                    prefixIcon: const Icon(Icons.key_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNew
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscureNew = !_obscureNew),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Yeni şifrenizi giriniz.';
                    }
                    if (v.trim().length < 6) {
                      return 'Şifre en az 6 karakter olmalıdır.';
                    }
                    if (v == 'Pr123456') {
                      return 'Yeni şifre standart ilk şifre (Pr123456) olamaz.';
                    }
                    if (v == _currentPasswordController.text) {
                      return 'Yeni şifreniz mevcut şifreniz ile aynı olamaz.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Yeni Şifre Tekrar
                TextFormField(
                  controller: _confirmPasswordController,
                  enabled: !_isLoading,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'Yeni Şifre Tekrar',
                    prefixIcon: const Icon(Icons.key_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  validator: (v) {
                    if (v != _newPasswordController.text) {
                      return 'Girdiğiniz şifreler eşleşmiyor.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // Butonlar
                Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    if (widget.isFirstLogin)
                      TextButton.icon(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                await ref
                                    .read(authControllerProvider.notifier)
                                    .logout();
                                if (context.mounted) {
                                  Navigator.of(context).maybePop(false);
                                }
                              },
                        icon: const Icon(Icons.logout_rounded, size: 18),
                        label: const Text('Çıkış Yap'),
                      )
                    else
                      OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.of(context).maybePop(false),
                        child: const Text('İptal'),
                      ),
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
                          : const Icon(Icons.check_circle_outline_rounded,
                              size: 18),
                      label: Text(
                        widget.isFirstLogin
                            ? 'Yeni Şifremi Kaydet'
                            : 'Şifreyi Güncelle',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}
