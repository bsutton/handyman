import 'dart:async';

import 'package:completer_ex/completer_ex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../dialogs/dialog_alert.dart';
import '../blocking_ui.dart';
import '../hero_text.dart';
import '../theme/nj_button.dart';
import '../theme/nj_text_themes.dart';
import '../theme/nj_theme.dart';
import '../toggle_switch.dart';
import 'mini_card.dart';
import 'mini_row_state.dart';

/// Base for all MaxCard implementors
// ignore: avoid_implementing_value_types
abstract class MaxiContent<T> implements Widget {
  /// Each implementor of the MaxiContent class
  /// MUST call this method each time the content
  /// changes.
  ///
  /// The implementation MUST be as follows
  ///
  /// ```dart
  ///   void onContentChanged(BuildContext context, T data) {
  ///     Provider.of<MiniRowState<T>>(context).onContentChanged(data);
  /// }
  /// ```
  void onContentChanged(BuildContext context, T data);
}

class MaxiCard<T, S extends MiniRowState<T, S>> extends StatefulWidget {
  //final ActiveMiniCard activeMiniCard;

  const MaxiCard(this.miniCard, this.miniRowState, {super.key});
  final MiniCard<T, S> miniCard;
  final MiniRowState<T, S> miniRowState;

  @override
  MaxiCardState<T, S> createState() => MaxiCardState<T, S>();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<MiniRowState<T, S>>('miniRowState', miniRowState));
  }
}

class MaxiCardState<T, S extends MiniRowState<T, S>>
    extends State<MaxiCard<T, S>> {
  bool selected = false;
  // ignore: diagnostic_describe_all_properties
  GlobalKey<ToggleSwitchState> toggleSwitchKey = GlobalKey<ToggleSwitchState>();

  @override
  void initState() {
    super.initState();
    selected = widget.miniRowState.isActive(widget.miniCard);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;

    return SizedBox(width: width, height: height, child: buildBody(context));
  }

  /// Builds the body of the card which is a top panel covering most
  /// of the UI and the bottom activation bar.
  Column buildBody(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Row(children: [buildPanel(), buildRightBar()])),
          buildActivation(context)
        ],
      );

  // elevation: selected ? 0 : 12,
  // return Hero(
  //   tag: 'mini-card-${widget.miniCard.title}-panel',
  Widget buildPanel() => Expanded(
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [buildTitle(), buildContent()]),
        //   ),
      );

  Widget buildRightBar() => HeroNoop(
      noop: false,
      tag: 'mini-card-${widget.miniCard.title}-rightBar',
      child: Container(
        width: 20,
        // height: 100,
        decoration: BoxDecoration(color: widget.miniCard.barColor),
      ));

  Widget buildContent() => Expanded(
        // child: Hero(
        //     tag: 'mini-card-${widget.miniCard.title}-content',
        child: FutureBuilderEx<MaxiContent<T>>(
          future: () async => widget.miniCard.maxiBuilder!(),
          waitingBuilder: (context) => NJTextBodyBold('Loading...'),
          builder: (context, content) => content!,
        ),
      );

  // this hero cause the problem.
  // only causes the issue on close.
  // Even if its just a Hero same problem
  Widget buildTitle() => GestureDetector(
      onTap: onClose,
      child: Hero(
        tag: 'mini-card-${widget.miniCard.title}',
        child: Container(
          padding: const EdgeInsets.all(NJTheme.padding),
          decoration: const BoxDecoration(
            color: Colors.green,
          ),
          child: NJTextSubheading(widget.miniCard.title),
        ),
      ));

  // this one may cause an overflow.
  // confirmed !
  Widget buildActivation(BuildContext context) => Hero(
      tag: 'mini-card-${widget.miniCard.title}-activation',
      child: Material(
          child: Container(
              decoration: BoxDecoration(
                color: selected ? Colors.yellow[500] : Colors.yellow[200],
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: buildToggleSwitch(),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child:
                          NJButtonPrimary(label: 'Close', onPressed: onClose),
                    )
                  ]))));

  // Called when the user clicks the close button.
  void onClose() {
    Navigator.pop(context);
  }

  Widget buildToggleSwitch() => ToggleSwitch(
      key: toggleSwitchKey,
      initialLabelIndex: (selected ? 0 : 1),
      minWidth: 50,
      minHeight: null,
      activeBgColor: Colors.green,
      activeTextColor: Colors.white,
      inactiveBgColor: Colors.grey,
      inactiveTextColor: Colors.white,
      labels: const ['On', 'Off'],
      // icons: [FontAwesomeIcons.check, FontAwesomeIcons.times],
      onToggle: (index) async => onActivationChanged(value: index == 0));

  // Called when the user taps the Switch to activate/deactive this card.
  Future<bool> onActivationChanged({required bool value}) {
    final complete = CompleterEx<bool>();

    if (value == false) {
      // force the switch back to active as you aren't allows
      // to deactivate a card. Instead you must activate another card.

      complete.complete(false);
      DialogAlert.show(context, 'Not a valid action',
          "You can't deactivate a forward. Instead activate another forward.");
    } else {
      BlockingUI().run<void>(() async {
        setState(() {
          final validator = widget.miniCard.validator();
          if (validator.valid) {
            // activated = value;
            widget.miniRowState.onActivationChanged(widget.miniCard);
            complete.complete(true);
          } else {
            DialogAlert.show(
                context, 'Activation refused', validator.cantActivateMessage);
            complete.complete(false);
          }
        });
      });
    }
    return complete.future;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('selected', selected));
  }
}
