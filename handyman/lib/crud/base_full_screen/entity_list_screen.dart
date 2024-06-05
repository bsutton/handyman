// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../dao/dao.dart';
import '../../entity/entities.dart';

class EntityListScreen<T extends Entity<T>> extends StatefulWidget {
  const EntityListScreen({
    required this.dao,
    required this.onEdit,
    required this.pageTitle,
    required this.title,
    required this.details,
    super.key,
  });

  final String pageTitle;
  final Widget Function(T entity) title;
  final Widget Function(T entity) details;
  final Widget Function(T? entity) onEdit;
  final Dao<T> dao;

  @override
  EntityListScreenState createState() => EntityListScreenState<T>();
}

class EntityListScreenState<T extends Entity<T>>
    extends State<EntityListScreen<T>> {
  late Future<List<T>> entities;

  @override
  void initState() {
    super.initState();
    // ignore: discarded_futures
    entities = fetchList();
  }

  Future<void> _refreshEntityList() async {
    setState(() {
      entities = fetchList();
    });
  }

  Future<List<T>> fetchList() async => widget.dao.getAll();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.pageTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
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
        body: FutureBuilderEx<List<T>>(
          future: entities,
          waitingBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          builder: (context, list) {
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

  Widget _buildListTiles(List<T> list) => ListView.builder(
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

  Future<void> _confirmDelete(Entity<T> entity) async {
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

  Future<void> _delete(Entity<T> entity) async {
    await widget.dao.delete(entity.id);
    await _refreshEntityList();
  }
}
