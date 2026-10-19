import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIncome = transaction.type == TransactionType.income;
    final Color amountColor = isIncome ? AppColors.emeraldGreen : AppColors.rosePink;
    final String amountPrefix = isIncome ? '+ ' : '- ';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Box (iOS Soft Tint Capsule)
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: isIncome
                  ? AppColors.emeraldGreen.withOpacity(0.12)
                  : AppColors.rosePink.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIncome ? CupertinoIcons.arrow_down_left : CupertinoIcons.arrow_up_right,
              color: isIncome ? AppColors.emeraldGreen : AppColors.rosePink,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),

          // Title & Detail info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    // Account Source Badge
                    Text(
                      transaction.accountName,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppColors.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    // Fund badge (iOS Pill)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: transaction.fundCategory.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        transaction.fundCategory.label,
                        style: TextStyle(
                          color: transaction.fundCategory.color,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormatter.formatDayMonth(transaction.date),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // Amount & Delete
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$amountPrefix${CurrencyFormatter.format(transaction.amount, includeSymbol: true)}',
                style: TextStyle(
                  color: amountColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              if (onDelete != null) ...[
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(
                    CupertinoIcons.trash,
                    color: AppColors.textMuted,
                    size: 16,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
