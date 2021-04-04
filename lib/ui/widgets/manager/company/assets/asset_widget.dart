import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/ui/widgets/manager/company/assets/assets_list_widget.dart';
import 'package:sopi/ui/widgets/manager/company/assets/bottomBookmarks/asset_bottom_bookmarks_widget.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/assets/assets_model.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';

import 'assign/employee/asset_employee_list_widget.dart';

class AssetWidget extends StatefulWidget {
  @override
  _AssetWidgetState createState() => _AssetWidgetState();
}

class _AssetWidgetState extends State<AssetWidget>
    with TickerProviderStateMixin {
  bool _isInit = true;
  bool _isLoading = false;
  AssetsModel _assets;
  List<UserModel> _employees = [];

  /// TODO do weryfikacji

  Future<Null> _loadData() async {
    _assets = Provider.of<AssetsModel>(context);
    if (!_assets.isInit) {
      await _assets.fetchAssets();
    }
    _employees = await UserModel.fetchAllEmployees();
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
    asset.removeAsset();

    setState(() {
      _assets.assets?.removeWhere((element) => element.aid == asset.aid);
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
                child: AssetListWidget(
                    _assets.assets, _assets.displayBookmarks, _removeAsset),
              ),
              AssetBottomBookmarksWidget(),
              Expanded(child: AssetEmployeeListWidget(_employees)),
            ],
          );
  }
}
