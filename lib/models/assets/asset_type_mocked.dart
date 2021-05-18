

import 'package:flutter/material.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';

Map<ProductType, AssetTypeMocked> assetsTypeMocked = {
  ProductType.DESSERT: AssetTypeMocked(ProductType.DESSERT, Colors.deepOrangeAccent, 'dessert.png'),
  ProductType.BURGER: AssetTypeMocked(ProductType.BURGER, Colors.brown, 'burger.png', 10),
  ProductType.PIZZA: AssetTypeMocked(ProductType.PIZZA, Colors.red,'pizza.png',  10),
  ProductType.PASTA: AssetTypeMocked(ProductType.PASTA, Colors.amberAccent,'pasta.png', 15),
  ProductType.OTHER: AssetTypeMocked(ProductType.OTHER, Colors.teal, 'other.png', 20),
};


class AssetTypeMocked {
  final String iconPath;
  final ProductType type;
  final Color color;
  int suggestTimeForOther;
  AssetTypeMocked(this.type, this.color, this.iconPath, [suggestTimeForOther]);
}