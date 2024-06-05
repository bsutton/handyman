import 'package:flutter/material.dart';

import '../../dao/dao.dart';
import '../../entity/entity.dart';
import '../../widgets/hmb_button.dart';

abstract class EntityState<E extends Entity<E>> {
  Future<E> forInsert();
  Future<E> forUpdate(E entity);
}

class EntityEditScreen<E extends Entity<E>> extends StatefulWidget {
  const EntityEditScreen(
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
  final EntityState<E> entityState;

  @override
  EntityEditScreenState createState() => EntityEditScreenState<E>();
}

class EntityEditScreenState<E extends Entity<E>>
    extends State<EntityEditScreen<E>> {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          HMBButton(
                              label: widget.entity != null ? 'Update' : 'Add',
                              onPressed: _save),
                          HMBButton(
                            onPressed: () => Navigator.of(context).pop(),
                            label: 'Cancel',
                          ),
                        ])),

                /// Inject the entity specific editor.
                Expanded(
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16), child: widget.editor),
                ),

                /// Save /Cancel Buttons
                const SizedBox(height: 16),
              ],
            ),
          )));

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
        Navigator.of(context).pop(widget.entity);
      }
    }
  }
}
