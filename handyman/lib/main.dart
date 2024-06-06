import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';
import 'package:provider/provider.dart';

import 'crud/customer/customer_list_screen.dart';
import 'crud/job/job_list_screen.dart';
import 'crud/supplier/supplier_list_screen.dart';
import 'crud/system/system_edit_screen.dart';
import 'dao/dao_system.dart';
import 'database/management/database_helper.dart';
import 'widgets/blocking_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

Future<void> _initDb() async {
  await DatabaseHelper.initDatabase();

  // await Future.delayed(const Duration(seconds: 60), () {});

  print('Database located at: ${await DatabaseHelper.pathToDatabase()}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Handyman',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider(
        create: (_) => BlockingUI(),
        child: Scaffold(
          body: BlockingUIBuilder<void>(
            future: _initDb,
            stacktrace: StackTrace.current,
            label: 'Upgrade your database.',
            builder: (context, _) =>
                const HomeWithDrawer(initialScreen: JobListScreen()),
          ),
        ),
      ));
}

class DrawerItem {
  DrawerItem({required this.title, required this.screen});
  final String title;
  final Widget screen;
}

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final List<DrawerItem> drawerItems = [
    DrawerItem(title: 'Jobs', screen: const JobListScreen()),
    DrawerItem(title: 'Customers', screen: const CustomerListScreen()),
    DrawerItem(title: 'Suppliers', screen: const SupplierListScreen()),
    DrawerItem(
      title: 'System',
      screen: FutureBuilderEx(
        future: DaoSystem().getById(1),
        builder: (context, system) => SystemEditScreen(system: system!),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView.builder(
          itemCount: drawerItems.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(drawerItems[index].title),
            onTap: () async {
              final targetRoute = MaterialPageRoute<void>(
                  builder: (context) => HomeWithDrawer(
                        initialScreen: drawerItems[index].screen,
                      ));

              if (drawerItems[index].title == 'System') {
                Navigator.pop(context); // Close the drawer
                await Navigator.push(context, targetRoute);
              } else {
                // Navigator.pop(context); // Close the drawer
                await Navigator.pushReplacement(context, targetRoute);
              }
            },
          ),
        ),
      );
}

class HomeWithDrawer extends StatelessWidget {
  const HomeWithDrawer({required this.initialScreen, super.key});
  final Widget initialScreen;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Handyman'),
        ),
        drawer: MyDrawer(),
        body: initialScreen,
      );
}



// Similarly, you can wrap CustomerListScreen, SupplierListScreen, and SystemEditScreen with Scaffold if they are not already.
