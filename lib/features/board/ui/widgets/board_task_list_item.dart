import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kanban_tracker/core/styles/app_sizes.dart';
import 'package:kanban_tracker/core/utils/date_format_utils.dart';
import 'package:kanban_tracker/features/board/models/board_task/board_task.dart';

class BoardTaskListItem extends StatelessWidget {
  const BoardTaskListItem({
    super.key,
    required this.boardTask,
    this.isCurrentTaskView = false,
  });

  final BoardTask boardTask;

  final bool isCurrentTaskView;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(appPrimaryPadding),
      decoration: BoxDecoration(
        borderRadius:
            isCurrentTaskView ? null : BorderRadius.circular(appBorderRadius),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCurrentTaskView)
            Text(
              'Active task',
              style:
                  Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 12),
            ),
          const SizedBox(height: appPrimaryPadding),
          Text(
            boardTask.title,
            style: Theme.of(context).textTheme.headline6?.copyWith(),
          ),
          const SizedBox(height: appPrimaryPadding),
          Text(
            boardTask.description.isNotEmpty
                ? boardTask.description
                : 'No desciption provided',
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(height: appPrimaryPadding * 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(appPrimaryPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Text(
                  boardTask.status.title,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (boardTask.finishedAt != null)
                    Text(
                      'Spent: ${boardTask.finishedAt!.difference(boardTask.startedAt!).toHhMmSs()}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  Text(
                    'Created at: ${DateFormat.yMd().add_jm().format(boardTask.createdAt)}',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  if (boardTask.finishedAt != null)
                    Text(
                      'Completed at: ${DateFormat.yMd().add_jm().format(boardTask.finishedAt!)}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
