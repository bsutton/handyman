// ignore_for_file: library_private_types_in_public_api

import '../../entity/contact.dart';
import '../../entity/customer.dart';
import '../dao_contact.dart';
import '../dao_contact_customer.dart';
import 'dao_join_adaptor.dart';

class CustomerContactJoinAdaptor implements DaoJoinAdaptor<Contact, Customer> {
  @override
  Future<void> deleteFromParent(Contact contact, Customer customer) async {
    await DaoContactCustomer().deleteJoin(customer, contact);
  }

  @override
  Future<List<Contact>> getByParent(Customer? parent) async =>
      DaoContact().getByCustomer(parent);

  @override
  Future<void> insertForParent(Contact contact, Customer customer) async {
    await DaoContact().insertForCustomer(contact, customer);
  }

  @override
  Future<void> setAsPrimary(Contact child, Customer parent) async {
    await DaoContactCustomer().setAsPrimary(child, parent);
  }
}
