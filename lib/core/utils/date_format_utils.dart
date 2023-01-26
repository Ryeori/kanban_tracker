// ignore_for_file: unnecessary_this

import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_custom.dart';

extension DurationFormatter on Duration? {
  String toHhMmSs() => this.toString().split('.').first.padLeft(8, '0');
}

void initDateFormatting({required Locale locale}) {
  initializeDateFormattingCustom(locale: locale.languageCode);
}
