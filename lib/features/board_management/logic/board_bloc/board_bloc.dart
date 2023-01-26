// ignore_for_file: no_leading_underscores_for_local_identifiers, invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kanban_tracker/features/board_management/api/board_management_api.dart';
import 'package:kanban_tracker/features/board_management/models/board_entity.dart';
import 'package:kanban_tracker/features/board_management/models/board_status/board_status.dart';
import 'package:kanban_tracker/features/board_management/models/board_task/board_task.dart';

part 'board_bloc.freezed.dart';
part 'board_event.dart';
part 'board_state.dart';

@LazySingleton()
class BoardBloc extends Bloc<BoardEvent, BoardState> implements Disposable {
  BoardBloc(
    @Named('FirebaseBoardManagementApi') this._boardApi, {
    List<BoardTask> initialTasks = const [],
    List<BoardStatus> initialStatuses = const [],
    required this.boardId,
  }) : super(
          _Loaded(
            tasks: initialTasks,
            statuses: initialStatuses,
            boardId: boardId,
          ),
        ) {
    on<BoardEvent>((event, emit) {
      event.when(
        started: () async {
          await loadBoardTasks();
        },
        stopTaskChangesListen: onStopTaskChangesListen,
        startTaskChangesListen: onStartTaskChangesListen,
        addBoardTask: (task, onTaskAddCallback) =>
            onAddBoardTasks(task: task, onTaskAddCallback: onTaskAddCallback),
        loadBoardTasks: (take, skip) {},
        updateBoardTask: onUpdateBoardTask,
      );
    });
  }
  final String boardId;

  StreamSubscription<BoardEntity>? currentTaskChangesSubscription;

  final BoardManagementApi _boardApi;

  // Future<void> loadBoardUserData() async {}
  Future<void> loadBoardTasks() async {
    await _boardApi
        .loadBoardTasks(
      boardId: boardId,
    )
        .then((loadedTasks) async {
      final boardStatuses = await _loadBoardStatuses();
      if (loadedTasks.isNotEmpty) {
        if (state is _Loaded) {
          final _state = state as _Loaded;
          emit(
            _state.copyWith(
              tasks: [..._state.tasks, ...loadedTasks],
              statuses: boardStatuses,
            ),
          );
        }
      } else {
        emit(
          BoardState.loaded(
            tasks: loadedTasks,
            boardId: boardId,
            statuses: boardStatuses,
          ),
        );
      }
    });
  }

  Future<void> onStopTaskChangesListen() async {
    if (state is _Loaded) {
      await currentTaskChangesSubscription?.cancel().then((_) {
        final _state = state as _Loaded;

        emit(_state.copyWith(listenedTask: null));
      });
    }
  }

  Future<List<BoardStatus>> _loadBoardStatuses() async {
    return _boardApi
        .loadBoardStatuses(
          boardId: boardId,
        )
        .then((loadedStatuses) => loadedStatuses);
  }

  Future<void> onUpdateBoardTask(BoardTask task) async {
    await _boardApi.updateBoardEntity(boardEntity: task).then((isUpdated) {
      if (state is _Loaded) {
        final _state = state as _Loaded;

        final int taskToReplaceIndex =
            _state.tasks.indexWhere((e) => e.id == task.id);
        final updatedTasks = [..._state.tasks]
          ..removeAt(taskToReplaceIndex)
          ..insert(taskToReplaceIndex, task);

        emit(_state.copyWith(tasks: updatedTasks));
      }
    });
  }

  Future<void> onAddBoardTasks({
    required BoardTask task,
    void Function()? onTaskAddCallback,
  }) async {
    try {
      await _boardApi
          .createBoardEntity(boardEntity: task)
          .then((isTaskCreated) {
        if (isTaskCreated) {
          if (onTaskAddCallback != null) {
            onTaskAddCallback();
          }

          if (state is _Loaded) {
            final _state = state as _Loaded;
            emit(_state.copyWith(tasks: [..._state.tasks, task]));
          } else {
            emit(
              BoardState.loaded(
                tasks: [task],
                boardId: boardId,
                statuses: [],
              ),
            );
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> onStartTaskChangesListen(BoardTask task) async {
    if (state is _Loaded) {
      currentTaskChangesSubscription = _boardApi
          .listenToBoardEntity<BoardTask>(boardEntity: task)
          ?.listen((listenedTask) {
        emit(
          (state as _Loaded).copyWith(listenedTask: listenedTask as BoardTask),
        );
      });
    }
  }

  @override
  Future<void> onDispose() async {
// TODO: CLOSE ALL LISTENINGS FOR EVENTS
    await close();
  }
}

@module
abstract class RegisterBoardBlocModule {
  List<BoardTask> get initialTasks => const [];
  List<BoardStatus> get initialStatuses => const [];
}
