import 'package:flutter/cupertino.dart';
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
  // Default Dana Panas
  FundCategory _selectedFund = FundCategory.danaPanas;
  AccountType _selectedAccountType = AccountType.bank;
  String _selectedAccountName = AppConstants.availableBanks.first;
  final String _selectedCategory = 'Makanan & Minuman';
  final DateTime _selectedDate = DateTime.now();

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
        SnackBar(
          content: const Text(
            'Nominal transaksi harus lebih dari Rp 0!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.rosePink,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            const Icon(CupertinoIcons.checkmark_circle_fill, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Transaksi ${_titleController.text.trim()} berhasil dicatat!',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
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
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // iOS Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 38,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D1D6),
                borderRadius: BorderRadius.circular(3),
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
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.xmark,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.surfaceBorder, thickness: 0.8),

          // Scrollable Form
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Tipe Transaksi: Pengeluaran vs Pendapatan (iOS Segmented Style)
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
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          CupertinoIcons.money_dollar,
                          color: AppColors.iosBlue,
                          size: 24,
                        ),
                        hintText: '0',
                        hintStyle: TextStyle(
                          color: AppColors.textMuted.withOpacity(0.5),
                          fontSize: 24,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Masukkan nominal transaksi';
                        }
                        return null;
                      },
                    ),

                    // Quick Nominal Chips (iOS Pill Style)
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [50000, 100000, 250000, 500000, 1000000].map((amt) {
                        return ActionChip(
                          label: Text(
                            '+ ${CurrencyFormatter.formatCompact(amt)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: AppColors.surfaceElevated,
                          side: const BorderSide(color: AppColors.surfaceBorder, width: 0.8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                        prefixIcon: Icon(
                          CupertinoIcons.pencil_ellipsis_rectangle,
                          color: AppColors.iosBlue,
                          size: 20,
                        ),
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

                    const SizedBox(height: 26),

                    // iOS Style Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryButtonGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.iosBlue.withOpacity(0.35),
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
                              Icon(CupertinoIcons.checkmark_alt, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Simpan Transaksi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.2,
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
        color: const Color(0xFFE5E5EA),
        borderRadius: BorderRadius.circular(14),
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
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedType == TransactionType.expense
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _selectedType == TransactionType.expense
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.arrow_up_right,
                      color: _selectedType == TransactionType.expense
                          ? AppColors.rosePink
                          : AppColors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Pengeluaran',
                      style: TextStyle(
                        color: _selectedType == TransactionType.expense
                            ? AppColors.rosePink
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
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
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedType == TransactionType.income
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _selectedType == TransactionType.income
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.arrow_down_left,
                      color: _selectedType == TransactionType.income
                          ? AppColors.emeraldGreen
                          : AppColors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Pendapatan',
                      style: TextStyle(
                        color: _selectedType == TransactionType.income
                            ? AppColors.emeraldGreen
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: EdgeInsets.only(right: fund != FundCategory.values.last ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? fund.color.withOpacity(0.12)
                        : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? fund.color : AppColors.surfaceBorder,
                      width: isSelected ? 1.5 : 0.8,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        fund.icon,
                        color: isSelected ? fund.color : AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        fund.label,
                        style: TextStyle(
                          color: isSelected ? fund.color : AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: EdgeInsets.only(right: type != AccountType.values.last ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.iosBlueLight
                        : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.iosBlue : AppColors.surfaceBorder,
                      width: isSelected ? 1.4 : 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        type.icon,
                        size: 16,
                        color: isSelected ? AppColors.iosBlue : AppColors.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        type.label,
                        style: TextStyle(
                          color: isSelected ? AppColors.iosBlue : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
            value: AppConstants.availableBanks.contains(_selectedAccountName)
                ? _selectedAccountName
                : AppConstants.availableBanks.first,
            dropdownColor: AppColors.surface,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            decoration: const InputDecoration(
              labelText: 'Pilih Bank',
              prefixIcon: Icon(CupertinoIcons.building_2_fill, color: AppColors.iosBlue, size: 20),
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
            value: AppConstants.availableEWallets.contains(_selectedAccountName)
                ? _selectedAccountName
                : AppConstants.availableEWallets.first,
            dropdownColor: AppColors.surface,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            decoration: const InputDecoration(
              labelText: 'Pilih E-Wallet',
              prefixIcon: Icon(CupertinoIcons.device_phone_portrait, color: AppColors.iosBlue, size: 20),
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
              border: Border.all(color: AppColors.surfaceBorder, width: 0.8),
            ),
            child: const Row(
              children: [
                Icon(CupertinoIcons.checkmark_circle_fill, color: AppColors.emeraldGreen, size: 18),
                SizedBox(width: 10),
                Text(
                  'Uang Tunai / Dompet Fisik',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
