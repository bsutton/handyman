import 'package:flutter/material.dart';
import 'package:strings/strings.dart';

import '../entity/site.dart';
import 'hmb_map_icon.dart';
import 'hmb_text_themes.dart';

class HMBSiteText extends StatelessWidget {
  const HMBSiteText({required this.label, required this.site, super.key});
  final String label;
  final Site? site;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (site != null) Text(label),
          if (site != null)
            Text(Strings.join([
              site?.addressLine1,
              site?.addressLine2,
              site?.suburb,
              site?.state,
              site?.postcode
            ], separator: ', ', excludeEmpty: true)),
            HMBMapIcon(site)
        ],
      );
}
