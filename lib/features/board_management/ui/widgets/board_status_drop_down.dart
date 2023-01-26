import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_tracker/core/styles/app_sizes.dart';

import 'package:kanban_tracker/features/board_management/logic/board_bloc/board_bloc.dart';
import 'package:kanban_tracker/features/board_management/models/board_status/board_status.dart';

class BoardStatusDropDown extends StatefulWidget {
  const BoardStatusDropDown({
    super.key,
    required this.onSelect,
    this.preselectedStatus,
    this.onInit,
  });

  final void Function(BoardStatus selectedBoardStatus) onSelect;
  final void Function(BoardStatus selectedBoardStatus)? onInit;

  final BoardStatus? preselectedStatus;
  @override
  State<BoardStatusDropDown> createState() => _BoardStatusDropDownState();
}

class _BoardStatusDropDownState extends State<BoardStatusDropDown> {
  bool isInitialized = false;
  BoardStatus? localBoardStatus;

  @override
  void initState() {
    localBoardStatus = widget.preselectedStatus;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardBloc, BoardState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (tasks, listenedTask, statuses, boardId) {
            if (!isInitialized) {
              localBoardStatus ??= statuses.first;
              if (widget.onInit != null) {
                if (localBoardStatus == null) {
                  widget.onInit!(statuses.first);
                } else {
                  widget.onInit!(localBoardStatus!);
                }
              }
              isInitialized = true;
            }

            return Row(
              children: [
                Text(
                  'Task status',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(width: appPrimaryPadding),
                DropdownButton<BoardStatus>(
                  value: localBoardStatus,
                  items: List.generate(
                    statuses.length,
                    (index) => DropdownMenuItem(
                      value: statuses[index],
                      child: Text(statuses[index].title),
                    ),
                  ),
                  onChanged: (newBoardStatus) {
                    if (newBoardStatus?.id != localBoardStatus?.id) {
                      widget.onSelect(newBoardStatus!);
                      setState(() {
                        localBoardStatus = newBoardStatus;
                      });
                    }
                  },
                ),
              ],
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}
