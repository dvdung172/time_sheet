import 'package:flutter/material.dart';

class Discount extends StatelessWidget {
  const Discount({
    Key? key,
    required this.discountRate,
  }) : super(key: key);

  final int discountRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.deepOrange,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text('-$discountRate%'),
    );
  }
}
