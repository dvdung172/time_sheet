import 'dart:convert';

import 'package:client/data/models/product.dart';
import 'package:client/data/repositories/api_connection.dart';
import 'package:client/data/repositories/product_repository.dart';
import 'package:flutter/services.dart';

class ProductRepositoryMock extends ProductRepository {
  ProductRepositoryMock({required ApiConnection connection})
      : super(connection);

  @override
  Future<List<Product>> getAllProducts() async {
    // dummy service
    // simulate calling to server take time 300 ms
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final data = await rootBundle.loadString('assets/mocks/all_products.json');

    // logger.d('Response: $data');

    final productList = await json
        .decode(data)
        .map<Product>((item) => Product.fromJson(item))
        .toList();
    return productList;
  }

  @override
  Future<Product> getProductById(int productId) async {
    // dummy service
    // simulate calling to server take time 300 ms
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final data = await rootBundle.loadString('assets/mocks/one_product.json');

    return Product.fromJson(json.decode(data));
  }
}
