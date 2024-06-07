import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';
import 'package:june/june.dart';

import '../crud/site/site_edit_screen.dart';
import '../dao/dao_site.dart';
import '../dao/join_adaptors/join_adaptor_customer_site.dart';
import '../entity/customer.dart';
import '../entity/site.dart';
import 'hmb_add_button.dart';

/// Allows the user to select a Primary Site from the sites
/// owned by a customer and and the associate them with another
/// entity e.g. a job.
class HMBSelectSite extends StatefulWidget {
  const HMBSelectSite(
      {required this.initialSite, required this.customer, super.key});

  /// The customer that owns the site.
  final Customer? customer;
  final SelectedSite initialSite;

  @override
  HMBSelectSiteState createState() => HMBSelectSiteState();
}

class HMBSelectSiteState extends State<HMBSelectSite> {
  @override
  Widget build(BuildContext context) => FutureBuilderEx(
        // ignore: discarded_futures
        future: DaoSite().getById(widget.initialSite.siteId),
        builder: (context, selectedSite) {
          if (widget.customer == null) {
            return const Center(child: Text('Select a customer first.'));
          } else {
            return FutureBuilderEx<List<Site>>(
              // ignore: discarded_futures
              future: DaoSite().getByCustomer(widget.customer),
              builder: (context, data) => Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Site>(
                      value: selectedSite,
                      hint: const Text('Select a site'),
                      onChanged: (newValue) {
                        setState(() {
                          widget.initialSite.siteId = newValue?.id;
                        });
                      },
                      items: data!
                          .map((site) => DropdownMenuItem<Site>(
                                value: site,
                                child: Text(site.abbreviated()),
                              ))
                          .toList(),
                      decoration: const InputDecoration(labelText: 'Site'),
                      // validator: (value) =>
                      //     value == null ? 'Please select a Site' : null,
                    ),
                  ),
                  HMBAddButton(
                      enabled: true,
                      onPressed: () async {
                        final customer = await Navigator.push<Site>(
                          context,
                          MaterialPageRoute<Site>(
                              builder: (context) => SiteEditScreen<Customer>(
                                  parent: widget.customer!,
                                  daoJoin: JoinAdaptorCustomerSite())),
                        );
                        setState(() {
                          widget.initialSite.siteId = customer?.id;
                        });
                      }),
                ],
              ),
            );
          }
        },
      );
}

class SelectedSite extends JuneState {
  SelectedSite();

  int? siteId;
}
