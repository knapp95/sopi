import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sopi/factory/field_builder_factory.dart';
import 'package:sopi/models/generic/generic_item_model.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/models/products/products_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/shared_styles.dart';
import 'package:get/get.dart';
import 'package:sopi/ui/widgets/common/images/image_source_sheet.dart';

class ProductItemDialog extends StatefulWidget {
  final bool isNew;
  final String pid;

  ProductItemDialog({this.isNew = false, this.pid});

  @override
  _ProductItemDialogState createState() =>
      _ProductItemDialogState();
}



class _ProductItemDialogState extends State<ProductItemDialog> {
  final FieldBuilderFactory _formFactory = FieldBuilderFactory();
  bool _isInit = false;
  ProductsModel _products;
  ProductItemModel _product;
  PickedFile _imageFile;

  @override
  void initState() {
    if (!_isInit) {
      _products = Provider.of<ProductsModel>(context, listen: false);
      _isInit = true;
    }
    if (widget.isNew) {
      _product = ProductItemModel();
    } else {
      _product =
          _products.products.firstWhere((element) => element.pid == widget.pid);
    }
    _formFactory.data = _product;
    super.initState();
  }

  void _changePhoto() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ImageSourceSheet(
          onImageSelected: (image) {
            _cropImage(image);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> _cropImage(File imageFile) async {
    try {
      File croppedFile = await ImageCropper.cropImage(
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        sourcePath: imageFile.path,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Adjust Photo',
          toolbarColor: primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls: true,
        ),
      );
      if (croppedFile != null) {
        setState(() {
          _imageFile = PickedFile(croppedFile?.path) ?? _imageFile;
        });
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> _submit() async {
    final image = _imageFile != null ? File(_imageFile.path) : null;
    await _product.saveProductToFirebase(image: image);
    _products.fetchProducts();
    Get.back();
  }

  List<GenericItemModel> get availableProductsTypes =>
      ProductsModel.types.where((element) => element.id != 'special').toList();

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
                    _buildImage(),
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
                    _formFactory.buildTextField(
                      fieldName: 'price',
                      initialValue: _product.price?.toString(),
                      labelText: 'Price',
                      keyboardType: TextInputType.number,
                      suffixIcon: Icon(Icons.attach_money),
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
                          child: _formFactory.buildDropdownField(
                            fieldName: 'prepareTime',
                            initialValue:  _product.prepareTime?.toString(),
                            labelText: 'Prepare time',
                            items: ProductsModel.times,
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
        backDialogButton,
        TextButton(
          onPressed: _submit,
          child: Text(
            'Submit',
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    Row(
      children: <Widget>[
        TextButton(
          child: Icon(Icons.refresh),
          onPressed: _changePhoto,
        ),
      ],
    );
    Widget image;
    if (_product.imageUrl != null) {
      image = Image.network(_product.imageUrl);
    }

    if (_imageFile != null) {
      image = Image.file(File(_imageFile.path));
    }

    if (image == null) {
      image = Image.asset('assets/images/no_photo.png');
    }
    final finalImageWidget = SizedBox(
      height: 250,
      child: InkWell(
        onTap: _changePhoto,
        child: Stack(
          children: <Widget>[
            Container(
              child: image,
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                backgroundColor: primaryColor,
                child: IconButton(
                  onPressed: _changePhoto,
                  icon: Icon(
                    Icons.photo_camera,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return finalImageWidget;
  }
}
