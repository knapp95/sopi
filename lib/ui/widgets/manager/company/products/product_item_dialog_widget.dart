import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sopi/factory/field_builder_factory.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/models/products/products_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/common/images/image_source_sheet.dart';

class ProductItemDialogWidget extends StatefulWidget {
  final ProductItemModel? productItem;

  const ProductItemDialogWidget([this.productItem, Key? key]) : super(key: key);

  @override
  _ProductItemDialogWidgetState createState() =>
      _ProductItemDialogWidgetState();
}

class _ProductItemDialogWidgetState extends State<ProductItemDialogWidget> {
  final FieldBuilderFactory _formFactory = FieldBuilderFactory();
  bool _isInit = false;
  late ProductsModel _products;
  late ProductItemModel _product;
  PickedFile? _imageFile;

  @override
  void initState() {
    if (!_isInit) {
      _product = widget.productItem ?? ProductItemModel();
      _products = Provider.of<ProductsModel>(context, listen: false);
      _isInit = true;
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
      final File? croppedFile = await ImageCropper.cropImage(
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        sourcePath: imageFile.path,
        androidUiSettings: const AndroidUiSettings(
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
          _imageFile = PickedFile(croppedFile.path);
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _submit() async {
    final image = _imageFile != null ? File(_imageFile!.path) : null;
    await _product.saveProductToFirebase(image: image);
    _products.fetchProducts();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_product.isNew ? 'Add product' : 'Edit product'),
      shape: shapeDialog,
      elevation: defaultElevation,
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
                      suffixIcon: const Icon(Icons.attach_money),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _formFactory.buildDropdownField(
                            fieldName: 'type',
                            initialValue: _product.type ?? ProductType.burger,
                            labelText: 'Type',
                            items: ProductsModel.types,
                          ),
                        ),
                        formSizedBoxWidth,
                        Expanded(
                          child: _formFactory.buildDropdownField(
                            fieldName: 'prepareTime',
                            initialValue: _product.prepareTime ?? 30,
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
      actions: [backDialogButton, submitDialogButton(_submit)],
    );
  }

  Widget _buildImage() {
    Row(
      children: <Widget>[
        TextButton(
          onPressed: _changePhoto,
          child: const Icon(Icons.refresh),
        ),
      ],
    );
    Widget? image;
    if (_product.imageUrl != null) {
      image = Image.network(_product.imageUrl!);
    }

    if (_imageFile != null) {
      image = Image.file(File(_imageFile!.path));
    }

    image ??= Image.asset('assets/images/no_photo.png');
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
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                backgroundColor: primaryColor,
                child: IconButton(
                  onPressed: _changePhoto,
                  icon: const Icon(
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
