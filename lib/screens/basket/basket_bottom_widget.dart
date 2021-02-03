import 'package:flutter/material.dart';
import 'package:sopi/models/basket_model.dart';

class BasketBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String shortInfo = '${BasketModel.products.values.first.name}  ${BasketModel.count}'; ///TODO
    return Container(
//      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(shortInfo),
            Text('Display basket',style: TextStyle(color: Theme.of(context).primaryColor)),
          ],
        ),
      ),
    );
  }
}
