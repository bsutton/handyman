import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app_scaffold.dart';
import '../../app/router.dart';
import '../../dao/repository/user_repository.dart';
import '../../widgets/local_context.dart';
import '../../widgets/undomanager/undo_manager_notifier.dart';
import 'contact.dart';
import 'contact_card.dart';
import 'contact_editor.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  static const RouteName routeName = RouteName('ContactList');
  static const Color dashletColor = Colors.orange;

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList>
    implements UndoManagerEventListener {
  _ContactListState();

  GlobalKey<AnimatedListState> animatedListGlobalKey =
      GlobalKey<AnimatedListState>();

  Animatable<double> get mt3 => Tween<double>(begin: 0, end: 1)
      .chain(CurveTween(curve: Curves.easeInOutBack));

  @override
  Widget build(BuildContext context) => AppScaffold(
        builder: (context) => Container(
            padding: const EdgeInsets.only(top: 10),
            color: Colors.black,
            child: Column(children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(UserRepository().viewAsUser.toString())
                      .collection('contacts')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('Loading...');
                    }

                    final contactCards = <ContactCard>[];
                    for (final doc in snapshot.data!.docs) {
                      contactCards.add(buildCard(Contact(doc)));
                    }

                    return ChangeNotifierProvider<UndoManagerNotifier>.value(
                        value: UndoManagerNotifier(contactCards, this),
                        child: LocalContext(
                            builder: (undoManagereNotifierContext) => Expanded(
                                child: AnimatedList(
                                    key: animatedListGlobalKey,
                                    shrinkWrap: true,
                                    initialItemCount:
                                        Provider.of<UndoManagerNotifier>(
                                                undoManagereNotifierContext)
                                            .entities
                                            .length,
                                    itemBuilder: itemIndexBuilder))));
                  }), //  onRemove))),
              buildSearchBar(),
              ElevatedButton(
                onPressed: () async {
                  await showModalBottomSheet<ContactEditor>(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => ContactEditor(Contact.empty()));
                },
                child: const Text('+'),
              ),
            ])),
      );

  // return  Provider.of<UndoManagerNotifier>(context).entities[index];
  Widget itemIndexBuilder(
          BuildContext context, int index, Animation<double> animation) =>
      SizeTransition(
          sizeFactor: animation.drive(mt3),
          child: Provider.of<UndoManagerNotifier>(context).entities[index]);

  // passing doc, so that ContactCard scan delete the firebase record when needed.
  ContactCard buildCard(Contact contact) => ContactCard(contact);

  Row buildSearchBar() => Row(children: [
        const Text('Search:', style: TextStyle(color: Colors.white)),
        Expanded(child: TextField(onChanged: onSearch)),
      ]);

  void onSearch(String filter) {}

  @override
  void onItemMarkForDelete(int idx, DeletableItem item) {
    animatedListGlobalKey.currentState?.removeItem(
        idx,
        (context, animation) =>
            SizeTransition(sizeFactor: animation.drive(mt3), child: item),
        duration: const Duration(seconds: 1));
  }

  @override
  void onItemUndo(int idx) {
    animatedListGlobalKey.currentState
        ?.insertItem(idx, duration: const Duration(seconds: 1));
  }
}
