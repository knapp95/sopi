import 'package:sopi/common/collections.dart';
import 'package:sopi/models/generic/generic_item_model.dart';
import 'package:flutter/material.dart';
import 'package:sopi/models/products/product_item_model.dart';

class ProductsModel with ChangeNotifier {
  bool isInit = false;
  static const double maxAvailableRate = 6.0;

  static List<GenericItemModel> types = [
    GenericItemModel(id: 'special', name: 'Special for your'),
    GenericItemModel(id: 'dessert', name: 'Desserts'),
    GenericItemModel(id: 'burger', name: 'Burger'),
    GenericItemModel(id: 'pizza', name: 'Pizza'),
    GenericItemModel(id: 'pasta', name: 'Pastas'),
    GenericItemModel(id: 'vege', name: 'Vegan'),
    GenericItemModel(id: 'other', name: 'Other'),
  ];

  static List<GenericItemModel> times = [
    GenericItemModel(id: '5', name: '5'),
    GenericItemModel(id: '10', name: '10'),
    GenericItemModel(id: '15', name: '15'),
    GenericItemModel(id: '20', name: '20'),
    GenericItemModel(id: '30', name: '30'),
    GenericItemModel(id: '40', name: '40'),
    GenericItemModel(id: '50', name: '50'),
    GenericItemModel(id: '60', name: '60'),
  ];


  List<ProductItemModel> products = [];

  Future<void> fetchProducts() async {
    try {
      final docs = (await productsCollection.get())?.docs;

      if (docs != null) {
        List<ProductItemModel> products = [];
        docs.forEach((doc) {
          final productTmp = ProductItemModel.fromJson(doc.data());
          products.add(productTmp);
        });
        this.products = products;
        this.isInit = true;
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
