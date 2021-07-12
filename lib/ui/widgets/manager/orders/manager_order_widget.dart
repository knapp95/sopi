import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/assets/asset_model.dart';
import 'package:sopi/services/assets/asset_service.dart';
import 'package:sopi/ui/shared/systems_parameters.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:sopi/ui/widgets/manager/orders/manager_order_floating_button.dart';
import 'package:sopi/ui/widgets/manager/orders/timelines/manager_order_timeline_left.dart';
import 'package:sopi/ui/widgets/manager/orders/timelines/manager_order_timeline_right.dart';

class ManagerOrderWidget extends StatefulWidget {
  @override
  _ManagerOrderWidgetState createState() => _ManagerOrderWidgetState();
}

class _ManagerOrderWidgetState extends State<ManagerOrderWidget> {
  final _assetService = AssetService.singleton;
  bool _isLoading = false;
  bool _isInit = true;
  GlobalKey _timelineKey = GlobalKey();
  late Timer _timer;
  DateTime _roundingNow = getRoundingTime();

  @override
  void initState() {
    super.initState();
    if (_isInit) {
      _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
      _isInit = false;

      setState(() {
        _isLoading = true;
      });
      _prepareData();
    }
  }

  void _getTime() {
    setState(() {
      _roundingNow = getRoundingTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _prepareData() async {
    AssetModel assets = Provider.of<AssetModel>(Get.context!);
    if (assets.assetTimelineSettings == null) {
      await assets.fetchAssetsTimelineSettings();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Asset line with positions should has the same height like timeline
  double _getHeightDependentTimelineLeft() {
    double heightDependentTimelineLeft = 0;
    final keyContext = _timelineKey.currentContext;
    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      heightDependentTimelineLeft = box.size.height;
    }
    return heightDependentTimelineLeft;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingDataInProgressWidget()
        : Scaffold(
            body: Padding(
              padding: EdgeInsets.only(top: statusBarHeight + 20),
              child: StreamBuilder(
                stream: _assetService.assets,
                builder: (ctx, snapshot) {
                  if (snapshot.data == null)
                    return LoadingDataInProgressWidget();
                  return SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          key: _timelineKey,
                          child: ManagerOrderTimelineLeft(_roundingNow),
                        ),
                        Expanded(
                          child: Container(
                            height: _getHeightDependentTimelineLeft(),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  (snapshot.data! as QuerySnapshot).docs.length,
                              itemBuilder: (_, int index) {
                                QueryDocumentSnapshot assetDoc =
                                    (snapshot.data! as QuerySnapshot)
                                        .docs[index];
                                final data =
                                    assetDoc.data()! as Map<String, dynamic>;
                                AssetItemModel assetItem =
                                    AssetItemModel.fromJson(data);
                                return ManagerOrderTimelineRight(assetItem);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            floatingActionButton: ManagerOrderFloatingButton(),
          );
  }
}
