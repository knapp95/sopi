import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/ui/shared/animations.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/manager/company/assets/item/asset_item_dialog_widget.dart';
import 'package:sopi/ui/widgets/manager/company/assets/item/asset_item_no_editable_widget.dart';

import '../assign/employee/asset_employee_item_widget.dart';
import '../assign/employee/asset_employee_unassigned_widget.dart';

class AssetItemWidget extends StatelessWidget {
  final AssetItemModel assetItem;

  const AssetItemWidget(this.assetItem, {Key? key}) : super(key: key);

  void _openAssetEditDialog() {
    showScaleDialog(AssetItemDialogWidget(assetItem));
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
            AssetItemNoEditableWidget(assetItem),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (assetItem.assignedEmployeesIds.isEmpty)
                  const AssetEmployeeUnassignedWidget()
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 5,
                        children: assetItem.assignedEmployeesIds
                            .map(
                              (String employeeId) => FutureBuilder(
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.none ||
                                      snapshot.data == null) {
                                    return Container();
                                  } else {
                                    final UserModel employee =
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
                    onPressed: _openAssetEditDialog,
                    child: const Text('Edit'),
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
