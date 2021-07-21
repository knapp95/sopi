import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/assets/asset_model.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/services/assets/asset_service.dart';
import 'package:sopi/services/users/user_service.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:sopi/ui/widgets/manager/company/assets/assets_list_widget.dart';

import 'assign/employee/asset_employee_list_widget.dart';

class AssetWidget extends StatefulWidget {
  @override
  _AssetWidgetState createState() => _AssetWidgetState();
}

class _AssetWidgetState extends State<AssetWidget>
    with TickerProviderStateMixin {
  final _userService = UserService.singleton;
  final _assetService = AssetService.singleton;
  bool _isInit = true;
  bool _isLoading = false;
  late AssetModel _assets;
  List<UserModel> _employees = [];

  Future<void> _loadData() async {
    _assets = Provider.of<AssetModel>(context);
    if (!_assets.isInit) {
      await _assets.fetchAssets();
    }
    _employees = await _userService.fetchAllEmployees();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _loadData();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _removeAsset(AssetItemModel asset) {
    _assetService.removeDoc(asset.aid);

    setState(() {
      _assets.assets.removeWhere((element) => element.aid == asset.aid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingDataInProgressWidget()
        : Column(
            children: [
              Expanded(
                flex: 3,
                child: AssetListWidget(_assets.assets, _removeAsset),
              ),
              Expanded(child: AssetEmployeeListWidget(_employees)),
            ],
          );
  }
}
