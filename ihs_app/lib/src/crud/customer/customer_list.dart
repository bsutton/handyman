import 'package:flutter/material.dart';

import '../../dao/customer_dao.dart';
import '../../dao/entities/customer.dart';
import '../crud_holder.dart';
import 'customer_editable.dart';

class CustomerList extends StatelessWidget implements CrudList {
  const CustomerList({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () async {
              if (context.mounted) {
                await Navigator.of(context).push<void>(MaterialPageRoute(
                    builder: (context) => CrudHolder<Customer>(
                        editable: CustomerEditable(),
                        listWidget: const CustomerList())));
              }
            },
          )
        ],
      ),
      body: customers());

  // body: (products.isNotEmpty)
  //     ? ListView.builder(
  //         itemCount: products.length,
  //         itemBuilder: (context, index) => ListTile(
  //               title: Text(products[index].name!),
  //               trailing: Text(products[index].price.toString()),
  //               onTap: () async {
  //                 await Navigator.of(context).push<void>(
  //                     MaterialPageRoute(
  //                         builder: (context) =>
  //                             EditProduct(product: products[index])));
  //               },
  //             ))
  //     : const Center(child: Text('Click + to add a new product')));
}

Widget customers() {
  final items = <Customer>[];
  return StreamBuilder(
      stream: CustomerDao().getCustomers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          return const Text('Click + to add a new customer');
        } else if (snapshot.hasError) {
          return const Text('Error!');
        } else {
          items.addAll(snapshot.data!);
          return SizedBox(
              child: Column(children: [
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) => ListTile(
                title: Text(items[index].name),
                onTap: () async {
                  await Navigator.of(context).push<void>(MaterialPageRoute(
                      builder: (context) => CrudHolder<Customer>(
                          editable: CustomerEditable(),
                          listWidget: const CustomerList(
                              // customer: items[index]
                              ))));
                },
              ),
              itemCount: items.length,
            ),
            const Text('Click + to add a new product')
          ]));
        }
      });
}
