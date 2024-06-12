// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';

import '../crud/base_nested/nested_list_screen.dart';
import '../crud/time_entry/time_entry_list_screen.dart';
import '../dao/dao_time_entry.dart';
import '../entity/task.dart';
import '../entity/time_entry.dart';
import '../util/format.dart';
import '../util/list_ex.dart';
import 'hmb_child_crud_card.dart';

// class HBMCrudTimeEntry extends StatelessWidget {
//   const HBMCrudTimeEntry({
//     required this.parent,
//     required this.parentTitle,
//     super.key,
//   });

//   final Parent<Task> parent;
//   final String parentTitle;

//   @override
//   Widget build(BuildContext context) => HMBChildCrudCard(
//       headline: 'Time Entries',
//       crudListScreen: TimeEntryListScreen(
//         parent: parent,
//       ));
// }

class HBMCrudTimeEntry extends StatefulWidget {
  const HBMCrudTimeEntry(
      {required this.parentTitle, required this.parent, super.key});

  final String parentTitle;
  final Parent<Task> parent;

  @override
  HBMCrudTimeEntryState createState() => HBMCrudTimeEntryState();
}

class HBMCrudTimeEntryState extends State<HBMCrudTimeEntry> {
  Future<void> refresh() async {
    setState(() {});
  }

  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  bool _isRunning = false;

  final GlobalKey<HBMCrudTimeEntryState> _timeEntryListKey =
      GlobalKey<HBMCrudTimeEntryState>();

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(_isRunning ? Icons.stop : Icons.play_arrow),
                onPressed: _toggleTimer,
              ),
              if (_isRunning)
                Text('Elapsed: ${formatDuration(_elapsedTime)}')
              else
                const Text('Tap to start tracking time')
            ],
          ),
          HMBChildCrudCard(
              headline: 'Time Entries',
              crudListScreen: TimeEntryListScreen(
                parent: widget.parent,
              )),
        ],
      );

  // FutureBuilder<List<TimeEntry>>(
  //       // ignore: discarded_futures
  //       future: DaoTimeEntry().getByTask(widget.parent.parent),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text('Error: ${snapshot.error}'));
  //         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //           return const Center(child: Text('No time entries found.'));
  //         } else {
  //           return ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: snapshot.data!.length,
  //             itemBuilder: (context, index) {
  //               final timeEntry = snapshot.data![index];
  //               return ListTile(
  //                 title: Text(
  //'''${timeEntry.startTime.toLocal()} - '''
  //'''${timeEntry.endTime?.toLocal() ?? 'Ongoing'}'''),
  //                 subtitle: Text(
  //                     '''Duration:
  //${_formatDuration(timeEntry.startTime, timeEntry.endTime)}'''),
  //               );
  //             },
  //           );
  //         }
  //       },
  //     );

  Future<void> _toggleTimer() async {
    setState(() {
      if (_isRunning) {
        _stopTimer();
      } else {
        _startTimer();
      }
    });

    if (_isRunning) {
      // Insert new TimeEntry to start tracking time
      await DaoTimeEntry().insert(TimeEntry.forInsert(
        taskId: widget.parent.parent!.id,
        startTime: DateTime.now(),
      ));
    } else {
      // Update the last TimeEntry to stop tracking time
      final entries = await DaoTimeEntry().getByTask(widget.parent.parent);
      final ongoingEntry =
          entries.lastWhereOrNull((entry) => entry.endTime == null);
      if (ongoingEntry == null) {
        return;
      }
      await DaoTimeEntry().update(TimeEntry.forUpdate(
        entity: ongoingEntry,
        taskId: widget.parent.parent!.id,
        startTime: ongoingEntry.startTime,
        endTime: DateTime.now(),
      ));
    }

    // Refresh the time entry list
    await _timeEntryListKey.currentState?.refresh();
  }

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime += const Duration(seconds: 1);
      });
    });
  }

  void _stopTimer() {
    _isRunning = false;
    _timer?.cancel();
    _elapsedTime = Duration.zero;
  }
}

// String _formatDuration(DateTime startTime, DateTime? endTime) {
//   if (endTime == null) {
//     return 'Ongoing';
//   }
//   return formatDuration(endTime.difference(startTime));
// }
