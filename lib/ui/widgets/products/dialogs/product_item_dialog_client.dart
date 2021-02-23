import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sopi/models/basket_model.dart';
import 'package:sopi/models/product_item_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/shared_styles.dart';
import 'package:get/get.dart';

class ProductItemDialogClient extends StatefulWidget {
  final ProductItemModel product;

  ProductItemDialogClient(this.product);

  @override
  _ProductItemDialogClientState createState() =>
      _ProductItemDialogClientState(this.product);
}

class _ProductItemDialogClientState extends State<ProductItemDialogClient> {
  ProductItemModel _product;

  _ProductItemDialogClientState(this._product);

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
          _product.imageUrl != null
              ? Image.network(_product.imageUrl, fit: BoxFit.cover)
              : Image.asset(
            'assets/images/no_photo.png',
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
