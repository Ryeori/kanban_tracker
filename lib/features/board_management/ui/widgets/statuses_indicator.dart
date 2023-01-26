import 'package:flutter/material.dart';
import 'package:kanban_tracker/core/styles/app_sizes.dart';
import 'package:kanban_tracker/features/board_management/models/board_status/board_status.dart';

class StatusesIndicator extends StatefulWidget {
  const StatusesIndicator({
    super.key,
    required this.boardStatuses,
    required this.pageController,
    required this.onStatusTap,
  });

  final List<BoardStatus> boardStatuses;
  final PageController pageController;
  final void Function(BoardStatus tappedStatus) onStatusTap;

  @override
  State<StatusesIndicator> createState() => _StatusesIndicatorState();
}

class _StatusesIndicatorState extends State<StatusesIndicator> {
  final double textMaxFontSize = 20;

  @override
  void initState() {
    widget.pageController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: textMaxFontSize,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          widget.boardStatuses.length,
          (index) {
            final isSelected = widget.pageController.page?.round() ==
                widget.boardStatuses[index].index;
            return GestureDetector(
              onTap: () {
                widget.onStatusTap(widget.boardStatuses[index]);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: appPrimaryPadding),
                child: AnimatedDefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            height: 1,
                            fontSize: isSelected ? textMaxFontSize : null,
                            fontWeight: isSelected ? FontWeight.bold : null,
                          ) ??
                      const TextStyle(),
                  duration: const Duration(milliseconds: 350),
                  child: Text(
                    widget.boardStatuses[index].title,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
