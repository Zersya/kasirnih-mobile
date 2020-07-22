import 'package:intl/intl.dart';

NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id', decimalDigits: 0, name: 'Rp. ', symbol: 'Rp. ');

NumberFormat currencyFormatternoSym = NumberFormat.currency(
    locale: 'id', decimalDigits: 0, name: '', symbol: '');
