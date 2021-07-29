import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sopi/factory/field_builder_factory.dart';
import 'package:sopi/models/basket/basket_model.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/client/basket/basket_button_widget.dart';

class ProductItemDialog extends StatefulWidget {
  final ProductItemModel product;

  const ProductItemDialog(this.product, {Key? key}) : super(key: key);

  @override
  _ProductItemDialogState createState() => _ProductItemDialogState();
}

class _ProductItemDialogState extends State<ProductItemDialog> {
  final FieldBuilderFactory _formFactory = FieldBuilderFactory();
  late ProductItemModel _product;

  _ProductItemDialogState();

  @override
  void initState() {
    _product = widget.product;
    _formFactory.data = _product;
    super.initState();
  }

  void _addToBasket() {
    final BasketModel _basket =
        Provider.of<BasketModel>(Get.context!, listen: false);
    if (_basket.products.containsKey(_product.pid)) {
      _basket.products[_product.pid]!.count =
          _basket.products[_product.pid]!.count! + _product.count!;
    } else {
      _basket.products[_product.pid] = _product;
    }
    _basket.notifyListenerHandler();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: shapeDialog,
      elevation: defaultElevation,
      child: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            if (_product.imageUrl != null)
              Image.network(_product.imageUrl!, fit: BoxFit.cover)
            else
              Image.asset(
                'assets/images/no_photo.png',
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_product.name!),
                  Text(
                    _product.description!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  formSizedBoxHeight,
                  _formFactory.buildNumberPicker(
                    fieldName: 'count',
                    max: 10,
                    value: _product.count!,
                    onChangedHandler: (_) => setState(() {}),
                  ),
                  _formFactory.buildTextField(
                    labelText: 'Add a note (extra sauce, no onions, etc.)',
                    maxLines: 5,
                  ),
                  BasketButtonWidget(
                    'Add (${_product.count}) to basket',
                    '\$${_product.displayTotalPrice}',
                    onPressedHandler: _addToBasket,
                    color: Colors.white,
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
