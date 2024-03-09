// ignore_for_file: avoid_catches_without_on_clauses, avoid_print

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/job.dart';
import '../supabase_factory.dart';

class JobDao with ChangeNotifier {
  factory JobDao() {
    _self ??= JobDao._();

    return _self!;
  }

  JobDao._() : _db = SupabaseFactory.client;
  static JobDao? _self;

  final SupabaseClient _db;

  List<Job> getJobs() {
    final results = _db.from('job').select().;

    for (final job in results) {
      {}
    }
  }

  // _db.collection('Jobs').snapshots().map((snapshot) => snapshot.docs
  //     .map((document) => Job.fromFirestore(document.data()))
  //     .toList());

  /// create or update a Job.
  Future<void> saveJob(Job Job) async {
    final completer = Completer<void>();
    try {
      await _db.collection('Jobs').doc(Job.jobId).set(Job.toMap()).then(
          (value) {
        print('Job saved: $Job');
        completer.complete();
      }, onError: (e) {
        completer.complete();
        print('Error updating appointment: $e');
      });
    } catch (e) {
      print(e);
    }

    await completer.future;
    print('finished saving');
  }

  Future<void> removeJob(String JobId) async =>
      _db.collection('Jobs').doc(JobId).delete();
}
