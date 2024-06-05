// ignore_for_file: library_private_types_in_public_api

import '../../entity/customer.dart';
import '../../entity/site.dart';
import '../dao_site.dart';
import '../dao_site_customer.dart';
import 'dao_join_adaptor.dart';

class CustomerSiteJoinAdaptor implements DaoJoinAdaptor<Site, Customer> {
  @override
  Future<void> deleteFromParent(Site site, Customer customer) async {
    await DaoSite().deleteFromCustomer(site, customer);
  }

  @override
  Future<List<Site>> getByParent(Customer? customer) async =>
      DaoSite().getByCustomer(customer);

  @override
  Future<void> insertForParent(Site site, Customer customer) async {
    await DaoSite().insertForCustomer(site, customer);
  }

    @override
  Future<void> setAsPrimary(Site child, Customer parent) async {
    await DaoSiteCustomer().setAsPrimary(child, parent);
  }
}
