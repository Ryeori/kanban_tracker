import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_tracker/features/board_management/api/board_management_api.dart';
import 'package:kanban_tracker/features/board_management/api/firebase_board_management_api.dart';
import 'package:kanban_tracker/features/board_management/logic/board_bloc/board_bloc.dart';
import 'package:kanban_tracker/features/board_management/models/board/board.dart';

class BoardWrapper extends StatefulWidget {
  const BoardWrapper({super.key, required this.selectedBoard});

  final Board selectedBoard;

  @override
  State<BoardWrapper> createState() => _BoardHomePageState();
}

class _BoardHomePageState extends State<BoardWrapper> {
  late final BoardBloc boardBloc;
  late final BoardManagementApi boardApi;

  @override
  void initState() {
    boardApi = FirebaseBoardManagementApi();
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
