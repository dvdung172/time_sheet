import 'package:client/core/di.dart';
import 'package:client/presentation/providers/product_list_provider.dart';
import 'package:client/presentation/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListTab extends StatefulWidget {
  const ProductListTab({Key? key}) : super(key: key);

  @override
  State<ProductListTab> createState() => _ProductListTabState();
}

class _ProductListTabState extends State<ProductListTab> {
  @override
  void initState() {
    super.initState();
    sl<ProductListProvider>().getAllProducts();
  }

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
