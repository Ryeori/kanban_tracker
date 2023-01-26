import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:kanban_tracker/core/utils/firebase_boards_api_utils.dart';
import 'package:kanban_tracker/features/board_management/api/board_management_api.dart';
import 'package:kanban_tracker/features/board_management/models/board_entity.dart';
import 'package:kanban_tracker/features/board_management/models/board_status/board_status.dart';
import 'package:kanban_tracker/features/board_management/models/board_task/board_task.dart';

@Named('FirebaseBoardManagementApi')
@LazySingleton(as: BoardManagementApi)
class FirebaseBoardManagementApi implements BoardManagementApi {
  FirebaseBoardManagementApi() {
    _database = FirebaseFirestore.instance;
  }
  late final FirebaseFirestore _database;

  @override
  Future<bool> createBoardEntity({required BoardEntity boardEntity}) {
    if (boardEntity is BoardTask) {
      return _createBoardTask(boardTask: boardEntity);
    }
    return Future(() => false);
  }

  Future<bool> _createBoardTask({required BoardTask boardTask}) async {
    try {
      final taskReference =
          _database.collection(boardTaskApiPath).doc(boardTask.id);

      await taskReference
          .set(json.decode(json.encode(boardTask)) as Map<String, dynamic>);

      final updatedTask = await taskReference.get();
      if (updatedTask.id.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<void> deleteBoardEntity({required String boardEntityId}) {
    // TODO: implement deleteBoardEntity
    throw UnimplementedError();
  }

  @override
  Stream<BoardEntity>? listenToBoardEntity<T>({
    required BoardEntity boardEntity,
  }) {
    Stream<BoardEntity>? stream;
    if (boardEntity is BoardTask) {
      stream = _listenToBoardTask<BoardTask>(boardTaskId: boardEntity.id);
    }

    return stream;
  }

  Stream<BoardTask>? _listenToBoardTask<T>({
    required String boardTaskId,
  }) async* {
    final StreamTransformer<QuerySnapshot<Map<String, dynamic>>, BoardTask>
        transformer = StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        if (data.docChanges.first.type == DocumentChangeType.modified ||
            data.docChanges.first.type == DocumentChangeType.added) {
          sink.add(BoardTask.fromJson(data.docChanges.first.doc.data()!));
        }
      },
    );
    final taskReference = _database
        .collection(boardTaskApiPath)
        .where('id', isEqualTo: boardTaskId);
    final snapshotsStream = taskReference.snapshots();
    yield* snapshotsStream.transform(transformer);
  }

  @override
  Future<List<BoardTask>> loadBoardTasks({required String boardId}) async {
    try {
      final taskTasks = await _database
          .collection(boardTaskApiPath)
          .where('boardId', isEqualTo: boardId)
          .get();

      final List<BoardTask> response =
          taskTasks.docs.map((e) => BoardTask.fromJson(e.data())).toList();
      return response;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<BoardStatus>> loadBoardStatuses({required String boardId}) async {
    try {
      final boardStatuses = await _database
          .collection(boardStatusesApiPath)
          .where('boardId', isEqualTo: boardId)
          //todo: ADD ORDERING HERE
          .get();

      final List<BoardStatus> parsedStatuses =
          boardStatuses.docs.map((e) => BoardStatus.fromJson(e.data())).toList()
            ..sort(
              (a, b) => a.index.compareTo(b.index),
            );

      return parsedStatuses;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<bool> updateBoardEntity({required BoardEntity boardEntity}) {
    if (boardEntity is BoardTask) {
      return _updateBoardTask(boardEntity);
    }
    return Future(() => false);
  }

  Future<bool> _updateBoardTask(BoardTask boardTask) async {
    try {
      final taskReference =
          _database.collection(boardTaskApiPath).doc(boardTask.id);

      await taskReference
          .update(json.decode(json.encode(boardTask)) as Map<String, dynamic>);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<void> dispose() async {
    await _database.terminate();
  }
}
