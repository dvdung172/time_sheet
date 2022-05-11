class QuantitySold {
  final String text;
  final int value;

  QuantitySold({
    required this.text,
    required this.value,
  });
  factory QuantitySold.fromJson(Map<String, dynamic> json) {
    // print('parse QuantitySold from $json');
    return QuantitySold(
      text: json['text'] ?? '',
      value: json['value'],
    );
  }
}

class Product {
  final int id;
  final String name;
  final String thumbnailUrl;
  final int price;
  final int originalPrice;
  final int discountRate;
  final double ratingAverage;
  final int reviewCount;
  final QuantitySold? quantitySold;

  Product({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.price,
    required this.originalPrice,
    required this.discountRate,
    required this.ratingAverage,
    required this.reviewCount,
    this.quantitySold,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // print('Mapping $json');
    try {
      return Product(
        id: json['id'],
        name: json['name'] ?? '',
        thumbnailUrl: json['thumbnail_url'] ?? '',
        price: int.parse('${json['price'] ?? '0'}'),
        originalPrice: int.parse('${json['original_price'] ?? '0'}'),
        discountRate: int.parse('${json['discount_rate'] ?? '0'}'),
        ratingAverage: double.parse('${json['rating_average'] ?? '0'}'),
        reviewCount: int.parse('${json['review_count'] ?? '0'}'),
        quantitySold: json['quantity_sold'] == null
            ? null
            : QuantitySold.fromJson(json['quantity_sold']),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  String toString() {
    return 'Product {id: $id, name: $name, price: $price, discountRate: $discountRate}';
  }
}
