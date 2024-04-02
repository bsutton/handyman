// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';

import '../../dao/dao.dart';
import '../../entity/entities.dart';

class EntityListScreen<T extends Entity> extends StatefulWidget {
  const EntityListScreen({
    required this.dao,
    required this.onEdit,
    required this.title,
    required this.subTitle,
    super.key, // Add key parameter here
  });

  final Widget Function(T entity) title;
  final Widget Function(T entity) subTitle;
  final Widget Function(T? entity) onEdit;
  final Dao dao;

  @override
  EntityListScreenState createState() => EntityListScreenState();
}

class EntityListScreenState extends State<EntityListScreen> {
  Future<List<Entity>>? _entities;

  @override
  void initState() {
    super.initState();
    unawaited(_refreshEntityList());
  }

  Future<void> _refreshEntityList() async {
    setState(() {
      _entities = widget.dao.getAll();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Customer List'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
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
        body: FutureBuilder(
          future: _entities,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData ||
                (snapshot.hasData && snapshot.data!.isEmpty)) {
              return const Center(
                child: Text('No customers found.'),
              );
            } else {
              final entityList = snapshot.data!;
              return ListView.builder(
                itemCount: entityList.length,
                itemBuilder: (context, index) {
                  final entity = entityList[index];
                  return ListTile(
                    title: widget.title(entity),
                    subtitle: widget.subTitle(entity),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _delete(entity);
                      },
                    ),
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
            }
          },
        ),
      );

  Future<void> _delete(Entity entity) async {
    await widget.dao.delete(entity.id);
    await _refreshEntityList();
  }
}
