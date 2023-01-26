import 'dart:io';

import 'package:csv/csv.dart';
import 'package:kanban_tracker/core/utils/date_format_utils.dart';
import 'package:kanban_tracker/features/board_management/models/board_task/board_task.dart';
import 'package:kanban_tracker/features/export/logic/csv_exporter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BoardDataCsvExporter implements CsvExporter {
  static Future<String?> generateFilePath() async {
    try {
      late final Directory? directoryPath;

      directoryPath = Platform.isAndroid
          ? await getExternalStorageDirectory().then((directory) {
              return directory;
            })
          : await getApplicationDocumentsDirectory().then((directory) {
              return directory;
            });

      return '${directoryPath?.path}/exportedTasks_${DateTime.now()}.csv';
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<bool> saveFile(String filePath, String csvFile) async {
    final File fileToSave = File(filePath);
    try {
      final savedFile = await fileToSave.writeAsString(csvFile);
      print(savedFile);
      return true;
    } catch (e) {
      print(e);
      //TODO: ADD FILE SAVING ERROR HANDLING
    }
    return false;
  }

  static Future<bool> checkStoragePermission() async {
    try {
      final status = await Permission.storage.request();

      if (status.isGranted) {
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<void> exportData<T>({
    required List<BoardTask> dataToExport,
    required void Function(String savedPath) onExportSuccessful,
  }) async {
    try {
      final isStorageAccessGranted = await checkStoragePermission();
      if (isStorageAccessGranted) {
        final String csvFileData = const ListToCsvConverter().convert([
          ['id', 'title', 'started at', 'finished at', 'duration'],
          ...dataToExport.map((e) => [
                e.id,
                e.title,
                e.startedAt,
                e.finishedAt,
                e.finishedAt!.difference(e.startedAt!).toHhMmSs(),
              ])
        ]);

        final filePath = await generateFilePath();
        if (filePath?.isNotEmpty ?? false) {
          await saveFile(filePath!, csvFileData).then((isSaved) {
            if (isSaved) {
              onExportSuccessful(filePath);
            }
          });
        }
      } else {
        //TODO: ANN NOTIFICATION ABOUT PERMISSION DENIED
      }
    } catch (e) {}
  }
}
