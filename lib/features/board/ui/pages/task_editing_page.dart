import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_tracker/core/styles/app_sizes.dart';
import 'package:kanban_tracker/features/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:kanban_tracker/features/board/logic/board_bloc/board_bloc.dart';
import 'package:kanban_tracker/features/board/models/board_status/board_status.dart';
import 'package:kanban_tracker/features/board/models/board_task/board_task.dart';
import 'package:kanban_tracker/features/board/ui/widgets/board_status_drop_down.dart';
import 'package:uuid/uuid.dart';

class TaskEditingPage extends StatefulWidget {
  const TaskEditingPage({
    super.key,
    this.taskToEdit,
  });

  final BoardTask? taskToEdit;

  @override
  State<TaskEditingPage> createState() => _TaskEditingPageState();
}

class _TaskEditingPageState extends State<TaskEditingPage> {
  late final String taskId;
  late final String boardId;
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final DateTime? startedAt;
  late final DateTime? finishedAt;
  late BoardStatus boardStatus;

  late final List<BoardStatus> abalibleStatuses;

  @override
  void initState() {
    taskId = widget.taskToEdit?.id ?? const Uuid().v4();
    titleController =
        TextEditingController(text: widget.taskToEdit?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.taskToEdit?.description ?? '');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<BoardBloc>(context).state.maybeWhen(
          loaded: (tasks, listenedTask, statuses, _boardId) {
            abalibleStatuses = statuses;
            boardId = widget.taskToEdit?.boardId ?? _boardId;
          },
          orElse: () => [],
        );

    super.didChangeDependencies();
  }

  Future<void> onTaskSave() async {
    final userBoardId =
        BlocProvider.of<AuthenticationBloc>(context).state.maybeWhen(
              signedIn: (user) => user.id,
              orElse: () => '',
            );
    final newTask = BoardTask(
      id: taskId, boardUserIdAssigTo: userBoardId, boardId: boardId,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      //TODO: ADD TIMEZONES
      createdAt: DateTime.now(),
      status: boardStatus,
    );
    BlocProvider.of<BoardBloc>(context).add(
      BoardEvent.addBoardTask(
        task: newTask,
        onTaskAddCallback: () {
          AutoRouter.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.fromLTRB(
          appPrimaryPadding,
          appPrimaryPadding,
          appPrimaryPadding,
          appPrimaryPadding + MediaQuery.of(context).viewPadding.bottom,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(hintText: 'Description'),
                    maxLines: 15,
                  ),
                  const Divider(),
                  BoardStatusDropDown(
                    onInit: (selectedBoardStatus) {
                      boardStatus = selectedBoardStatus;
                    },
                    onSelect: (selectedBoardStatus) {
                      boardStatus = selectedBoardStatus;
                    },
                  )
                ],
              ),
            ),
            ElevatedButton(onPressed: onTaskSave, child: const Text('SAVE'))
          ],
        ),
      ),
    );
  }
}
