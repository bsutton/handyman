// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class HMBChildCrudCard extends StatelessWidget {
  const HMBChildCrudCard({
    required this.headline,
    required this.crudListScreen,
    super.key,
  });

  final Widget crudListScreen;
  final String headline;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                headline,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: crudListScreen,
              ),
            ],
          ),
        ),
      );
}