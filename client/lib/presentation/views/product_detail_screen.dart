import 'package:client/core/constants.dart';
import 'package:client/core/di.dart';
import 'package:client/core/logger.dart';
import 'package:client/presentation/providers/product_detail_provider.dart';
import 'package:client/presentation/widgets/discount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail(this.productId, {Key? key}) : super(key: key);

  final int productId;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  void initState() {
    super.initState();

    sl<ProductDetailProvider>().getProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailProvider>(builder: (_, provider, chile) {
      if (provider.loading) {
        return const Center(child: CircularProgressIndicator());
      }

      final product = provider.product!;

      return Scaffold(
        body: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.network(product.thumbnailUrl),
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 8),
                  child: Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      if (product.reviewCount > 0)
                        Text(' (${product.reviewCount})'),
                      if (product.quantitySold != null)
                        Text(' | ${product.quantitySold!.text}'),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        color: Colors.black45,
                        icon: const Icon(Icons.link),
                      ),
                      IconButton(
                        onPressed: () {},
                        color: Colors.black45,
                        icon: const Icon(Icons.share),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrency.format(product.price),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.redAccent),
                      ),
                      Discount(discountRate: product.discountRate),
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    logger.d('TODO: Add product ${widget.productId} to cart');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: Text(
                    'Chọn Mua',
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(fontSize: 18.0, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
