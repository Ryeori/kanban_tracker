import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kanban_tracker/core/models/app_user/app_user.dart';
import 'package:kanban_tracker/features/board/models/board_entity.dart';

part 'board_user.freezed.dart';
part 'board_user.g.dart';

@Freezed(toJson: true)
class BoardUser extends BoardEntity with _$BoardUser {
  const factory BoardUser({
    required String id,
    // @JsonKey(toJson: AppUser fromJson: AppUser.fromJson)
    required AppUser appUser,
    required String role,
    required String boardId,
  }) = _BoardUser;

  factory BoardUser.fromJson(Map<String, dynamic> json) =>
      _$BoardUserFromJson(json);
}
