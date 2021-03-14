import 'package:flutter/material.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/products/product_item_model.dart';

class BasketModel with ChangeNotifier {
  Map<String, ProductItemModel> products = {};
  void notifyListenerHandler() {
    notifyListeners();
  }

  String get displaySummaryPrice {
    double summaryPrice = 0;
    try {
      this.products.forEach((_, product) {
        summaryPrice += product.count * product.price;
      });
    } catch (e) {
      throw e;
    }
    return fixedDouble(summaryPrice);
  }

  void clearBasket() {
    this.products = {};
    notifyListeners();
  }
}
