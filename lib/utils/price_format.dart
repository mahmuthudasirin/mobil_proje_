/// "$2,499" veya 1299 gibi değerleri sayıya çevirir.
double parseAmount(Object? raw) {
  if (raw is num) return raw.toDouble();
  final text = (raw ?? '').toString().replaceAll(RegExp(r'[^0-9.,]'), '');
  if (text.isEmpty) return 0;
  if (text.contains(',') && !text.contains('.')) {
    final parts = text.split(',');
    if (parts.last.length == 3) {
      return double.parse(text.replaceAll(',', ''));
    }
  }
  return double.parse(text.replaceAll(',', '.'));
}

/// USD tutarını $2,499 biçiminde, diğerlerini TL biçiminde yazar.
String formatMoney(num value, String currency) {
  if (currency.toUpperCase() == 'USD') {
    final whole = value.round();
    final digits = whole.abs().toString();
    final grouped = StringBuffer(whole < 0 ? '-' : '');
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) grouped.write(',');
      grouped.write(digits[i]);
    }
    return '\$$grouped';
  }
  return formatTry(value);
}

/// Tutarı Türk lirası yazımına çevirir: 1299 -> 1.299 TL, 189.5 -> 189,50 TL.
String formatTry(num value) {
  final cents = (value.toDouble() * 100).round();
  final whole = cents ~/ 100;
  final fraction = cents.abs() % 100;
  final digits = whole.abs().toString();
  final grouped = StringBuffer();

  if (whole < 0) {
    grouped.write('-');
  }

  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      grouped.write('.');
    }
    grouped.write(digits[i]);
  }

  if (fraction == 0) {
    return '$grouped TL';
  }

  final fractionText = fraction.toString().padLeft(2, '0');
  return '$grouped,$fractionText TL';
}
