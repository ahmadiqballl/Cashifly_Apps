import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isRegisterMode = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    bool success;
    if (_isRegisterMode) {
      if (password != _confirmPasswordController.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Konfirmasi kata sandi tidak cocok!'),
            backgroundColor: AppColors.rosePink,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }

      success = await _authService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      );
    } else {
      success = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
    }

    if (!mounted) return;

    if (!success) {
      final msg = _authService.errorMessage ??
          (_isRegisterMode ? 'Gagal mendaftarkan akun.' : 'Email atau kata sandi salah.');

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.surfaceBorder, width: 0.8),
          ),
          title: Row(
            children: [
              const Icon(CupertinoIcons.info_circle_fill, color: AppColors.rosePink, size: 22),
              const SizedBox(width: 10),
              Text(
                _isRegisterMode ? 'Informasi Pendaftaran' : 'Gagal Masuk',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            msg,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: AppColors.iosBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background iOS Ambient Light Orbs
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.iosBlue.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emeraldGreen.withOpacity(0.06),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // iOS App Icon Box (Squircle)
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          gradient: AppColors.cardGradient,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.iosBlue.withOpacity(0.32),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '💸',
                            style: TextStyle(fontSize: 36),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Cashifly',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        _isRegisterMode
                            ? 'Buat akun baru untuk mulai mencatat keuangan'
                            : 'Masuk dengan email dan kata sandi Anda',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 22),

                      // iOS Segmented Mode Switcher: Masuk vs Daftar
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E5EA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isRegisterMode = false;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(vertical: 9),
                                  decoration: BoxDecoration(
                                    color: !_isRegisterMode ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: !_isRegisterMode
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.12),
                                              blurRadius: 4,
                                              offset: const Offset(0, 1),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Masuk',
                                      style: TextStyle(
                                        color: !_isRegisterMode
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isRegisterMode = true;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(vertical: 9),
                                  decoration: BoxDecoration(
                                    color: _isRegisterMode ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: _isRegisterMode
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.12),
                                              blurRadius: 4,
                                              offset: const Offset(0, 1),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Daftar Akun',
                                      style: TextStyle(
                                        color: _isRegisterMode
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Input Fields Card (iOS Clean White Surface)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.surfaceBorder, width: 0.8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nama Lengkap (Khusus Mode Daftar)
                            if (_isRegisterMode) ...[
                              const Text(
                                'Nama Lengkap',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _nameController,
                                style: const TextStyle(color: AppColors.textPrimary),
                                decoration: const InputDecoration(
                                  hintText: 'Misal: Budi Santoso',
                                  prefixIcon: Icon(
                                    CupertinoIcons.person_fill,
                                    color: AppColors.iosBlue,
                                    size: 18,
                                  ),
                                ),
                                validator: (val) {
                                  if (_isRegisterMode && (val == null || val.trim().isEmpty)) {
                                    return 'Nama lengkap harus diisi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Email Field
                            const Text(
                              'Alamat Email',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: const InputDecoration(
                                hintText: 'nama@email.com',
                                prefixIcon: Icon(
                                  CupertinoIcons.mail_solid,
                                  color: AppColors.iosBlue,
                                  size: 18,
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                if (!val.contains('@')) {
                                  return 'Format email tidak valid';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Kata Sandi Field
                            const Text(
                              'Kata Sandi',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                hintText: 'Minimal 6 karakter',
                                prefixIcon: const Icon(
                                  CupertinoIcons.lock_fill,
                                  color: AppColors.iosBlue,
                                  size: 18,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? CupertinoIcons.eye_slash_fill
                                        : CupertinoIcons.eye_fill,
                                    color: AppColors.textMuted,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Kata sandi tidak boleh kosong';
                                }
                                if (val.length < 6) {
                                  return 'Kata sandi minimal 6 karakter';
                                }
                                return null;
                              },
                            ),

                            // Konfirmasi Kata Sandi (Khusus Mode Daftar)
                            if (_isRegisterMode) ...[
                              const SizedBox(height: 16),
                              const Text(
                                'Konfirmasi Kata Sandi',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                style: const TextStyle(color: AppColors.textPrimary),
                                decoration: InputDecoration(
                                  hintText: 'Ulangi kata sandi Anda',
                                  prefixIcon: const Icon(
                                    CupertinoIcons.lock_shield_fill,
                                    color: AppColors.iosBlue,
                                    size: 18,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? CupertinoIcons.eye_slash_fill
                                          : CupertinoIcons.eye_fill,
                                      color: AppColors.textMuted,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword = !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (val) {
                                  if (_isRegisterMode && (val == null || val.trim().isEmpty)) {
                                    return 'Konfirmasi kata sandi harus diisi';
                                  }
                                  return null;
                                },
                              ),
                            ],

                            const SizedBox(height: 24),

                            // Submit Button (iOS Blue Button)
                            AnimatedBuilder(
                              animation: _authService,
                              builder: (context, _) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryButtonGradient,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.iosBlue.withOpacity(0.35),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: _authService.isLoading ? null : _submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: _authService.isLoading
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              _isRegisterMode
                                                  ? 'Daftar Sekarang'
                                                  : 'Masuk ke Akun',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                letterSpacing: -0.2,
                                              ),
                                            ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Tombol Mode Uji Coba Cepat (Yang Mulia 👑)
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: OutlinedButton(
                          onPressed: () {
                            _authService.signInDemo();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.surfaceBorder, width: 0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            backgroundColor: AppColors.surface,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('👑', style: TextStyle(fontSize: 15)),
                              SizedBox(width: 8),
                              Text(
                                'Masuk Cepat Mode Pengujian (Yang Mulia)',
                                style: TextStyle(
                                  color: AppColors.iosBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Database Status Footer
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.shield_fill, size: 14, color: AppColors.textMuted),
                          SizedBox(width: 6),
                          Text(
                            'Autentikasi Aman Supabase Database',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
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
        ],
      ),
    );
  }
}
