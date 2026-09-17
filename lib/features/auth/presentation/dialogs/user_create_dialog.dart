import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/dialogs/pgys_dialog.dart';
import '../../../../core/widgets/feedback/pgys_feedback.dart';
import '../../../personnel/application/personnel_provider.dart';
import '../../../personnel/domain/models/personnel.dart';
import '../../application/user_management_provider.dart';
import '../../domain/models/user_role.dart';
import '../../domain/repositories/auth_repository.dart';

class UserCreateDialog extends ConsumerStatefulWidget {
  const UserCreateDialog({super.key});

  @override
  ConsumerState<UserCreateDialog> createState() => _UserCreateDialogState();
}

class _UserCreateDialogState extends ConsumerState<UserCreateDialog> {
  final _formKey = GlobalKey<FormState>();

  Personnel? _selectedPersonnel;
  UserRole _selectedRole = UserRole.teamOfficer;
  late final TextEditingController _groupController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _groupController = TextEditingController();
  }

  @override
  void dispose() {
    _groupController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPersonnel == null) {
      PGYSFeedback.showWarning(context, 'Lütfen kullanıcı için bir personel seçiniz.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(userManagementProvider.notifier).createUser(
            personnelId: _selectedPersonnel!.id,
            registryNumber: _selectedPersonnel!.registryNumber,
            fullName: _selectedPersonnel!.fullName,
            role: _selectedRole,
            groupName: _groupController.text.trim().isEmpty
                ? null
                : _groupController.text.trim(),
          );

      if (mounted) {
        PGYSFeedback.showSuccess(
          context,
          '${_selectedPersonnel!.fullName} için kullanıcı hesabı oluşturuldu. İlk şifre: Pr123456',
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
          'Kullanıcı oluşturulurken bir hata meydana geldi.',
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
    final personnelAsync = ref.watch(personnelListProvider);

    return PGYSDialog(
      title: 'Yeni Kullanıcı Hesabı Tanımla',
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bilgilendirme Kartı: Sicil No Kullanıcı Adı & Standart İlk Şifre
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Kurumsal Hesap Kuralları',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '• Kullanıcı adı personelin Sicil Numarası olacaktır.\n'
                      '• İlk şifre standart olarak "Pr123456" olarak atanır.\n'
                      '• Kullanıcı ilk giriş yaptığında yeni bir şifre belirlemek zorundadır.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Personel Seçimi
              personnelAsync.when(
                data: (personnelList) {
                  return DropdownButtonFormField<Personnel>(
                    initialValue: _selectedPersonnel,
                    decoration: InputDecoration(
                      labelText: 'Personel Seçiniz *',
                      prefixIcon: const Icon(Icons.person_search_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    isExpanded: true,
                    items: personnelList.map((person) {
                      return DropdownMenuItem<Personnel>(
                        value: person,
                        child: Text(
                          '${person.fullName} (Sicil: ${person.registryNumber}) - ${person.rank}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedPersonnel = val;
                        if (val != null && _groupController.text.isEmpty) {
                          _groupController.text = val.department;
                        }
                      });
                    },
                    validator: (v) =>
                        v == null ? 'Lütfen bir personel seçiniz.' : null,
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => Text(
                  'Personel listesi yüklenemedi: $e',
                  style: TextStyle(color: theme.colorScheme.error),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          role.label,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          role.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedRole = val);
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Grup Adı (Opsiyonel)
              TextFormField(
                controller: _groupController,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: 'Grup / Kısım / Ekip (İsteğe Bağlı)',
                  hintText: 'Örn: A Grubu, Asayiş Ekipler, vb.',
                  prefixIcon: const Icon(Icons.groups_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
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
                        : const Icon(Icons.person_add_alt_1_rounded, size: 18),
                    label: const Text('Kullanıcıyı Kaydet'),
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
