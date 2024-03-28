import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../util/log.dart';
import '../../widgets/nj_text_field.dart';
import 'contact.dart';

class ContactEditor extends StatefulWidget {
  const ContactEditor(this.contact, {super.key});
  final Contact contact;

  @override
  State<StatefulWidget> createState() => ContactEditorState();
}

class ContactEditorState extends State<ContactEditor> {
  ContactEditorState();

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          TextFieldNJ(
            initialValue: widget.contact.firstname ?? '',
            keyboardType: TextInputType.name,
            autofillHints: const [AutofillHints.givenName],
            label: 'First Name',
            onChanged: (value) => {widget.contact.firstname = value},
          ),
          TextFieldNJ(
              keyboardType: TextInputType.name,
              autofillHints: const [AutofillHints.familyName],
              initialValue: widget.contact.lastname ?? '',
              label: 'Last Name',
              onChanged: (value) => {widget.contact.lastname = value}),
          TextFieldNJ(
              keyboardType: TextInputType.phone,
              autofillHints: const [AutofillHints.telephoneNumberNational],
              initialValue: widget.contact.mobile ?? '',
              label: 'Mobile',
              onChanged: (value) => {widget.contact.mobile = value}),
          TextFieldNJ(
              keyboardType: TextInputType.phone,
              autofillHints: const [AutofillHints.telephoneNumberNational],
              initialValue: widget.contact.landline ?? '',
              label: 'Land Line',
              onChanged: (value) => {widget.contact.landline = value}),
          TextFieldNJ(
              keyboardType: TextInputType.name,
              autofillHints: const [AutofillHints.organizationName],
              initialValue: widget.contact.company ?? '',
              label: 'Company',
              onChanged: (value) => {widget.contact.company = value}),
          ElevatedButton(
              onPressed: () async {
                Log().d('Save...');
                await widget.contact.document!.reference
                    .update(widget.contact.getData());
                SQRouter().pop<void>();
              },
              child: const Text('Save'))
        ],
      );
}
