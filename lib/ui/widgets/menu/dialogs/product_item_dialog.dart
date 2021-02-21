import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sopi/models/basket_model.dart';
import 'package:sopi/models/product_item_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/shared_styles.dart';
import 'package:get/get.dart';

class ProductItemDialog extends StatefulWidget {
  final ProductItemModel product;

  ProductItemDialog(this.product);

  @override
  _ProductItemDialogState createState() =>
      _ProductItemDialogState(this.product);
}

class _ProductItemDialogState extends State<ProductItemDialog> {
  ProductItemModel _product;

  _ProductItemDialogState(this._product);

  void _addToBasket() {
    if (BasketModel.products.containsKey(_product.pid)) {
      BasketModel.products[_product.pid].count =
          BasketModel.products[_product.pid].count + _product.count;
    } else {
      BasketModel.products[_product.pid] = _product;
      BasketModel.count = 5;
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: shapeDialog,
      child: Column(
        children: [
          Image.network(
            _product.imageUrl,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  title: Text(_product.name),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(_product.description),
                  ),
                ),
                FormBuilderTouchSpin(
                  initialValue: 1,
                ),
              ],
            ),
          ),
          Spacer(),
          FlatButton(
            minWidth: double.infinity,
            color: primaryColor,
            child: Text(
              'Add to basket',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _addToBasket,
          )
        ],
      ),
    );
  }
}
