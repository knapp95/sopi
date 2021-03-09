import 'package:flutter/material.dart';
import 'package:sopi/models/products/product_item_model.dart';


class BasketModel with ChangeNotifier {
  Map<String, ProductItemModel> products = {};
  int count = 1;

  void notifyListenerHandler() {
    notifyListeners();
  }


}
