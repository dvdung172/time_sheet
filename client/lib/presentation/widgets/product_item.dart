import 'package:client/core/constants.dart';
import 'package:client/core/routes.dart';
import 'package:client/data/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'discount.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.productDetails,
          arguments: product.id,
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.network(
                product.thumbnailUrl,
                width: 100,
                height: 100,
              ),
              Text(product.name.length > 36
                  ? '${product.name.substring(0, 36)}...'
                  : product.name),
              Row(
                children: [
                  RatingBar.builder(
                    initialRating: product.ratingAverage,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 16,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 2,
                    ),
                    onRatingUpdate: (_) {},
                  ),
                  if (product.quantitySold != null)
                    Text(' | ${product.quantitySold!.text}'),
                ],
              ),
              Row(
                children: [
                  Text(formatCurrency.format(product.price)),
                  const Spacer(),
                  Discount(discountRate: product.discountRate),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
