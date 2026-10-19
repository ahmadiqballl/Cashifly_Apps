class CurrencyFormatter {
  /// Format a numeric value to Indonesian Rupiah representation: e.g. "Rp 1.500.000"
  static String format(num amount, {bool includeSymbol = true}) {
    final bool isNegative = amount < 0;
    final int value = amount.abs().round();
    final String valueStr = value.toString();

    final StringBuffer buffer = StringBuffer();
    int count = 0;
    for (int i = valueStr.length - 1; i >= 0; i--) {
      buffer.write(valueStr[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }

    final String reversed = buffer.toString().split('').reversed.join('');
    final String prefix = isNegative ? '- ' : '';
    if (includeSymbol) {
      return '$prefix Rp $reversed';
    }
    return '$prefix$reversed';
  }

  /// Compact representation: e.g. "Rp 1.5 Jt" or "Rp 500 Rb"
  static String formatCompact(num amount) {
    final bool isNegative = amount < 0;
    final double absVal = amount.abs().toDouble();
    String formatted;

    if (absVal >= 1000000000) {
      final double b = absVal / 1000000000;
      formatted = '${b.toStringAsFixed(b.truncateToDouble() == b ? 0 : 1)} M';
    } else if (absVal >= 1000000) {
      final double m = absVal / 1000000;
      formatted = '${m.toStringAsFixed(m.truncateToDouble() == m ? 0 : 1)} Jt';
    } else if (absVal >= 1000) {
      final double k = absVal / 1000;
      formatted = '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)} Rb';
    } else {
      formatted = absVal.toInt().toString();
    }

    final String prefix = isNegative ? '- ' : '';
    return '$prefix Rp $formatted';
  }

  /// Parse user input string e.g. "1.500.000" or "Rp 50000" to double
  static double parse(String input) {
    final String cleaned = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) return 0.0;
    return double.tryParse(cleaned) ?? 0.0;
  }
}

