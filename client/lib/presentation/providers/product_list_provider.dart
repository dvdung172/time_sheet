import 'package:client/core/logger.dart';
import 'package:client/data/models/product.dart';
import 'package:client/data/repositories/product_repository.dart';
import 'package:flutter/material.dart';

class ProductListProvider extends ChangeNotifier {
  final ProductRepository productRepository;
  bool loading = false;
  List<Product> products = [];

  ProductListProvider(this.productRepository);

  void getAllProducts() async {
    loading = true;
    notifyListeners();

    logger.d('getProducts');

    if (products.isEmpty) {
      final value = await productRepository.getAllProducts();
      loading = false;
      products = value;
      notifyListeners();
    }
  }
}
