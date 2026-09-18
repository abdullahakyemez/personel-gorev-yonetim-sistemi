import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/feedback/pgys_feedback.dart';
import '../../application/auth_state_provider.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      await ref.read(authControllerProvider.notifier).login(username, password);

      if (mounted) {
        PGYSFeedback.showSuccess(
          context,
          'Başarıyla giriş yapıldı. Hoş geldiniz!',
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        PGYSFeedback.showError(context, e.message);
      }
    } catch (e) {
      if (mounted) {
        PGYSFeedback.showError(
          context,
          'Giriş yapılırken beklenmedik bir hata oluştu.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.lock_reset_rounded, color: Color(0xFF203A43)),
            SizedBox(width: 10),
            Text(
              'Şifremi Unuttum',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'PGYS kurumsal güvenlik politikası gereğince şifre sıfırlama işlemleri sistem yöneticisi (Büro Amiri) tarafından gerçekleştirilmektedir.\n\nLütfen Büro Amirliğinize başvurarak şifrenizin sıfırlanmasını talep ediniz.',
          style: TextStyle(height: 1.4),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0F2027),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Anlaşıldı'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F2027), // Koyu Lacivert
              Color(0xFF203A43), // Kurumsal Mavi
              Color(0xFF2C5364), // Daha açık Mavi
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 600;

              if (isDesktop) {
                // Masaüstü: Ekranın merkezinde odaklanmış modern login kartı
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 28),
                          _buildFormCard(isDesktop: true),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // Mobil: Üstte amblem ve başlık, altta yuvarlatılmış form alanı
              return Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: _buildHeader(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 32,
                      ),
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: _buildFormFields(isDesktop: false),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/logo_icon.png',
            height: 90,
            width: 90,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.shield,
              size: 72,
              color: Color(0xFF0F2027),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'PGYS',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'PERSONEL VE GÖREV\nYÖNETİMİ SİSTEMİ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard({required bool isDesktop}) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: _buildFormFields(isDesktop: isDesktop),
    );
  }

  Widget _buildFormFields({required bool isDesktop}) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'PERSONEL YÖNETİM PORTALI',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F2027),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Sisteme devam etmek için kimlik bilgilerinizi giriniz',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 22),

          // Sicil Numarası Alanı
          TextFormField(
            controller: _usernameController,
            enabled: !_isLoading,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            style: const TextStyle(
              color: Color(0xFF0F2027),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            cursorColor: const Color(0xFF203A43),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Sicil numaranızı giriniz';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Sicil Numarası',
              labelStyle: TextStyle(color: Colors.grey[700], fontSize: 14),
              floatingLabelStyle: const TextStyle(
                color: Color(0xFF203A43),
                fontWeight: FontWeight.bold,
              ),
              hintText: 'Sicil no giriniz',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: const Icon(
                Icons.badge_outlined,
                color: Color(0xFF203A43),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF203A43),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Şifre Alanı
          TextFormField(
            controller: _passwordController,
            enabled: !_isLoading,
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
            style: const TextStyle(
              color: Color(0xFF0F2027),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            cursorColor: const Color(0xFF203A43),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Şifrenizi giriniz';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Şifre',
              labelStyle: TextStyle(color: Colors.grey[700], fontSize: 14),
              floatingLabelStyle: const TextStyle(
                color: Color(0xFF203A43),
                fontWeight: FontWeight.bold,
              ),
              hintText: '••••••••',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Color(0xFF203A43),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[700],
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF203A43),
                  width: 2,
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _showForgotPasswordDialog,
              child: const Text(
                'Şifremi Unuttum',
                style: TextStyle(
                  color: Color(0xFFD32F2F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Giriş Butonu
          ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F2027),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              elevation: 5,
              shadowColor: const Color(0xFF0F2027).withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'GİRİŞ YAP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
          ),

          const SizedBox(height: 20),

          // Alt Bilgi
          Center(
            child: Text(
              '© 2026 Emniyet Teşkilatı',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

