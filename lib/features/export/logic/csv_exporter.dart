import 'dart:async';

abstract class CsvExporter {
  static FutureOr exportData<T>({
    required List<T> dataToExport,
    required void Function() onExportSuccessful,
  }) {}
}
