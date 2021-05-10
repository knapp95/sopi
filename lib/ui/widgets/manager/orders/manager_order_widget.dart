import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/services/assets/asset_service.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:sopi/ui/widgets/manager/orders/manager_order_timeline.dart';

class ManagerOrderWidget extends StatefulWidget {
  @override
  _ManagerOrderWidgetState createState() => _ManagerOrderWidgetState();
}

class _ManagerOrderWidgetState extends State<ManagerOrderWidget> {
  final _assetService = AssetService.singleton;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  tabs: [
                    Tab(
                      text: 'Patelnia',
                      icon: Icon(Icons.supervised_user_circle,
                          color: Colors.white),
                    ),
                    Tab(icon: Icon(Icons.food_bank, color: Colors.white)),
                    Tab(icon: Icon(Icons.kitchen, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          body: StreamBuilder(
            stream: _assetService.assets,
            builder: (ctx, snapshot) {
              if (!snapshot.hasData) return LoadingDataInProgressWidget();
              if (snapshot.data.docs.isEmpty) return Text('empty');
              QueryDocumentSnapshot assetDoc = snapshot.data.docs[0];
              AssetItemModel assetItem =
              AssetItemModel.fromJson(assetDoc.data());
              return Container(child: ManagerOrderTimeline(assetItem));
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (_, int index) {
                  QueryDocumentSnapshot assetDoc = snapshot.data.docs[index];
                  AssetItemModel assetItem =
                      AssetItemModel.fromJson(assetDoc.data());
                  return Column(
                    children: [
                      Expanded(child: ManagerOrderTimeline(assetItem)),
                    ],
                  );

                  /// HEIGHT TODO
                },
              );
            },
          )),
    );
  }
}
