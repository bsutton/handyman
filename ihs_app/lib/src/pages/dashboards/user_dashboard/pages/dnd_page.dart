import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../../../dao/bus/bus.dart';
import '../../../../dao/entities/call_forward_target.dart';
import '../../../../dao/entities/dnd.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../dao/types/er.dart';
import '../../../../util/format.dart';
import '../../../../util/local_date.dart';
import '../../../../util/local_time.dart';
import '../../../../widgets/call_forward/call_forward_panel_v2.dart';
import '../../../../widgets/mini_card/mini_row_state_provider.dart';
import '../../../../widgets/theme/nj_button.dart';
import '../../../../widgets/theme/text_headline_6.dart';
import '../../../../widgets/timepicker/time_picker.dart';
import '../../dashboard_page.dart';
import '../dashboard/user_page_thumb_menu.dart';

class DNDPageState extends CallForwardMiniRowState {}

class DNDPage extends StatefulWidget {
  const DNDPage({super.key});
  static const RouteName routeName = RouteName('/dndpage');

  static const String providerName = 'dndpage';

  @override
  // ignore: library_private_types_in_public_api
  _DNDPageState createState() => _DNDPageState();
}

class _DNDPageState extends State<DNDPage> {
  late ER<DND> dnd;
  late DateTime nextOpeningHours;
  late ER<CallForwardTarget> erCallForwardTarget;
  late Team? primaryTeam;
  late String diversionDescription;

  Future<void> loadData() async {
    primaryTeam = await Repos().team.primary;

    nextOpeningHours = await _getNextOpeningHours(primaryTeam!);

    dnd = ER((await Repos().dnd.getByUser(Repos().user.viewAsUser!))!);

    erCallForwardTarget = dnd.entity.callForwardTarget!;

    diversionDescription =
        await (await erCallForwardTarget.resolve)!.diversionDescription;
  }

  Future<DateTime> _getNextOpeningHours(Team team) async =>
      (await team.getNextOpeningTime(LocalDate.today()))!;

  @override
  Widget build(BuildContext context) => AppScaffold(
      builder: (context) => DashboardPage(
          loadData: (context) async => loadData(),
          title: 'Do Not Disturb',
          currentRouteName: DNDPage.routeName,
          builder: (context) => buildBody(dnd),
          thumbMenu: UserPageThumbMenu()));

  Widget buildBody(ER<DND> dnd) => ListView(
          shrinkWrap: true, //  mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildStatus(dnd.entity),
            buildCallForwardPanel(),
            buildButtons(dnd.entity)
          ]);

  Widget buildCallForwardPanel() =>
      MiniRowStateProvider<ER<CallForwardTarget>, CallForwardMiniRowState>(
        create: () => CallForwardMiniRowState(saveHandler: onSaveForwards),
        child: CallForwardPanelV2<DNDPageState>(
          erCallForwardTarget,
          showIVR: false,
        ),
      );

  ///
  /// This method is used to save any updates to the CallForwardTargets.
  /// The updated [CallForwardTarget] must be a copy of the original
  /// [CallForwardTarget] withe same GUID and id (e.g. use copyWith)
  ///
  Future<void> onSaveForwards(ER<CallForwardTarget> updated) async {
    // update the db.

    await erCallForwardTarget.resolve;
    assert(erCallForwardTarget.entity.guid == updated.guid, 'bad');
    final target = await updated.resolve;
    // update this pages reference.
    erCallForwardTarget.replace(target!);
    await Repos().callForwardTarget.update(target);

    // force the heading to update when the active forward has changed.
    setState(() {
      Bus().add<DNDBusEvent>(BusAction.update, instance: DNDBusEvent(dnd));
    });
  }

  void onChanged() {
    statusKey.currentState?.setState(() {});
  }

  GlobalKey<StatusWidgetState> statusKey = GlobalKey<StatusWidgetState>();

  Widget buildStatus(DND dnd) => StatusWidget(key: statusKey, dnd: dnd);

  Widget buildButtons(DND dnd) {
    final oneHour = DateTime.now().add(const Duration(hours: 1));

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      buildDNDTomorrow(dnd),
      NJButtonSecondary(
          label: 'DND FOR 1 HOUR ${Format.dateTime(oneHour, 'h:mm a')}',
          onPressed: () => enableDNDUtil(dnd, oneHour)),
      NJButtonSecondary(
          label: 'DND CUSTOM PERIOD ...',
          onPressed: () async => customPeriod(dnd)),
      buildDNDButton(dnd),
    ]);
  }

  Future<void> customPeriod(DND dnd) async {
    final pickedTime = await TimePicker.show(
        context, ' DND Custom Period', getDefaultCustomPeriod());

    if (pickedTime != null) {
      setState(() {
        enableDNDUtil(dnd, pickedTime.asDateTime());
      });
    }
  }

  String getOneHour() =>
      Format.time(DateTime.now().add(const Duration(hours: 1)), '(h:mm a)');

  LocalTime getDefaultCustomPeriod() {
    final now = DateTime.now();

    final endTime = LocalTime.fromDateTime(now.add(const Duration(hours: 2)));

    // round minutes to nearest 5 minutes so the TimePicker shows a selected minute button.
    final minute = endTime.minute ~/ 5 * 5;
    return LocalTime(hour: endTime.hour, minute: minute);
  }

  Widget buildDNDButton(DND dnd) {
    String label;

    label = dnd.isDiverted() ? 'CANCEL DIVERSION' : 'DO NOT DISTURB ME';

    return NJButtonPrimary(
        label: label, onPressed: () => toggleDoNoDisturb(dnd));
  }

  void toggleDoNoDisturb(DND dnd) {
    setState(() {
      if (dnd.isDiverted()) {
        dnd.forcedOn = false;
        dnd.endTime = null;
      } else {
        dnd.forcedOn = true;
      }
    });
  }

  Widget buildDNDTomorrow(DND dnd) {
    final label =
        'DND UNTIL ${Format.dateTime(nextOpeningHours, 'EEE h:mm a').toUpperCase()}';
    return NJButtonSecondary(
        label: label, onPressed: () => enableDNDUtil(dnd, nextOpeningHours));
  }

  void enableDNDUtil(DND dnd, DateTime dateTime) {
    setState(() {
      dnd.endTime = dateTime;
      dnd.forcedOn = false;
    });
  }
}

class StatusWidget extends StatefulWidget {
  const StatusWidget({required this.dnd, super.key});
  final DND dnd;

  @override
  StatusWidgetState createState() => StatusWidgetState();
}

class StatusWidgetState extends State<StatusWidget> {
  StatusWidgetState();
  String status = '';

  String diversion = '';

  DateTime now = DateTime.now();

  Future<void> updateDescription() async {
    final target = widget.dnd.callForwardTarget!.entity;

    final diversionDescription = await target.diversionDescription;

    if (widget.dnd.forcedOn) {
      status = 'DND is on until you disable it.';
      diversion = 'Calls are $diversionDescription.';
      // color = Colors.orangeAccent;
    } else {
      if (widget.dnd.endTime!.isBefore(now)) {
        status = 'DND is off.';
        diversion = 'Calls are flowing normally.';
      } else {
        status =
            'DND is on until ${Format.dateTime(widget.dnd.endTime!, 'EEE h:mm a.')}';
        diversion = ' Calls are $diversionDescription.';
        // color = Colors.orangeAccent;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).textTheme.titleLarge!.color;

    return FutureBuilderEx(
        future: () async => updateDescription(),
        builder: (context, _) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextHeadline6(diversion, color: color)),
              TextHeadline6(status, color: color),
            ])));
  }
}

class DNDBusEvent {
  DNDBusEvent(this.dnd);
  ER<DND> dnd;
}
