import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sopi/models/generic/generic_item_model.dart';
import 'package:sopi/ui/shared/animations.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/widgets/manager/company/assets/item/asset_item_dialog_widget.dart';
import 'package:sopi/ui/widgets/manager/company/products/product_item_dialog_widget.dart';

class ProductButtons extends StatefulWidget {
  const ProductButtons({Key? key}) : super(key: key);

  @override
  _ProductButtonsState createState() => _ProductButtonsState();
}

class _ProductButtonsState extends State<ProductButtons> {
  final List<GenericItemModel> visibleItems = [
    GenericItemModel(
      name: 'Add product',
      icon: Icons.food_bank,
      funHandler: () => showScaleDialog(
        const ProductItemDialogWidget(),
      ),
      color: primaryColor,
    ),
    GenericItemModel(
      name: 'Add asset',
      icon: Icons.kitchen,
      funHandler: () => showScaleDialog(
        const AssetItemDialogWidget(),
      ),
      color: primaryColor,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        animatedIcon: AnimatedIcons.view_list,
        children: visibleItems.map((GenericItemModel item) {
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
