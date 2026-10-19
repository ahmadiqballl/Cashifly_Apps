import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../services/transaction_service.dart';

class WeeklyChartCard extends StatelessWidget {
  final TransactionService service;

  const WeeklyChartCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final List<WeeklySummary> weeklyData = service.getWeeklyAnalysis();

    // Cari nilai maksimum untuk normalisasi tinggi grafik
    double maxVal = 100000;
    for (final w in weeklyData) {
      maxVal = max(maxVal, max(w.income, w.expense));
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.neonCyan.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.bar_chart_rounded,
                      color: AppColors.neonCyan,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Analisis Arus Kas Mingguan',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Legend
          Row(
            children: [
              _buildLegendDot(AppColors.emeraldGreen, 'Pendapatan'),
              const SizedBox(width: 16),
              _buildLegendDot(AppColors.primaryPurplePastel, 'Pengeluaran'),
            ],
          ),

          const SizedBox(height: 24),

          // Bar Chart Area
          SizedBox(
            height: 170,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: weeklyData.map((week) {
                final double incomeRatio = (week.income / maxVal).clamp(0.06, 1.0);
                final double expenseRatio = (week.expense / maxVal).clamp(0.06, 1.0);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Bars Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Income Bar
                        _buildBar(
                          height: 110 * incomeRatio,
                          color: AppColors.emeraldGreen,
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0xFF065F46),
                              AppColors.emeraldGreen,
                            ],
                          ),
                          tooltip: CurrencyFormatter.formatCompact(week.income),
                        ),
                        const SizedBox(width: 6),
                        // Expense Bar
                        _buildBar(
                          height: 110 * expenseRatio,
                          color: AppColors.primaryPurple,
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0xFF4C1D95),
                              AppColors.primaryPurplePastel,
                            ],
                          ),
                          tooltip: CurrencyFormatter.formatCompact(week.expense),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Week Label
                    Text(
                      week.weekLabel,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Net summary footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.insights_rounded, size: 16, color: AppColors.neonCyan),
                    SizedBox(width: 8),
                    Text(
                      'Rasio Finansial',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  service.totalIncome >= service.totalExpense ? 'Surplus Aman' : 'Defisit Terpantau',
                  style: TextStyle(
                    color: service.totalIncome >= service.totalExpense
                        ? AppColors.emeraldGreen
                        : AppColors.rosePink,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBar({
    required double height,
    required Color color,
    required LinearGradient gradient,
    required String tooltip,
  }) {
    return Column(
      children: [
        Text(
          tooltip,
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 18,
          height: height,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

