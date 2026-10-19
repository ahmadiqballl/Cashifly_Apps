import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/transaction_model.dart';
import '../../services/auth_service.dart';
import '../../services/transaction_service.dart';
import '../transaction/add_transaction_sheet.dart';
import 'widgets/account_storage_card.dart';
import 'widgets/fund_allocation_card.dart';
import 'widgets/total_balance_card.dart';
import 'widgets/transaction_tile.dart';
import 'widgets/weekly_chart_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TransactionService _txService = TransactionService();
  final AuthService _authService = AuthService();

  TransactionType? _filterType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _txService.fetchFromSupabase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_txService, _authService]),
      builder: (context, _) {
        final user = _authService.currentUser;
        final transactions = _txService.transactions.where((t) {
          if (_filterType == null) return true;
          return t.type == _filterType;
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // iOS Navigation Header / Royal Profile Row
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: AppColors.iosBlueLight,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  '👑',
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      user?.name ?? 'Yang Mulia',
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      CupertinoIcons.checkmark_seal_fill,
                                      size: 17,
                                      color: AppColors.iosBlue,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  DateFormatter.formatFull(DateTime.now()),
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Quick Add Button in header (iOS Clean Icon Button)
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const AddTransactionSheet(),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.surfaceBorder, width: 0.8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              CupertinoIcons.plus,
                              color: AppColors.iosBlue,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Main Content List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 6),

                      // 1. Total Keseluruhan Aset Card (Apple Wallet / Card Style)
                      TotalBalanceCard(
                        totalBalance: _txService.totalBalance,
                        totalIncome: _txService.totalIncome,
                        totalExpense: _txService.totalExpense,
                      ),

                      const SizedBox(height: 18),

                      // 2. Pemisahan per Dana Tabungan, Dana Darurat, dan Dana Panas
                      FundAllocationCard(service: _txService),

                      const SizedBox(height: 18),

                      // 3. Pemisahan Aset di Bank, E-Wallet, atau Cash
                      AccountStorageCard(service: _txService),

                      const SizedBox(height: 18),

                      // 4. Analisis Pendapatan dan Pengeluaran Per Minggu
                      WeeklyChartCard(service: _txService),

                      const SizedBox(height: 24),

                      // 5. Riwayat Transaksi Terakhir Header & iOS Segmented Filter
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Transaksi Terkini',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
                            ),
                          ),
                          // iOS Segmented Filter
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5E5EA),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                _buildSegmentItem('Semua', null),
                                _buildSegmentItem('Keluar', TransactionType.expense),
                                _buildSegmentItem('Masuk', TransactionType.income),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      if (transactions.isEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.surfaceBorder, width: 0.8),
                          ),
                          child: const Center(
                            child: Column(
                              children: [
                                Icon(
                                  CupertinoIcons.tray,
                                  size: 44,
                                  color: AppColors.textMuted,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Belum ada transaksi',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else ...[
                        ...transactions.map(
                          (tx) => TransactionTile(
                            transaction: tx,
                            onDelete: () {
                              _txService.deleteTransaction(tx.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Transaksi ${tx.title} dihapus',
                                    style: const TextStyle(color: AppColors.textPrimary),
                                  ),
                                  backgroundColor: AppColors.surface,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(color: AppColors.surfaceBorder),
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                      ],

                      const SizedBox(height: 80), // spacing for bottom nav & FAB
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSegmentItem(String label, TransactionType? type) {
    final bool isSelected = _filterType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _filterType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
