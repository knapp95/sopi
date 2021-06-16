import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/products/primitive_product_item_model.dart';
import 'package:sopi/services/products/product_service.dart';

class ProductItemModel extends PrimitiveProductItemModel {
  final _productService = ProductService.singleton;
  String? imageUrl;
  String? description;
  double? price;

  ProductItemModel();

  double get rate {
    var rng = Random();
    return rng.nextInt(6).toDouble();
  }

  String get displayTotalPrice => fixedDouble(this.price! * this.count!);

  ProductItemModel.fromJson(Map<String, dynamic> data) : super.fromJson(data) {
    try {
      this.imageUrl = data['imageUrl'];
      this.description = data['description'];
      this.price = data['price'];
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['description'] = this.description;
      data['imageUrl'] = this.imageUrl;
      data['price'] = this.price;
    } catch (e) {
      throw e;
    }
    data.addAll(super.toJson());
    return data;
  }

  void changeValueInForm(String fieldName, value) {
    try {
      if (value == null) return;
      switch (fieldName) {
        case 'name':
          this.name = value;
          break;
        case 'description':
          this.description = value;
          break;
        case 'price':
          this.price = double.tryParse(value);
          break;
        case 'type':
          this.type = value;
          break;
        case 'count':
          this.count = value?.toInt();
          break;
        case 'prepareTime':
          this.prepareTime = int.tryParse(value);
          break;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveProductToFirebase({File? image}) async {
    try {
      final _document = _productService.getDoc(this.pid);
      bool isNew = this.pid == null;

      if (isNew) {
        this.pid = _document.id;
      }
      if (image != null) {
        await this.putImage(image);
      }
      final data = this.toJson();
      if (isNew) {
        await _document.set(data);
      } else {
        await _document.update(data);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> putImage(File file) async {
    try {
      final FirebaseStorage _storage = FirebaseStorage.instance;
      String filePath = '${DateTime.now()}.png';
      final Reference reference = _storage.ref('images/').child(filePath);
      await reference.putFile(file);
      this.imageUrl = await reference.getDownloadURL();
    } catch (e) {
      throw e;
    }
  }
}
