import 'package:flutter/material.dart';
import 'package:timezone/standalone.dart';

import '../util/format.dart';
import '../util/local_time.dart';
import 'theme/nj_text_themes.dart';
import 'tick_builder.dart';

class ClockInternational extends StatefulWidget {

  const ClockInternational(this.location, {super.key, this.color = Colors.black});
  final Location location;
  final Color color;

  @override
  State<StatefulWidget> createState() => ClockInternationalState();
}

class ClockInternationalState extends State<ClockInternational> {
  @override
  Widget build(BuildContext context) => TickBuilder(
        interval: const Duration(seconds: 1),
        limit: 100, // not actually used.
        builder: (context, tick) {
          final locationNow = TZDateTime.now(widget.location);

          // DateTime locationTime = DateTime.fromMillisecondsSinceEpoch(
          //     widget.location.translate(DateTime.now().millisecondsSinceEpoch));

          final time = LocalTime.fromDateTime(locationNow);
          return NJTextLabel(Format.localTime(time), color: widget.color);
        });
}
