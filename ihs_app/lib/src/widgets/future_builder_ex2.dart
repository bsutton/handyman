import 'dart:async';
import 'package:flutter/material.dart';
import 'package:completer_ex/completer_ex.dart';

import '../util/log.dart';

import 'theme/nj_text_themes.dart';

typedef CompletedBuilder<T1, T2> = Widget Function(BuildContext context, T1 data1, T2 data2);
typedef ContextBuilder = Widget Function(BuildContext context);

class FutureBuilderEx2<T1, T2> extends StatefulWidget {
  final StackTrace stackTrace;
  final ContextBuilder waitingBuilder;
  final ContextBuilder errorBuilder;
  final CompletedBuilder<T1, T2> builder;
  final Future<T1> future1;
  final Future<T2> future2;

  const FutureBuilderEx2(
      {Key key,
      @required this.future1,
      @required this.future2,
      @required this.builder,
      this.waitingBuilder,
      this.errorBuilder,
      @required this.stackTrace})
      : assert(builder != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FutureBuilderExState2<T1, T2>();
  }
}

class Data<T1, T2> {
  T1 d1;
  T2 d2;
  Future<T1> future1;
  Future<T2> future2;

  Data(this.future1, this.future2);

  Future<Data<T1, T2>> wait() {
    var completer = CompleterEx<Data<T1, T2>>();
    Future.wait([future1, future2]).then((results) {
      d1 = results[0] as T1;
      d2 = results[1] as T2;
      completer.complete(this);
    });
    return completer.future;
  }
}

class FutureBuilderExState2<T1, T2> extends State<FutureBuilderEx2<T1, T2>> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Data<T1, T2>>(
        future: Data<T1, T2>(widget.future1, widget.future2).wait(), builder: loadBuilder);
  }

  Widget loadBuilder(BuildContext context, AsyncSnapshot<Data<T1, T2>> data) {
    if (data.hasData) {
      return widget.builder(context, data.data.d1, data.data.d2);
    } else if (data.hasError) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder(context);
      } else {
        Log.e('Exception: ${data.error}');
        return Center(child: NJTextError('An error occured.'));
      }
    } else {
      return Center(child: Text('Loading...'));
    }
  }
}
