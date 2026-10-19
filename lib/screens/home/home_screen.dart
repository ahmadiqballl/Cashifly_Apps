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
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top App Bar / Royal Header
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
                                gradient: AppColors.primaryButtonGradient,
                                border: Border.all(
                                  color: AppColors.primaryPurplePastel.withOpacity(0.5),
                                  width: 2,
                                ),
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified_rounded,
                                        size: 16, color: AppColors.neonCyan),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  DateFormatter.formatFull(DateTime.now()),
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Quick Add Button in header
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const AddTransactionSheet(),
                            );
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primaryPurple.withOpacity(0.4),
                              ),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              color: AppColors.primaryPurplePastel,
                              size: 22,
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

                      // 1. Total Keseluruhan Aset Card
                      TotalBalanceCard(
                        totalBalance: _txService.totalBalance,
                        totalIncome: _txService.totalIncome,
                        totalExpense: _txService.totalExpense,
                      ),

                      const SizedBox(height: 20),

                      // 2. Pemisahan per Dana Tabungan, Dana Darurat, dan Dana Panas
                      FundAllocationCard(service: _txService),

                      const SizedBox(height: 20),

                      // 3. Pemisahan Aset di Bank, E-Wallet, atau Cash
                      AccountStorageCard(service: _txService),

                      const SizedBox(height: 20),

                      // 4. Analisis Pendapatan dan Pengeluaran Per Minggu
                      WeeklyChartCard(service: _txService),

                      const SizedBox(height: 24),

                      // 5. Riwayat Transaksi Terakhir Header & Filter
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Transaksi Terkini',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Filter Chips
                          Row(
                            children: [
                              _buildFilterChip('Semua', null),
                              const SizedBox(width: 6),
                              _buildFilterChip('Keluar', TransactionType.expense),
                              const SizedBox(width: 6),
                              _buildFilterChip('Masuk', TransactionType.income),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      if (transactions.isEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 36),
                          child: const Center(
                            child: Column(
                              children: [
                                Icon(Icons.inbox_rounded,
                                    size: 48, color: AppColors.textMuted),
                                SizedBox(height: 8),
                                Text(
                                  'Belum ada transaksi',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 14,
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
                                  content: Text('Transaksi ${tx.title} dihapus'),
                                  backgroundColor: AppColors.surfaceElevated,
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

  Widget _buildFilterChip(String label, TransactionType? type) {
    final bool isSelected = _filterType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _filterType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryPurple.withOpacity(0.3)
              : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurplePastel : AppColors.surfaceBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textMuted,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

