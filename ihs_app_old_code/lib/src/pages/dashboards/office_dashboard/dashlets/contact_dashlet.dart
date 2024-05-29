import 'package:flutter/material.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../../../contacts/contact_list.dart';

class ContactDashlet extends StatefulWidget {
  const ContactDashlet({super.key});

  @override
  State<StatefulWidget> createState() => ContactDashletState();
}

class ContactDashletState extends State<ContactDashlet> {
  @override
  Widget build(BuildContext context) => Dashlet(
        label: 'Contacts/Dial',
        svgImage: buildContent(),
        flex: 2,
        targetRoute: ContactList.routeName,
        backgroundColor: ContactList.dashletColor);

  Widget buildContent() => const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Svg('Contacts', height: Dashlet.height / 2),
        ),
      ],
    );
}
