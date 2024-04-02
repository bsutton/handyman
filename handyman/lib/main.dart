import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'crud/customer_list_screen.dart';
import 'crud/job_list_screen.dart'; // Import the JobListScreen
import 'dao/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.initDatabase();

  print('Database located at: ${await getDatabasesPath()}');

  runApp(const MyApp());
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
        home: const HomeWithDrawer(child: CustomerListScreen()),
      );
}

class DrawerItem {
  DrawerItem({required this.title, required this.screen});
  final String title;
  final Widget screen;
}

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final List<DrawerItem> drawerItems = [
    DrawerItem(title: 'Customer', screen: const CustomerListScreen()),
    DrawerItem(
        title: 'Job',
        screen: const JobListScreen()), // Add JobListScreen to drawerItems
  ];

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView.builder(
          itemCount: drawerItems.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(drawerItems[index].title),
            onTap: () async {
              Navigator.pop(context); // Close the drawer
              await Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (context) => drawerItems[index].screen),
              );
            },
          ),
        ),
      );
}

class HomeWithDrawer extends StatelessWidget {
  const HomeWithDrawer({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Handyman'),
        ),
        drawer: MyDrawer(),
        body: child,
      );
}
