import 'package:flutter/material.dart';

import '../dao/dao_job.dart';
import '../entity/job.dart';
import 'base/entity_list_screen.dart';
import 'job_edit_screen.dart';

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});

  @override
  Widget build(BuildContext context) => EntityListScreen<Job>(
        dao: DaoJob(),
        pageTitle: 'Jobs',
        title: (job) => Text(job.summary),
        onEdit: (job) => AddEditJobScreen(job: job),
        subTitle: (entity) {
          final job = entity;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Start Date: ${job.startDate}'),
              Text('Summary: ${job.summary}'),
              Text('Description: ${job.description}'),
              Text('Address: ${job.address}'),
            ],
          );
        },
      );
}
