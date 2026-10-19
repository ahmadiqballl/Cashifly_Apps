import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/transaction_model.dart';
import '../../../services/transaction_service.dart';

class AccountStorageCard extends StatefulWidget {
  final TransactionService service;

  const AccountStorageCard({super.key, required this.service});

  @override
  State<AccountStorageCard> createState() => _AccountStorageCardState();
}

class _AccountStorageCardState extends State<AccountStorageCard> {
  AccountType _selectedType = AccountType.bank;

  @override
  Widget build(BuildContext context) {
    final double bankBalance = widget.service.balanceForAccountType(AccountType.bank);
    final double eWalletBalance = widget.service.balanceForAccountType(AccountType.eWallet);
    final double cashBalance = widget.service.balanceForAccountType(AccountType.cash);

    final Map<String, double> activeBreakdown = widget.service.getAccountBreakdown(_selectedType);

    return Container(
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.iosBlueLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      CupertinoIcons.building_2_fill,
                      color: AppColors.iosBlue,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Pemisahan Saldo & Akun',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceBorder, width: 0.8),
                ),
                child: const Text(
                  'Bank • E-Wallet • Cash',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 3 Tabs for Bank, E-Wallet, Cash (iOS Clean Segmented Style)
          Row(
            children: [
              _buildTypeTab(
                type: AccountType.bank,
                label: 'Bank',
                amount: bankBalance,
                icon: CupertinoIcons.building_2_fill,
              ),
              const SizedBox(width: 8),
              _buildTypeTab(
                type: AccountType.eWallet,
                label: 'E-Wallet',
                amount: eWalletBalance,
                icon: CupertinoIcons.device_phone_portrait,
              ),
              const SizedBox(width: 8),
              _buildTypeTab(
                type: AccountType.cash,
                label: 'Cash',
                amount: cashBalance,
                icon: CupertinoIcons.money_dollar_circle_fill,
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Details breakdown for the selected type
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceBorder, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rincian Saldo ${_selectedType.label}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${activeBreakdown.length} Akun Terdaftar',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (activeBreakdown.isEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        'Belum ada transaksi pada kategori ini',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ),
                  ),
                ] else ...[
                  ...activeBreakdown.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: AppColors.iosBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            CurrencyFormatter.format(entry.value),
                            style: const TextStyle(
                              color: AppColors.iosBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeTab({
    required AccountType type,
    required String label,
    required double amount,
    required IconData icon,
  }) {
    final bool isSelected = _selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.iosBlue : AppColors.surfaceBorder,
              width: isSelected ? 1.5 : 0.8,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.iosBlue.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.iosBlue : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.iosBlue : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.formatCompact(amount),
                style: TextStyle(
                  color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
