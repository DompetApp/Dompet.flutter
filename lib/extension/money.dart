import 'package:intl/intl.dart';

extension MoneyExtension on num {
  // ignore: non_constant_identifier_names
  String get USD {
    return 'USD. ${NumberFormat("#,##0.00").format(this)}';
  }

  String get usd {
    if (this >= 0) {
      return '\$${NumberFormat("#,##0").format(this)}';
    }

    return '-\$${NumberFormat("#,##0").format(-this)}';
  }
}
