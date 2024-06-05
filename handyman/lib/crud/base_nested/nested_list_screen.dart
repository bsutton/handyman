// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../dao/dao.dart';
import '../../entity/entities.dart';
import '../../widgets/hmb_add_button.dart';

class Parent<P extends Entity<P>> {
  Parent(this.parent);

  P? parent;
}

class NestedEntityListScreen<C extends Entity<C>, P extends Entity<P>>
    extends StatefulWidget {
  const NestedEntityListScreen({
    required this.dao,
    required this.onEdit,
    required this.onDelete,
    required this.onInsert,
    required this.pageTitle,
    required this.title,
    required this.details,
    required this.parent,
    required this.fetchList,
    super.key,
  });

  final Parent<P> parent;
  final String pageTitle;
  final Widget Function(C entity) title;
  final Widget Function(C entity) details;
  final Widget Function(C? entity) onEdit;
  final Future<void> Function(C? entity) onDelete;
  final Future<void> Function(C? entity) onInsert;
  final Future<List<C>> Function() fetchList;
  final Dao<C> dao;

  @override
  NestedEntityListScreenState createState() =>
      NestedEntityListScreenState<C, P>();
}

class NestedEntityListScreenState<C extends Entity<C>, P extends Entity<P>>
    extends State<NestedEntityListScreen<C, P>> {
  late Future<List<C>> entities;

  @override
  void initState() {
    super.initState();
    // ignore: discarded_futures
    entities = _fetchList();
  }

  Future<void> _refreshEntityList() async {
    setState(() {
      print('refreshing');
      entities = _fetchList();
    });
  }

  Future<List<C>> _fetchList() async {
    if (widget.parent.parent == null) {
      return <C>[];
    } else {
      return widget.fetchList();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // No back button
          title: Text(
            widget.pageTitle,
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            HMBAddButton(
              enabled: widget.parent.parent != null,
              onPressed: () async {
                if (context.mounted) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (context) => widget.onEdit(null)),
                  ).then((_) => _refreshEntityList());
                }
              },
            )
          ],
        ),
        body: FutureBuilderEx<List<C>>(
          future: entities,
          waitingBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          builder: (context, list) {
            if (widget.parent.parent == null) {
              return const Center(
                  child: Text(
                'Save the parent first.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ));
            }
            if (list!.isEmpty) {
              return const Center(
                  child: Text(
                'No records found.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ));
            } else {
              return _buildListTiles(list);
            }
          },
        ),
      );

  Widget _buildListTiles(List<C> list) => ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final entity = list[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            child: ListTile(
              title: widget.title(entity),
              subtitle: widget.details(entity),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await _confirmDelete(entity);
                },
              ),
              onTap: () async {
                if (context.mounted) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (context) => widget.onEdit(entity)),
                  ).then((_) => _refreshEntityList());
                }
              },
            ),
          );
        },
      );

  Future<void> _confirmDelete(C entity) async {
    final deleteConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Confirmation'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (deleteConfirmed ?? false) {
      await _delete(entity);
    }
  }

  Future<void> _delete(C entity) async {
    await widget.onDelete(entity);
    await _refreshEntityList();
  }
}
