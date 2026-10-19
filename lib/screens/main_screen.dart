import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import 'transaction/add_transaction_sheet.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ProfileScreen(),
  ];

  void _openAddTransactionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTransactionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // iOS Style Floating Action Button for recording transactions
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTransactionSheet,
        elevation: 0,
        backgroundColor: Colors.transparent,
        highlightElevation: 0,
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            gradient: AppColors.primaryButtonGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.iosBlue.withOpacity(0.38),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(CupertinoIcons.plus, color: Colors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // iOS Style Translucent White Tab Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(
            top: BorderSide(color: AppColors.surfaceBorder, width: 0.8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Item 1: Beranda
                _buildNavItem(
                  index: 0,
                  label: 'Beranda',
                  icon: CupertinoIcons.house,
                  activeIcon: CupertinoIcons.house_fill,
                ),

                // Spacing for center docked FAB
                const SizedBox(width: 48),

                // Item 2: Profil
                _buildNavItem(
                  index: 1,
                  label: 'Profil',
                  icon: CupertinoIcons.person,
                  activeIcon: CupertinoIcons.person_fill,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final bool isSelected = _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.iosBlueLight
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? AppColors.iosBlue : AppColors.textMuted,
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.iosBlue : AppColors.textMuted,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
