import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_tracker/features/board/api/board_api.dart';
import 'package:kanban_tracker/features/board/api/firebase_board_api.dart';
import 'package:kanban_tracker/features/board/logic/board_bloc/board_bloc.dart';
import 'package:kanban_tracker/features/board/models/board/board.dart';

class BoardWrapper extends StatefulWidget {
  const BoardWrapper({super.key, required this.selectedBoard});

  final Board selectedBoard;

  @override
  State<BoardWrapper> createState() => _BoardHomePageState();
}

class _BoardHomePageState extends State<BoardWrapper> {
  late final BoardBloc boardBloc;
  late final BoardApi boardApi;

  @override
  void initState() {
    boardApi = FirebaseBoardApi();
    boardBloc = BoardBloc(boardApi, boardId: widget.selectedBoard.id);
    super.initState();
  }

  @override
  void dispose() {
    boardApi.dispose();
    boardBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => boardBloc..add(const BoardEvent.started()),
      child: const AutoRouter(),
    );
  }
}
