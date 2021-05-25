import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/services/assets/asset_service.dart';
import 'package:sopi/ui/shared/systems_parameters.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:sopi/ui/widgets/manager/orders/manager_order_generate_mocked_button.dart';
import 'package:sopi/ui/widgets/manager/orders/timelines/manager_order_timeline_left.dart';
import 'package:sopi/ui/widgets/manager/orders/timelines/manager_order_timeline_right.dart';

class ManagerOrderWidget extends StatefulWidget {
  @override
  _ManagerOrderWidgetState createState() => _ManagerOrderWidgetState();
}

class _ManagerOrderWidgetState extends State<ManagerOrderWidget> {
  final _assetService = AssetService.singleton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight + 20),
        child: StreamBuilder(
          stream: _assetService.assets,
          builder: (ctx, snapshot) {
            if (snapshot.data == null) return LoadingDataInProgressWidget();
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ManagerOrderTimelineLeft(),
                      Expanded(
                        child: Container(
                          height: 1800,
                          ///TODO
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (_, int index) {
                              QueryDocumentSnapshot assetDoc =
                                  snapshot.data.docs[index];
                              AssetItemModel assetItem =
                                  AssetItemModel.fromJson(assetDoc.data());
                              return ManagerOrderTimelineRight(assetItem);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: ManagerOrderGenerateMockedButton(),
    );
  }
}
