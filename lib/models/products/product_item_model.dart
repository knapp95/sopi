import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sopi/common/collections.dart';
import 'package:sopi/common/scripts.dart';

class ProductItemModel {
  String pid;
  String imageUrl;
  String name;
  String description;
  double price;
  String type;

  int count = 1;
  int prepareTime = 30;

  ProductItemModel({
    this.pid,
    this.imageUrl,
    this.name,
    this.description,
    this.price,
    this.type,
    this.prepareTime,
  });

  String get displayTotalPrice => fixedDouble(this.price * this.count);

  double get rate {
    var rng = Random();
    return rng.nextInt(6).toDouble();
  }

  bool get isVeg => this.type == 'vege';

  ProductItemModel.fromJson(Map<String, dynamic> data) {
    try {
      this.pid = data['pid'];
      this.imageUrl = data['imageUrl'];
      this.name = data['name'];
      this.description = data['description'];
      this.price = data['price'];
      this.type = data['type'];
      this.count = data['count'] ?? 1;
      this.prepareTime = data['prepareTime'];
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['pid'] = this.pid;
      data['name'] = this.name;
      data['description'] = this.description;
      data['imageUrl'] = this.imageUrl;
      data['price'] = this.price;
      data['type'] = this.type;
      data['count'] = this.count;
      data['prepareTime'] = this.prepareTime;
    } catch (e) {
      throw e;
    }
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

  Future<void> saveProductToFirebase({File image}) async {
    try {
      final _document = productsCollection.doc(this.pid);
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
      return e;
    }
  }

  Future<void> removeProduct() async {
    try {
      productsCollection.doc(this.pid).delete();
    } catch (e) {
      return e;
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
