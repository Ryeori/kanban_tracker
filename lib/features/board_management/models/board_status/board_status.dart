import 'package:kanban_tracker/features/board_management/models/board_entity.dart';
// ignore: directives_ordering
import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_status.freezed.dart';
part 'board_status.g.dart';

@freezed
class BoardStatus extends BoardEntity with _$BoardStatus {
  const factory BoardStatus({
    required String id,
    required int index,
    required String boardId,
    required String title,
  }) = _BoardStatus;

  factory BoardStatus.fromJson(Map<String, dynamic> json) =>
      _$BoardStatusFromJson(json);
}
