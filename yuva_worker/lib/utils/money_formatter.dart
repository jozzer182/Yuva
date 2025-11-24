import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

String formatAmount(num value, BuildContext context) {
  final code = Localizations.localeOf(context).languageCode == 'en' ? 'en_US' : 'es_CO';
  final formatter = NumberFormat.decimalPattern(code);
  return formatter.format(value.round());
}
