import '../entities/entity_settings.dart';
import '../entities/user.dart';
import '../transaction/api/retry/retry_data.dart';
import '../transaction/query.dart';
import '../transaction/transaction.dart';
import '../types/guid.dart';
import '../types/phone_number.dart';
import '../types/user_role.dart';
import 'actions/action_user_clear_email_addresses.dart';
import 'repository.dart';
import 'repository_search.dart';

class UserRepository extends Repository<User>
    with RepositorySearch<User>
    implements EntitySettings<User> {
  UserRepository() : super(const Duration(minutes: 5));

  /// The currently logged in user.
  static GUID? _loggedInUser;

  /// squarephone allows an admin to enter a mode where they can perform all
  /// UI interactions as if they are another user.
  /// This variable holds the the user that the admin is viewing.
  /// In cases where an admin isn't viewing it will hold the same
  /// user as the LoggedInUser.
  /// This varible should always be used when identifying the data
  /// that is to be displayed or edited.
  static GUID? _viewAsUser;

  // get the user that we are acting on behalf of.
  GUID? get loggedInUserGUID => _loggedInUser;

  Future<User> get loggedInUser => getByGUID(loggedInUserGUID!);

  Future<User?> getByApiKey(String apiKey) => super.getFirst('apiKey', apiKey);

  Future<User?> getByMobile(PhoneNumber mobile) =>
      super.getFirst('mobilePhone', mobile.toE164());

  Future<User?> getByEmailAddress(String emailAddress) =>
      super.getFirst('emailAddress', emailAddress);

  Future<void> login(GUID userGuid) async {
    _loggedInUser = userGuid;
    _viewAsUser = userGuid;
  }

  GUID? get viewAsUser => _viewAsUser;

  @override
  Query searchQuery(String filter, {int offset = 0, int limit = 100}) {
    final query = Query(
      entity,
      filterMode: FilterMode.or,
      offset: offset,
      limit: limit,
    )
      ..addFilter(Match('username', filter, matchMode: MatchMode.wild))
      ..addFilter(Match('firstname', filter, matchMode: MatchMode.wild))
      ..addFilter(Match('surname', filter, matchMode: MatchMode.wild))
      ..addFilter(Match('description', filter, matchMode: MatchMode.wild))
      ..addFilter(Match('emailAddress', filter, matchMode: MatchMode.wild))
      ..addFilter(Match('landline', filter, matchMode: MatchMode.wild))
      ..addFilter(Match('mobilePhone', filter, matchMode: MatchMode.wild))
      ..addFilter(Match('extensionNo', filter, matchMode: MatchMode.wild));
    return query;
  }

  @override
  User fromJson(Map<String, dynamic> json) => User.fromJson(json);

  /// Checks if there is at lease one administrator excluding the
  /// passed user.
  Future<bool> hasOtherAdministrators(User user) async {
    final query = Query(
      entity,
      limit: 1,
    )
      ..addFilter(Match('userRole', UserRole.customerAdministrator.toString()))
      ..addFilter(
          Match('guid', user.guid.toString(), matchMode: MatchMode.notEq));
    return (await select(query)).isEmpty;
  }

  /// Clear passed email address from all accounts.
  /// Used when we are about to create a new account with a verified
  /// email address. Other accounts with the same email address
  /// now loose their email address.
  Future<void> clearEmails(String emailAddress,
      {Transaction? transaction,
      bool force = false,
      RetryData retryData = RetryData.defaultRetry,
      User? exclude}) {
    final action = ActionUserClearEmailAddress(emailAddress, retryData);

    Repository.findTransaction(transaction).addAction(action);

    return action.future;
  }
}
