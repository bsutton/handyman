import 'dart:async';

import 'package:completer_ex/completer_ex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' hide Shadow;

import '../../app/router.dart';
import '../../dao/entities/call_forward_target.dart';
import '../../dialogs/dialog_alert.dart';
import '../../util/named_provider.dart';
import '../blocking_ui.dart';
import '../theme/nj_text_themes.dart';
import '../theme/nj_theme.dart';
import '../toggle_switch.dart';
import 'maxi_card.dart';
import 'maxi_card_page.dart';
import 'mini_row_state.dart';

class MiniCardValidator {
  bool? valid;
  // messages as to why the card is invalid
  // We display this message when a user tries to activate
  // a card.
  String? cantActivateMessage;
}

abstract class MiniCardContent {
  // void activate();
}

typedef MiniCardContentBuilder = MiniCardContent Function(BuildContext context);
typedef Activate = void Function<T>(T data);

class MiniCard<T, S extends MiniRowState<T, S>> extends StatefulWidget {
  MiniCard({
    required this.title,
    required this.contentBuilder,
    required this.barColor,
    required this.widthFactor,
    required this.heightFactor,
    required this.validator,
    required this.data,
    this.maxiBuilder,
  }) : super(key: GlobalKey<_MiniCardState>());
  final String title;
  final MiniCardContentBuilder contentBuilder;
  final MiniCardValidator Function() validator;
  final Future<MaxiContent> Function()? maxiBuilder;

  // a handle to the data this mini card is holding.
  final T data;

  final double widthFactor;
  final double heightFactor;

  static const double borderRadius = 10;

  final Color barColor;

  final GlobalKey<_MiniCardState> miniCardState = GlobalKey();

  @override
  _MiniCardState<T, S> createState() => _MiniCardState<T, S>();

  bool equals(MiniCard<T, S> other) => title == other.title;
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(ObjectFlagProperty<MiniCardContentBuilder>.has(
          'contentBuilder', contentBuilder))
      ..add(ObjectFlagProperty<MiniCardValidator Function()>.has(
          'validator', validator))
      ..add(ObjectFlagProperty<Future<MaxiContent> Function()?>.has(
          'maxiBuilder', maxiBuilder))
      ..add(DiagnosticsProperty<T>('data', data))
      ..add(DoubleProperty('widthFactor', widthFactor))
      ..add(DoubleProperty('heightFactor', heightFactor))
      ..add(ColorProperty('barColor', barColor))
      ..add(DiagnosticsProperty<GlobalKey<dynamic>>(
          'miniCardState', miniCardState));
  }
}

class MaxiCardRouteArgs<T, S extends MiniRowState<T, S>> {
  MaxiCardRouteArgs(this.state, this.miniCard);
  // The MiniCard which the user is currently editing.
  MiniCard<T, S> miniCard;
  MiniRowState state;
}
