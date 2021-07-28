import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/ui/shared/animations.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/manager/company/assets/item/asset_item_dialog_widget.dart';
import 'package:sopi/ui/widgets/manager/company/assets/item/asset_item_no_editable_widget.dart';

import '../assign/employee/asset_employee_item_widget.dart';
import '../assign/employee/asset_employee_unassigned_widget.dart';

class AssetItemWidget extends StatefulWidget {
  final AssetItemModel assetItem;

  AssetItemWidget(this.assetItem);

  @override
  _AssetItemWidgetState createState() => _AssetItemWidgetState(this.assetItem);
}

class _AssetItemWidgetState extends State<AssetItemWidget> {
  final AssetItemModel _assetItem;

  _AssetItemWidgetState(this._assetItem);

  void _openAssetEditDialog() {
    showScaleDialog(AssetItemDialogWidget(_assetItem));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: shapeCard,
        elevation: defaultElevation,
        child: Column(
          children: [
            AssetItemNoEditableWidget(_assetItem),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _assetItem.assignedEmployeesIds.length == 0
                    ? AssetEmployeeUnassignedWidget()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 5,
                            children: _assetItem.assignedEmployeesIds
                                .map(
                                  (String employeeId) => FutureBuilder(
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.none ||
                                          snapshot.data == null) {
                                        return Container();
                                      } else {
                                        UserModel employee =
                                            snapshot.data! as UserModel;
                                        return AssetEmployeeWidget(employee);
                                      }
                                    },
                                    future: UserModel.getUser(employeeId),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    child: Text('Edit'),
                    onPressed: _openAssetEditDialog,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
