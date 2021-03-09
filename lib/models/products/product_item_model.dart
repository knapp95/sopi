import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductItemModel {
  final _documentsCollections = FirebaseFirestore.instance.collection('products');
  String pid;
  String imageUrl;
  String name;
  String description;
  double price;
  String type;

  int count;

  ProductItemModel({
    this.pid,
    this.imageUrl,
    this.name,
    this.description,
    this.price,
    this.type,
  });

  double get rate {
    var rng = Random();
    return rng.nextInt(6).toDouble();
  }
  bool get isVeg => this.type == 'vege';

  int get prepareTime {
    var rng = Random();
    return rng.nextInt(90);
  }

  ProductItemModel.fromJson(Map<String, dynamic> data) {
    try {
      this.pid = data['pid'];
      this.imageUrl = data['imageUrl'];
      this.name = data['name'];
      this.description = data['description'];
      this.price = data['price'];
      this.type = data['type'];
      this.count = data['count'] ?? 1;
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['name'] = this.name;
      data['description'] = this.description;
      data['imageUrl'] = this.imageUrl;
      data['price'] = this.price;
      data['type'] = this.type;
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
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveProductToFirebase({File image}) async {
    try {
      final _document = _documentsCollections.doc(this.pid);
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
      _documentsCollections.doc(this.pid).delete();
    } catch (e) {
      return e;
    }
  }

  Future<void> putImage(File file) async{
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
