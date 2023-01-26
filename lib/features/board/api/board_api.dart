import 'dart:async';

import 'package:kanban_tracker/features/board/models/board_entity.dart';
import 'package:kanban_tracker/features/board/models/board_status/board_status.dart';
import 'package:kanban_tracker/features/board/models/board_task/board_task.dart';

abstract class BoardApi {
  Future<void> dispose();
  Future<List<BoardTask>> loadBoardTasks({required String boardId});
  Future<List<BoardStatus>> loadBoardStatuses({required String boardId});
  Future<bool> createBoardEntity({required BoardEntity boardEntity});
  Future<bool> updateBoardEntity({required BoardEntity boardEntity});
  Future deleteBoardEntity({required String boardEntityId});
  Stream<BoardEntity>? listenToBoardEntity<T>({
    required BoardEntity boardEntity,
  });
}
