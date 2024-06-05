import 'package:flutter/material.dart';

import '../../dao/dao_site.dart';
import '../../dao/join_adaptors/dao_join_adaptor.dart';
import '../../entity/entity.dart';
import '../../entity/site.dart';
import '../../widgets/hmb_site_text.dart';
import '../base_nested/nested_list_screen.dart';
import 'site_edit_screen.dart';

class SiteListScreen<P extends Entity<P>> extends StatelessWidget {
  const SiteListScreen({
    required this.parent,
    required this.daoJoin,
    super.key,
  });

  final Parent<P> parent;

  final DaoJoinAdaptor<Site, P> daoJoin;

  @override
  Widget build(BuildContext context) => NestedEntityListScreen<Site, P>(
      parent: parent,
      pageTitle: 'Sites',
      dao: DaoSite(),
      onDelete: (site) async => daoJoin.deleteFromParent(site!, parent.parent!),
      onInsert: (site) async => daoJoin.insertForParent(site!, parent.parent!),
      // ignore: discarded_futures
      fetchList: () => daoJoin.getByParent(parent.parent),
      title: (site) => Text('${site.addressLine1} ${site.suburb}') as Widget,
      onEdit: (site) =>
          SiteEditScreen(daoJoin: daoJoin, parent: parent.parent!, site: site),
      details: (entity) {
        final site = entity;
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [HMBSiteText(label: 'Address', site: site)]);
      });
}
