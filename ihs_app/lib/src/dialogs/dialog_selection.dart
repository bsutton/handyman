import 'dart:core' as prefix0;
import 'dart:core';

import 'package:flutter/material.dart' hide SearchBar;
import 'package:future_builder_ex/future_builder_ex.dart';

import '../app/router.dart';
import '../widgets/search_bar.dart';
import 'dialog_full_screen.dart';

typedef FilterMatch<T> = Future<bool> Function(String filter, T item);
typedef CardBuilder<T> = Widget Function(
    // ignore: avoid_positional_boolean_parameters
    BuildContext context,
    T item,
    // ignore: avoid_positional_boolean_parameters
    bool selected);
typedef ListLoader<T> = Future<List<T>> Function();

class DialogSelection<T> extends StatelessWidget {
  const DialogSelection(
      {required this.selectionListStateKey,
      required this.searchLabel,
      required this.cardBuilder,
      required this.filterMatch,
      super.key,
      this.searchHint,
      this.initialData,
      this.listLoader,
      this.initialT});
  final String searchLabel;
  final String? searchHint;
  // final T selected;
  final CardBuilder<T> cardBuilder;
  final FilterMatch<T> filterMatch;
  final List<T>? initialData;
  final T? initialT;
  final ListLoader<T>? listLoader;
  final GlobalKey<SelectionListState<T>> selectionListStateKey;

  static Future<T> show<T>(
      {required BuildContext context,
      required String title,
      required String searchLabel,
      required CardBuilder<T> cardBuilder,
      required FilterMatch<T> filterMatch,
      String? searchHint,
      List<T>? initialData,
      ListLoader<T>? listLoader,
      T? initialT}) async {
    final selectionListStateKey = GlobalKey<SelectionListState<T>>();

    await DialogFullScreen.show(context,
        title: title,
        okLabel: 'Close',
        showCancel: false,
        builder: (context) => DialogSelection(
              selectionListStateKey: selectionListStateKey,
              searchLabel: searchLabel,
              cardBuilder: cardBuilder,
              filterMatch: filterMatch,
              searchHint: searchHint,
              initialData: initialData,
              listLoader: listLoader,
            ));

    return Future.value(selectionListStateKey.currentState!.selected as T);
  }

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
      heightFactor: 1,
      child: SelectionList<T>(selectionListStateKey, searchLabel, searchHint,
          filterMatch, cardBuilder, initialData, listLoader, initialT));
}

class SelectionList<T> extends StatefulWidget {
  const SelectionList(
      Key selectionListStateKey,
      this.searchLabel,
      this.searchHint,
      this.filterMatch,
      this.cardBuilder,
      this.initialData,
      this.listLoader,
      this.initialT)
      : super(key: selectionListStateKey);
  final String searchLabel;
  final String? searchHint;
  final T? initialT;
  final FilterMatch<T> filterMatch;
  final CardBuilder<T> cardBuilder;
  final List<T>? initialData;
  final ListLoader<T>? listLoader;

  @override
  State<StatefulWidget> createState() => SelectionListState<T>();
}

class SelectionListState<T> extends State<SelectionList<T>> {
  SelectionListState() {
    initialData = widget.initialData;
    listLoader = widget.listLoader;
    selected = widget.initialT;
    filterMatch = widget.filterMatch;
    bodyBuilder = widget.cardBuilder;
  }
  T? selected;
  String filter = '';
  late final FilterMatch<T> filterMatch;
  late final CardBuilder<T> bodyBuilder;
  late final List<T>? initialData;
  late final ListLoader<T>? listLoader;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilderEx<List<T>>(
              initialData: initialData,
              future: fetchFilteredList,
              builder: (context, list) => buildList(list!),
            ),
            buildSearchBar(),
          ]);

  Future<List<T>> fetchFilteredList() async {
    final list = <T>[];
    final sourceList = await listLoader?.call() ?? <T>[];

    final lcFilter = filter.toLowerCase();
    for (final item in sourceList) {
      if (filter.isNotEmpty) {
        if (await filterMatch(lcFilter, item)) {
          list.add(item);
        }
      } else {
        list.add(item);
      }
    }
    return list;
  }

  Widget buildList(List<T> list) {
    final cards = <TCard<T>>[];

    for (final item in list) {
      cards.add(buildCard(item, bodyBuilder));
    }

    return Expanded(
        child: ListView(
      // shrinkWrap: true,
      children: cards,
    ));
  }

  TCard<T> buildCard(T item, CardBuilder<T> bodyBuilder) =>
      TCard<T>(item, bodyBuilder,
          onTap: () => onSelected(item), selected: item == selected);

  void onSelected(T item) {
    selected = item;
    SQRouter().pop<T>(selected);
  }

  Widget buildSearchBar() => SearchBar(
      label: widget.searchLabel,
      hint: widget.searchHint,
      onChange: (value) {
        setState(() => filter = value.toLowerCase());
      });
}

class TCard<T> extends StatelessWidget {
  const TCard(this.item, this.cardBuilder,
      {required this.selected, super.key, this.onTap});
  final T item;
  final VoidCallback? onTap;
  final bool selected;
  final CardBuilder<T> cardBuilder;

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      child: SizedBox(
          height: 40,
          child: Card(
              color: (selected ? Colors.orange : Colors.orangeAccent),
              child: Center(child: cardBuilder(context, item, selected)))));
}
