import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/transaction_model.dart';
import '../../services/transaction_service.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _customAccountController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  // Default Dana Panas sesuai instruksi Yang Mulia: "input normalnya yaa"
  FundCategory _selectedFund = FundCategory.danaPanas;
  AccountType _selectedAccountType = AccountType.bank;
  String _selectedAccountName = AppConstants.availableBanks.first;
  String _selectedCategory = 'Makanan & Minuman';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _updateDefaultAccountName();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _customAccountController.dispose();
    super.dispose();
  }

  void _updateDefaultAccountName() {
    if (_selectedAccountType == AccountType.bank) {
      _selectedAccountName = AppConstants.availableBanks.first;
    } else if (_selectedAccountType == AccountType.eWallet) {
      _selectedAccountName = AppConstants.availableEWallets.first;
    } else {
      _selectedAccountName = 'Cash (Uang Tunai)';
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final double amount = CurrencyFormatter.parse(_amountController.text);
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nominal transaksi harus lebih dari Rp 0!'),
          backgroundColor: AppColors.rosePink,
        ),
      );
      return;
    }

    String finalAccountName = _selectedAccountName;
    if ((_selectedAccountName == 'Bank Lainnya' ||
            _selectedAccountName == 'E-Wallet Lainnya') &&
        _customAccountController.text.trim().isNotEmpty) {
      finalAccountName = _customAccountController.text.trim();
    }

    final newTransaction = TransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      amount: amount,
      type: _selectedType,
      fundCategory: _selectedFund,
      accountType: _selectedAccountType,
      accountName: finalAccountName,
      category: _selectedCategory,
      date: _selectedDate,
    );

    TransactionService().addTransaction(newTransaction);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text('Transaksi ${_titleController.text.trim()} berhasil dicatat!'),
          ],
        ),
        backgroundColor: AppColors.emeraldGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Catat Transaksi Baru',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.surfaceBorder),

          // Scrollable Form
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Tipe Transaksi: Pengeluaran vs Pendapatan
                    _buildTypeToggle(),

                    const SizedBox(height: 18),

                    // 2. Input Nominal
                    const Text(
                      'Nominal (Rp)',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.money_rounded, color: AppColors.primaryPurplePastel),
                        hintText: '0',
                        hintStyle: TextStyle(
                          color: AppColors.textMuted.withValues(alpha: 0.5),
                          fontSize: 22,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Masukkan nominal transaksi';
                        }
                        return null;
                      },
                    ),

                    // Quick Nominal Chips
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [50000, 100000, 250000, 500000, 1000000].map((amt) {
                        return ActionChip(
                          label: Text(
                            '+ ${CurrencyFormatter.formatCompact(amt)}',
                            style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
                          ),
                          backgroundColor: AppColors.surfaceElevated,
                          side: const BorderSide(color: AppColors.surfaceBorder),
                          onPressed: () {
                            final current = CurrencyFormatter.parse(_amountController.text);
                            final total = current + amt;
                            _amountController.text = CurrencyFormatter.format(total, includeSymbol: false);
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 18),

                    // 3. Judul / Catatan
                    const Text(
                      'Keterangan / Catatan',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.edit_note_rounded, color: AppColors.primaryPurplePastel),
                        hintText: 'Misal: Makan Siang, Bensin, Tabungan Emas',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Keterangan tidak boleh kosong';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // 4. Pos Alokasi Dana (Dana Panas, Dana Darurat, Ditabung)
                    _buildFundAllocationSelector(),

                    const SizedBox(height: 20),

                    // 5. Tipe Penyimpanan (Bank, E-Wallet, Cash)
                    _buildAccountStorageSelector(),

                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryButtonGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryPurple.withValues(alpha: 0.4),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_rounded, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Simpan Transaksi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedType = TransactionType.expense;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedType == TransactionType.expense
                      ? AppColors.rosePink.withValues(alpha: 0.25)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedType == TransactionType.expense
                        ? AppColors.rosePink
                        : Colors.transparent,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_upward_rounded, color: AppColors.rosePink, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Pengeluaran',
                      style: TextStyle(
                        color: AppColors.rosePink,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedType = TransactionType.income;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedType == TransactionType.income
                      ? AppColors.emeraldGreen.withValues(alpha: 0.25)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedType == TransactionType.income
                        ? AppColors.emeraldGreen
                        : Colors.transparent,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_downward_rounded, color: AppColors.emeraldGreen, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Pendapatan',
                      style: TextStyle(
                        color: AppColors.emeraldGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundAllocationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Pos Alokasi Dana',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _selectedFund == FundCategory.danaPanas ? '(Default Normal)' : '',
              style: const TextStyle(
                color: AppColors.amberOrange,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: FundCategory.values.map((fund) {
            final isSelected = _selectedFund == fund;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFund = fund;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: fund != FundCategory.values.last ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? fund.color.withValues(alpha: 0.2)
                        : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? fund.color : AppColors.surfaceBorder,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(fund.icon, color: isSelected ? fund.color : AppColors.textSecondary, size: 20),
                      const SizedBox(height: 6),
                      Text(
                        fund.label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAccountStorageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipe Penyimpanan / Akun',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        // 3 Tipe: Bank, E-Wallet, Cash
        Row(
          children: AccountType.values.map((type) {
            final isSelected = _selectedAccountType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAccountType = type;
                    _updateDefaultAccountName();
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: type != AccountType.values.last ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryPurple.withValues(alpha: 0.25)
                        : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryPurplePastel : AppColors.surfaceBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(type.icon,
                          size: 16,
                          color: isSelected ? AppColors.primaryPurplePastel : AppColors.textMuted),
                      const SizedBox(width: 6),
                      Text(
                        type.label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 12),

        // Pilihan Nama Bank atau E-Wallet
        if (_selectedAccountType == AccountType.bank) ...[
          DropdownButtonFormField<String>(
            value: _selectedAccountName,
            dropdownColor: AppColors.surfaceElevated,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            decoration: const InputDecoration(
              labelText: 'Pilih Bank',
              prefixIcon: Icon(Icons.account_balance_rounded, color: AppColors.neonCyan),
            ),
            items: AppConstants.availableBanks.map((bank) {
              return DropdownMenuItem(
                value: bank,
                child: Text(bank),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedAccountName = val;
                });
              }
            },
          ),
          if (_selectedAccountName == 'Bank Lainnya') ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _customAccountController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Tulis nama bank Anda',
              ),
            ),
          ],
        ] else if (_selectedAccountType == AccountType.eWallet) ...[
          DropdownButtonFormField<String>(
            value: _selectedAccountName,
            dropdownColor: AppColors.surfaceElevated,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            decoration: const InputDecoration(
              labelText: 'Pilih E-Wallet',
              prefixIcon: Icon(Icons.phone_android_rounded, color: AppColors.neonCyan),
            ),
            items: AppConstants.availableEWallets.map((wallet) {
              return DropdownMenuItem(
                value: wallet,
                child: Text(wallet),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedAccountName = val;
                });
              }
            },
          ),
          if (_selectedAccountName == 'E-Wallet Lainnya') ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _customAccountController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Tulis nama E-Wallet Anda',
              ),
            ),
          ],
        ] else ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: AppColors.emeraldGreen, size: 18),
                SizedBox(width: 10),
                Text(
                  'Uang Tunai / Dompet Fisik',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

