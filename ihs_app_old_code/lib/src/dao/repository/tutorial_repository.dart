import '../entities/entity_settings.dart';
import '../entities/tutorial.dart';
import '../transaction/query.dart';
import 'actions/action_get_new_tutorials.dart';
import 'repository.dart';
import 'repository_search.dart';

class TutorialRepository extends Repository<Tutorial>
    with RepositorySearch<Tutorial>
    implements EntitySettings<Tutorial> {
  TutorialRepository() : super(const Duration(hours: 5));

  @override
  Tutorial fromJson(Map<String, dynamic> json) => Tutorial.fromJson(json);

  @override
  Query searchQuery(String filter, {int offset = 0, int limit = 100}) {
    final query = Query(
      entity,
      filterMode: FilterMode.or,
      offset: offset,
      limit: limit,
    )
      ..addFilter(Match('summary', filter, matchMode: MatchMode.wild))
      ..addFilter(Match('subject', filter, matchMode: MatchMode.wild))
      ..addFilter(Match('htmlBody', filter, matchMode: MatchMode.wild));

    return query;
  }

  Future<List<Tutorial>> getNewTutorials() =>
      getByListAction(ActionGetNewTutorials());
}
