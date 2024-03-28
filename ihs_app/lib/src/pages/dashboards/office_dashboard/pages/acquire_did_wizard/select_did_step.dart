import 'dart:async';
import 'dart:math';

import 'package:completer_ex/completer_ex.dart';
import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/square_phone_app.dart';
import '../../../../../dao/entities/priced_did_range.dart';
import '../../../../../dao/entities/region.dart';
import '../../../../../dao/repository/actions/action_get_did_choices.dart';
import '../../../../../dialogs/dialog_info.dart';
import '../../../../../util/quick_snack.dart';
import '../../../../../util/ref.dart';
import '../../../../../widgets/theme/nj_text_themes.dart';
import '../../../../../widgets/theme/nj_theme.dart';
import '../../../../../widgets/wizard.dart';
import '../../../../../widgets/wizard_step.dart';

///
/// A page that allows a user to acquire a new DID
///
class SelectDIDStep extends WizardStep {
  SelectDIDStep(this.selectedRegion, this.selectedDID)
      : super(title: 'Phone No.');
  final FutureRef<Region> selectedRegion;
  final Ref<PricedDIDRange> selectedDID;

  @override
  Widget build(BuildContext context) => SelectDID(selectedRegion, selectedDID);

  @override
  Future<void> onNext(BuildContext context, WizardStepTarget intendedStep,
      {required bool userOriginated}) async {
    if (selectedDID.isNotEmpty) {
      intendedStep.confirm();
    } else {
      await QuickSnack().warning(context, 'Please select a Phone No.');
      intendedStep.cancel();
    }
  }
}

class SelectDID extends StatefulWidget {
  const SelectDID(this.selectedRegion, this.selectedDID, {super.key});
  final FutureRef<Region> selectedRegion;
  final Ref<PricedDIDRange> selectedDID;

  @override
  State<StatefulWidget> createState() => SelectDIDState();
}

class SelectDIDState extends State<SelectDID> {
  SelectDIDState();
  late Future<List<PricedDIDRange>> sortedPricedDIDs;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData() async {
    final completer = CompleterEx<List<PricedDIDRange>>();
    sortedPricedDIDs = completer.future;

    final region = widget.selectedRegion.obj;
    // Fetch some priced DIDs.
    await ActionGetDIDChoices(region).run().then<void>((dids) {
      final premium = <PricedDIDRange>[];
      final nonPremium = <PricedDIDRange>[];

      // sort them premium/non-premium, premium/non-premium,...
      for (final range in dids) {
        range.valuationType == ValuationType.premium
            ? premium.add(range)
            : nonPremium.add(range);
      }
      final sorted = <PricedDIDRange>[];

      for (var i = 0; i < max(nonPremium.length, premium.length); i++) {
        if (i < premium.length) {
          sorted.add(premium[i]);
        }

        if (i < nonPremium.length) {
          sorted.add(nonPremium[i]);
        }
      }
      completer.complete(sorted);
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      FutureBuilderEx(
          future: () async => fetchData(),
          builder: (context, _) =>
              ListTileTheme(child: Column(children: [buildDIDSelection()])));

  Widget buildDIDSelection() => FutureBuilderEx<List<PricedDIDRange>>(
        future: () => sortedPricedDIDs,
        builder: (context, available) {
          final dids = <Widget>[];

          for (final pricedDid in available!) {
            dids.add(buildCard(pricedDid));
          }

          final height = MediaQuery.of(context).size.height / 3;
          return SizedBox(height: height, child: ListView(children: dids));
        },
      );

  Widget buildCard(PricedDIDRange pricedDid) => Card(
      color: widget.selectedDID.obj == pricedDid
          ? NJColors.listCardBackgroundSelected
          : NJColors.listCardBackgroundInActive,
      child: ListTile(
        onTap: () => selected(pricedDid),
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          buildFormattedRange(pricedDid),
          NJTextListItem('${pricedDid.chargePrice.format('S 0.00')} per month'),
          GestureDetector(
              onTap: info,
              child: const Icon(Icons.info_outline,
                  color: NJColors.helpIcon // Colors.blue, // .infoBackground,
                  ))
        ]),
        dense: true,
      ));

  Widget buildFormattedRange(PricedDIDRange pricedDid) {
    if (pricedDid.valuationType == ValuationType.nonPremium) {
      return NJTextListItem(pricedDid.formattedRange);
    } else {
      return NJTextListItemBold(pricedDid.formattedRange);
    }
  }

  void selected(PricedDIDRange pricedDid) {
    setState(() {
      widget.selectedDID.obj = pricedDid;
    });
  }

  Future<void> info() async {
    await DialogInfo.showWithWidget(
        context, 'Pricing details', buildInfoMessage());
  }

  Widget buildInfoMessage() => GestureDetector(
      onTap: showInfoURL,
      child: RichText(
          text: TextSpan(children: [
        const TextSpan(
            style: NJTextBody.style,
            text:
                'Price includes unlimited local, mobile and national calls within the terms of our '),
        TextSpan(
            text: 'fair use policy',
            style: NJTextBody.style.copyWith(
                color: Colors.blue, decoration: TextDecoration.underline)),
        const TextSpan(
            text:
                '. International and Premium numbers such as 1300 are charged separately.')
      ])));

  Future<void> showInfoURL() async {
    final url = Uri.parse(SquarePhoneApp.fairUseURL);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
