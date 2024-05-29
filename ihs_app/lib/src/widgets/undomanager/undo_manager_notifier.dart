import 'package:flutter/material.dart';

import '../../util/cancellable_future.dart';
import '../../util/quick_snack.dart';

//
class UndoManagerNotifier extends ChangeNotifier {
  UndoManagerNotifier(this._entities, this.eventListener);
  final List<DeletableItem> _entities;

  Map<DeletableItem, int> pendingDelete = {};

  CancelableFuture? deleteFuture;

  final Duration undoDuration = const Duration(seconds: 10);

  UndoManagerEventListener eventListener;

  // with snackBarDuration being less than the undoDuration, the user is
  // less likely to feel that undo failed when they click it
  // near the end time.
  final Duration snackBarDuration = const Duration(seconds: 9);

  List<DeletableItem> get entities => _entities;

  Future<void> markForDelete(DeletableItem entity, BuildContext context) async {
    final index = _entities.indexOf(entity);

    if (_entities.remove(entity)) {
      pendingDelete[entity] = index;
      scheduleDelete();
      await showUndoSnackBar(context, entity);
      eventListener.onItemMarkForDelete(index, entity);
      notifyListeners();
    }
  }

  Widget itemBuilder(
      BuildContext context, Animation<double> animation, DeletableItem item) {
    final mt = Tween<Offset>(begin: Offset.zero, end: const Offset(100, 100))
        .chain(CurveTween(curve: Curves.easeInOutBack));

    return SlideTransition(position: animation.drive(mt), child: item);
  }

  Future<void> showUndoSnackBar(
      BuildContext context, DeletableItem entity) async {
    QuickSnack().clear(context);
    await QuickSnack().undo(
        context: context,
        duration: snackBarDuration,
        message: '${entity.getDescription()} deleted }',
        callback: () => undo(entity),
        buttonText: 'UNDO ${pendingDelete.length}');
  }

  void scheduleDelete() {
    deleteFuture?.cancel();
    deleteFuture = CancelableFuture(undoDuration, () {
      for (final item in pendingDelete.keys) {
        item.delete();
      }
      pendingDelete.clear();
    });
  }

  void undo(DeletableItem entity) {
    deleteFuture?.cancel();
    if (pendingDelete.isNotEmpty) {
      pendingDelete
        ..forEach((item, idx) {
          _entities.add(item);
          eventListener.onItemUndo(idx);
        })
        ..clear();
      notifyListeners();
    }
  }

  set entities(List<DeletableItem> entities) {
    _entities.clear();
    final tmp = entities;
    for (final item in tmp) {
      if (pendingDelete[item] == null) {
        _entities.add(item);
      }
    }

    notifyListeners();
  }
}

abstract class DeletableItem extends StatefulWidget {
  const DeletableItem(ValueKey<String> key) : super(key: key);

  void delete();
  String getDescription();
}

abstract class UndoManagerEventListener {
  void onItemUndo(int idx);
  void onItemMarkForDelete(int idx, DeletableItem item);
}
