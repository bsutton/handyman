/// Controls what pages a logged in user has access to.
/// @author bsutton
///
enum UserRole { Staff, Administrator, Accounts, Provider, CustomerAdministrator, CustomerStaff, All, Monitor }

class UserRoleHelper {
  UserRoleHelper();

  static bool isVisible(UserRole userRole) {
    switch (userRole) {
      case UserRole.All:
        return false;
      default:
        return true;
    }
  }

  static List<UserRole> visibleValues() {
    var visible = <UserRole>[];

    for (var value in UserRole.values) {
      if (UserRoleHelper.isVisible(value)) {
        visible.add(value);
      }
    }
    return visible;
  }
}
