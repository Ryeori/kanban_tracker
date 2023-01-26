part of 'board_bloc.dart';

@freezed
class BoardState with _$BoardState {
  const factory BoardState.initial() = _Initial;
  const factory BoardState.loaded({
    required List<BoardTask> tasks,
    @Default(null) BoardTask? listenedTask,
    required List<BoardStatus> statuses,
    required String boardId,
  }) = _Loaded;
  const factory BoardState.loading() = _Loading;
}
