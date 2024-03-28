/// Controls what pages a logged in user has access to.
/// @author bsutton
///
enum UserRole {
  staff,
  administrator,
  accounts,
  provider,
  customerAdministrator,
  customerStaff,
  all,
  monitor
}

class UserRoleHelper {
  UserRoleHelper();

  static bool isVisible(UserRole userRole) {
    switch (userRole) {
      case UserRole.all:
        return false;
      // ignore: no_default_cases
      default:
        return true;
    }
  }

  static List<UserRole> visibleValues() {
    final visible = <UserRole>[];

    for (final value in UserRole.values) {
      if (UserRoleHelper.isVisible(value)) {
        visible.add(value);
      }
    }
    return visible;
  }
}
