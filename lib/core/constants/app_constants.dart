import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Cashifly';
  static const String appTagline = 'Kelola Keuangan Modern & Terarah';

  // Bank Options
  static const List<String> availableBanks = [
    'Bank BCA',
    'Bank Mandiri',
    'Bank BRI',
    'Bank BNI',
    'Bank Syariah Indonesia (BSI)',
    'Bank Jago',
    'CIMB Niaga',
    'Permata Bank',
    'Bank Danamon',
    'Blu by BCA',
    'Bank Lainnya',
  ];

  // E-Wallet Options
  static const List<String> availableEWallets = [
    'GoPay',
    'OVO',
    'DANA',
    'ShopeePay',
    'LinkAja',
    'AstraPay',
    'E-Wallet Lainnya',
  ];

  // Expense Categories
  static const List<Map<String, dynamic>> expenseCategories = [
    {'name': 'Makanan & Minuman', 'icon': Icons.restaurant_rounded},
    {'name': 'Transportasi', 'icon': Icons.directions_car_rounded},
    {'name': 'Belanja Harian', 'icon': Icons.shopping_bag_rounded},
    {'name': 'Tagihan & Utilitas', 'icon': Icons.receipt_long_rounded},
    {'name': 'Hiburan & Liburan', 'icon': Icons.sports_esports_rounded},
    {'name': 'Kesehatan', 'icon': Icons.medical_services_rounded},
    {'name': 'Pendidikan', 'icon': Icons.school_rounded},
    {'name': 'Lain-lain', 'icon': Icons.more_horiz_rounded},
  ];

  // Income Categories
  static const List<Map<String, dynamic>> incomeCategories = [
    {'name': 'Gaji Utama', 'icon': Icons.account_balance_wallet_rounded},
    {'name': 'Usaha / Bisnis', 'icon': Icons.storefront_rounded},
    {'name': 'Freelance / Proyek', 'icon': Icons.laptop_mac_rounded},
    {'name': 'Investasi & Dividen', 'icon': Icons.trending_up_rounded},
    {'name': 'Hadiah / Bonus', 'icon': Icons.card_giftcard_rounded},
    {'name': 'Pemasukan Lainnya', 'icon': Icons.add_circle_outline_rounded},
  ];
}

