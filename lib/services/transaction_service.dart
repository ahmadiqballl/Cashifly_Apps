import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction_model.dart';
import 'supabase_service.dart';

class WeeklySummary {
  final String weekLabel;
  final double income;
  final double expense;

  const WeeklySummary({
    required this.weekLabel,
    required this.income,
    required this.expense,
  });

  double get net => income - expense;
}

class TransactionService extends ChangeNotifier {
  static final TransactionService _instance = TransactionService._internal();
  factory TransactionService() => _instance;
  TransactionService._internal() {
    // Normal awal: Saldo Rp 0 (bersih) dan mengambil dari Supabase
    fetchFromSupabase();
  }

  final List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);


  /// Total Keseluruhan Aset Uang
  double get totalBalance {
    double total = 0;
    for (final tx in _transactions) {
      if (tx.type == TransactionType.income) {
        total += tx.amount;
      } else {
        total -= tx.amount;
      }
    }
    return total < 0 ? 0 : total;
  }

  /// Total Pemasukan
  double get totalIncome {
    return _transactions
        .where((tx) => tx.type == TransactionType.income)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  /// Total Pengeluaran
  double get totalExpense {
    return _transactions
        .where((tx) => tx.type == TransactionType.expense)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  /// Saldo per Kategori Dana (Dana Panas, Dana Darurat, Ditabung)
  double balanceForFund(FundCategory category) {
    double total = 0;
    for (final tx in _transactions.where((t) => t.fundCategory == category)) {
      if (tx.type == TransactionType.income) {
        total += tx.amount;
      } else {
        total -= tx.amount;
      }
    }
    return total < 0 ? 0 : total;
  }

  /// Persentase dari total aset untuk kategori dana
  double percentageForFund(FundCategory category) {
    final tb = totalBalance;
    if (tb <= 0) return 0.0;
    final b = balanceForFund(category);
    return (b / tb).clamp(0.0, 1.0);
  }

  /// Saldo per Tipe Penyimpanan (Bank, E-Wallet, Cash)
  double balanceForAccountType(AccountType type) {
    double total = 0;
    for (final tx in _transactions.where((t) => t.accountType == type)) {
      if (tx.type == TransactionType.income) {
        total += tx.amount;
      } else {
        total -= tx.amount;
      }
    }
    return total < 0 ? 0 : total;
  }

  /// Rincian per nama akun spesifik (misal: BCA: 4.5jt, Mandiri: 2jt)
  Map<String, double> getAccountBreakdown(AccountType type) {
    final Map<String, double> breakdown = {};
    for (final tx in _transactions.where((t) => t.accountType == type)) {
      final current = breakdown[tx.accountName] ?? 0.0;
      if (tx.type == TransactionType.income) {
        breakdown[tx.accountName] = current + tx.amount;
      } else {
        breakdown[tx.accountName] = current - tx.amount;
      }
    }
    // Filter saldo negatif untuk tampilan yang rapi
    breakdown.updateAll((key, val) => val < 0 ? 0 : val);
    return breakdown;
  }

  /// Analisis Pendapatan dan Pengeluaran per Minggu dalam bulan ini
  List<WeeklySummary> getWeeklyAnalysis() {
    final now = DateTime.now();
    // 4 Minggu dalam sebulan
    final List<WeeklySummary> weeks = [];

    for (int w = 1; w <= 4; w++) {
      final int startDay = (w - 1) * 7 + 1;
      final int endDay = (w == 4) ? 31 : w * 7;

      double income = 0;
      double expense = 0;

      for (final tx in _transactions) {
        // Cek apakah di bulan yang sama (atau data demo terkini)
        if (tx.date.month == now.month && tx.date.year == now.year) {
          if (tx.date.day >= startDay && tx.date.day <= endDay) {
            if (tx.type == TransactionType.income) {
              income += tx.amount;
            } else {
              expense += tx.amount;
            }
          }
        }
      }

      weeks.add(WeeklySummary(
        weekLabel: 'Mgg $w',
        income: income,
        expense: expense,
      ));
    }

    return weeks;
  }

  /// Mengambil data transaksi dari Supabase jika pengguna sudah login
  Future<void> fetchFromSupabase() async {
    if (!SupabaseConfig.isConfigured) return;

    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) return;

      final response = await client
          .from('transactions')
          .select()
          .eq('user_id', user.id)
          .order('date', ascending: false);

      if (response.isNotEmpty) {
        _transactions.clear();
        for (final item in response) {
          _transactions.add(TransactionModel.fromMap(item));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Catatan fetch Supabase: $e');
    }
  }

  /// Tambah Transaksi Baru (Simpan ke Memori & Supabase)
  Future<void> addTransaction(TransactionModel transaction) async {
    _transactions.insert(0, transaction);
    notifyListeners();

    if (SupabaseConfig.isConfigured) {
      try {
        final client = Supabase.instance.client;
        final user = client.auth.currentUser;
        
        final mapData = transaction.toMap();
        if (user != null) {
          mapData['user_id'] = user.id;
        } else {
          // Buang key user_id jika user belum login ke supabase auth
          mapData.remove('user_id');
        }

        await client.from('transactions').insert(mapData);
      } catch (e) {
        debugPrint('Catatan simpan ke Supabase: $e');
      }
    }
  }

  /// Hapus Transaksi (Hapus dari Memori & Supabase)
  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((tx) => tx.id == id);
    notifyListeners();

    if (SupabaseConfig.isConfigured) {
      try {
        final client = Supabase.instance.client;
        await client.from('transactions').delete().eq('id', id);
      } catch (e) {
        debugPrint('Catatan hapus dari Supabase: $e');
      }
    }
  }
}

