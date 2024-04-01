import 'dart:async';

import 'package:flutter/material.dart';

import '../dao/types/er.dart';
import '../dao/types/phone_number.dart';
import '../pages/account_status/payment_failed_page.dart';
import '../pages/account_status/pending_suspension_page.dart';
import '../pages/account_status/suspended_page.dart';
import '../pages/account_status/trail_expiring_page.dart';
import '../pages/account_status/trial_expired_page.dart';
import '../pages/contacts/contact_list.dart';
import '../pages/dashboards/office_dashboard/dashboard/office_dashboard.dart';
import '../pages/dashboards/office_dashboard/pages/about_page.dart';
import '../pages/dashboards/office_dashboard/pages/acquire_did_wizard/acquire_did_wizard.dart';
import '../pages/dashboards/office_dashboard/pages/office_holidays_page.dart';
import '../pages/dashboards/office_dashboard/pages/phone_no_edit_page.dart';
import '../pages/dashboards/office_dashboard/pages/phone_no_list_page.dart';
import '../pages/dashboards/office_dashboard/pages/user_invite/user_invite_page.dart';
import '../pages/dashboards/team_dashboard/dashboard/team_dashboard.dart';
import '../pages/dashboards/team_dashboard/pages/create_team_page.dart';
import '../pages/dashboards/team_dashboard/pages/override_hours_page.dart';
import '../pages/dashboards/team_dashboard/pages/team_business_hours_page.dart';
import '../pages/dashboards/team_dashboard/pages/team_members_page.dart';
import '../pages/dashboards/user_dashboard/dashboard/user_dashboard.dart';
import '../pages/dashboards/user_dashboard/pages/conference_page.dart';
import '../pages/dashboards/user_dashboard/pages/dnd_page.dart';
import '../pages/dashboards/user_dashboard/pages/holidays_page.dart';
import '../pages/dashboards/user_dashboard/pages/limits_page.dart';
import '../pages/dashboards/user_dashboard/pages/support_page.dart';
import '../pages/dashboards/user_dashboard/pages/user_deleted_page.dart';
import '../pages/error_page.dart';
import '../pages/tutorial/tutorial_index_page.dart';
import '../pages/user/user_index_page.dart';
import '../pages/voicemail/voicemail_index_page.dart';
import '../util/log.dart';
import '../widgets/mini_card/mini_card.dart';

class RouteName {
  const RouteName(String routeName) : _routeName = routeName;
  final String _routeName;

  String get name => _routeName;

  @override
  String toString() => name;
}

typedef WidgetBuilderWithArg = Widget Function(
    BuildContext context, RouteSettings setting);

class SQRouter {
  factory SQRouter() => _self;

  const SQRouter._internal();
  static const SQRouter _self = SQRouter._internal();

  static RouteName? _currentRouteName;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  // static GlobalKey<NavigatorState> thumb_menuNavigator = GlobalKey();

// Standard navigation routes.
  static Map<RouteName, RouteBuilder<dynamic>> routes = {
    AboutPage.routeName: RouteBuilderNoArgs(AboutPage.new),
    AcquireDIDWizard.routeName: RouteBuilderNoArgs(AcquireDIDWizard.new),

    CreateTeamPage.routeName: RouteBuilderNoArgs(CreateTeamPage.new),
    ContactList.routeName: RouteBuilderNoArgs(ContactList.new),
    ConferencePage.routeName: RouteBuilderNoArgs(ConferencePage.new),

    DNDPage.routeName: RouteBuilderNoArgs(DNDPage.new),

    HolidaysPage.routeName: RouteBuilderNoArgs(HolidaysPage.new),
    // HomePage.routeName: RouteBuilderNoArgs(HomePage.new),

    LimitsPage.routeName: RouteBuilderNoArgs(LimitsPage.new),

    OfficeDashboard.routeName: RouteBuilderNoArgs(OfficeDashboard.new),
    OfficeHolidaysPage.routeName: RouteBuilderNoArgs(OfficeHolidaysPage.new),
    OverrideHoursPage.routeName: RouteBuilderNoArgs(OverrideHoursPage.new),

    PhoneNoListPage.routeName: RouteBuilderNoArgs(PhoneNoListPage.new),

    SupportPage.routeName: RouteBuilderNoArgs(SupportPage.new),

    TeamBusinessHoursPage.routeName:
        RouteBuilderNoArgs(TeamBusinessHoursPage.new),
    TeamDashboard.routeName: RouteBuilderNoArgs(TeamDashboard.new),
    TeamMembersPage.routeName: RouteBuilderNoArgs(TeamMembersPage.new),
    TutorialIndexPage.routeName: RouteBuilderNoArgs(TutorialIndexPage.new),

    UserDashboard.routeName: RouteBuilderNoArgs(UserDashboard.new),
    UserDeletedPage.routeName: RouteBuilderNoArgs(UserDeletedPage.new),
    UserIndexPage.routeName: RouteBuilderNoArgs(UserIndexPage.new),
    UserInvitePage.routeName: RouteBuilderNoArgs(UserInvitePage.new),

    VoicemailIndexPage.routeName: RouteBuilderNoArgs(VoicemailIndexPage.new),

    /// Routes with args
    // AskForInvitationPage.routeName: RouteBuilderWithArgs<PhoneNumber>(
    //     (arg) => AskForInvitationPage(mobile: arg)),
    // ExpiredInvitationPage.routeName: RouteBuilderWithArgs<PhoneNumber>(
    //     (arg) => ExpiredInvitationPage(mobile: arg)),
    // ReminderPage.routeName: RouteBuilderWithArgs<ReminderPageSettings>(
    //     (setting) => ReminderPage(settings: setting)),
    // RegistrationWizard.routeName: RouteBuilderWithArgs<RegistrationType>(
    //     (type) => RegistrationWizard(type: type)),

    // ReRegistrationPage.routeName:
    //     RouteBuilderWithArgs<ReRegistrationPageSettings>(
    //         (setting) => ReRegistrationPage(settings: setting)),

    TrialExpiredPage.routeName: RouteBuilderWithArgs<TrialExpiredPageSettings>(
        (setting) => TrialExpiredPage(settings: setting)),

    PaymentFailedPage.routeName:
        RouteBuilderWithArgs<PaymentFailedPageSettings>(
            (setting) => PaymentFailedPage(settings: setting)),
    SuspendedPage.routeName: RouteBuilderWithArgs<SuspendedPageSettings>(
        (setting) => SuspendedPage(settings: setting)),
    PendingSuspensionPage.routeName:
        RouteBuilderWithArgs<PendingSuspensionPageSettings>(
            (setting) => PendingSuspensionPage(settings: setting)),
    TrialExpiringPage.routeName:
        RouteBuilderWithArgs<TrialExpiringPageSettings>(
            (setting) => TrialExpiringPage(settings: setting)),

    // SeeYouSoon.routeName: RouteBuilderWithArgs<ReminderPageSettings>(
    //     (reg) => SeeYouSoon(reminder: reg)),
    PhoneNoEditPage.routeName: RouteBuilderWithArgs<ER<DIDForward>>(
        (arg) => PhoneNoEditPage(forwardTo: arg)),

    ErrorPage.routeName:
        RouteBuilderWithArgs<String>((cause) => ErrorPage(cause: cause)),

    /// Routes with custom transitions and args
    // MaxiCardPage.routeName:
    //     TransitionRouteBuilder<MaxiCardRouteArgs<dynamic, dynamic>>((arg) =>
    //         MaxiCardPage<ER<CallForwardTarget>, CallForwardMiniRowState>(
    //             args: arg as MaxiCardRouteArgs<ER<CallForwardTarget>,
    //                 CallForwardMiniRowState>))
  };

  bool isCurrentRoute(RouteName routeName) {
    getNav().popUntil((route) {
      // This is just a way to access currentRoute; the top route in the
      // Navigator stack.

      _currentRouteName = getRouteNameByString(route.settings.name ?? '');

      // Return true so popUntil() pops nothing.
      return true;
    });

    return _currentRouteName == routeName;
  }

  //
  // Set of push methods
  //

  ///,
  /// Pushes the given route onto the route stack.
  ///
  /// To remove this route call 'pop'.
  ///
  Future<T> pushNamed<T extends Object>(RouteName routeName) async {
    final r = await getNav().pushNamed<T>(
      routeName.name,
    );
    return r!;
  }

  /// [T] is the type of the returned data (if any)
  /// [A] is the type of the passed argument.
  /// The type checking here is busted, it will happily accept an incorrect type for argument.
  /// Maybe one day they'll fix Dart
  /// https://stackoverflow.com/questions/58616328/type-checking-for-generic-methods-in-dart-seems-to-be-broken
  Future<T> pushNamedWithArg<T extends Object, A>(
      RouteName routeName, A argument) async {
    final r = await getNav().pushNamed<T>(routeName.name, arguments: argument);
    return r!;
  }

  /// [T] is the type of the returned data (if any)
  /// [A] is the type of the passed argument.
  Future<T> replaceWithNamedAndArg<T extends Object, A>(
      RouteName routeName, A argument) async {
    final r = await getNav()
        .pushReplacementNamed<T, A>(routeName.name, arguments: argument);
    return r!;
  }

  /// Replace the current route of the navigator by pushing the route named
  /// [routeName] and then disposing the previous route once the new route has
  /// finished animating in.
  Future<void> replaceWithNamed(RouteName routeName) async {
    if (!isCurrentRoute(routeName)) {
      await getNav().pushReplacementNamed(routeName.name);
    } else {
      Log.d(
          'Ignored replaceWithName ${routeName.name} as the route is already on top');
    }
  }

  /// Replaces the existing route with the default route.
  Future<void> pushDefaultRoute() async {
    if (!isCurrentRoute(defaultRoute)) {
      await getNav().pushReplacementNamed(defaultRoute.name);
    } else {
      Log.d(
          'Ignored replaceWithName  ${defaultRoute.name}as the route is already on top');
    }
  }

  // ///
  // /// Pushes the a replacement route onto the Root navigator.
  // /// You should normally NOT use this method. Use [pushReplacmentNamed] instead.
  // void replaceWithRootNamed(RouteName routeName) {
  //   navigatorKey.currentState.pushReplacementNamed(routeName.name);
  // }

  Future<T> push<T>(Widget route) async =>
      (await getNav().push(MaterialPageRoute<T>(builder: (context) => route)))!;

  ///
  /// pop methods.
  ///
  ///
  ///

  /// Pop the top route of the route stack and optionally return its
  /// result.
  void pop<T>([T? result]) {
    getNav().pop(result);
  }

  void popUntil(RoutePredicate predicate) {
    getNav().popUntil(predicate);
  }

  RouteName get defaultRoute => HomePage.routeName;

  RouteBuilder<dynamic>? getRoute(String routeName) {
    RouteBuilder<dynamic>? builder;

    for (final route in routes.keys) {
      if (route.name == routeName) {
        builder = routes[route];
        break;
      }
    }
    return builder;
  }

  RouteName? getRouteNameByString(String name) {
    RouteName? routeName;

    for (final route in routes.keys) {
      if (route.name == name) {
        routeName = route;
        break;
      }
    }
    return routeName;
  }

  Map<RouteName, RouteBuilder<dynamic>> getRoutes() => routes;

  // RouteName getDefaultRootRoute() {
  //   return AppScaffold.routeName;
  // }

  Future<void> home() async {
    final nav = getNav();
    while (nav.canPop()) {
      nav.pop();
    }
    await replaceWithNamed(defaultRoute);
  }

  NavigatorState getNav() => navigatorKey.currentState!;
}

class RouteBuilderNoArgs extends RouteBuilder<void> {
  RouteBuilderNoArgs(Widget Function() builder)
      : super((context, arg) => builder());
}

class RouteBuilderWithArgs<T> extends RouteBuilder<T> {
  RouteBuilderWithArgs(Widget Function(T arg) builder)
      : super((context, arg) => builder(arg));
}

class RouteBuilder<T> {
  RouteBuilder(this.builder);
  Widget Function(BuildContext context, T arg) builder;

  PageRoute<Widget> build(BuildContext context, RouteSettings routeSettings) =>
      MaterialPageRoute<Widget>(
          builder: (context) => builder(context, routeSettings.arguments as T),
          settings: routeSettings);
}

class TransitionRouteBuilder<T> extends RouteBuilder<T> {
  TransitionRouteBuilder(this.pageBuilder)
      : super((context, arg) => pageBuilder(arg));
  Widget Function(T arg) pageBuilder;

  @override
  PageRoute<Widget> build(BuildContext context, RouteSettings routeSettings) =>
      PageTransition<MaxiCardPage<T, dynamic>>(
          type: PageTransitionType.fade,
          child: pageBuilder(routeSettings.arguments
              as T), // MaxiCardPage.withActive(activeMiniCard, this.widget),
          duration: const Duration(milliseconds: 600));
}
