import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kanban_tracker/core/utils/date_format_utils.dart';

enum _TimerState { notStarted, running, finished }

class TimerButtons extends StatefulWidget {
  const TimerButtons({
    super.key,
    required this.onStartTap,
    required this.onFinishTap,
    required this.startedDate,
    required this.finishedDate,
  });

  final void Function() onStartTap;
  final void Function() onFinishTap;
  final DateTime? startedDate;
  final DateTime? finishedDate;

  @override
  State<TimerButtons> createState() => _TimerButtonsState();
}

class _TimerButtonsState extends State<TimerButtons> {
  late _TimerState timerState;
  DateTime? startTime;
  Timer? timer;
  Duration taskCompleteSecondsDuration = Duration.zero;

  @override
  void initState() {
    getTimerState();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TimerButtons oldWidget) {
    if (oldWidget.finishedDate != widget.finishedDate ||
        oldWidget.startedDate != widget.startedDate) {
      getTimerState();
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void getTimerState() {
    if (widget.startedDate == null && widget.finishedDate == null) {
      timerState = _TimerState.notStarted;
    } else if (widget.startedDate != null && widget.finishedDate == null) {
      startTime = widget.startedDate;
      timerState = _TimerState.running;
      startTimer();
      updateCurrentDuration();
    } else if (widget.startedDate != null && widget.finishedDate != null) {
      timerState = _TimerState.finished;
      updateCurrentDuration();
    } else {
      timerState = _TimerState.notStarted;
    }
  }

  void startTimer() {
    if (timerState == _TimerState.running) {
      startTime ??= DateTime.now();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(updateCurrentDuration);
      });
    }
  }

  void stopTimer() {
    if (timerState == _TimerState.running) {
      setState(() {
        taskCompleteSecondsDuration = DateTime.now().difference(startTime!);
      });
      timer?.cancel();
    }
  }

  String? tryFromatDuration(Duration? duration) {
    return duration.toHhMmSs();
  }

  void updateCurrentDuration() {
    taskCompleteSecondsDuration = Duration(
      seconds: (widget.finishedDate ?? DateTime.now())
          .difference(startTime ?? widget.startedDate!)
          .inSeconds,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (timerState) {
      case _TimerState.notStarted:
        return ElevatedButton(
          onPressed: () {
            widget.onStartTap();
            setState(() {
              timerState = _TimerState.running;
            });
            startTimer();
          },
          child: const Text('Start tracking'),
        );
      case _TimerState.running:
        //TODO: СДЕЛАТЬ КРАСИВО, ВЫНЕСТИ РАСЧЕТЫ В ОТДЕЛЬНЫЙ ВИДЖЕТ КНОПКУ ДЛЯ ОКОНЧАНИЯ
        final formattedDuration =
            tryFromatDuration(taskCompleteSecondsDuration);

        return ElevatedButton(
          onPressed: () {
            widget.onFinishTap();
            stopTimer();
            setState(() {
              timerState = _TimerState.finished;
            });
          },
          child: Text(
            'Finish tracking: $formattedDuration',
            textAlign: TextAlign.center,
          ),
        );
      case _TimerState.finished:
        return Text(
          'Task Completed in: ${tryFromatDuration(taskCompleteSecondsDuration)}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        );
    }
  }
}
