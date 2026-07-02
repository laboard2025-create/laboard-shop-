import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final _dateFormat = DateFormat('yyyy/MM/dd');
  static final _dateTimeFormat = DateFormat('yyyy/MM/dd HH:mm');
  static final _currencyFormat = NumberFormat.currency(locale: 'zh_HK', symbol: r'HK$', decimalDigits: 0);

  static String date(DateTime? date) => date == null ? '-' : _dateFormat.format(date);

  static String dateTime(DateTime? date) => date == null ? '-' : _dateTimeFormat.format(date);

  static String currency(num? amount) => amount == null ? '-' : _currencyFormat.format(amount);
}
