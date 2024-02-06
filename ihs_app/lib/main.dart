// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';

import 'dao/crud_providers/product_editable.dart';
import 'dao/models/product.dart';
import 'screens/crud_holder.dart';
import 'screens/product_list.dart';
import 'supabase_factory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SupabaseFactory.initialise();

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
