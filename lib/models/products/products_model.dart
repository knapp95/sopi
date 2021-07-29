import 'package:flutter/material.dart';
import 'package:sopi/models/generic/generic_item_model.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/models/products/product_type_model.dart';
import 'package:sopi/services/products/product_service.dart';

class ProductsModel with ChangeNotifier {
  final _productService = ProductService.singleton;
  bool isInit = false;
  static const double maxAvailableRate = 6.0;

  static List<ProductTypeModel> types = [
    ProductTypeModel(ProductType.special, 'Special for your'),
    ProductTypeModel(ProductType.dessert, 'Desserts'),
    ProductTypeModel(ProductType.burger, 'Burger'),
    ProductTypeModel(ProductType.pizza, 'Pizza'),
    ProductTypeModel(ProductType.pasta, 'Pastas'),
    ProductTypeModel(ProductType.vege, 'Vegan'),
    ProductTypeModel(ProductType.other, 'Other'),
  ];

  static List<ProductTypeModel> get availableProductsTypes =>
      ProductsModel.types
          .where((element) => element.id != ProductType.special)
          .toList();

  static String getTypeName(ProductType? id) {
    return types.firstWhere((product) => product.id == id).name;
  }

  static List<GenericItemModel> times = [
    GenericItemModel(id: 5, name: '5'),
    GenericItemModel(id: 10, name: '10'),
    GenericItemModel(id: 15, name: '15'),
    GenericItemModel(id: 20, name: '20'),
    GenericItemModel(id: 30, name: '30'),
    GenericItemModel(id: 40, name: '40'),
    GenericItemModel(id: 50, name: '50'),
    GenericItemModel(id: 60, name: '60'),
  ];

  List<ProductItemModel> products = [];

  Future<void> fetchProducts() async {
    products = await _productService.fetchProducts();
    isInit = true;
    notifyListeners();
  }

  List<ProductItemModel> getSortedProductsByType(ProductType type) {
    List<ProductItemModel> productsByType = [];
    switch (type) {
      case ProductType.vege:
        productsByType = products.where((product) => product.isVeg).toList();
        break;
      case ProductType.special:
        productsByType = products..shuffle();
        break;
      default:
        productsByType =
            products.where((product) => product.type == type).toList();
    }
    productsByType.sort((a, b) => a.price!.compareTo(b.price!));
    return productsByType;
  }
}
