import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../../../dao/entities/call_forward_target.dart';
import '../../../../dao/entities/did_forward.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../dao/types/er.dart';
import '../../../../widgets/alignment.dart';
import '../../../../widgets/theme/nj_text_themes.dart';
import '../../../../widgets/theme/nj_theme.dart';
import '../../dashboard_page.dart';
import '../dashboard/office_page_thumb_menu.dart';
import 'acquire_did_wizard/acquire_did_wizard.dart';
import 'phone_no_edit_page.dart';

class PhoneNoListPage extends StatefulWidget {
  const PhoneNoListPage({super.key});
  static const RouteName routeName = RouteName('phonenolist');

  @override
  PhoneNoListPageState createState() => PhoneNoListPageState();
}

class PhoneNoListPageState extends State<PhoneNoListPage> {
  @override
  Widget build(BuildContext context) => AppScaffold(
        builder: (context) => DashboardPage(
            title: 'Phone Numbers',
            currentRouteName: PhoneNoListPage.routeName,
            builder: (context) => buildUI(),
            thumbMenu: OfficePageThumbMenu()),
      );

  @override
  void initState() {
    super.initState();
  }

  Future<List<DIDForward>> resolveEntities() async {
    final forwards = await Repos().customer.ownedPhoneNumbers;
    // await ER.resolveListChild<DIDForward, PhoneNumber>(forwards, (forward) => forward.entity.did));
    await ER.resolveListChild<DIDForward, CallForwardTarget>(
        forwards, (forward) => forward.callForwardTarget!.resolveER);

    return forwards;
  }

  Widget buildPhoneList() => FutureBuilderEx<List<DIDForward>>(
        future: resolveEntities,
        builder: (context, dids) =>
            ListView(children: <Widget>[...buildDIDList(dids!)]),
      );

  List<Widget> buildDIDList(List<DIDForward> dids) {
    final list = <Widget>[];

    for (final did in dids) {
      final didWidget = buildPhoneTile(did);
      list.add(didWidget);
    }
    return list;
  }

  Widget buildUI() => Column(children: [
        Expanded(child: buildPhoneList()),
        Right(
            child: FloatingActionButton(
                heroTag: 'Add',
                onPressed: onAddDID,
                child: const Icon(Icons.add)))
      ]);

  Future<void> onAddDID() async {
    // AcquireDIDWizard().show(context);
    await SQRouter().pushNamed(AcquireDIDWizard.routeName);
  }

  Widget buildPhoneTile(DIDForward didForward) => GestureDetector(
      onTap: () async => editTile(didForward),
      child: Card(
          color: NJColors.listCardBackgroundInActive, // Colors.green,
          child: ListTile(
              title: NJTextListItem(didForward.did!.toNational()),
              dense: true,
              subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTargetDescription(didForward),
                    NJTextListItem(
                        didForward.callForwardTarget!.entity.shortDescription())
                  ]))));

  Future<void> editTile(DIDForward didForward) async {
    await SQRouter()
        .pushNamedWithArg(PhoneNoEditPage.routeName, ER(didForward));
  }

  Widget buildTargetDescription(DIDForward didForward) =>
      FutureBuilderEx<String>(
        future: () => didForward.callForwardTarget!.entity.targetDescription,
        builder: (context, description) => NJTextListItem(description!),
      );
}
