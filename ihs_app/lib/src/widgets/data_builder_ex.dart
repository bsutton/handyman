import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef CompletedBuilder<T> = Widget Function(BuildContext context, T data);
typedef ErrorBuilder = Widget Function(BuildContext context, Object error);
typedef ContextBuilder = Widget Function(BuildContext context);

class DataBuilder<T> extends StatefulWidget {
  const DataBuilder({
    required this.future,
    required this.builder,
    required this.waitingBuilder,
    required this.errorBuilder,
    super.key,
    this.initialData,
  });
  final ContextBuilder waitingBuilder;
  final ErrorBuilder errorBuilder;
  final CompletedBuilder<T> builder;
  final Future<T> future;
  final T? initialData;

  @override
  State<StatefulWidget> createState() => DataBuilderState<T>();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<ContextBuilder>.has(
          'waitingBuilder', waitingBuilder))
      ..add(ObjectFlagProperty<ErrorBuilder?>.has('errorBuilder', errorBuilder))
      ..add(ObjectFlagProperty<CompletedBuilder<T>>.has('builder', builder))
      ..add(DiagnosticsProperty<Future<T>>('future', future))
      ..add(DiagnosticsProperty<T?>('initialData', initialData));
  }
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
      return widget.errorBuilder(context, data.error!);
    } else {
      return const Center(child: Text('Loading...'));
    }
  }
}
