import 'package:flutter/material.dart';

import '../../app/router.dart' as r;
import '../../pages/dashboards/user_dashboard/dashboard/user_dashboard.dart';
import '../../pages/dashboards/user_dashboard/dashboard/user_thumb_menu.dart';
import '../expansion_bottom_app_bar/expansion_bottom_app_bar.dart';
import '../nav_menu/nav_menu.dart';

class ThumbMenuScaffold extends StatefulWidget {
  const ThumbMenuScaffold({super.key});

  static const String routeName = 'ThumbMenuScaffold';
  static final GlobalKey<ExpansionBottomAppBarState> expansionBarKey =
      GlobalKey();

  @override
  State<StatefulWidget> createState() => ThumbMenuScaffoldState();

  static ExpansionBottomAppBarState expansionBar() =>
      expansionBarKey.currentState!;
}

class ThumbMenuScaffoldState extends State<ThumbMenuScaffold> {
  @override
  Widget build(BuildContext context) => PopScope(
      // onPopInvoked: _onWillPop,
      child: Scaffold(body: buildBody(), bottomNavigationBar: buildNavBar()));

  ExpansionBottomAppBar buildNavBar() => ExpansionBottomAppBar(
      key: ThumbMenuScaffold.expansionBarKey,
      menu: const NavMenu(currentRoute: UserDashboard.routeName),
      bottomAppBar: BottomAppBar(child: buildThumbMenu()));

  Widget buildThumbMenu() => UserThumbMenu();

  Widget buildBody() => Navigator(
        // key: SQRouter.thumb_menuNavigator,
        initialRoute: r.SQRouter().defaultRoute.name,
        onGenerateRoute: generateRoute,
        onUnknownRoute: buildUnknownRoute,
      );

  PageRoute<Widget>? generateRoute(RouteSettings routeSettings) {
    final routeBuilder = r.SQRouter().getRoute(routeSettings.name!);

    return routeBuilder?.build(context, routeSettings);
  }

  Route<dynamic> buildUnknownRoute(RouteSettings routeSettings) =>
      MaterialPageRoute<void>(
          builder: (context) =>
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                    """
The ThumbMenu Navigator reported that the selected route '${routeSettings.name}' is unknown"""),
                ElevatedButton(
                    child: const Text('Home'),
                    onPressed: () async => r.SQRouter().home())
              ]));

  // Future<bool> _onWillPop() async {
  //   r.SQRouter().pop<void>();

  //   return false;
  // }
}

/*

class ConfirmExitDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConfirmExitDialogState();
  }
}

class ConfirmExitDialogState extends State<ConfirmExitDialog> {
  @override
  Widget build(BuildContext context) {
     return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Home Page'),
        ),
        body: new Center(
          child: new Text('Home Page'),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
*/
