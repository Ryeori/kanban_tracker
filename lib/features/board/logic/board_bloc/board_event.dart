part of 'board_bloc.dart';

@freezed
class BoardEvent with _$BoardEvent {
  const factory BoardEvent.started() = _Started;
  const factory BoardEvent.addBoardTask({
    required BoardTask task,
    void Function()? onTaskAddCallback,
  }) = _AddBoardTask;
  const factory BoardEvent.updateBoardTask({
    required BoardTask task,
  }) = _UpdateBoardTask;
  const factory BoardEvent.stopTaskChangesListen() = _StopTaskChangesListen;
  const factory BoardEvent.startTaskChangesListen({
    required BoardTask task,
  }) = _StartTaskChangesListen;

  const factory BoardEvent.loadBoardTasks({
    @Default(10) int take,
    @Default(0) int skip,
  }) = _LoadBoardTasks;
}
