import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_tracker/core/services/toast_service/toast_service.dart';
import 'package:kanban_tracker/core/styles/app_sizes.dart';
import 'package:kanban_tracker/core/utils/date_format_utils.dart';
import 'package:kanban_tracker/features/board_management/logic/board_bloc/board_bloc.dart';
import 'package:kanban_tracker/features/board_management/models/board_task/board_task.dart';
import 'package:kanban_tracker/features/board_management/ui/pages/board_home_page.dart';
import 'package:kanban_tracker/features/export/logic/board_data_csv_exporter.dart';

class CompletedTaskHistoryPage extends StatefulWidget {
  const CompletedTaskHistoryPage({super.key});

  @override
  State<CompletedTaskHistoryPage> createState() =>
      _CompletedTaskHistoryPageState();
}

class _CompletedTaskHistoryPageState extends State<CompletedTaskHistoryPage> {
  Future<void> onExportDataTap(List<BoardTask> dataToExport) async {
    await BoardDataCsvExporter.exportData(
      dataToExport: dataToExport,
      onExportSuccessful: (savedPath) {
        ToastService.showMessage(
          context,
          errorMessage: 'Your file saved into:\n\n$savedPath',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Board history'),
        leading: IconButton(
          onPressed: () {
            AutoRouter.of(context).pop();
          },
          icon: const Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.fromLTRB(
          appPrimaryPadding,
          appPrimaryPadding,
          appPrimaryPadding,
          appPrimaryPadding + MediaQuery.of(context).viewPadding.bottom,
        ),
        child: BlocBuilder<BoardBloc, BoardState>(
          builder: (context, state) {
            return state.maybeWhen(
              loaded: (tasks, listenedTask, statuses, boardId) {
                final finishedTasks = tasks
                    .where(
                      (task) =>
                          task.startedAt != null && task.finishedAt != null,
                    )
                    .toList();

                final totalTasksTime = finishedTasks.fold(
                  Duration.zero,
                  (previousValue, element) =>
                      element.finishedAt!.difference(element.startedAt!) +
                      previousValue,
                );
                return Column(
                  children: [
                    Text(
                      'Total time spent: ${totalTasksTime.toHhMmSs()}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const Divider(),
                    Expanded(
                      child: BoardStatusTaskSection(
                        tasks: finishedTasks,
                        currentTask: null,
                        onTaskTap: (tappedTask) {},
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onExportDataTap(finishedTasks);
                      },
                      child: const Text('Export data'),
                    )
                  ],
                );
              },
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}
