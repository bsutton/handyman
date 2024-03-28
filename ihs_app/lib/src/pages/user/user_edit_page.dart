import 'package:flutter/material.dart';

import '../../dao/entities/user.dart';
import '../../dao/types/phone_number.dart';
import '../../widgets/crud/crud_edit.dart';
import '../../widgets/theme/nj_theme.dart';

class UserEditPage extends StatefulWidget {

  const UserEditPage({required this.user, super.key});
  final User user;

  @override
  UserEditPageState createState() => UserEditPageState();
}

class UserEditPageState extends State<UserEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? firstname;
  String? surname;
  String? mobilePhone;

  @override
  Widget build(BuildContext context) => CrudEdit<User>(
      formKey: _formKey,
      entity: widget.user,
      onSave: () async => widget.user.copyWith(
          firstname: firstname,
          surname: surname,
          mobilePhone: PhoneNumber(mobilePhone ?? ''),
          enabled: true),
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: NJTheme.padding),
                child: TextFormField(
                  initialValue: widget.user.firstname,
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
                initialValue: widget.user.surname,
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
          initialValue: widget.user.mobilePhone!.toNational(),
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
