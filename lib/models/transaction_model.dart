import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

enum TransactionType {
  expense,
  income;

  String get label => this == TransactionType.expense ? 'Pengeluaran' : 'Pendapatan';
  Color get color => this == TransactionType.expense ? AppColors.rosePink : AppColors.emeraldGreen;
  IconData get icon => this == TransactionType.expense ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded;
}

enum FundCategory {
  danaPanas,
  danaDarurat,
  tabungan;

  String get label {
    switch (this) {
      case FundCategory.danaPanas:
        return 'Dana Panas';
      case FundCategory.danaDarurat:
        return 'Dana Darurat';
      case FundCategory.tabungan:
        return 'Ditabung';
    }
  }

  String get description {
    switch (this) {
      case FundCategory.danaPanas:
        return 'Keperluan sehari-hari (aktif)';
      case FundCategory.danaDarurat:
        return 'Dana jaga-jaga darurat';
      case FundCategory.tabungan:
        return 'Tabungan masa depan';
    }
  }

  IconData get icon {
    switch (this) {
      case FundCategory.danaPanas:
        return Icons.local_fire_department_rounded;
      case FundCategory.danaDarurat:
        return Icons.shield_rounded;
      case FundCategory.tabungan:
        return Icons.savings_rounded;
    }
  }

  Color get color {
    switch (this) {
      case FundCategory.danaPanas:
        return AppColors.danaPanas;
      case FundCategory.danaDarurat:
        return AppColors.danaDarurat;
      case FundCategory.tabungan:
        return AppColors.danaTabungan;
    }
  }
}

enum AccountType {
  bank,
  eWallet,
  cash;

  String get label {
    switch (this) {
      case AccountType.bank:
        return 'Bank';
      case AccountType.eWallet:
        return 'E-Wallet';
      case AccountType.cash:
        return 'Cash';
    }
  }

  IconData get icon {
    switch (this) {
      case AccountType.bank:
        return Icons.account_balance_rounded;
      case AccountType.eWallet:
        return Icons.phone_android_rounded;
      case AccountType.cash:
        return Icons.payments_rounded;
    }
  }
}

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final FundCategory fundCategory;
  final AccountType accountType;
  final String accountName;
  final String category;
  final DateTime date;
  final String? notes;
  final String? userId;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.fundCategory,
    required this.accountType,
    required this.accountName,
    required this.category,
    required this.date,
    this.notes,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.name,
      'fund_category': fundCategory.name,
      'account_type': accountType.name,
      'account_name': accountName,
      'category': category,
      'date': date.toIso8601String(),
      'notes': notes,
      'user_id': userId,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id']?.toString() ?? UniqueKey().toString(),
      title: map['title'] as String? ?? 'Transaksi',
      amount: map['amount'] is num
          ? (map['amount'] as num).toDouble()
          : (double.tryParse(map['amount']?.toString() ?? '') ?? 0.0),
      type: (map['type'] == 'income') ? TransactionType.income : TransactionType.expense,
      fundCategory: FundCategory.values.firstWhere(
        (e) => e.name == map['fund_category'],
        orElse: () => FundCategory.danaPanas,
      ),
      accountType: AccountType.values.firstWhere(
        (e) => e.name == map['account_type'],
        orElse: () => AccountType.cash,
      ),
      accountName: map['account_name'] as String? ?? 'Cash',
      category: map['category'] as String? ?? 'Umum',
      date: map['date'] != null ? DateTime.parse(map['date'] as String) : DateTime.now(),
      notes: map['notes'] as String?,
      userId: map['user_id'] as String?,
    );
  }

  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    FundCategory? fundCategory,
    AccountType? accountType,
    String? accountName,
    String? category,
    DateTime? date,
    String? notes,
    String? userId,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      fundCategory: fundCategory ?? this.fundCategory,
      accountType: accountType ?? this.accountType,
      accountName: accountName ?? this.accountName,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      userId: userId ?? this.userId,
    );
  }
}

