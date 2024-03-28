import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../dao/entities/voicemail_message.dart';
import '../../widgets/crud/crud_index.dart';
import '../../widgets/expansion_flip_tile/expansion_flip_tile.dart';
import '../../widgets/expansion_flip_tile/expansion_flip_tile_skeleton.dart';
import '../../widgets/theme/nj_button.dart';

class VoicemailIndexPage extends StatelessWidget {

  VoicemailIndexPage({super.key});
  static const RouteName routeName = RouteName('voicemailpage');
  static const _swatch = Colors.orange;
  final GlobalKey<CrudIndexState<VoicemailMessage>> crudKey =
      GlobalKey<CrudIndexState<VoicemailMessage>>(
          debugLabel: 'VoicemailIndexPage CrudIndexState key');

  Widget _buildItem(
    BuildContext context,
    int index,
    VoicemailMessage voicemail,
  ) {
    final label = voicemail.guid.toString().substring(0, 20);
    return ExpansionFlipTile(
      swatch: _swatch,
      title: Text(label),
      bodyBuilder: (context) => Column(
        children: <Widget>[
          Text(label),
          Text(label),
          Text(label),
          Text(label),
        ],
      ),
      actionBuilder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          NJButtonPrimary(
            label: 'Delete',
            onPressed: () async =>
                crudKey.currentState!.deleteEntity(index, voicemail),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => CrudIndex<VoicemailMessage>(
      key: crudKey,
      title: 'Voicemails',
      currentRouteName: VoicemailIndexPage.routeName,
      listItemBuilder: _buildItem,
      skeletonItemBuilder: (context, index) => const ExpansionFlipTileSkeleton(
        swatch: _swatch,
      ),
    );
}
