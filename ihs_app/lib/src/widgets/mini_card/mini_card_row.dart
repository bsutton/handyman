import 'package:flutter/material.dart';

import 'mini_card.dart';
import 'mini_row_state.dart';

class MiniCardRow<T, S extends MiniRowState<T, S>> extends StatelessWidget {
  const MiniCardRow(this.miniCards, {super.key});
  final List<MiniCard<T, S>> miniCards;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisSize: MainAxisSize.min, children: miniCards));
}
