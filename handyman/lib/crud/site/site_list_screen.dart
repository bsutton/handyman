import 'package:flutter/material.dart';

import '../../dao/dao_site.dart';
import '../../entity/site.dart';
import '../base_full_screen/entity_list_screen.dart';
import 'site_edit_screen.dart';

class SiteListScreen extends StatelessWidget {
  const SiteListScreen({super.key});

  @override
  Widget build(BuildContext context) => EntityListScreen<Site>(
      pageTitle: 'Sites',
      dao: DaoSite(),
      title: (site) => Text('${site.addressLine1} ${site.suburb}') as Widget,
      onEdit: (site) => SiteEditScreen(site: site),
      details: (entity) {
        final site = entity;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('''
      Address: ${site.addressLine1}, ${site.addressLine2}, ${site.suburb}, ${site.state}, ${site.postcode}''')
        ]);
      });
}
