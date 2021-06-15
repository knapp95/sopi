import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sopi/factory/order_factory.dart';
import 'package:sopi/models/generic/generic_item_model.dart';
import 'package:sopi/models/products/product_item_model.dart';
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
    List<GenericItemModel> allItems = [
      GenericItemModel(
        funHandler: _orderFactory.clearDataFactory,
        name: 'CLEAR FACTORY',
        icon: Icons.remove_circle,
        color: Colors.red,
      )
    ];
    for (var count in [15, 10, 5]) {
      allItems.add(
        GenericItemModel(
          funHandler: () => _orderFactory.generateOrders(count),
          name: 'Generate $count ORDERS',
          icon: Icons.add,
          color: primaryColor,
        ),
      );
    }
    return allItems;
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
