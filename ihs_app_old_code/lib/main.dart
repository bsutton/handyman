// ignore_for_file: lines_longer_than_80_chars

import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';

import 'src/crud/customer/customer_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Firestore.initialize('handyman-407821');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CustomerList()

      // home: CrudHolder<Customer>(
      //   editable: CustomerEditable(),
      //   listWidget: const CustomerList(),
      // ),
      );
}
