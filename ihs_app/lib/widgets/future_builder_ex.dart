import 'package:flutter/material.dart';
import 'package:stacktrace_impl/stacktrace_impl.dart';
import '../util/log.dart';
import 'empty.dart';


import 'theme/nj_text_themes.dart';
import 'tick_builder.dart';

typedef CompletedBuilder<T> = Widget Function(BuildContext context, T data);
typedef ContextBuilder = Widget Function(BuildContext context);
typedef ErrorBuilder = Widget Function(BuildContext context, Object error);

typedef SubscribeTo<S> = void Function(S type);

class FutureBuilderListEx<T> extends FutureBuilderEx<List<T>> {}

///
/// ```dart
///  return Consumer<SelectedTeam>(
///      builder: (context, selectedTeam, _) => FutureBuilderEx<String>(
///        future: () => selectedTeam.teamName,
///        builder: (context, teamName) => NJTextSubheading('Team: $teamName', color: Colors.white),
///        stackTrace: StackTraceImpl(),
///      ),
///    );
/// ```

class FutureBuilderEx<T> extends StatefulWidget {
  final StackTrace stackTrace;
  //Future args
  final ContextBuilder waitingBuilder;
  final ErrorBuilder errorBuilder;
  final CompletedBuilder<T> builder;

  final Future<T> Function() future;
  final T initialData;
  final String debugLabel;

  const FutureBuilderEx(
      {Key key,
      @required this.future,
      @required this.builder,
      this.initialData,
      this.waitingBuilder,
      this.errorBuilder,
      this.debugLabel,
      @required this.stackTrace})
      : assert(builder != null),
        assert(future != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FutureBuilderExState<T>();
  }
}

class FutureBuilderExState<T> extends State<FutureBuilderEx<T>> {
  StackTraceImpl mergedStack;

  // set to true once the future has completed.
  bool completed = false;

  @override
  void initState() {
    super.initState();
    var future = widget.future();
    assert(future != null);
    future.whenComplete(() => completed = true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        future: widget.future().then((t) {
          return t;
        },
            // ignore: avoid_types_on_closure_parameters
            onError: (Object e, StackTrace s) {
          if (widget.stackTrace != null) {
            mergedStack = StackTraceImpl.fromStackTrace(widget.stackTrace).merge(s);
          }
          throw e;
        }).catchError((dynamic e) {
          // Log.e(e.toString(), stackTrace: mergedStack);
          throw e;
        }),
        initialData: widget.initialData,
        builder: (context, data) {
          try {
            return loadBuilder(context, data);
          }
          // ignore: avoid_catches_without_on_clauses
          catch (e, s) {
            Log.e(e.toString(), stackTrace: s);
            rethrow;
          }
        });
  }

  Widget loadBuilder(BuildContext context, AsyncSnapshot<T> data) {
    Widget builder;

    if (data.hasError) {
      builder = callErrorBuilder(context, data.error);
    } else {
      switch (data.connectionState) {
        case ConnectionState.none:
          builder = callWaitingBuilder(context);
          break;
        case ConnectionState.waiting:
          if (!completed) {
            builder = callWaitingBuilder(context);
          } else {
            builder = widget.builder(context, data.data);
          }
          break;
        case ConnectionState.active:
          builder = widget.builder(context, data.data);
          break;
        case ConnectionState.done:
          builder = widget.builder(context, data.data);
          break;
      }
    }
    return builder;
  }

  Widget callWaitingBuilder(BuildContext contect) {
    if (widget.waitingBuilder != null) {
      return widget.waitingBuilder(context);
    } else {
      return loading();
    }
  }

  Widget callErrorBuilder(BuildContext context, Object error) {
    if (widget.errorBuilder != null) {
      return widget.errorBuilder(context, error);
    } else {
      Log.e('Exception: $error ', stackTrace: mergedStack);
      return Center(child: NJTextError('An error occured.'));
    }
  }

  /// Displays a loading message.
  /// For the first 500ms we just show an empty container as
  /// this reduces flicker when the compent loads quickly.
  Widget loading() {
    var startTime = DateTime.now();
    return TickBuilder(
        interval: Duration(milliseconds: 100),
        builder: (context, index) {
          var showLoading = DateTime.now().difference(startTime) > Duration(milliseconds: 500);
          if (showLoading) {
            return Center(child: Text('Loading...'));
          } else {
            return Empty();
          }
        });
  }
}
