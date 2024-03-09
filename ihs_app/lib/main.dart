// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';

import 'src/dao/crud_providers/product_editable.dart';
import 'src/dao/models/product.dart';
import 'src/screens/crud_holder.dart';
import 'src/screens/product_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        home: CrudHolder<Product>(
          editable: ProductEditable(),
          child: const Products(),
        ),
      );
}
