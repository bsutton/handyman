import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dao/dao.dart';
import '../../entity/entity.dart';

abstract class NestedEntityState<E extends Entity<E>> {
  Future<E> forInsert();
  Future<E> forUpdate(E entity);
}

class NestedEntityEditScreen<E extends Entity<E>> extends StatefulWidget {
  const NestedEntityEditScreen(
      {required this.entity,
      required this.editor,
      required this.entityName,
      required this.entityState,
      required this.dao,
      super.key});
  final E? entity;
  final String entityName;
  final Dao<E> dao;

  final Widget editor;
  final NestedEntityState<E> entityState;

  @override
  NestedEntityEditScreenState createState() => NestedEntityEditScreenState<E>();
}

class NestedEntityEditScreenState<E extends Entity<E>>
    extends State<NestedEntityEditScreen<E>> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(widget.entity != null
            ? 'Edit ${widget.entityName}'
            : 'Add ${widget.entityName}'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: onEnterKey(
              onPressed: (context) async => _save(),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: _save,
                            child:
                                Text(widget.entity != null ? 'Update' : 'Add'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),

                      /// Inject the entity specific editor.
                      widget.editor,

                      /// Save /Cancel Buttons
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ))));

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      if (widget.entity != null) {
        final entity = await widget.entityState.forUpdate(widget.entity!);

        await widget.dao.update(entity);
      } else {
        final entity = await widget.entityState.forInsert();
        await widget.dao.insert(entity);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Widget onEnterKey(
          {required Widget child,
          required void Function(BuildContext context) onPressed}) =>
      KeyboardListener(
        focusNode: FocusNode(), // Ensure that the RawKeyboardListener
        // receives key events
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            // Handle Enter key press here
            // For example, call onPressed for the RaisedButton
            onPressed(context);
          }
        },
        child: child,
      );
}
