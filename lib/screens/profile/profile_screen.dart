import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../services/auth_service.dart';
import '../../services/supabase_service.dart';
import '../../services/transaction_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.surfaceBorder, width: 0.8),
          ),
          title: const Row(
            children: [
              Icon(CupertinoIcons.square_arrow_right, color: AppColors.rosePink, size: 22),
              SizedBox(width: 10),
              Text(
                'Konfirmasi Keluar',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: const Text(
            'Apakah Yang Mulia yakin ingin keluar dari aplikasi Cashifly?',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'Batal',
                style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rosePink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                Navigator.of(ctx).pop();
                await authService.signOut();
                TransactionService().clear();
              },
              child: const Text('Ya, Keluar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final txService = TransactionService();
    final user = authService.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // Top Title
              const Center(
                child: Text(
                  'Profil Akun',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Royal User Avatar Card (iOS Blue Card)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.iosBlue.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar with badge
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '👑',
                              style: TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.emeraldGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.checkmark_alt,
                            color: Colors.white,
                            size: 13,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // User Name
                    Text(
                      user?.name ?? 'Yang Mulia',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Email
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.mail_solid, color: Colors.white70, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          user?.email ?? 'pengguna@email.com',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Statistics Card (iOS White Grouped Card)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surfaceBorder, width: 0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      label: 'Total Saldo',
                      value: CurrencyFormatter.formatCompact(txService.totalBalance),
                      icon: CupertinoIcons.creditcard_fill,
                      color: AppColors.emeraldGreen,
                    ),
                    Container(width: 0.8, height: 38, color: AppColors.surfaceBorder),
                    _buildStatItem(
                      label: 'Transaksi',
                      value: '${txService.transactions.length}',
                      icon: CupertinoIcons.doc_plaintext,
                      color: AppColors.iosBlue,
                    ),
                    Container(width: 0.8, height: 38, color: AppColors.surfaceBorder),
                    _buildStatItem(
                      label: 'Status DB',
                      value: SupabaseConfig.isConfigured ? 'Tersambung' : 'Lokal (Siap)',
                      icon: CupertinoIcons.cloud_fill,
                      color: AppColors.iosBlue,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Information Card (iOS Grouped List)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surfaceBorder, width: 0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: CupertinoIcons.info_circle_fill,
                      title: 'Versi Aplikasi',
                      subtitle: 'Cashifly v1.0.0 (Release iOS Look)',
                    ),
                    const Divider(color: AppColors.surfaceBorder, height: 20, thickness: 0.8),
                    _buildInfoRow(
                      icon: Icons.storage_rounded,
                      title: 'Backend Database',
                      subtitle: 'Supabase PostgreSQL (Aktif)',
                    ),
                    const Divider(color: AppColors.surfaceBorder, height: 20, thickness: 0.8),
                    _buildInfoRow(
                      icon: CupertinoIcons.lock_shield_fill,
                      title: 'Metode Identitas',
                      subtitle: 'Email & Kata Sandi (Supabase Auth)',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Tombol Keluar (iOS Destructive Button)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => _showLogoutDialog(context, authService),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.rosePink, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: AppColors.rosePink.withOpacity(0.06),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.square_arrow_right, color: AppColors.rosePink, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Keluar dari Akun',
                        style: TextStyle(
                          color: AppColors.rosePink,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.iosBlueLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.iosBlue, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
