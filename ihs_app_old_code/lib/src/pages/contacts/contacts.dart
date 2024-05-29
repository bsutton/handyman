import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/router.dart';

class Contacts extends StatefulWidget {
  const Contacts({required this.title, super.key});
  static const RouteName routeName = RouteName('contacts');
  final String title;

  @override
  ContactsState createState() => ContactsState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) => ListView(
        children: List<Widget>.generate(50, (idx) => const ListTile(
        leading: CircleAvatar(
          child: Text('FL'),
        ),
        title: Text('Firstname Lastname'),
      )));

  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: List<Widget>.generate(50, (int idx) {
          return ListTile(
            leading: CircleAvatar(
              child: Text('FL'),
            ),
            title: Text('Firstname Lastname'),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add contact',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: ExpansionBottomAppBar(
        key: _bottomBarKey,
        menu: NavMenu(currentRoute: Contacts.routeName),
        bottomAppBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                color: Theme.of(context).buttonTheme.colorScheme.onPrimary,
                onPressed: () {
                  _bottomBarKey.currentState.toggle();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
  */
}
