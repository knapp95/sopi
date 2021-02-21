import 'package:flutter/material.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/factory/field_builder_factory.dart';
import 'package:sopi/models/generic/generic_item_model.dart';
import 'package:sopi/models/generic/generic_response_model.dart';
import 'package:sopi/models/menu_model.dart';
import 'package:sopi/models/product_item_model.dart';
import 'package:sopi/ui/shared/shared_styles.dart';
import 'package:get/get.dart';
class ProductItemManagerDialog extends StatefulWidget {
  final bool isNew;
  final String pid;

  ProductItemManagerDialog({this.isNew, this.pid});

  @override
  _ProductItemManagerDialogState createState() =>
      _ProductItemManagerDialogState();
}

class _ProductItemManagerDialogState extends State<ProductItemManagerDialog> {
  final FieldBuilderFactory _formFactory = FieldBuilderFactory();
  ProductItemModel _product;

  @override
  void initState() {
    if (widget.isNew) {
      _product = ProductItemModel();
    } else {
      // _product = //find by widget.pid
    }
    _formFactory.data = _product;
    super.initState();
  }

  void _submit() {
    _product.saveProductToFirebase();
    showBottomNotification(context, GenericResponseModel('Product saved', true));
    Get.back();
  }

  List<GenericItemModel> get availableProductsTypes => MenuModel.productsTypes
      .where((element) => element.id != 'special')
      .toList();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isNew ? 'Add product' : 'Edit product'),
      shape: shapeDialog,
      content: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _formFactory.buildTextField(
                      labelText: 'Name',
                      fieldName: 'name',
                      initialValue: _product.name,
                    ),
                    _formFactory.buildTextField(
                      labelText: 'Description',
                      fieldName: 'description',
                      initialValue: _product.description,
                      maxLines: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _formFactory.buildDropdownField(
                            fieldName: 'type',
                            initialValue: _product.type,
                            labelText: 'Type',
                            items: availableProductsTypes,
                          ),
                        ),
                        formSizedBoxWidth,
                        Expanded(
                          child: _formFactory.buildTextField(
                            fieldName: 'price',
                            initialValue: _product.price?.toString(),
                            labelText: 'Price',
                            keyboardType: TextInputType.number,
                            suffixIcon: Icon(Icons.attach_money),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        cancelDialogButton,
        FlatButton(
          onPressed: _submit,
          child: Text(
            'Submit',
          ),
        ),
      ],
    );
  }
}
