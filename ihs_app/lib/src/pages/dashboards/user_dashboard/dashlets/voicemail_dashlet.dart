import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../../../dao/bus/bus_builder.dart';
import '../../../../dao/entities/voicemail_message.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../dao/repository/user_repository.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../../../voicemail/voicemail_index_page.dart';

class VoicemailDashlet extends StatefulWidget {
  const VoicemailDashlet({super.key});

  @override
  State<StatefulWidget> createState() => VoicemailDashletState();
}

class VoicemailDashletState extends State<VoicemailDashlet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BusBuilder<VoicemailMessage>(
      builder: (context, event) => FutureBuilderEx<List<VoicemailMessage>>(
            future: () async => Repos()
                .voicemailMessage
                .getByUser(UserRepository().viewAsUser!),
            waitingBuilder: (context) => buildDashlet(null),
            errorBuilder: (context, error) => buildDashlet(null),
            builder: (context, messages) =>
                buildDashlet('Unread ${messages!.length}'),
            debugLabel: 'Voicemail Dashlet',
          ));

  Widget buildDashlet(String? chipText) => Dashlet(
        label: 'Voicemail',
        svgImage: buildContent(),
        chipColor: Colors.orange,
        chipText: chipText,
        flex: 2,
        targetRoute: VoicemailIndexPage.routeName,
      );

  Widget buildContent() => const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Svg('Voicemail', height: Dashlet.height),
          ),
        ],
      );
}
