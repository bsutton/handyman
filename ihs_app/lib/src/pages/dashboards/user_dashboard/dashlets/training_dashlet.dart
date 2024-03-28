import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../../../app/router.dart';
import '../../../../dao/bus/bus_builder.dart';
import '../../../../dao/entities/tutorial.dart';
import '../../../../dao/entities/tutorial_was_viewed.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../../../tutorial/tutorial_index_page.dart';

class TrainingDashlet extends StatefulWidget {
  const TrainingDashlet({super.key});

  @override
  State<StatefulWidget> createState() => TrainingDashletState();
}

class TrainingDashletState extends State<TrainingDashlet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BusBuilder<TutorialWasViewed>(
      builder: (context, event) => FutureBuilderEx<List<Tutorial>>(
            future: () async => Repos().tutorial.getNewTutorials(),
            waitingBuilder: (context) => buildDashlet(0),
            errorBuilder: (context, error) => buildDashlet(0),
            builder: (context, tutorials) => buildDashlet(tutorials!.length),
            debugLabel: 'Training Dashlet',
          ));

  Widget buildDashlet(int newTutorials) => Dashlet(
      label: 'Training',
      svgImage: const Svg('Training', height: Dashlet.height),
      targetRoute: TutorialIndexPage.routeName,
      chipText: newTutorials == 0 ? null : 'New: $newTutorials',
      chipColor: Colors.green);

  Future<void> pushRoute() async {
    await SQRouter().pushNamed(TutorialIndexPage.routeName);
  }
}
