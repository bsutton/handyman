import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../dao/entities/tutorial.dart';
import '../../widgets/crud/crud_index.dart';
import 'tutorial_edit_page.dart';

class TutorialIndexPage extends StatelessWidget {

  TutorialIndexPage({super.key});
  static const RouteName routeName = RouteName('tutorialspage');
  final GlobalKey<CrudIndexState<Tutorial>> crudKey =
      GlobalKey<CrudIndexState<Tutorial>>(
          debugLabel: 'TutorialIndexPage CrudIndexState key');

  Widget _buildItem(
    BuildContext context,
    int index,
    Tutorial tutorial,
  ) => ListTile(
      title: Text(tutorial.subject!),
      onTap: () async => crudKey.currentState?.editEntity(index, tutorial),
    );

  @override
  Widget build(BuildContext context) => CrudIndex<Tutorial>(
      key: crudKey,
      title: 'Tutorials',
      currentRouteName: TutorialIndexPage.routeName,
      editPageBuilder: (context, index, tutorial) =>
          TutorialEditPage(tutorial: tutorial),
      listItemBuilder: _buildItem,
    );
}
