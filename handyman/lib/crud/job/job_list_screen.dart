import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../dao/dao_contact.dart';
import '../../dao/dao_customer.dart';
import '../../dao/dao_job.dart';
import '../../dao/dao_job_status.dart';
import '../../dao/dao_site.dart';
import '../../entity/customer.dart';
import '../../entity/job.dart';
import '../../util/format.dart';
import '../../widgets/hmb_email_text.dart';
import '../../widgets/hmb_phone_text.dart';
import '../../widgets/hmb_site_text.dart';
import '../../widgets/hmb_text.dart';
import '../../widgets/hmb_text_themes.dart';
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
        fetchList: (filter) async => DaoJob().getByFilter(filter),
        title: (job) => Text(
          job.summary,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        background: (job) async =>
            (await DaoJobStatus().getById(job.jobStatusId))?.getColour() ??
            Colors.white,
        details: (entity) {
          final job = entity;
          return FutureBuilderEx(
              // ignore: discarded_futures
              future: DaoJobStatus().getById(job.jobStatusId),
              builder: (context, jobStatus) => FutureBuilderEx<Customer?>(
                    // ignore: discarded_futures
                    future: DaoCustomer().getById(job.customerId),
                    builder: (context, customer) => FutureBuilderEx(
                      // ignore: discarded_futures
                      future: DaoSite().getByJob(job),
                      builder: (context, site) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HMBTextHeadline2(customer?.name ?? 'Not Set'),
                          HMBTextHeadline3(job.summary),
                          FutureBuilderEx(
                            // ignore: discarded_futures
                            future: DaoContact().getById(job.contactId),
                            builder: (context, contact) => Column(
                              children: [
                                HMBPhoneText(
                                    phoneNo: contact?.mobileNumber ??
                                        contact?.landLine),
                                HMBEmailText(email: contact?.emailAddress)
                              ],
                            ),
                          ),
                          HMBText('Status: ${jobStatus?.name}'),
                          HMBText('Scheduled: ${formatDate(job.startDate)}'),
                          HMBText(
                            '''Description: ${RichEditor.createParchment(job.description).toPlainText().split('\n').first}''',
                          ),
                          HMBSiteText(label: 'Address:', site: site),
                          buildStatistics(job)
                        ],
                      ),
                    ),
                  ));
        },
      );

  FutureBuilderEx<JobStatistics> buildStatistics(Job job) => FutureBuilderEx(
        // ignore: discarded_futures
        future: DaoJob().getJobStatistics(job),
        builder: (context, remainingTasks) {
          if (remainingTasks == null) {
            return const CircularProgressIndicator();
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Mobile layout
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HMBText(
                      'Completed: ${remainingTasks.completedTasks}/${remainingTasks.totalTasks}',
                    ),

                    // ignore: discarded_futures

                    HMBText(
                      'Effort(hrs): ${remainingTasks.completedEffort.format('0.00')}/${remainingTasks.totalEffort.format('0.00')}',
                    ),
                    HMBText(
                      'Earnings: ${remainingTasks.earnedCost}/${remainingTasks.totalCost}',
                    ),
                    HMBText(
                      'Worked: ${remainingTasks.worked}',
                    ),
                  ],
                );
              } else {
                // Desktop layout
                return Row(
                  children: [
                    HMBText(
                      'Completed: ${remainingTasks.completedTasks}/${remainingTasks.totalTasks}',
                    ),
                    const SizedBox(width: 16), // Add spacing between items
                    HMBText(
                      'Effort(hrs): ${remainingTasks.completedEffort.format('0.00')}/${remainingTasks.totalEffort.format('0.00')}',
                    ),
                    const SizedBox(width: 16), // Add spacing between items
                    HMBText(
                      'Earnings: ${remainingTasks.earnedCost}/${remainingTasks.totalCost}',
                    ),
                    HMBText(
                      ' Worked: ${remainingTasks.worked}',
                    ),
                  ],
                );
              }
            },
          );
        },
      );
}
