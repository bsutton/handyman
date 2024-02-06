import 'package:flutter/material.dart';

import '../../util/log.dart';
import 'mini_card.dart';

class MiniRowState<T, S extends MiniRowState<T, S>> extends ChangeNotifier {
  /// Used to initialise the state.
  /// The saveHandler is called when the contents of a card change
  /// or the activation state changes to give a parent widget
  /// a chance to save the changes.
  MiniRowState({
    required this.saveHandler,
    required MiniCard<T, S> activate,
  }) : _active = activate {
    // one minicard must be active at all times.
    // assert(activated != null);
  }
  // The mini card which is currently active.
  MiniCard<T, S> _active;

  Future<void> Function(T updated) saveHandler;

  /// Called when the contents of a [MiniCard] have changed
  /// (via the MaxiCard editor) and the [MiniCard] needs
  /// to redraw itself.
  Future<void> onContentChanged(T data) => saveHandler(data);

  /// Called by a mini card when it is made active.
  void onActivationChanged(MiniCard<T, S> active) {
    Log.d('Activating card: ${active.title}');
    if (_active.title != active.title) {
      _active = active;
      _active.onActivate(_active.data);
      saveHandler(active.data);

      // notify cards that the activated card has changed.
      notifyListeners();
    }
  }

  bool isActive(MiniCard miniCard) => miniCard.title == _active.title;

  void initState(MiniCard<T, S> active) {
    _active = active;
    // notify cards of the initial activation state.
    notifyListeners();
  }
}
