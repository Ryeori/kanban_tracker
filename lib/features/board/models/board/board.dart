import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kanban_tracker/core/utils/json_converters/json_color_converter.dart';
import 'package:kanban_tracker/features/board/models/board_entity.dart';
import 'package:kanban_tracker/features/board/models/board_status/board_status.dart';
import 'package:kanban_tracker/features/board/models/board_task/board_task.dart';

part 'board.freezed.dart';
part 'board.g.dart';

@freezed
class Board extends BoardEntity with _$Board {
  const factory Board({
    required String id,
    required String title,
    @Default(<String>[]) @JsonKey(defaultValue: <String>[]) List<String> users,
    @Default(<BoardTask>[])
    @JsonKey(defaultValue: <BoardTask>[])
        List<BoardTask> tasks,
    @Default(<BoardStatus>[])
    @JsonKey(defaultValue: <BoardStatus>[])
        List<BoardStatus> statuses,
    @JsonKey(fromJson: JsonColorConverter.fromJson, toJson: JsonColorConverter.toJson, defaultValue: null)
        Color? color,
  }) = _Board;

  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);
}
