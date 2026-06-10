import 'package:intl/intl.dart';

/// Kwanza (Kz) money formatting — the only currency in MAJU.
abstract class Money {
  static final NumberFormat _fmt = NumberFormat.decimalPattern('pt_PT');

  /// 450000 -> "450.000 Kz"
  static String kz(num value) => '${_fmt.format(value)} Kz';

  /// Compact form for tight cards: 1200000 -> "1,2 M Kz"
  static String kzShort(num value) {
    if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1).replaceAll('.', ',')} M Kz';
    }
    if (value.abs() >= 1000) {
      return '${(value / 1000).round()} k Kz';
    }
    return kz(value);
  }

  /// Parse user input "450.000" / "450000" -> 450000
  static num parse(String input) =>
      num.tryParse(input.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
}
