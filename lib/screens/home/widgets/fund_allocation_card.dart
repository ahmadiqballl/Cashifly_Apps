import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/transaction_model.dart';
import '../../../services/transaction_service.dart';

class FundAllocationCard extends StatelessWidget {
  final TransactionService service;

  const FundAllocationCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final double panas = service.balanceForFund(FundCategory.danaPanas);
    final double darurat = service.balanceForFund(FundCategory.danaDarurat);
    final double tabungan = service.balanceForFund(FundCategory.tabungan);
    final double total = service.totalBalance;

    final double pctPanas = total > 0 ? (panas / total) : 0.0;
    final double pctDarurat = total > 0 ? (darurat / total) : 0.0;
    final double pctTabungan = total > 0 ? (tabungan / total) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.pie_chart_outline_rounded,
                      color: AppColors.primaryPurplePastel,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Pemisahan Pos Dana',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: const Text(
                  '3 Kategori',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Visual Segmented Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  if (pctPanas > 0)
                    Expanded(
                      flex: (pctPanas * 100).round().clamp(1, 100),
                      child: Container(color: AppColors.danaPanas),
                    ),
                  if (pctDarurat > 0)
                    Expanded(
                      flex: (pctDarurat * 100).round().clamp(1, 100),
                      child: Container(color: AppColors.danaDarurat),
                    ),
                  if (pctTabungan > 0)
                    Expanded(
                      flex: (pctTabungan * 100).round().clamp(1, 100),
                      child: Container(color: AppColors.danaTabungan),
                    ),
                  if (total <= 0)
                    Expanded(
                      child: Container(color: AppColors.surfaceBorder),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // 3 Item Cards: Dana Panas, Dana Darurat, Ditabung
          _buildFundItem(
            category: FundCategory.danaPanas,
            amount: panas,
            percentage: pctPanas,
            isDefault: true,
          ),
          const SizedBox(height: 10),
          _buildFundItem(
            category: FundCategory.danaDarurat,
            amount: darurat,
            percentage: pctDarurat,
          ),
          const SizedBox(height: 10),
          _buildFundItem(
            category: FundCategory.tabungan,
            amount: tabungan,
            percentage: pctTabungan,
          ),
        ],
      ),
    );
  }

  Widget _buildFundItem({
    required FundCategory category,
    required double amount,
    required double percentage,
    bool isDefault = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: category.color.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          // Icon badge
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              category.icon,
              color: category.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Info Title & Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      category.label,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (isDefault) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.amberOrange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Harian Normal',
                          style: TextStyle(
                            color: AppColors.amberOrange,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  category.description,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Amount & Percentage
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.format(amount),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${(percentage * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  color: category.color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

