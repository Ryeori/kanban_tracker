import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_tracker/core/navigation/app_router.gr.dart';
import 'package:kanban_tracker/core/styles/app_sizes.dart';
import 'package:kanban_tracker/core/widgets/app_drawer.dart';
import 'package:kanban_tracker/features/board/logic/board_bloc/board_bloc.dart';
import 'package:kanban_tracker/features/board/models/board_task/board_task.dart';
import 'package:kanban_tracker/features/board/ui/widgets/board_task_list_item.dart';
import 'package:kanban_tracker/features/board/ui/widgets/statuses_indicator.dart';

class BoardHomePage extends StatefulWidget {
  const BoardHomePage({super.key});

  @override
  State<BoardHomePage> createState() => _BoardHomePageState();
}

class _BoardHomePageState extends State<BoardHomePage> {
  final PageController pageController = PageController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> onTaskAddTap() async {
    await AutoRouter.of(context).push(TaskEditingPageRoute());
  }

  void onTaskTap(BoardTask tappedTask, BoardTask? currentTask) {
    BlocProvider.of<BoardBloc>(context)
        .add(BoardEvent.startTaskChangesListen(task: tappedTask));
    AutoRouter.of(context).navigate(
      TaskDetailedPageRoute(
        isAvalibleToStartTracking: currentTask == null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: onTaskAddTap,
        child: const Icon(Icons.add),
      ),
      drawer: AppDrawer(scaffoldKey: scaffoldKey),
      appBar: AppBar(),
      body: BlocBuilder<BoardBloc, BoardState>(
        builder: (context, state) {
          return state.maybeWhen(
            loaded: (tasks, listenedTask, statuses, boardId) {
              final BoardTask? currentTask = tasks.firstWhereOrNull(
                (element) =>
                    element.startedAt != null && element.finishedAt == null,
              );
              return Column(
                children: [
                  if (currentTask != null)
                    InkWell(
                      onTap: () => onTaskTap(currentTask, currentTask),
                      child: BoardTaskListItem(
                        boardTask: currentTask,
                        isCurrentTaskView: true,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: appPrimaryPadding * 4),
                    child: StatusesIndicator(
                      boardStatuses: statuses,
                      pageController: pageController,
                    ),
                  ),
                  const SizedBox(height: appPrimaryPadding),
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: statuses.length,
                      itemBuilder: (context, index) {
                        return BoardStatusTaskSection(
                          currentTask: currentTask,
                          onTaskTap: (tappedTask) {
                            onTaskTap(tappedTask, currentTask);
                          },
                          tasks: tasks
                              .where(
                                (element) =>
                                    element.status.id == statuses[index].id,
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

class BoardStatusTaskSection extends StatefulWidget {
  const BoardStatusTaskSection({
    super.key,
    required this.tasks,
    required this.currentTask,
    required this.onTaskTap,
  });

  final List<BoardTask> tasks;
  final BoardTask? currentTask;
  final void Function(BoardTask tappedTask) onTaskTap;

  @override
  State<BoardStatusTaskSection> createState() => _BoardStatusTaskSectionState();
}

class _BoardStatusTaskSectionState extends State<BoardStatusTaskSection> {
  @override
  Widget build(BuildContext context) {
    if (widget.tasks.isEmpty) {
      return const Center(
        child: Text('You dont have tasks yet, would you like to craete one?'),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: appPrimaryPadding),
      child: ListView.separated(
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => widget.onTaskTap(widget.tasks[index]),
            child: BoardTaskListItem(
              boardTask: widget.tasks[index],
            ),
          );
        },
        separatorBuilder: (context, index) =>
            const SizedBox(height: appPrimaryPadding),
      ),
    );
  }
}
