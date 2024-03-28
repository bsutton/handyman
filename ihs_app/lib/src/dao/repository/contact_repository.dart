import '../entities/contact.dart';
import 'repository.dart';

class ContactRepository extends Repository<Contact> {
  ContactRepository() : super(const Duration(minutes: 5));

  @override
  Contact fromJson(Map<String, dynamic> json) => Contact.fromJson(json);
}
