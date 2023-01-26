import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kanban_tracker/features/board/models/board_entity.dart';
import 'package:kanban_tracker/features/board/models/board_status/board_status.dart';
import 'package:kanban_tracker/features/board/models/board_user/board_user.dart';

part 'board_task.freezed.dart';
part 'board_task.g.dart';

@freezed
class BoardTask extends BoardEntity with _$BoardTask {
  const factory BoardTask({
    required String id,
    required String boardUserIdAssigTo,
    required String title,
    required String boardId,
    required String description,
    required DateTime createdAt,

    ///Time that user started a time tracker
    DateTime? startedAt,
    DateTime? finishedAt,
    required BoardStatus status,
    BoardUser? assignee,
  }) = _BoardTask;

  factory BoardTask.fromJson(Map<String, dynamic> json) =>
      _$BoardTaskFromJson(json);
}
