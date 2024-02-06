import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../svg.dart';
import '../theme/nj_text_themes.dart';
import 'time_of_day_state.dart';

class MoonPhase extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MoonPhaseState();
  }
}

class MoonPhaseState extends State<MoonPhase> {
  String period = 'Midnight';
  String icon = 'moon';
  Color color = Colors.yellow;

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalTimeState>(builder: (context, timeOfDay, _) {
      determineDisplay(timeOfDay);
      return Row(
        children: [getSvg(), NJTextSubheading(period)],
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      );
    });
  }

  Svg getSvg() {
    var image = Svg(icon, location: LOCATION.VAADIN, height: 16, width: 24, color: color);
    return image;
  }

  void determineDisplay(LocalTimeState timeOfDay) {
    var minute = timeOfDay.minute;
    var hour = timeOfDay.hour;
    var am = timeOfDay.isAM();

    if (am) {
      if (hour == 12 && minute == 0) {
        period = 'Midnight';
        icon = 'moon';
        color = Colors.black;
      } else if (hour == 12 || hour < 4) {
        period = 'Early Morning';
        icon = 'moon-o';
        color = Color(0xFF312e57);
      } else if (hour < 6) {
        period = 'Early Morning';
        icon = 'sun-rise';
        color = Colors.purple;
      } else if (hour < 7) {
        period = 'Early Morning';
        icon = 'sun-rise';
        color = Colors.yellow;
      } else {
        period = 'Morning';
        icon = 'sun-o';
        color = Colors.yellow;
      }
    } else {
      if (hour == 12 && minute == 0 && !am) {
        period = 'Midday';
        icon = 'sun-o';
        color = Colors.blue;
      } else if (hour < 6 || hour == 12) {
        period = 'Afternoon';
        icon = 'sun-o';
        color = Colors.yellow;
      } else if (hour < 7) {
        period = 'Afternoon';
        icon = 'sun-down';
        color = Colors.orange;
      } else if (hour < 8) {
        period = 'Afternoon';
        icon = 'sun-down';
        color = Colors.red;
      } else {
        period = 'Evening';
        icon = 'moon';
        color = Colors.black;
      }
    }
  }
}
