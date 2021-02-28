import 'package:sopi/models/generic/generic_item_model.dart';
import 'package:sopi/models/product_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsModel with ChangeNotifier {
  static const double maxAvailableRate = 6.0;
  final _productsCollection = FirebaseFirestore.instance.collection('products');

  static List<GenericItemModel> types = [
    GenericItemModel(id: 'special', name: 'Special for your'),
    GenericItemModel(id: 'dessert', name: 'Desserts'),
    GenericItemModel(id: 'burger', name: 'Burger'),
    GenericItemModel(id: 'pizza', name: 'Pizza'),
    GenericItemModel(id: 'pasta', name: 'Pastas'),
    GenericItemModel(id: 'vege', name: 'Vegan'),
    GenericItemModel(id: 'other', name: 'Other'),
  ];

  List<ProductItemModel> products = [];

  Future<void> fetchProducts() async {
    try {
      final docs = (await _productsCollection.get())?.docs;

      if (docs != null) {
        List<ProductItemModel> products = [];
        docs.forEach((doc) {
          final productTmp = ProductItemModel.fromJson(doc.data());
          products.add(productTmp);
        });
        this.products = products;
        notifyListeners();
      }
    } catch (e) {
      return e;
    }
  }

  List<ProductItemModel> getSortedProductsByType(String type) {
    List<ProductItemModel> productsByType = [];
    switch (type) {
      case 'vege':
        productsByType =
            this.products.where((product) => product.isVeg).toList();
        break;
      case 'special':
        productsByType = this.products..shuffle();
        break;
      default:
        productsByType =
            this.products.where((product) => product.type == type).toList();
    }
    productsByType.sort((a, b) => a.price?.compareTo(b.price));
    return productsByType;
  }
}
