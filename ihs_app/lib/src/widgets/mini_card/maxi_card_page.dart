import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/router.dart';
import 'maxi_card.dart';
import 'mini_card.dart';
import 'mini_row_state.dart';

class MaxiCardPage<T, S extends MiniRowState<T, S>> extends StatelessWidget {

  const MaxiCardPage({required this.args, super.key});

  const MaxiCardPage.withActive(this.args, {super.key});
  static const RouteName routeName = RouteName('/maxicard');
  final MaxiCardRouteArgs<T, S> args;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Material(
            child: MaxiCard<T, S>(
                // args.active,
                args.miniCard,
                args.state)));
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MaxiCardRouteArgs<T, S>>('args', args));
  }
}
