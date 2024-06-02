import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'crud/contact/contact_list_screen.dart';
import 'crud/customer/customer_list_screen.dart';
import 'crud/job/job_list_screen.dart'; // Import the JobListScreen
import 'crud/supplier/supplier_list_screen.dart';
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
        home: const HomeWithDrawer(child: JobListScreen()),
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
    DrawerItem(title: 'Jobs', screen: const JobListScreen()),
    DrawerItem(title: 'Customers', screen: const CustomerListScreen()),
    DrawerItem(title: 'Suppliers', screen: const SupplierListScreen()),
    DrawerItem(title: 'Contacts', screen: const ContactListScreen()),
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
