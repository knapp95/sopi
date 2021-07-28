import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/services/assets/asset_service.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:sopi/ui/widgets/manager/company/assets/item/asset_item_widget.dart';

class AssetWidget extends StatefulWidget {
  @override
  _AssetWidgetState createState() => _AssetWidgetState();
}

class _AssetWidgetState extends State<AssetWidget> {
  final _assetService = AssetService.singleton;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _assetService.assets,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) return LoadingDataInProgressWidget();
        if ((snapshot.data! as QuerySnapshot).docs.isEmpty) return Container();
        return ListView.builder(
          itemCount: (snapshot.data! as QuerySnapshot).docs.length,
          itemBuilder: (_, int index) {
            QueryDocumentSnapshot orderDoc =
                (snapshot.data! as QuerySnapshot).docs[index];
            final data = orderDoc.data()! as Map<String, dynamic>;
            AssetItemModel asset = AssetItemModel.fromJson(data);
            return AssetItemWidget(asset);
          },
        );
      },
    );
  }
}
