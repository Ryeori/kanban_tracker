import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kanban_tracker/features/board_management/models/board/board.dart';
import 'package:kanban_tracker/features/board_management/models/board_status/board_status.dart';
import 'package:kanban_tracker/features/boards_overview/api/boards_overview_api.dart';
import 'package:uuid/uuid.dart';

part 'boards_overview_state.dart';
part 'boards_overview_cubit.freezed.dart';

@LazySingleton()
class BoardsOverviewCubit extends Cubit<BoardsOverviewState> {
  BoardsOverviewCubit(
    @Named('FirebaseBoardsOverviewApi') this._boardsOverviewApi,
  ) : super(const BoardsOverviewState.initial());

  final BoardsOverviewApi _boardsOverviewApi;

  Future<Board?> createNewBoard({
    required String title,
    required String boardUserId,
  }) async {
    //todo: move this creation logic into class or back end
    final List<String> defaultStatuses = ['to do', 'in progress', 'done'];
    try {
      final boardId = const Uuid().v4();

      final List<BoardStatus> statuses = [];
      for (var i = 0; i < defaultStatuses.length; i++) {
        statuses.add(
          BoardStatus(
            id: const Uuid().v4(),
            title: defaultStatuses[i],
            boardId: boardId,
            index: i,
          ),
        );
      }
      final createdBoard = await _boardsOverviewApi.createNewBoard(
        newBoard: Board(
          id: boardId,
          title: title,
          statuses: statuses,
          tasks: [],
          users: [boardUserId],
        ),
      );

      return createdBoard;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteBoard({required String boardId}) async {}
  Future<void> updateBoard({
    required String boardId,
    required Board updatedBoard,
  }) async {}
  Future<void> loadUserBoards({required String userId}) async {
    try {
      final userBoards =
          await _boardsOverviewApi.loadUserBoards(userId: userId);
      emit(BoardsOverviewState.loaded(userBoards: userBoards));
    } catch (e) {
      print(e);
      //TODO: Add error handler
      emit(const BoardsOverviewState.error());
    }
  }
}
