import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../dao/dao_customer.dart';
import '../../dao/dao_job.dart';
import '../../dao/dao_site.dart';
import '../../entity/customer.dart';
import '../../entity/job.dart';
import '../../util/format.dart';
import '../../widgets/hmb_site_text.dart';
import '../../widgets/rich_editor.dart';
import '../base_full_screen/entity_list_screen.dart';
import 'job_edit_screen.dart';

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});

  @override
  Widget build(BuildContext context) => EntityListScreen<Job>(
        dao: DaoJob(),
        pageTitle: 'Jobs',
        onEdit: (job) => JobEditScreen(job: job),
        title: (job) => Text(
          job.summary,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        details: (entity) {
          final job = entity;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FutureBuilderEx<Customer?>(
                // ignore: discarded_futures
                future: DaoCustomer().getById(job.customerId),
                builder: (context, customer) => FutureBuilderEx(
                  // ignore: discarded_futures
                  future: DaoSite().getPrimaryForCustomer(customer),
                  builder: (context, site) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer: ${customer?.name ?? 'Not Set'}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Scheduled: ${formatDate(job.startDate)}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Summary: ${job.summary}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Description: ${RichEditor.createParchment(job.description).toPlainText().split('\n').first}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      HMBSiteText(label: 'Address:', site: site),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
}
