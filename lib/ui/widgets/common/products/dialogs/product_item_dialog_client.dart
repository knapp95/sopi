import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/factory/field_builder_factory.dart';
import 'package:sopi/models/basket/basket_model.dart';
import 'package:sopi/models/products/product_item_model.dart';
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
  final FieldBuilderFactory _formFactory = FieldBuilderFactory();
  ProductItemModel _product;

  _ProductItemDialogClientState(this._product);


  void _addToBasket() {
    BasketModel _basket = Provider.of<BasketModel>(Get.context,listen: false);
    if (_basket.products.containsKey(_product.pid)) {
      _basket.products[_product.pid].count =
          _basket.products[_product.pid].count + _product.count;
    } else {
      _basket.products[_product.pid] = _product;
      _basket.count = 5;
    }
    _basket.notifyListenerHandler();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: shapeDialog,
      child: SingleChildScrollView(
        reverse: true,
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
                  _formFactory.buildTouchSpinField(
                      initialValue: _product.count),
                  _formFactory.buildTextField(
                    labelText: 'Add a note (extra sauce, no onions, etc.)',
                    maxLines: 5,
                  ),
                  FlatButton(
                    minWidth: double.infinity,
                    color: primaryColor,
                    child: Text(
                      'Add to basket',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _addToBasket,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
