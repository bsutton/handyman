import 'dart:async';

import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';
import 'package:intl/intl.dart';

import '../dao/dao_time_entry.dart';
import '../entity/task.dart';
import '../entity/time_entry.dart';
import '../util/format.dart';
import 'hmb_text.dart';
import 'hmb_text_area.dart';
import 'hmb_text_field.dart';

final _dateTimeFormat = DateFormat('yyyy-MM-dd hh:mm a');

/// Display a control that lets you start/stop and time
/// entry as well as displaying the elapsed time.
class HMBTimeEntryController extends StatefulWidget {
  const HMBTimeEntryController({required this.task, super.key});
  @override
  State<StatefulWidget> createState() => HMBTimeEntryControllerState();

  final Task? task;
}

class HMBTimeEntryControllerState extends State<HMBTimeEntryController> {
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  late Future<TimeEntry?> _initialEntry;
  TimeEntry? timeEntry;

  @override
  void initState() {
    super.initState();
    // ignore: discarded_futures
    _initialEntry = DaoTimeEntry().getActiveEntry();
    // ignore: discarded_futures
    _initialEntry.then((entry) {
      setState(() {
        timeEntry = entry;
        _initTimer(entry);
      });
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilderEx(
      future: _initialEntry,
      builder: (context, _) => Row(
            children: [
              IconButton(
                icon: Icon(timeEntry != null ? Icons.stop : Icons.play_arrow),
                onPressed: () async => _toggleTimer(timeEntry),
              ),
              _buildElapsedTime(timeEntry)
            ],
          ));

  Future<void> _toggleTimer(TimeEntry? timeEntry) async {
    if (timeEntry == null) {
      // Insert new TimeEntry to start tracking time
      timeEntry = TimeEntry.forInsert(
        taskId: widget.task!.id,
        startTime: DateTime.now(),
      );

      await DaoTimeEntry().insert(timeEntry);
      setState(() {
        _startTimer(timeEntry!);
      });
    } else {
      // Update the last TimeEntry to stop tracking time
      // final entries = await DaoTimeEntry().getByTask(widget.task);
      // final ongoingEntry =
      //     entries.lastWhereOrNull((entry) => entry.endTime == null);
      // if (ongoingEntry == null) {
      //   return;
      // }
      await DaoTimeEntry().update(TimeEntry.forUpdate(
        entity: timeEntry,
        taskId: widget.task!.id,
        startTime: timeEntry.startTime,
        endTime: DateTime.now(),
      ));

      setState(_stopTimer);
    }
  }

  void _initTimer(TimeEntry? timeEntry) {
    if (timeEntry != null) {
      _startTimer(timeEntry);
    }
  }

  void _startTimer(TimeEntry timeEntry) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime += DateTime.now().difference(timeEntry.startTime);
        this.timeEntry = timeEntry;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _elapsedTime = Duration.zero;
    timeEntry = null;
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  Widget _buildElapsedTime(TimeEntry? timeEntry) {
    final running = timeEntry != null && timeEntry.endTime == null;
    if (running) {
      final elapsedTime = DateTime.now().difference(timeEntry.startTime);
      return Text('Elapsed: ${formatDuration(elapsedTime, seconds: true)}');
    } else {
      return const Text('Tap to start tracking time');
    }
  }
}

Future<TimeEntry?> _showTimeEntryDialog(
    BuildContext context, Task task, TimeEntry? openEntry) {
  final now = DateTime.now();
  DateTime nearestQuarterHour;

  if (openEntry == null) {
    nearestQuarterHour = DateTime(
        now.year, now.month, now.day, now.hour, (now.minute ~/ 15) * 15);
  } else {
    nearestQuarterHour = DateTime(
        now.year, now.month, now.day, now.hour, (now.minute ~/ 15) + 1 * 15);
  }

  final dateTimeController = TextEditingController(
    text: formatDateTime(nearestQuarterHour),
  );
  final noteController = TextEditingController();
  final dateTimeFocusNode = FocusNode();
  final noteFocusNode = FocusNode();

  noteController.text = openEntry?.note ?? '';

  return showDialog<TimeEntry>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(openEntry != null ? 'Stop Timer' : 'Start Timer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (openEntry != null)
            HMBText('Start: ${formatDateTime(openEntry.startTime)}'),
          GestureDetector(
            onTap: () async => _selectDateTime(context, dateTimeController),
            child: AbsorbPointer(
              child: HMBTextField(
                controller: dateTimeController,
                focusNode: dateTimeFocusNode,
                labelText: openEntry != null ? 'Stop Timer' : 'Start Timer',
                keyboardType: TextInputType.datetime,
                required: true,
              ),
            ),
          ),
          HMBTextArea(
            controller: noteController,
            focusNode: noteFocusNode,
            labelText: 'Note',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final selectedDateTime =
                _dateTimeFormat.parse(dateTimeController.text);
            final note = noteController.text;
            TimeEntry timeEntry;
            if (openEntry == null) {
              timeEntry = TimeEntry.forInsert(
                  taskId: task.id, startTime: selectedDateTime, note: note);
            } else {
              timeEntry = TimeEntry.forUpdate(
                  entity: openEntry,
                  taskId: task.id,
                  startTime: openEntry.startTime,
                  endTime: selectedDateTime,
                  note: note);
            }
            Navigator.pop(context, timeEntry);
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> _selectDateTime(
    BuildContext context, TextEditingController controller) async {
  final selectedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (selectedDate != null && context.mounted) {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      ),
    );

    if (selectedTime != null) {
      final finalDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      controller.text = formatDateTime(finalDateTime);
    }
  }
}
