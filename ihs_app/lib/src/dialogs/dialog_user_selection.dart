import 'dart:core' as prefix0;
import 'dart:core';
import 'package:flutter/material.dart';
import '../dao/entities/user.dart';
import '../dao/repository/repos.dart';
import 'dialog_selection.dart';

class DialogUserSelection {
  static Future<User> show(
      {required BuildContext context,
      required String title,
      required String searchLabel,
      User? initialUser}) async {
    final dialog = DialogUserSelection();

    return dialog._show(context, title, searchLabel, initialUser);
  }

  Future<User> _show(BuildContext context, String title, String searchLabel,
      User? initialUser) => DialogSelection.show<User>(
        context: context,
        title: title,
        searchLabel: 'Colleague',
        filterMatch: (filter, user) async =>
            user.fullname.toLowerCase().contains(filter),
        cardBuilder: (context, user, selected) =>
            buildCard(user, selected: selected),
        listLoader: () => Repos().user.getAll());

  UserCard buildCard(User user, {required bool selected}) => UserCard(user, selected: selected);
}

class UserCard extends StatelessWidget {

  const UserCard(this.user, {required this.selected, super.key, this.onTap});
  final User user;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 40,
        child: Card(
            color: (selected ? Colors.orange : Colors.orangeAccent),
            child: Center(child: Text(user.fullname))));
}
