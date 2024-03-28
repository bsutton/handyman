import 'package:flutter/material.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../../../dao/bus/bus.dart';
import '../../../../dao/entities/call_forward_target.dart';
import '../../../../dao/entities/leave.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../dao/types/er.dart';
import '../../../../dialogs/dialog_alert.dart';
import '../../../../util/format.dart';
import '../../../../util/local_date.dart';
import '../../../../util/log.dart';
import '../../../../widgets/call_forward/call_forward_panel_v2.dart';
import '../../../../widgets/mini_card/mini_row_state_provider.dart';
import '../../../../widgets/theme/text_body_1.dart';
import '../../../../widgets/theme/text_headline_6.dart';
import '../../dashboard_page.dart';
import '../dashboard/user_page_thumb_menu.dart';

class UserHolidaysPageState extends CallForwardMiniRowState {}

class HolidaysPage extends StatefulWidget {
  const HolidaysPage({super.key});
  static const RouteName routeName = RouteName('/userholidayspage');

  @override
  HolidaysPageState createState() => HolidaysPageState();
}

class HolidaysPageState extends State<HolidaysPage> {
  late ER<Leave>? leave;
  late ER<CallForwardTarget> erCallForwardTarget;

  Future<void> loadData() async {
    final viewAsUser = Repos().user.viewAsUser;
    final repo = Repos().leave;
    leave = ER((await repo.getByUser(viewAsUser))!);
    erCallForwardTarget = leave!.entity.callForwardTarget!;
    Log.d('loadData returning target = $erCallForwardTarget');
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
        builder: (context) => DashboardPage(
            loadData: (_) async => loadData(),
            title: 'Holidays',
            currentRouteName: HolidaysPage.routeName,
            builder: (context) => buildBody(),
            thumbMenu: UserPageThumbMenu()),
      );

  Widget buildBody() => ListView(
          shrinkWrap: true, //  mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildActivateSwitch(leave!),
            buildStatus(leave!.entity),
            buildDates(leave!.entity),
            MiniRowStateProvider<ER<CallForwardTarget>,
                CallForwardMiniRowState>(
              create: () =>
                  CallForwardMiniRowState(saveHandler: onSaveForwards),
              child: CallForwardPanelV2<UserHolidaysPageState>(
                erCallForwardTarget,
                showIVR: false,
              ),
            ),
          ]);

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
      Bus().add<HolidayBusEvent>(BusAction.update,
          instance: HolidayBusEvent(leave!));
    });
  }

  // var start = leave.getStart();
  // var end = leave.getEnd();

  // start ??= LocalDate.today();

  // end ??= start.addDays(7);
  Widget buildDates(Leave leave) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        buildDate(
            'First Day',
            leave.getStart(),
            (date) => setState(() async {
                  leave.startDate = date;
                  await Repos().leave.update(leave);
                })),
        buildDate(
            'Last Day',
            leave.getEnd(),
            (date) => setState(() async {
                  leave.endDate = date;
                  await Repos().leave.update(leave);
                }))
      ]);

  Widget buildDate(
          String label, LocalDate? date, void Function(LocalDate) onChanged) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(children: [
            TextBody1(
                '$label: ${date != null ? Format.localDate(date) : "Not Set"}'),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async => _selectDate(context, date, onChanged),
              child: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.date_range)),
            )
          ]));

  Future<void> _selectDate(BuildContext context, LocalDate? date,
      void Function(LocalDate) onChanged) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: date != null ? date.toDateTime() : DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null) {
      onChanged(LocalDate.fromDateTime(picked));
    }
  }

  Future<void> onActivate(
    ER<Leave> leaveRef, {
    required bool enabled,
  }) async {
    final today = LocalDate.today();
    if (leaveRef.entity.endDate!.isBefore(today)) {
      await DialogAlert.show(context, 'Invalid Date range',
          'The Last Day of leave is in the past.');
      return;
    }

    if (leaveRef.entity.endDate!.isBefore(leaveRef.entity.startDate!)) {
      await DialogAlert.show(context, 'Invalid Date range',
          'The Last Day of leave must be AFTER the First Day of leave');
      return;
    }

    setState(() {
      leave!.entity.active = enabled;
      Repos().leave.update(leave!.entity);
      Bus().add<HolidayBusEvent>(BusAction.update,
          instance: HolidayBusEvent(leaveRef));
    });
  }

  Widget buildActivateSwitch(ER<Leave> leaveRef) => Row(children: [
        Switch(
            value: leaveRef.entity.active,
            onChanged: (enabled) async =>
                onActivate(leaveRef, enabled: enabled)),
        const TextHeadline6('Activate')
      ]);

  Widget buildStatus(Leave leave) {
    String status;
    var color = Theme.of(context).textTheme.titleLarge!.color;
    if (leave.active) {
      if (leave.startDate!.isAfter(leave.endDate!)) {
        status = 'Error: the First date must be before the Last date';
        color = Colors.red;
      } else {
        if (leave.endDate!.isBefore(LocalDate.today())) {
          status = 'Your holidays are in the Past';
          color = Colors.orangeAccent;
        } else {
          if (leave.startDate!.isAfter(LocalDate.today())) {
            status =
                'Your holidays start on: ${Format.localDate(leave.startDate!, 'EEE yyyy MMM dd')}';
          } else {
            status =
                'Last day of Holidays: ${Format.localDate(leave.endDate!, 'EEE yyyy MMM dd')}';
          }
        }
      }
    } else {
      status = 'Holidays are inactive';
      color = Colors.orangeAccent;
    }
    status += '.';
    return Padding(
        padding: const EdgeInsets.all(20),
        child: TextHeadline6(status, color: color));
  }
}

class HolidayBusEvent {
  HolidayBusEvent(this.leave);
  ER<Leave> leave;
}
