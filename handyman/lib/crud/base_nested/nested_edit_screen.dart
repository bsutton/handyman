import 'package:flutter/material.dart';

import '../../dao/dao.dart';
import '../../entity/entity.dart';

abstract class NestedEntityState<E extends Entity<E>> {
  Future<E> forInsert();
  Future<E> forUpdate(E entity);
}

class NestedEntityEditScreen<C extends Entity<C>, P extends Entity<P>>
    extends StatefulWidget {
  const NestedEntityEditScreen(
      {required this.entity,
      required this.editor,
      required this.onInsert,
      required this.entityName,
      required this.entityState,
      required this.dao,
      super.key});
  final C? entity;
  final String entityName;
  final Dao<C> dao;

  final Widget editor;
  final NestedEntityState<C> entityState;
  final Future<void> Function(C? entity) onInsert;

  @override
  NestedEntityEditScreenState createState() =>
      NestedEntityEditScreenState<C, P>();
}

class NestedEntityEditScreenState<C extends Entity<C>, P extends Entity<P>>
    extends State<NestedEntityEditScreen<C, P>> {
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
                        child: Text(widget.entity != null ? 'Update' : 'Add'),
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
          )));

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      if (widget.entity != null) {
        final entity = await widget.entityState.forUpdate(widget.entity!);

        await widget.dao.update(entity);
      } else {
        final entity = await widget.entityState.forInsert();
        await widget.onInsert(entity);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
