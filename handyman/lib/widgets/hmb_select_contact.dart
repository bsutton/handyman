import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';
import 'package:june/june.dart';

import '../crud/contact/contact_edit_screen.dart';
import '../dao/dao_contact.dart';
import '../dao/join_adaptors/customer_contact_join_adaptor.dart';
import '../entity/contact.dart';
import '../entity/customer.dart';
import 'hmb_add_button.dart';

/// Allows the user to select a Primary Contact from the contacts
/// owned by a customer and and the associate them with another
/// entity e.g. a job.
class HMBSelectContact extends StatefulWidget {
  const HMBSelectContact(
      {required this.initialContact, required this.customer, super.key});

  /// The customer that owns the contact.
  final Customer? customer;
  final SelectedContact initialContact;

  @override
  HMBSelectContactState createState() => HMBSelectContactState();
}

class HMBSelectContactState extends State<HMBSelectContact> {
  @override
  Widget build(BuildContext context) {
    if (widget.customer == null) {
      return const Center(child: Text('Select a customer first.'));
    } else {
      return FutureBuilderEx(
        // ignore: discarded_futures
        future: DaoContact().getById(widget.initialContact.contactId),
        builder: (context, selectedContact) => FutureBuilderEx<List<Contact>>(
          // ignore: discarded_futures
          future: DaoContact().getByCustomer(widget.customer),
          builder: (context, data) => Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<Contact>(
                  value: selectedContact,
                  hint: const Text('Select a contact'),
                  onChanged: (newValue) {
                    setState(() {
                      widget.initialContact.contactId = newValue?.id;
                    });
                  },
                  items: data!
                      .map((contact) => DropdownMenuItem<Contact>(
                            value: contact,
                            child: Text(contact.abbreviated()),
                          ))
                      .toList(),
                  decoration: const InputDecoration(labelText: 'Contact'),
                  // validator: (value) =>
                  //     value == null ? 'Please select a Contact' : null,
                ),
              ),
              HMBAddButton(
                  enabled: true,
                  onPressed: () async {
                    final customer = await Navigator.push<Contact>(
                      context,
                      MaterialPageRoute<Contact>(
                          builder: (context) => ContactEditScreen<Customer>(
                              parent: widget.customer!,
                              daoJoin: CustomerContactJoinAdaptor())),
                    );
                    setState(() {
                      widget.initialContact.contactId = customer?.id;
                    });
                  }),
            ],
          ),
        ),
      );
    }
  }
}

class SelectedContact extends JuneState {
  SelectedContact();

  int? contactId;
}
