import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/ui/widgets/manager/company/assets/asset_item_widget.dart';

@immutable
class AssetListWidget extends StatelessWidget {
  final List<AssetItemModel> assets;
  final Function removeHandler;

  AssetListWidget(this.assets, this.removeHandler);

  void _assignEmployeeToAsset({
    UserModel? employee,
    required AssetItemModel asset,
  }) {
    if (!asset.assignedEmployees
        .any((assignedEmployee) => assignedEmployee!.uid == employee!.uid)) {
      asset.assignedEmployees.add(employee);
      asset.updateAssignedEmployeesIds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8.0),
      itemCount: assets.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 10.0,
        );
      },
      itemBuilder: (context, index) {
        final asset = assets[index];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: DragTarget<UserModel>(
            builder: (context, assign, _) {
              return AssetItemWidget(asset, assign.isNotEmpty, removeHandler);
            },
            onAccept: (assign) =>
                _assignEmployeeToAsset(asset: asset, employee: assign),
          ),
        );
      },
    );
  }
}
