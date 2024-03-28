import 'package:flutter/material.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../../../dao/bus/bus.dart';
import '../../../../dao/entities/call_forward_target.dart';
import '../../../../dao/entities/did_forward.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../dao/types/er.dart';
import '../../../../widgets/blocking_ui.dart';
import '../../../../widgets/call_forward/call_forward_panel_v2.dart';
import '../../../../widgets/empty.dart';
import '../../../../widgets/mini_card/mini_row_state_provider.dart';
import '../../../../widgets/theme/nj_text_themes.dart';
import '../../../../widgets/theme/nj_theme.dart';
import '../../dashboard_page.dart';
import '../dashboard/office_page_thumb_menu.dart';

class PhoneNoEditPage extends StatefulWidget {
  const PhoneNoEditPage({super.key, this.forwardTo});
  static const RouteName routeName = RouteName('phonenoedit');
  static const providerName = 'phonenoedit';
  final ER<DIDForward>? forwardTo;

  @override
  PhoneNoEditPageState createState() => PhoneNoEditPageState();
}

class PhoneNoEditPageState extends State<PhoneNoEditPage> {
  late ER<CallForwardTarget>? erCallForwardTarget;

  Future<void> loadData() async {
    erCallForwardTarget = (await widget.forwardTo!.resolve)!.callForwardTarget;
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
        builder: (context) => DashboardPage(
            loadData: (context) async => loadData(),
            title: 'Phone Management',
            currentRouteName: PhoneNoEditPage.routeName,
            builder: (context) => buildUI(),
            thumbMenu: OfficePageThumbMenu()),
      );

  Widget buildUI() => Column(children: [
        NJTextPageHeading(widget.forwardTo!.entity.did!.toNational()),
        Padding(
          padding: const EdgeInsets.all(NJTheme.padding),
          child: NJTextSubheading(
              'Select the action to perform when a call is recieved.'),
        ),
        MiniRowStateProvider<ER<CallForwardTarget>, CallForwardMiniRowState>(
          create: () => CallForwardMiniRowState(saveHandler: onSaveForwards),
          child: const Empty(), // was after hours
        ),
      ]);

  ///
  /// This method is used to save any updates to the CallForwardTargets.
  /// The updated [CallForwardTarget] must be a copy of the original
  /// [CallForwardTarget] withe same GUID and id (e.g. use copyWith)
  ///
  Future<void> onSaveForwards(ER<CallForwardTarget> updated) async {
    // update the db.

    await BlockingUI().run<void>(() async {
      await erCallForwardTarget!.resolve;
      assert(erCallForwardTarget!.entity.guid == updated.guid, 'bad');
      final target = await updated.resolve;
      // update this pages reference.
      erCallForwardTarget!.replace(target!);
      await Repos().callForwardTarget.update(target);

      // force the heading to update when the active forward has changed.
      setState(() {
        Bus().add<PhoneManagementBusEvent>(BusAction.update,
            instance: PhoneManagementBusEvent(widget.forwardTo!));
      });
    });
  }

  Widget buildOverview() => const Column();
}

class PhoneManagementBusEvent {
  PhoneManagementBusEvent(this.didForward);
  ER<DIDForward> didForward;
}
