import 'dart:async';

import 'package:completer_ex/completer_ex.dart';
import 'package:flutter/material.dart';

import '../../app/router.dart';
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
  // ignore: avoid_positional_boolean_parameters
  MiniCardValidator(this.valid, this.cantActivateMessage);

  MiniCardValidator.success()
      : valid = true,
        cantActivateMessage = '';

  bool valid;
  // messages as to why the card is invalid
  // We display this message when a user tries to activate
  // a card.
  String cantActivateMessage;
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
    this.onActivate,
  }) : super(key: GlobalKey<MiniCardState<T, S>>());
  final String title;
  final MiniCardContentBuilder contentBuilder;
  final MiniCardValidator Function() validator;
  final Future<MaxiContent<T>> Function()? maxiBuilder;
  final void Function(T)? onActivate;

  // a handle to the data this mini card is holding.
  final T? data;

  final double widthFactor;
  final double heightFactor;

  static const double borderRadius = 10;

  final Color barColor;

  final GlobalKey<MiniCardState<T, S>> miniCardState = GlobalKey();

  @override
  MiniCardState<T, S> createState() => MiniCardState<T, S>();

  bool equals(MiniCard<T, S> other) => title == other.title;
}

class MiniCardState<T, S extends MiniRowState<T, S>>
    extends State<MiniCard<T, S>> {
  // bool activated = false;

  MiniCardContent? currentContent;
  GlobalKey<ToggleSwitchState> toggleSwitchKey = GlobalKey<ToggleSwitchState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * widget.widthFactor;
    final height = MediaQuery.of(context).size.height * widget.heightFactor;

    return SizedBox(width: width, height: height, child: buildBody(context));
  }

  /// Builds the body of the card which is a top panel covering most
  /// of the UI and the bottom activation bar.
  Widget buildBody(BuildContext context) => GestureDetector(
      onTap: showMaxiCard,
      child: Container(
        margin: const EdgeInsets.only(
            left: NJTheme.padding, right: NJTheme.padding),
        decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(
              Radius.circular(MiniCard.borderRadius),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Row(children: [buildPanel(), buildRightBar()])),
            buildActivation(context)
          ],
        ),
      ));

  // elevation: selected ? 0 : 12,
  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  Widget buildPanel() => Expanded(
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [buildTitle(), buildContent()]),
      );

  Widget buildRightBar() => Hero(
      tag: 'mini-card-${widget.title}-rightBar',
      child: Container(
        width: 20,
        // height: 100,
        decoration: BoxDecoration(
            color: widget.barColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(MiniCard.borderRadius),
            )),
      ));

  Widget buildContent() => Expanded(
        // child: Hero(
        //   tag: 'mini-card-${widget.title}-content',
        child: Container(
          padding: const EdgeInsets.all(NJTheme.padding),

          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
          // When the MaxiCard closes we get notify and force
          // the body to rebuild to reflect any changes made
          // by the maxi card editing session.
          child: NamedConsumer<S>(builder: (context, state, _) {
            currentContent = widget.contentBuilder(context);
            return currentContent! as Widget;
          }),
        ),
        // ),
        // )
      );

  Widget buildTitle() => Hero(
        tag: 'mini-card-${widget.title}',
        child: Container(
          padding: const EdgeInsets.all(NJTheme.padding),
          decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MiniCard.borderRadius))),
          child: NJTextSubheading(widget.title),
        ),
      );

  // if the active mini-card changes we must redraw to reflect our new activation status.
  Widget buildActivation(BuildContext context) => NamedConsumer<S>(
        builder: (context, state, _) {
          final activated = state.isActive(widget);
          if (toggleSwitchKey.currentState != null) {
            toggleSwitchKey.currentState?.setIndex(activated ? 0 : 1);
          }
          return Hero(
              tag: 'mini-card-${widget.title}-activation',
              child: Material(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(MiniCard.borderRadius),
                      bottomLeft: Radius.circular(MiniCard.borderRadius)),
                  child: Container(
                      decoration: BoxDecoration(
                          color: activated
                              ? Colors.yellow[500]
                              : Colors.yellow[200],
                          borderRadius: const BorderRadius.only(
                              bottomRight:
                                  Radius.circular(MiniCard.borderRadius),
                              bottomLeft:
                                  Radius.circular(MiniCard.borderRadius))),
                      alignment: Alignment.centerLeft,
                      child: buildSwitch(activated: activated))));
        },
      );

  Future<void> showMaxiCard() async {
    final state = NamedProvider.of<S>();

    await SQRouter().pushNamedWithArg<MaxiCardPage<T,S>, MaxiCardRouteArgs<T,S>>(
        MaxiCardPage.routeName, MaxiCardRouteArgs<T, S>(state!, widget));
  }

  Widget buildSwitch({required bool activated}) => Container(
        margin: const EdgeInsets.all(10),
        child: ToggleSwitch(
            key: toggleSwitchKey,
            initialLabelIndex: (activated ? 0 : 1),
            minWidth: 50,
            activeBgColor: Colors.green,
            activeTextColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveTextColor: Colors.white,
            labels: const ['On', 'Off'],
            // icons: [FontAwesomeIcons.check, FontAwesomeIcons.times],
            onToggle: (index) async => onActivationChanged(active: index == 0)),
      );

  // Called when the user taps the Switch to activate/deactive this card.
  Future<bool> onActivationChanged({required bool active}) {
    final complete = CompleterEx<bool>();

    final miniRowState = NamedProvider.of<S>();

    if (active == false) {
      // force the switch back to active as you aren't allows
      // to deactivate a card. Instead you must activate another card.

      complete.complete(false);
      DialogAlert.show(context, 'Not a valid action',
          "You can't deactivate a forward. Instead activate another forward.");
    } else {
      BlockingUI().run<void>(() async {
        setState(() {
          final validator = widget.validator();
          if (validator.valid) {
            // activated = value;

            miniRowState?.onActivationChanged(widget);
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
}

class MaxiCardRouteArgs<T, S extends MiniRowState<T, S>> {
  MaxiCardRouteArgs(this.state, this.miniCard);
  // The MiniCard which the user is currently editing.
  MiniCard<T, S> miniCard;
  MiniRowState<T,S> state;
}
