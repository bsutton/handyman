import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../dialogs/dialog_alert.dart';
import '../context_help/context_help_button.dart';
import '../theme/nj_theme.dart';

class NjBottomAppBar extends StatelessWidget {
  const NjBottomAppBar({required this.actions, required this.shape, super.key});
  // Hero transitions here do not work as expected, due to:
  // https://github.com/flutter/flutter/issues/36220
  static const String heroTag = 'AppBar';
  final List<Widget> actions;
  final NotchedShape shape;

  Future<void> _showNotices(BuildContext context) async {
    await DialogAlert.show(
        context, 'Notices', 'Please implement the Notices dialog');
  }

  Widget _buildNoticesChip(BuildContext context) => InkWell(
        onTap: () async => _showNotices(context),
        child: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Chip(
            avatar: Icon(Icons.notifications),
            label: Text('3'),
            backgroundColor: Colors.orange,
          ),
        ),
      );

  Widget _buildContent(BuildContext context) {
    final children = <Widget>[
      Row(children: [
        const ContextHelpButton(),
        _buildNoticesChip(context),
      ]),
      Row(children: actions)
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) => BottomAppBar(
        color: NJColors.appBarColor,
        shape: shape,
        child: _buildContent(context),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<NotchedShape>('shape', shape));
  }
}
