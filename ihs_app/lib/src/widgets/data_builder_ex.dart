import 'package:flutter/material.dart';

import 'empty.dart';

typedef CompletedBuilder<T> = Widget Function(BuildContext context, T data);
typedef ErrorBuilder = Widget Function(BuildContext context, Object error);
typedef ContextBuilder = Widget Function(BuildContext context);

class DataBuilder<T> extends StatefulWidget {

  const DataBuilder({
    required this.future, required this.builder, super.key,
    this.initialData,
    this.waitingBuilder,
    this.errorBuilder,
  });
  final ContextBuilder? waitingBuilder;
  final ErrorBuilder? errorBuilder;
  final CompletedBuilder<T> builder;
  final Future<T> future;
  final T? initialData;

  @override
  State<StatefulWidget> createState() => DataBuilderState<T>();
}

class DataBuilderState<T> extends State<DataBuilder<T>> {
  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
        future: widget.future,
        initialData: widget.initialData,
        builder: loadBuilder);

  Widget loadBuilder(BuildContext context, AsyncSnapshot<T> data) {
    if (data.hasData) {
      return widget.builder(context, data.data as T);
    } else if (data.hasError) {
      return widget.errorBuilder?.call(context, data.error!) ?? const Empty();
    } else {
      return const Center(child: Text('Loading...'));
    }
  }
}
