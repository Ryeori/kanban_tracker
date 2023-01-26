part of 'boards_overview_cubit.dart';

@freezed
class BoardsOverviewState with _$BoardsOverviewState {
  const factory BoardsOverviewState.initial() = _Initial;
  const factory BoardsOverviewState.loaded({required List<Board> userBoards}) =
      _Loaded;
  const factory BoardsOverviewState.loading() = _Loading;
  const factory BoardsOverviewState.error() = _Error;
}
