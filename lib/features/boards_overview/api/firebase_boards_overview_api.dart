import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:kanban_tracker/core/models/app_user/app_user.dart';
import 'package:kanban_tracker/core/utils/firebase_boards_api_utils.dart';
import 'package:kanban_tracker/features/board_management/models/board/board.dart';
import 'package:kanban_tracker/features/board_management/models/board_user/board_user.dart';

import 'package:kanban_tracker/features/boards_overview/api/boards_overview_api.dart';
import 'package:uuid/uuid.dart';

@Named('FirebaseBoardsOverviewApi')
@LazySingleton(as: BoardsOverviewApi)
class FirebaseBoardsOverviewApi extends BoardsOverviewApi {
  FirebaseBoardsOverviewApi() {
    _database = FirebaseFirestore.instance;
  }

  late final FirebaseFirestore _database;

  @override
  Future<Board?> createNewBoard({required Board newBoard}) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser?.uid.isNotEmpty ?? false) {
        final boardReference =
            _database.collection('/$boardsApiPath').doc(newBoard.id);
        final jsonDecodedBoard =
            json.decode(json.encode(newBoard)) as Map<String, dynamic>;
        await boardReference.set(jsonDecodedBoard);
        final fetchedBoard = await boardReference.get();
        if (fetchedBoard.id.isNotEmpty) {
          final BoardUser newBoardUser = BoardUser(
            id: const Uuid().v4(),
            appUser:
                AppUser(id: currentUser!.uid, email: currentUser.email ?? ''),
            role: '',
            boardId: newBoard.id,
          );
          await _createNewBoardUser(
            newBoardUser: newBoardUser,
            boardId: newBoard.id,
          );

          await _createNewBoardStatuses(newBoard: newBoard);
          return newBoard;
        }
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> _createNewBoardStatuses({required Board newBoard}) async {
    final firestoreBatch = _database.batch();
    for (var i = 0; i < newBoard.statuses.length; i++) {
      final boardReference = _database
          .collection('/$boardStatusesApiPath')
          .doc(newBoard.statuses[i].id);
      firestoreBatch.set(
        boardReference,
        json.decode(json.encode(newBoard.statuses[i])),
      );
    }
    try {
      await firestoreBatch.commit();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<BoardUser?> _createNewBoardUser({
    required BoardUser newBoardUser,
    required String boardId,
  }) async {
    try {
      final boardReference =
          _database.collection('/$boardUsersApiPath').doc(newBoardUser.id);
      await boardReference
          .set(json.decode(json.encode(newBoardUser)) as Map<String, dynamic>);
      return await boardReference.get().then((value) {
        if (value.id.isNotEmpty) {
          return newBoardUser;
        }
        return null;
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> deleteBoard({required String boardId}) {
    // TODO: implement deleteBoard
    throw UnimplementedError();
  }

  @override
  Future<List<Board>> loadUserBoards({required String userId}) async {
    try {
      final boardReference = await _database
          .collection('/$boardsApiPath')
          .where('users', arrayContains: userId)
          .get();

      return boardReference.docs.map((e) => Board.fromJson(e.data())).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Board?> updateBoard({required Board updateBoard}) {
    // TODO: implement updateBoard
    throw UnimplementedError();
  }
}
