import 'package:client/core/logger.dart';
import 'package:client/data/models/product.dart';
import 'package:client/data/repositories/product_repository.dart';
import 'package:flutter/material.dart';

class ProductDetailProvider extends ChangeNotifier {
  final ProductRepository productRepository;
  bool loading = false;
  Product? product;

  ProductDetailProvider(this.productRepository);

  Future<void> getProductById(int productId) async {
    loading = true;
    notifyListeners();

    logger.d('getProducts');

    final value = await productRepository.getProductById(productId);
    loading = false;
    product = value;
    notifyListeners();
  }
}
