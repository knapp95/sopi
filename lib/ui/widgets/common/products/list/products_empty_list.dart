import 'package:flutter/material.dart';

class ProductEmptyList extends StatelessWidget {
  const ProductEmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        Image.asset(
          'assets/images/no_available_products.png',
          width: 200,
        ),
      ],
    );
  }
}
