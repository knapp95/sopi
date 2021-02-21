import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductItemModel {
  final _productsCollection = FirebaseFirestore.instance.collection('products');
  String pid;
  String imageUrl;
  String name;
  String description;
  double price;
  String type;
  bool isVeg;
  int count;

  ProductItemModel({
    this.pid,
    this.imageUrl,
    this.name,
    this.description,
    this.price,
    this.type,
    this.isVeg = false,
    this.count = 1,
  });

  double get rate {
    var rng = Random();
    return rng.nextInt(6).toDouble();
  }

  int get prepareTime {
    var rng = Random();
    return rng.nextInt(90);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['name'] = this.name;
      data['description'] = this.description;
      data['price'] = this.price;
      data['type'] = this.type;
      data['isVeg'] = this.isVeg;
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
          this.price = double.parse(value);
          break;
        case 'type':
          this.type = value;
          break;
        case 'isVeg':
          this.isVeg = value;
          break;
      }
    } catch (e) {
      throw e;
    }

  }

  Future<void> saveProductToFirebase() async {
    try {
      final data = this.toJson();
      if (this.pid != null) {
        await _productsCollection.doc(this.pid).set(data);
      } else {
        await _productsCollection.add(data);
      }
    } catch (e) {
      return e;
    }
  }
}
