import 'dart:async';

import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';
import 'package:timezone/standalone.dart';

import '../../../../../dao/entities/region.dart';
import '../../../../../dao/repository/repos.dart';
import '../../../../../dialogs/dialog_selection.dart';
import '../../../../../util/locations.dart';
import '../../../../../util/ref.dart';
import '../../../../../util/schedule_now.dart';
import '../../../../../widgets/clock_international.dart';
import '../../../../../widgets/theme/nj_text_themes.dart';
import '../../../../../widgets/theme/nj_theme.dart';
import '../../../../../widgets/wizard_step.dart';

///
/// A page that allows a user to acquire a new DID
///
class SelectRegionStep extends WizardStep {
  SelectRegionStep(this.selectedRegion) : super(title: 'Region');
  final FutureRef<Region> selectedRegion;

  @override
  Widget build(BuildContext context) => SelectRegion(selectedRegion);
}

class SelectRegion extends StatefulWidget {
  const SelectRegion(this.selectedRegion, {super.key});
  final FutureRef<Region> selectedRegion;

  @override
  State<StatefulWidget> createState() => SelectRegionState();
}

class SelectRegionState extends State<SelectRegion> {
  SelectRegionState();
  late ScrollController _scrollController;

  /// map of timezones to Locations
  Map<String, Location> locations = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) => ListTileTheme(
      selectedColor: Colors.red,
      child: Column(children: [buildStateSelection()]));

  // @override
  // void onNext(BuildContext context, WizardStepTarget intendedStep,
  //     bool userOriginated) async {}

  Widget buildStateSelection() => FutureBuilderEx<List<Region>>(
        future: () async => resolveEntities(),
        builder: (context, regions) {
          final tiles = <Card>[];

          final selectedKey = GlobalKey();

          var selectedIndex = 0;
          var index = 0;
          for (final region in regions!) {
            final selected = region == widget.selectedRegion.obj;

            final card = Card(
                key: selected ? selectedKey : null,
                color: selected
                    ? NJColors.listCardBackgroundSelected
                    : NJColors.listCardBackgroundInActive,
                child: ListTile(
                    dense: true,
                    // selected: region == this.selectedRegion.obj,
                    onTap: () => changeRegion(region),
                    leading:
                        const Icon(Icons.watch, color: NJColors.listCardText),
                    title: NJTextListItem(region.timezone.humanName),
                    trailing:
                        ClockInternational(locations[region.timezone.name]!)));
            if (selected) {
              selectedIndex = index;
              //Scrollable.ensureVisible(selectedKey.currentContext);
            }
            index++;

            tiles.add(card);
          }

          final height = MediaQuery.of(context).size.height / 3;
          final Widget list = SizedBox(
              height: height,
              child: ListView(controller: _scrollController, children: tiles));

          scheduleNow(() async => _scrollController.animateTo(
              (selectedIndex * 70).toDouble(),
              duration: const Duration(seconds: 2),
              curve: Curves.ease));

          return list;
        },
      );

  Future<Region?> selectState(BuildContext context) async {
    final regions = await Repos().region.getAll();
    final defaultRegion = await Repos().region.defaultRegion;
    var region = defaultRegion;
    if (context.mounted) {
      region = await DialogSelection.show<Region>(
          context: context,
          title: 'Select State',
          searchLabel: 'State',
          cardBuilder: (context, cardsRegion, selected) =>
              NJTextListItem(cardsRegion.timezone.humanName),
          filterMatch: (filter, cardsRegion) => Future.value(true),
          initialData: regions,
          initialT: defaultRegion);
    }

    return region;
  }

  void changeRegion(Region region) {
    setState(() {
      widget.selectedRegion.obj = region;
    });
  }

  Future<List<Region>> resolveEntities() async {
    await widget.selectedRegion.future;

    final regions =
        await Repos().region.getByCountry(widget.selectedRegion.obj.country);

    for (final region in regions) {
      locations[region.timezone.name] =
          await Locations().getLocation(region.timezone.name);
    }

    return regions;
  }
}
