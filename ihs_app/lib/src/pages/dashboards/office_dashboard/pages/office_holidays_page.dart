import 'dart:async';

import 'package:completer_ex/completer_ex.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../../../dao/entities/call_forward_target.dart';
import '../../../../dao/entities/office_holidays.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../dao/types/er.dart';
import '../../../../util/format.dart';
import '../../../../util/local_date.dart';
import '../../../../widgets/call_forward/call_forward_panel_v2.dart';
import '../../../../widgets/theme/text_body_1.dart';
import '../../../../widgets/theme/text_headline_6.dart';
import '../../dashboard_page.dart';
import '../../user_dashboard/dashboard/user_page_thumb_menu.dart';

class OfficeHolidaysState extends CallForwardMiniRowState {}

class OfficeHolidaysPage extends StatefulWidget {
  const OfficeHolidaysPage({super.key});
  static const RouteName routeName = RouteName('/officeholidayspage');

  @override
  OfficeHolidaysPageState createState() => OfficeHolidaysPageState();
}

class OfficeHolidaysPageState extends State<OfficeHolidaysPage> {
  late OfficeHolidays? officeHolidays;

  late ER<CallForwardTarget> callForwardTarget;

  Future<void> loadData() async => loader(() async {
        final customer = Repos().customer;
        final erHolidays = await customer.officeHolidays;
        officeHolidays = await erHolidays!.resolve;
        callForwardTarget = officeHolidays!.callForwardTarget!;
      });

  Future<void> loader<T>(Future<T> Function() payload) {
    final done = CompleterEx<T>();
    payload().then((value) => done.complete(null));
    return done.future;
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
        builder: (context) => DashboardPage(
            loadData: (context) async => loadData(),
            title: 'Office Holidays',
            currentRouteName: OfficeHolidaysPage.routeName,
            builder: (context) => buildBody(),
            thumbMenu: UserPageThumbMenu()),
      );

  Widget buildBody() => ListView(
          shrinkWrap: true, //  mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildActivateSwitch(),
            buildStatus(),
            buildDates(),
            CallForwardPanelV2<OfficeHolidaysState>(
              callForwardTarget,
            ),
          ]);

  void onActivateForward() {
    setState(() {
      // force the heading to update when the active forward has changed.
    });
  }

  Widget buildDates() {
    final start = officeHolidays!.start;
    final end = officeHolidays!.end;

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      buildDate('First Day', start,
          (date) => setState(() => officeHolidays!.start = date)),
      buildDate(
          'Last Day', end, (date) => setState(() => officeHolidays!.end = date))
    ]);
  }

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

  void onActivate(OfficeHolidays officeHolidays, {required bool enabled}) {
    setState(() => officeHolidays.active = enabled);
  }

  Widget buildActivateSwitch() => Row(children: [
        Switch(
            value: officeHolidays!.active,
            onChanged: (enabled) =>
                onActivate(officeHolidays!, enabled: enabled)),
        const TextHeadline6('Activate')
      ]);

  Widget buildStatus() {
    String status;
    var color = Theme.of(context).textTheme.titleLarge!.color;
    if (officeHolidays!.active) {
      if (officeHolidays!.start.isAfter(officeHolidays!.end)) {
        status = 'Error: the First date must be before the Last date';
        color = Colors.red;
      } else {
        if (officeHolidays!.end.isBefore(LocalDate.today())) {
          status = 'Office holidays are in the Past';
          color = Colors.orangeAccent;
        } else {
          if (officeHolidays!.start.isAfter(LocalDate.today())) {
            status = 'Office holidays start on: '
                '${Format.localDate(officeHolidays!.start, 'EEE yyyy MMM dd')}';
          } else {
            status = 'On Holidays until: '
                '${Format.localDate(officeHolidays!.end, 'EEE yyyy MMM dd')}';
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
