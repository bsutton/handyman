import 'package:equatable/equatable.dart';

import 'api/enum.dart';

class Query extends Equatable {
  const Query(
    String entityType, {
    FilterMode<String> filterMode = FilterMode.and,
    List<Match> filters = const <Match>[],
    List<String> fields = const [],
    List<String> sort = const [],
    int limit = 100,
    int offset = 0,
  })  : _filterMode = filterMode,
        _filters = filters,
        _fields = fields,
        _sort = sort,
        _limit = limit,
        _offset = offset,
        _entityType = entityType;
  final FilterMode<String> _filterMode;
  final List<Match> _filters;
  final List<String> _fields;
  final List<String> _sort;
  final int _offset;
  final int _limit;
  final String _entityType;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'FilterMode': _filterMode,
        'Filters': _filters,
        'Fields': _fields,
        'Sort': _sort,
        'offset': _offset,
        'limit': _limit,
      };

  void addFilter(Match match) {
    _filters.add(match);
  }

  void addFilterAll(List<Match> matchers) {
    _filters.addAll(matchers);
  }

  @override
  List<Object> get props =>
      [_offset, _limit, _sort, _fields, _filters, _filterMode, _entityType];
}

class FilterMode<String> extends Enum<String> {
  const FilterMode(super.value);

  static const or = FilterMode('OR');
  static const and = FilterMode('AND');
}

class MatchMode<String> extends Enum<String> {
  const MatchMode(super.value);

  static const eq = MatchMode('EQ');
  static const notEq = MatchMode('NOT_EQ');
  static const like = MatchMode('LIKE');
  static const wild = MatchMode('WILD');
  static const gt = MatchMode('GT');
  static const gtEq = MatchMode('GT_EQ');
  static const lt = MatchMode('LT');
}

class Match extends Equatable {
  const Match(this.field, this.value, {this.matchMode = MatchMode.eq});
  final String field;
  final String value;
  final MatchMode<String> matchMode;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'field': field, 'value': value, 'matchMode': matchMode};

  @override
  List<Object> get props => [field, value, matchMode];
}
