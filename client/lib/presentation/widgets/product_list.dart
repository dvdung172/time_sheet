import 'package:client/presentation/providers/product_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_item.dart';

class ProductList extends StatelessWidget {
  const ProductList({Key? key}) : super(key: key);

  static const routeName = '/ProductList';

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductListProvider>(
      builder: (_, provider, child) {
        if (provider.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        final productList = provider.products;

        return GridView.count(
          crossAxisCount: 2,
          children: productList.map((e) {
            final index = productList.indexOf(e);
            final product = productList[index];

            return ProductItem(product: product);
          }).toList(),
        );
      },
    );
  }
}
