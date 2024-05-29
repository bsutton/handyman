import 'package:firedart/firestore/models.dart';
import 'package:uuid/uuid.dart';

class Contact {
  factory Contact(Document document) {
    final map = document.map;
    return Contact.internal(
        map['id'] as String? ?? const Uuid().v4(),
        map['firstname'] as String? ?? '',
        map['lastname'] as String? ?? '',
        map['company'] as String? ?? '',
        map['mobile'] as String? ?? '',
        map['landline'] as String? ?? '',
        document);
  }

  Contact.internal(this.id, this.firstname, this.lastname, this.company,
      this.mobile, this.landline, this._document);

  Contact.empty() {
    id = const Uuid().v4();
  }
  String? id;
  String? firstname;
  String? lastname;
  String? company;
  String? mobile;
  String? landline;
  Document? _document;

  String getName() => '$firstname $lastname';

  String getLandline() => landline ?? '';

  String getMobile() => mobile ?? '';

  String getCompany() => company ?? '';

  String getDescription() => getName();

  Document? get document => _document;

  Map<String, dynamic> getData() => <String, dynamic>{
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'company': company,
        'mobile': mobile,
        'landline': landline
      };
}
