import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sopi/models/basket_model.dart';
import 'package:sopi/models/product_item_model.dart';

class ProductItemScreen extends StatefulWidget {
  final ProductItemModel product;

  ProductItemScreen(this.product);

  @override
  _ProductItemScreenState createState() =>
      _ProductItemScreenState(this.product);
}

class _ProductItemScreenState extends State<ProductItemScreen> {
  ProductItemModel _product;

  _ProductItemScreenState(this._product);

  void _addToBasket() {
    if (BasketModel.products.containsKey(_product.pid)) {
      BasketModel.products[_product.pid].count =
          BasketModel.products[_product.pid].count + _product.count;
    } else {
      BasketModel.products[_product.pid] = _product;
      BasketModel.count = 5;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
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
                FormBuilderTouchSpin(initialValue: 1,),
              ],
            ),
          ),
          Spacer(),
          FlatButton(
            minWidth: double.infinity,
            color: Theme.of(context).primaryColor,
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
