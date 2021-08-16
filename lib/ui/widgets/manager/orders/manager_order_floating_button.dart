import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sopi/factory/order_factory.dart';
import 'package:sopi/models/generic/generic_item_model.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/ui/shared/animations.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/widgets/manager/orders/settings/manager_order_settings_dialog.dart';

class ManagerOrderFloatingButton extends StatefulWidget {
  const ManagerOrderFloatingButton({Key? key}) : super(key: key);

  @override
  _ManagerOrderFloatingButtonState createState() =>
      _ManagerOrderFloatingButtonState();
}

class _ManagerOrderFloatingButtonState
    extends State<ManagerOrderFloatingButton> {
  List<ProductItemModel> products = [];
  final _orderFactory = OrderFactory.singleton;

  void _openSettingsOrdersDialog() {
    showScaleDialog(const ManagerOrderSettingsDialog());
  }

  List<GenericItemModel> get allItems {
    final List<GenericItemModel> allItems = [
      GenericItemModel(
        funHandler: _orderFactory.clearDataFactory,
        name: 'Clear factory',
        icon: Icons.remove_circle,
        color: Colors.red,
      ),
    ];
    allItems.add(GenericItemModel(
      funHandler: _openSettingsOrdersDialog,
      name: 'Settings',
      icon: Icons.settings,
      color: Colors.blue,
    ));
    for (final count in [15, 10, 4]) {
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
        children: allItems.map((GenericItemModel item) {
          return SpeedDialChild(
            child: Center(
              child: FaIcon(
                item.icon,
                color: Colors.white,
              ),
            ),
            backgroundColor: item.color,
            onTap: () => item.funHandler!(),
            label: item.name,
            labelStyle: const TextStyle(color: Colors.white),
            labelBackgroundColor: item.color,
          );
        }).toList());
  }
}
