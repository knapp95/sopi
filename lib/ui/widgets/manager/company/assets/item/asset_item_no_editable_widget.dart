import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/products/products_model.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/manager/common/asset_show_image.dart';
import 'package:sopi/ui/widgets/manager/company/assets/common/color_box_widget.dart';

class AssetItemNoEditableWidget extends StatelessWidget {
  final AssetItemModel _assetItem;

  AssetItemNoEditableWidget(this._assetItem);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
          leading: AssetShowImage(_assetItem.imagePath),
          trailing: ColorBoxWidget(
              _assetItem.color, '${_assetItem.maxWaitingTime ?? '-'}'),
          title: Text(
            _assetItem.name ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize20,
            ),
          ),
          subtitle: Text(
            ProductsModel.getTypeName(
              _assetItem.assignedProductType,
            ),
          ),
        )
      ],
    );
  }
}
