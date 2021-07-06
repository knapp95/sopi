import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/orders/order_model.dart';
import 'package:sopi/models/orders/products/order_product_model.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';
import 'package:sopi/services/assets/asset_service.dart';

class AssetsModel with ChangeNotifier {
  final _assetService = AssetService.singleton;
  bool isInit = false;
  List<AssetItemModel> assets = [];

  Future<void> fetchAssets() async {
    try {
      final docs = await _assetService.getDocs();
      List<AssetItemModel> assets = [];
      for (QueryDocumentSnapshot doc in docs) {
        final data = doc.data()! as Map<String, dynamic>;
        final assetTmp = AssetItemModel.fromJson(data);
        List<String> assignedEmployeesIds =
            List<String>.from(data['assignedEmployeesIds']);
        await assetTmp.setAssignedEmployees(assignedEmployeesIds);
        assets.add(assetTmp);
      }
      this.assets = assets;
      this.isInit = true;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  AssetItemModel findAssetByProductType(ProductType? productType) {
    return this
        .assets
        .firstWhere((asset) => asset.assignedProductType == productType);
  }

  DateTime findTheLatestAssetEndIncludeOrder(
      OrderModel order, List<AssetItemModel> assetExistsInOrder) {
    DateTime theLatestAssetEnd = DateTime.now();
    for (AssetItemModel asset in assetExistsInOrder) {
      DateTime assetPlannedEnd = asset.queueProducts.isNotEmpty
          ? asset.queueProducts.last.plannedEndProcessingDate
          : DateTime.now();
      List<OrderProductModel> productsByType =
          order.getProductsForType(asset.assignedProductType);
      int assignedProductsTime =
          productsByType.fold(0, (sum, item) => sum + item.totalPrepareTime);
      assetPlannedEnd =
          assetPlannedEnd.add(Duration(minutes: assignedProductsTime));
      if (theLatestAssetEnd.isBefore(assetPlannedEnd)) {
        theLatestAssetEnd = assetPlannedEnd;
      }
    }
    return theLatestAssetEnd;
  }

  static List<AssetProductModel> getAllQueueProductsInAssetsForEmployee(
      List<QueryDocumentSnapshot> docs) {
    List<AssetProductModel> queueAllProductsInAssetsForEmployee = [];
    for (QueryDocumentSnapshot doc in docs) {
      final data = doc.data()! as Map<String, dynamic>;
      AssetItemModel assetItemModel = AssetItemModel.fromJson(data);
      queueAllProductsInAssetsForEmployee.addAll(assetItemModel.queueProducts);
    }
    return queueAllProductsInAssetsForEmployee;
  }
}
