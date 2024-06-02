import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../dao/dao_customer.dart';
import '../../dao/dao_job.dart';
import '../../entity/customer.dart';
import '../../entity/job.dart';
import '../base/entity_list_screen.dart';
import 'job_edit_screen.dart';

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});

  @override
  Widget build(BuildContext context) => EntityListScreen<Job>(
        dao: DaoJob(),
        pageTitle: 'Jobs',
        title: (job) => Text(job.summary),
        onEdit: (job) => JobEditScreen(job: job),
        subTitle: (entity) {
          final job = entity;
          return SizedBox(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilderEx<Customer?>(
                  // ignore: discarded_futures
                  future: DaoCustomer().getById(job.customerId),
                  builder: (context, customer) =>
                      Text('Customer: ${customer?.name ?? 'Not Set'}'),
                ),
                Text('Start Date: ${job.startDate}'),
                Text('Summary: ${job.summary}'),
                Text('Description: ${job.description}'),
                Text('Address: ${job.address}'),
              ],
            ),
          );
        },
      );
}
