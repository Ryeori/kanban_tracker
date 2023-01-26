import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_tracker/core/styles/app_sizes.dart';
import 'package:kanban_tracker/features/board/logic/board_bloc/board_bloc.dart';
import 'package:kanban_tracker/features/board/models/board_status/board_status.dart';
import 'package:kanban_tracker/features/board/models/board_task/board_task.dart';
import 'package:kanban_tracker/features/board/ui/widgets/board_status_drop_down.dart';
import 'package:kanban_tracker/features/board/ui/widgets/timer_buttons.dart';

class TaskDetailedPage extends StatefulWidget {
  const TaskDetailedPage({
    super.key,
    required this.isAvalibleToStartTracking,
  });

  ///If there is already task tracked then false
  final bool isAvalibleToStartTracking;

  @override
  State<TaskDetailedPage> createState() => _TaskDetailedPageState();
}

class _TaskDetailedPageState extends State<TaskDetailedPage> {
  BoardStatus? currentBoardStatus;

  @override
  void deactivate() {
    BlocProvider.of<BoardBloc>(context)
        .add(const BoardEvent.stopTaskChangesListen());
    super.deactivate();
  }

  Future<void> onStatusUpdate(
    BoardStatus selectedBoardStatus,
    BoardTask task,
  ) async {
    await BlocProvider.of<BoardBloc>(context)
        .onUpdateBoardTask(task.copyWith(status: selectedBoardStatus));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BoardBloc, BoardState>(
        builder: (context, state) {
          return state.maybeWhen(
            loaded: (tasks, listenedTask, statuses, boardId) {
              if (listenedTask != null) {
                currentBoardStatus = listenedTask.status;
                return SafeArea(
                  minimum: const EdgeInsets.all(appPrimaryPadding),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Text(
                              listenedTask.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                  ),
                            ),
                            const SizedBox(height: appPrimaryPadding),
                            Text(
                              listenedTask.description.isNotEmpty
                                  ? listenedTask.description
                                  : 'No description has been provided',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            const Divider(),
                            BoardStatusDropDown(
                              preselectedStatus: currentBoardStatus,
                              onSelect: (selectedBoardStatus) {
                                onStatusUpdate(
                                  selectedBoardStatus,
                                  listenedTask,
                                );
                                setState(() {
                                  currentBoardStatus = selectedBoardStatus;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TimerButtons(
                          onStartTap: () {
                            BlocProvider.of<BoardBloc>(context).add(
                              BoardEvent.updateBoardTask(
                                task: listenedTask.copyWith(
                                  startedAt: DateTime.now(),
                                ),
                              ),
                            );
                          },
                          onFinishTap: () {
                            BlocProvider.of<BoardBloc>(context).add(
                              BoardEvent.updateBoardTask(
                                task: listenedTask.copyWith(
                                  finishedAt: DateTime.now(),
                                ),
                              ),
                            );
                          },
                          startedDate: listenedTask.startedAt,
                          finishedDate: listenedTask.finishedAt,
                        ),
                      )
                    ],
                  ),
                );
              }
              return const Text('no task has been loaded');
            },
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
