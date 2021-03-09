import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/basket/basket_model.dart';

class BasketBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BasketModel _basket = Provider.of<BasketModel>(Get.context, listen: false);
    String shortInfo =
        '${_basket.products.values.first.name}  ${_basket.count}';
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(shortInfo),
            Text(
              'Display basket',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
