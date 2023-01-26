import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kanban_tracker/features/board/models/board_entity.dart';

part 'board_role.freezed.dart';
part 'board_role.g.dart';

@freezed
class BoardRole extends BoardEntity with _$BoardRole {
  const factory BoardRole({
    required String id,
    required String title,
    required String color,
  }) = _BoardRole;

  factory BoardRole.fromJson(Map<String, dynamic> json) =>
      _$BoardRoleFromJson(json);
}
