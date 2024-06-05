import 'package:flutter/material.dart';

import '../entity/site.dart';

class HMBSiteText extends StatelessWidget {
  const HMBSiteText({required this.label, required this.site, super.key});
  final String label;
  final Site? site;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (site != null) Text(label),
          if (site != null) Text('''
${site?.addressLine1}, ${site?.addressLine2}, ${site?.suburb}, ${site?.state}, ${site?.postcode}''')
        ],
      );
}
