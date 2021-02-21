import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sopi/models/generic/generic_item_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/widgets/menu/dialogs/product_item_manager_dialog.dart';

class MenuAddItem extends StatefulWidget {
  @override
  _MenuAddItemState createState() => _MenuAddItemState();
}

class _MenuAddItemState extends State<MenuAddItem> {
  Map<String, GenericItemModel> get allItems {
    Map<String, GenericItemModel> allItems = {};
    allItems['addProductManual'] = GenericItemModel(
      name: 'Add product manual',
      icon: Icons.add,
      funHandler: () => showDialog(
          context: context,
          child: ProductItemManagerDialog(
            isNew: true,
          )),
      color: primaryColor,
    );

    ///TODO
    allItems['addProductImport'] = GenericItemModel(
      name: 'Add products from file (JSON)',
      icon: Icons.file_upload,
      color: Colors.blue,
    );
    return allItems;
  }

  List<GenericItemModel> get visibleItems {
    List<GenericItemModel> visibleItems = [];
    visibleItems.add(allItems['addProductImport']);
    visibleItems.add(allItems['addProductManual']);
    return visibleItems;
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        animatedIcon: AnimatedIcons.list_view,
        children: visibleItems.map((GenericItemModel item) {
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
