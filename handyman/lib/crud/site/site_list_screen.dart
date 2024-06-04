import 'package:flutter/material.dart';

import '../../dao/dao_site.dart';
import '../../entity/customer.dart';
import '../../entity/site.dart';
import '../../widgets/text_site.dart';
import '../base_nested/nested_list_screen.dart';
import 'site_edit_screen.dart';

class SiteListScreen extends StatelessWidget {
  const SiteListScreen({required this.parent, super.key});

  final Parent<Customer> parent;

  @override
  Widget build(BuildContext context) => NestedEntityListScreen<Site, Customer>(
      parent: parent,
      pageTitle: 'Sites',
      dao: DaoSite(),
      onDelete: (site) async =>
          DaoSite().deleteFromCustomer(site!, parent.parent!),
      onInsert: (site) async =>
          DaoSite().insertForCustomer(site!, parent.parent!),
      // ignore: discarded_futures
      fetchList: () => DaoSite().getByCustomer(parent.parent),
      title: (site) => Text('${site.addressLine1} ${site.suburb}') as Widget,
      onEdit: (site) => SiteEditScreen(customer: parent.parent!, site: site),
      details: (entity) {
        final site = entity;
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [TextSite(label: 'Address', site: site)]);
      });
}
