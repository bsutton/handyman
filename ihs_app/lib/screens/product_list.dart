import 'package:flutter/material.dart';

import '../dao/crud_providers/product_editable.dart';
import '../dao/product_dao.dart';
import '../dao/models/product.dart';
import 'crud_holder.dart';
import 'product_edit.dart';

class Products extends StatelessWidget {
  const Products({super.key});

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
                    builder: (context) => CrudHolder<Product>(
                        editable: ProductEditable(),
                        child: const EditProduct())));
              }
            },
          )
        ],
      ),
      body: products());

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

Widget products() {
  final items = <Product>[];
  return StreamBuilder(
      stream: ProductDao().getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          return const Text('Click + to add a new product');
        } else if (snapshot.hasError) {
          return const Text('Error!');
        } else {
          items.addAll(snapshot.data!);
          return SizedBox(
              child: Column(children: [
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) => ListTile(
                title: Text(items[index].name!),
                trailing: Text(items[index].price.toString()),
                onTap: () async {
                  await Navigator.of(context).push<void>(MaterialPageRoute(
                      builder: (context) => CrudHolder<Product>(
                          editable: ProductEditable(),
                          child: EditProduct(product: items[index]))));
                },
              ),
              itemCount: items.length,
            ),
            const Text('Click + to add a new product')
          ]));
        }
      });
}
