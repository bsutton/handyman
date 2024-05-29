// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../dao/dao.dart';
import '../../entity/entities.dart';

class EntityListScreen<T extends Entity> extends StatefulWidget {
  const EntityListScreen({
    required this.dao,
    required this.onEdit,
    required this.pageTitle,
    required this.title,
    required this.subTitle,
    super.key, // Add key parameter here
  });

  final String pageTitle;
  final Widget Function(T entity) title;
  final Widget Function(T entity) subTitle;
  final Widget Function(T? entity) onEdit;
  final Dao<T> dao;

  @override
  EntityListScreenState createState() => EntityListScreenState<T>();
}

class EntityListScreenState<T extends Entity>
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
      print('refreshing');
      entities = fetchList();
    });
  }

  Future<List<T>> fetchList() async => widget.dao.getAll();

  @override
  Widget build(BuildContext context) => _buildList(context);

  Scaffold _buildList(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            // add new entity
            onPressed: () async {
              if (context.mounted) {
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (context) => widget.onEdit(null)),
                ).then((_) =>
                    _refreshEntityList()); // Refresh list after adding/editing
              }
            },
          )
        ],
      ),
      body: FutureBuilderEx<List<T>>(
          future: () async => entities,
          waitingBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          builder: (context, list) {
            if (list!.isEmpty) {
              return const Center(child: Text('No records found.'));
            } else {
              return _buildListTiles(list);
            }
          }));

  Widget _buildListTiles(List<T> list) => ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final entity = list[index];
          return ListTile(
            title: widget.title(entity),
            subtitle: widget.subTitle(entity),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _delete(entity);
              },
            ),

            /// Edit entity
            onTap: () async {
              if (context.mounted) {
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (context) => widget.onEdit(entity)),
                ).then((_) =>
                    // Refresh list after editing
                    _refreshEntityList());
              }
            },
          );
        },
      );

  Future<void> _delete(Entity entity) async {
    await widget.dao.delete(entity.id);
    await _refreshEntityList();
  }
}
