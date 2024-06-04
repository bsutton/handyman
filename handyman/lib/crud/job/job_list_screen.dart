import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../dao/dao_customer.dart';
import '../../dao/dao_job.dart';
import '../../dao/dao_site.dart';
import '../../entity/customer.dart';
import '../../entity/job.dart';
import '../../util/format.dart';
import '../../widgets/rich_editor.dart';
import '../../widgets/text_site.dart';
import '../base_full_screen/entity_list_screen.dart';
import 'job_edit_screen.dart';

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});

  @override
  Widget build(BuildContext context) => EntityListScreen<Job>(
        dao: DaoJob(),
        pageTitle: 'Jobs',
        onEdit: (job) => JobEditScreen(job: job),
        title: (job) => Text(job.summary),
        details: (entity) {
          final job = entity;
          return SizedBox(
            height: 150,
            child: FutureBuilderEx<Customer?>(
              // ignore: discarded_futures
              future: DaoCustomer().getById(job.customerId),
              builder: (context, customer) => FutureBuilderEx(
                  // ignore: discarded_futures
                  future: DaoSite().getPrimaryForCustomer(customer),
                  builder: (context, site) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Customer: ${customer?.name ?? 'Not Set'}'),
                            Text('Scheduled: ${formatDate(job.startDate)}'),
                            Text('Summary: ${job.summary}'),
                            Text(
                                '''Description: ${RichEditor.createParchment(job.description).toPlainText().split('\n').first}'''),
                            TextSite(label: 'Address:', site: site),
                          ])),
            ),
          );
        },
      );
}
