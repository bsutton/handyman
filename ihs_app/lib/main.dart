// // ignore_for_file: lines_longer_than_80_chars

// import 'package:flutter/material.dart';

// import 'src/screens/crud_holder.dart';
// import 'src/screens/product_list.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   runApp(const MyApp());
// }

import 'package:flutter/material.dart';

import 'src/crud/crud_holder.dart';
import 'src/crud/customer/customer_editable.dart';
import 'src/crud/customer/customer_list.dart';
import 'src/dao/entities/customer.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CrudHolder<Customer>(
          editable: CustomerEditable(),
          listWidget: const CustomerList(),
        ),
      );
}
