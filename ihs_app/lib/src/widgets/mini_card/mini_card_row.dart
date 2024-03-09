import 'package:flutter/material.dart';
import 'mini_card.dart';
import 'mini_row_state.dart';

class MiniCardRow<T, S extends MiniRowState<T, S>> extends StatelessWidget {
  final List<MiniCard<T, S>> miniCards;

  MiniCardRow(this.miniCards);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal, child: Row(mainAxisSize: MainAxisSize.min, children: miniCards));
  }
}
