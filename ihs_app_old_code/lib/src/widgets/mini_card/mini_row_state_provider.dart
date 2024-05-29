import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../util/named_provider.dart';
import '../local_context.dart';
import 'mini_row_state.dart';

// Provider that lets mini-cards communicate between each other
// when they change state (e.g. become active)

class MiniRowStateProvider<T, S extends MiniRowState<T, S>>
    extends StatelessWidget {
  const MiniRowStateProvider({
    required this.child,
    required this.create,
    super.key,
  });
  final Widget child;

  final S Function() create;

  @override
  Widget build(BuildContext context) => NamedProvider<S>(
      create: create, child: LocalContext(builder: (context) => child));
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<S Function()>.has('create', create));
  }
}
