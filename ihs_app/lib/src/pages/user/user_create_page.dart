import 'package:flutter/material.dart';

import '../../dao/entities/user.dart';
import '../../dao/repository/repos.dart';
import '../../dao/types/phone_number.dart';
import '../../widgets/crud/crud_create.dart';
import '../../widgets/theme/nj_theme.dart';

class UserCreatePage extends StatefulWidget {
  const UserCreatePage({super.key});

  @override
  UserCreatePageState createState() => UserCreatePageState();
}

class UserCreatePageState extends State<UserCreatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? firstname;
  String? surname;
  String? mobilePhone;

  @override
  Widget build(BuildContext context) => CrudCreate<User>(
      formKey: _formKey,
      onSave: () async {
        final user = User.forInsert();
        user.firstname = firstname;
        user.surname = surname;
        user.mobilePhone = PhoneNumber(mobilePhone ?? '');
        user.owner = (await Repos().user.loggedInUser).owner;
        user.enabled = true;
        return user;
      },
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: NJTheme.padding),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'First name',
                    labelText: 'First name *',
                  ),
                  validator: UserValidator.firstname,
                  onSaved: (value) => firstname = value,
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Surname',
                  labelText: 'Surname *',
                ),
                validator: UserValidator.surname,
                onSaved: (value) => surname = value,
              ),
            ),
          ],
        ),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Mobile/cell phone number',
            labelText: 'Mobile/cell phone number *',
          ),
          validator: UserValidator.mobilePhone,
          onSaved: (value) => mobilePhone = value,
        ),
      ],
    );
}
