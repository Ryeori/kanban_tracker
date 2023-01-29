import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_tracker/core/styles/app_sizes.dart';
import 'package:kanban_tracker/features/authentication/logic/authentication_bloc/authentication_bloc.dart';
import 'package:kanban_tracker/features/board_management/logic/board_bloc/board_bloc.dart';
import 'package:kanban_tracker/features/board_management/models/board_status/board_status.dart';
import 'package:kanban_tracker/features/board_management/models/board_task/board_task.dart';
import 'package:kanban_tracker/features/board_management/ui/widgets/board_status_drop_down.dart';
import 'package:uuid/uuid.dart';

class TaskEditingPage extends StatefulWidget {
  const TaskEditingPage({
    super.key,
    this.taskToEdit,
    required this.isPopTopAfterSave,
  });

  final BoardTask? taskToEdit;
  final bool isPopTopAfterSave;

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
  DateTime? createdAt;
  BoardStatus? boardStatus;

  List<BoardStatus> abalibleStatuses = [];

  @override
  void initState() {
    taskId = widget.taskToEdit?.id ?? const Uuid().v4();
    titleController =
        TextEditingController(text: widget.taskToEdit?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.taskToEdit?.description ?? '');
    if (widget.taskToEdit != null) {
      boardStatus = widget.taskToEdit!.status;
      createdAt = widget.taskToEdit!.createdAt;
    }

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
      createdAt: createdAt ?? DateTime.now(),
      status: boardStatus!,
    );

    if (widget.taskToEdit != null) {
      BlocProvider.of<BoardBloc>(context).add(
        BoardEvent.updateBoardTask(
          task: newTask,
        ),
      );

      widget.isPopTopAfterSave
          ? AutoRouter.of(context).popUntilRoot()
          : AutoRouter.of(context).pop();
    } else {
      BlocProvider.of<BoardBloc>(context).add(
        BoardEvent.addBoardTask(
          task: newTask,
          onTaskAddCallback: () {
            widget.isPopTopAfterSave
                ? AutoRouter.of(context).popUntilRoot()
                : AutoRouter.of(context).pop();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: 'Title'),
                    ),
                    Expanded(
                      child: TextField(
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                            hintText: 'Description', border: InputBorder.none),
                      ),
                    ),
                    BoardStatusDropDown(
                      preselectedStatus: boardStatus,
                      onInit: (selectedBoardStatus) {
                        boardStatus ??= selectedBoardStatus;
                      },
                      onSelect: (selectedBoardStatus) {
                        boardStatus = selectedBoardStatus;
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: onTaskSave, child: const Text('SAVE')))
            ],
          ),
        ),
      ),
    );
  }
}
