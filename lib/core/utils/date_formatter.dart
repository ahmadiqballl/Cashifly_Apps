class DateFormatter {
  static const List<String> _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  static const List<String> _monthsShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des'
  ];

  static const List<String> _days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

  /// Example: "Kamis, 15 Oktober 2026"
  static String formatFull(DateTime date) {
    final String dayName = _days[date.weekday - 1];
    final String monthName = _months[date.month - 1];
    return '$dayName, ${date.day} $monthName ${date.year}';
  }

  /// Example: "15 Okt 2026"
  static String formatShort(DateTime date) {
    final String monthName = _monthsShort[date.month - 1];
    return '${date.day} $monthName ${date.year}';
  }

  /// Example: "15 Okt"
  static String formatDayMonth(DateTime date) {
    final String monthName = _monthsShort[date.month - 1];
    return '${date.day} $monthName';
  }

  /// Get month name
  static String getMonthName(int month) {
    if (month >= 1 && month <= 12) {
      return _months[month - 1];
    }
    return '';
  }
}

