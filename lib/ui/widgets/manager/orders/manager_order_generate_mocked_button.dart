import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sopi/factory/order_factory.dart';
import 'package:sopi/models/generic/generic_item_model.dart';
import 'package:sopi/models/orders/products/order_product_model.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/models/products/products_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';

class ManagerOrderGenerateMockedButton extends StatefulWidget {
  @override
  _ManagerOrderGenerateMockedButtonState createState() =>
      _ManagerOrderGenerateMockedButtonState();
}

class _ManagerOrderGenerateMockedButtonState
    extends State<ManagerOrderGenerateMockedButton> {
  List<ProductItemModel> products = [];
  final _orderFactory = OrderFactory.singleton;

  List<GenericItemModel> get allItems {
    return [
      GenericItemModel(
        funHandler: () => generateOrders(5),
        name: 'Generate 5 ORDERS',
        icon: Icons.add,
        color: primaryColor,
      ),
      GenericItemModel(
        funHandler: () => generateOrders(10),
        name: 'Generate 10 ORDERS',
        icon: Icons.add,
        color: primaryColor,
      ),
      GenericItemModel(
        funHandler: () => generateOrders(15),
        name: 'Generate 15 ORDERS',
        icon: Icons.add,
        color: primaryColor,
      ),
      GenericItemModel(
        funHandler: clearFactory,
        name: 'CLEAR FACTORY',
        icon: Icons.remove_circle,
        color: Colors.red,
      )
    ];
  }

  generateOrders(int ordersCount) async {
    for (int i = 0; i < ordersCount; i++) {
      int productsCount = Random().nextInt(6) + 1;
      if (products.isEmpty) {
        ProductsModel _productsModel =
        Provider.of<ProductsModel>(Get.context, listen: false);
        await _productsModel.fetchProducts();
        products = _productsModel.products;
      }
      products.shuffle();
      List<ProductItemModel> randomProducts =
      products.length > productsCount ? products.sublist(0, productsCount) : products;
      double summaryPrice = 0.0;
      List<OrderProductModel> randomProductsOrder = [];
      randomProducts.forEach((product) {
        randomProductsOrder.add(OrderProductModel.fromProduct(product));
        summaryPrice += product.count * product.price;
      });
      await _orderFactory.createOrder(randomProductsOrder, summaryPrice);
    }
  }

  clearFactory() {
    _orderFactory.clearDataFactory();
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        animatedIcon: AnimatedIcons.view_list,
        children: this.allItems.map((GenericItemModel item) {
          return SpeedDialChild(
            child: Center(
              child: FaIcon(
                item.icon,
                color: Colors.white,
              ),
            ),
            backgroundColor: item.color,
            onTap: () => item.funHandler(),
            label: item.name,
            labelStyle: TextStyle(color: Colors.white),
            labelBackgroundColor: item.color,
          );
        }).toList());
  }
}
