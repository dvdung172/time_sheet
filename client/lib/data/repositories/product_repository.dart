import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants.dart';
import 'package:client/core/logger.dart';
import 'package:client/data/models/product.dart';
import 'package:client/data/repositories/api_connection.dart';

class ProductRepository {
  final ApiConnection connection;

  ProductRepository(this.connection);

  Future<List<Product>> getAllProducts() async {
    var response = await connection.execute(ApiRequest(
      endPoint: Endpoints.productApiUrl,
      method: ApiMethod.get,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
    ));

    logger.d('Response: ${response.body}');

    final productList = await json
        .decode(response.body)
        .map<Product>((item) => Product.fromJson(item))
        .toList();
    // print('productList: $productList');
    return productList;
  }

  Future<Product> getProductById(int productId) async {
    var response = await connection.execute(ApiRequest(
      endPoint: '${Endpoints.productApiUrl}/$productId',
      method: ApiMethod.get,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
    ));

    return Product.fromJson(json.decode(response.body));
  }
}
