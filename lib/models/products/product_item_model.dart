import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';
import 'package:sopi/models/products/primitive_product_item_model.dart';
import 'package:sopi/services/products/product_service.dart';

part 'product_item_model.g.dart';

@JsonSerializable()
class ProductItemModel extends PrimitiveProductItemModel {
  final _productService = ProductService.singleton;
  String? imageUrl;
  String? description;
  double? price;

  bool get isNew => this.pid == null;

  ProductItemModel();

  double get rate {
    final rng = Random();
    return rng.nextInt(6).toDouble();
  }

  String get displayTotalPrice => fixedDouble(price! * count!);

  factory ProductItemModel.fromJson(Map<String, dynamic> json) =>
      _$ProductItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductItemModelToJson(this);

  void changeValueInForm(String fieldName, dynamic value) {
    try {
      if (value == null) return;

      switch (fieldName) {
        case 'name':
          name = value as String;
          break;
        case 'description':
          description = value as String;
          break;
        case 'price':
          price = double.tryParse(value as String);
          break;
        case 'type':
          type = value as ProductType;
          break;
        case 'count':
          count = value as int;
          break;
        case 'prepareTime':
          prepareTime = value as int;
          break;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveProductToFirebase({File? image}) async {
    try {
      final _document = _productService.getDoc(this.pid);
      final bool isNew = this.pid == null;

      if (isNew) {
        this.pid = _document.id;
      }
      if (image != null) {
        await putImage(image);
      }
      final data = toJson();
      if (isNew) {
        await _document.set(data);
      } else {
        await _document.update(data);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> putImage(File file) async {
    try {
      final FirebaseStorage _storage = FirebaseStorage.instance;
      final String filePath = '${DateTime.now()}.png';
      final Reference reference = _storage.ref('images/').child(filePath);
      await reference.putFile(file);
      imageUrl = await reference.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }
}
