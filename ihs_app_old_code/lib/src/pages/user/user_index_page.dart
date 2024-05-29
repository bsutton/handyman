import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../dao/entities/user.dart';
import '../../util/enum_helper.dart';
import '../../widgets/crud/crud_index.dart';
import '../../widgets/expansion_flip_tile/expansion_flip_tile.dart';
import '../../widgets/expansion_flip_tile/expansion_flip_tile_skeleton.dart';
import '../../widgets/theme/nj_button.dart';
import 'user_create_page.dart';
import 'user_edit_page.dart';

class UserIndexPage extends StatelessWidget {
  UserIndexPage({super.key});
  static const RouteName routeName = RouteName('userspage');
  static const _swatch = Colors.green;
  final GlobalKey<CrudIndexState<User>> crudKey =
      GlobalKey<CrudIndexState<User>>(
          debugLabel: 'UserIndexPage CrudIndexState key');

  Widget _buildItem(
    BuildContext context,
    int index,
    User user,
  ) {
    final label = user.fullname.isNotEmpty
        ? user.fullname
        : user.bestPhoneNumber?.toString() ??
            user.emailAddress?.toString() ??
            user.guid.toString();
    return ExpansionFlipTile(
      swatch: _swatch,
      title: Text(label),
      bodyBuilder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label),
          Text(user.bestPhoneNumber?.toString() ?? ''),
          Text(EnumHelper.getName(user.userRole).replaceAll('Customer ', '')),
          Text(user.emailAddress == null ? '' : user.emailAddress.toString()),
        ],
      ),
      actionBuilder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          NJButtonPrimary(
            label: 'Edit',
            onPressed: () async =>
                crudKey.currentState!.editEntity(index, user),
          ),
          NJButtonPrimary(
            label: 'Delete',
            onPressed: () async =>
                crudKey.currentState!.deleteEntity(index, user),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => CrudIndex<User>(
        key: crudKey,
        title: 'Users',
        currentRouteName: UserIndexPage.routeName,
        createPageBuilder: (context) => const UserCreatePage(),
        editPageBuilder: (context, index, user) => UserEditPage(user: user),
        listItemBuilder: _buildItem,
        skeletonItemBuilder: (context, index) =>
            const ExpansionFlipTileSkeleton(
          swatch: _swatch,
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GlobalKey<CrudIndexState<User>>>(
        'crudKey', crudKey));
  }
}
