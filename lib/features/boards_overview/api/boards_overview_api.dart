import 'package:kanban_tracker/features/board_management/models/board/board.dart';

abstract class BoardsOverviewApi {
  Future<Board?> createNewBoard({required Board newBoard});
  Future<bool> deleteBoard({required String boardId});

  Future<Board?> updateBoard({required Board updateBoard});
  Future<List<Board>> loadUserBoards({required String userId});
}
