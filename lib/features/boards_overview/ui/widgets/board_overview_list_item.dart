import 'package:flutter/material.dart';
import 'package:kanban_tracker/core/styles/app_sizes.dart';
import 'package:kanban_tracker/features/board/models/board/board.dart';

class BoardOverviewListItem extends StatelessWidget {
  const BoardOverviewListItem({
    super.key,
    required this.board,
    required this.onTap,
  });

  final Board board;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: board.color,
        child: Padding(
          padding: const EdgeInsets.all(appPrimaryPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                board.title,
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
