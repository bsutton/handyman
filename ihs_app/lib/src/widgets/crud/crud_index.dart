import 'dart:async';

import 'package:dcache/dcache.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quiver/cache.dart';

import '../../app/app_scaffold.dart';
import '../../app/router.dart';
import '../../dao/bus/bus.dart';
import '../../dao/entities/entity.dart';
import '../../dao/repository/repos.dart';
import '../../dao/repository/repository_search.dart';
import '../../util/cancellable_future.dart';
import '../../util/log.dart';
import '../../util/quick_snack.dart';
import '../collapse_transition.dart';
import '../empty.dart';
import '../expansion_flip_tile/expansion_flip_tile_skeleton.dart';
import '../j_bottom_app_bar/nj_bottom_app_bar.dart';
import '../nj_search_bar/nj_search_bar.dart';
import '../scaffold/sliver_scaffold.dart';

const double _kListPadding = 16;
const int _kPageSize = 100;
const Duration _kUndoDuration = Duration(seconds: 6);
const Duration _kDeleteAnimationDuration = Duration(milliseconds: 300);

typedef EntityIndexedWidgetBuilder<T extends Entity<T>> = Widget Function(
  BuildContext context,
  int index,
  T entity,
);

enum ListPageStatus { unknown, forced, pending, avaliable }

class ListItem<T extends Entity<T>> {
  ListItem({required this.entity, required this.animationController});
  final T entity;
  bool isDeleted = false;
  AnimationController animationController;
}

class CrudSearchRoute<T> extends Route<T> {}

class CrudIndex<T extends Entity<T>> extends StatefulWidget {
  const CrudIndex({
    required this.title,
    required this.currentRouteName,
    required this.listItemBuilder,
    super.key,
    this.createPageBuilder,
    this.editPageBuilder,
    this.skeletonItemBuilder,
  });
  final String title;
  final RouteName currentRouteName;
  final WidgetBuilder? createPageBuilder;
  final EntityIndexedWidgetBuilder<T>? editPageBuilder;
  final EntityIndexedWidgetBuilder<T> listItemBuilder;
  final IndexedWidgetBuilder? skeletonItemBuilder;

  @override
  CrudIndexState createState() => CrudIndexState<T>();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(
          DiagnosticsProperty<RouteName>('currentRouteName', currentRouteName))
      ..add(ObjectFlagProperty<WidgetBuilder?>.has(
          'createPageBuilder', createPageBuilder))
      ..add(ObjectFlagProperty<EntityIndexedWidgetBuilder<T>?>.has(
          'editPageBuilder', editPageBuilder))
      ..add(ObjectFlagProperty<EntityIndexedWidgetBuilder<T>>.has(
          'listItemBuilder', listItemBuilder))
      ..add(ObjectFlagProperty<IndexedWidgetBuilder?>.has(
          'skeletonItemBuilder', skeletonItemBuilder));
  }
}

class CrudIndexState<T extends Entity<T>> extends State<CrudIndex<T>>
    with TickerProviderStateMixin {
  final RepositorySearch<T> _repository = Repos().searchOf<T>();
  StreamSubscription<BusEvent<T>> _subscription;
  late Cache<int, List<ListItem<T>>> _cache;
  List<ListPageStatus> _pageStatus = [];
  int _totalRecords = 0;
  String? _error;
  String? _searchTerm;
  bool _isSearching = false;
  final Map<int, ListItem<T>> _deletedItems = <int, ListItem<T>>{};
  final Map<int, ListItem<T>> _pendingDeletedItems = <int, ListItem<T>>{};
  CancelableFuture? _deleteFuture;
  BuildContext? _scaffoldContext;

  @override
  void initState() {
    super.initState();
    _cache = SimpleCache<int, List<ListItem<T>>>(
      storage: SimpleStorage(size: 4),
      onEvict: (key, _) => _pageStatus[key] = ListPageStatus.unknown,
    );
    final eventDebouncer = Debouncer<BusEvent<T>>(
      const Duration(milliseconds: 200),
      onChanged: (_) => _fetchTotal(force: true),
    );
    _subscription = Bus().listen<T>((event) {
      if (event.action == BusAction.insert ||
          event.action == BusAction.update) {
        eventDebouncer.value = event;
      }
    });
    _fetchTotal();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void createEntity() {
    Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: widget.createPageBuilder,
    ));
  }

  Future<void> editEntity(int index, T entity) async {
    await _repository.getByGUID(entity.guid).then((fullEntity) {
      Navigator.of(context).push<bool>(MaterialPageRoute(
        builder: (context) =>
            widget.editPageBuilder(context, index, fullEntity),
      ));
    }).catchError((dynamic error) {
      Log.e('CrudIndexState.editEntity tried to fetch non-existent entity');
      setState(() {
        _error = error.toString();
      });
    });
  }

  void _performDelete() {
    _pendingDeletedItems.forEach((id, item) {
      _repository.delete(item.entity).then((_) {
        _deletedItems[id] = item;
        Bus().add(BusAction.delete, oldInstance: item.entity);
      }).catchError((dynamic error) {
        setState(() {
          // TODO: delete failure handling
          _error = error.toString();
        });
      });
    });
    _pendingDeletedItems.clear();
  }

  void _cancelDelete() {
    _deleteFuture?.cancel();
    _pendingDeletedItems
        .forEach((id, item) => item.animationController.forward());
    _pendingDeletedItems.clear();
  }

  void deleteEntity(int index, T entity) {
    _deleteFuture?.cancel();
    final pageNum = _itemPage(index);
    final item = _cache.get(pageNum)[_itemIndex(pageNum, index)];
    _pendingDeletedItems[item.entity.id] = item;
    item.animationController.reverse();
    _deleteFuture = CancelableFuture(_kUndoDuration, _performDelete);
    QuickSnack().undo(
      context: _scaffoldContext,
      duration: _kUndoDuration,
      message: 'Deleted ${_pendingDeletedItems.length} item(s)',
      callback: _cancelDelete,
    );
  }

  void _fetchTotal({bool force = false}) {
    Future<int> count;
    count = _repository.countSearch(_searchTerm, force: force);
    count.then((count) {
      setState(() {
        _error = null;
        if (force) {
          _deletedItems.clear();
        }
        _totalRecords = count;
        final _numPages = (count / _kPageSize).ceil();
        _pageStatus = List<ListPageStatus>.generate(
          _numPages,
          (_) => force ? ListPageStatus.forced : ListPageStatus.unknown,
          growable: false,
        );
      });
    }).catchError((dynamic error) {
      setState(() {
        _error = error.toString();
      });
    });
  }

  void _fetchPage(int pageNum, {bool force = false}) {
    final offset = pageNum * _kPageSize;
    Future<List<T>> page;
    page = _repository.search(
      _searchTerm,
      offset: offset,
      limit: _kPageSize,
      force: force,
    );
    page.then((entities) {
      setState(() {
        _cache.set(
          pageNum,
          entities
              .map((entity) => ListItem<T>(
                    entity: entity,
                    animationController: AnimationController(
                      vsync: this,
                      duration: _kDeleteAnimationDuration,
                      value: _deletedItems.containsKey(entity.id) ? 0.0 : 1.0,
                    ),
                  ))
              .toList(),
        );
        _pageStatus[pageNum] = ListPageStatus.avaliable;
      });
    }).catchError((dynamic error) {
      setState(() {
        _error = error.toString();
      });
    });
  }

  void _submitSearch(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
      _fetchTotal();
    });
  }

  void _enterSearch(BuildContext context) {
    setState(() {
      _isSearching = true;
      Navigator.of(context).push(CrudSearchRoute<void>()).then((_) {
        setState(() {
          final hadResults = _searchTerm.isNotEmpty;
          _isSearching = false;
          _searchTerm = null;
          if (hadResults) {
            _fetchTotal();
          }
        });
      });
    });
  }

  void _exitSearch(BuildContext context) {
    Navigator.of(context).pop();
  }

  int _itemIndex(int page, int index) => index - (page * _kPageSize);

  int skeletonItemBuilder_itemPage(int index) => (index / _kPageSize).floor();

  Widget _buildSkeleton(BuildContext context, int index) {
    return widget.skeletonItemBuilder(context, _totalRecords);
    return ExpansionFlipTileSkeleton();
  }

  Widget _buildWaiting(BuildContext context) => const SliverPadding(
        padding: EdgeInsets.all(_kListPadding),
        sliver: SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );

  Widget _buildEmpty(BuildContext context) => SliverPadding(
        padding: const EdgeInsets.all(_kListPadding),
        sliver: SliverToBoxAdapter(
          child: ListTile(
            title:
                Center(child: Text('No ${widget.title.toLowerCase()} found')),
            subtitle: const Center(child: Text('Pull to refresh')),
          ),
        ),
      );

  Widget _buildItem(BuildContext context, int index) {
    final pageNum = _itemPage(index);
    switch (_pageStatus[pageNum]) {
      case ListPageStatus.unknown:
        _pageStatus[pageNum] = ListPageStatus.pending;
        _fetchPage(pageNum);
        return _buildSkeleton(context, index);
        break;
      case ListPageStatus.forced:
        _pageStatus[pageNum] = ListPageStatus.pending;
        _fetchPage(pageNum, force: true);
        return _buildSkeleton(context, index);
        break;
      case ListPageStatus.pending:
        return _buildSkeleton(context, index);
        break;
      case ListPageStatus.avaliable:
        final item = _cache.get(pageNum)[_itemIndex(pageNum, index)];
        // In case our entity got deleted from the remote while paging, render empty container
        if (item == null || item.entity == null) {
          return Empty();
        }
        return CollapseTransition(
          controller: item.animationController,
          child: widget.listItemBuilder(
            context,
            index,
            item.entity,
          ),
        );
        break;
      default:
        return _buildSkeleton(context, index);
    }
  }

  Widget _buildList(BuildContext context) {
    Log.e(_error);
    return _buildEmpty(context);
    return SliverPadding(
      padding: const EdgeInsets.all(_kListPadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          _buildItem,
          childCount: _totalRecords,
        ),
      ),
    );
  }

  Widget _buildSearchButton(BuildContext context) => IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => _enterSearch(context),
      );

  Widget _buildAppBar(BuildContext context) {
    if (_isSearching) {
      return NjSearchBar(
        onClose: () => _exitSearch(context),
        onSearch: _submitSearch,
      );
    }

    return NjBottomAppBar(
      shape: const CircularNotchedRectangle(),
      actions: <Widget>[_buildSearchButton(context)],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    if (_isSearching) {
      return null;
    }
    return FloatingActionButton(
      backgroundColor: Colors.pinkAccent,
      onPressed: createEntity,
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
        appBar: _buildAppBar(context),
        floatingActionButton: _buildFloatingActionButton(context),
        showHomeButton: _isSearching ? false : true,
        builder: (context) {
          _scaffoldContext = context;
          return SliverScaffold(
            title: widget.title,
            currentRouteName: widget.currentRouteName,
            refreshCallback: () => _fetchTotal(force: true),
            sliver: _buildList(context),
          );
        },
      );
}
