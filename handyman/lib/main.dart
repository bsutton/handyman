// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'crud/customer_list_screen.dart';
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
      home: const CustomerListScreen(),
    );
}
