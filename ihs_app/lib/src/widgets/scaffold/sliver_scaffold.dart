import 'package:flutter/material.dart';

import '../../app/router.dart';

class SliverScaffold extends StatelessWidget {
  const SliverScaffold({
    required this.currentRouteName,
    required this.title,
    required this.sliver,
    super.key,
    this.refreshCallback,
    this.headerActions,
  });
  final String title;
  final Widget sliver;
  final RouteName currentRouteName;
  final VoidCallback? refreshCallback;
  final List<Widget>? headerActions;

  Widget _buildScrollView(BuildContext context) => CustomScrollView(
        slivers: [
          _buildHeader(context),
          sliver,
        ],
      );

  Widget _buildHeader(BuildContext context) => SliverAppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: Container(),
        expandedHeight: 200,
        floating: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(title),
        ),
        actions: headerActions,
      );

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: () async {
          refreshCallback?.call();
        },
        child: _buildScrollView(context),
      );
}
