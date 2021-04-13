import 'package:flutter/material.dart';

class ProductEmptyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          Image.asset(
            'assets/images/no_available_products.png',
            width: 200,
          ),
        ],
      ),
    );
  }
}
