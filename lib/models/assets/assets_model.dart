import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:flutter/material.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';
import 'package:sopi/services/assets/asset_service.dart';




class AssetsModel with ChangeNotifier {
  final _assetService = AssetService.singleton;
  bool isInit = false;
  List<AssetItemModel> assets = [];

  Future<void> fetchAssets() async {
    try {
      final docs = await _assetService.getDocs();
      if (docs != null) {
        List<AssetItemModel> assets = [];
        for (QueryDocumentSnapshot doc in docs) {
          final assetTmp = AssetItemModel.fromJson(doc.data());
          List<String> assignedEmployeesIds =
              List<String>.from(doc.data()['assignedEmployeesIds']);
          await assetTmp.setAssignedEmployees(assignedEmployeesIds);
          assets.add(assetTmp);
        }
        this.assets = assets;
        this.isInit = true;
        notifyListeners();
      }
    } catch (e) {
      return e;
    }
  }

  AssetItemModel findAssetByProductType(ProductType productType) {
    return this.assets.firstWhere((asset) => asset.assignedProductType == productType);
  }


}
