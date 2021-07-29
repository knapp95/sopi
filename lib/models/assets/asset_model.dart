import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/orders/order_model.dart';
import 'package:sopi/models/orders/products/order_product_model.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';
import 'package:sopi/services/assets/asset_service.dart';
import 'package:sopi/services/settings/settings_service.dart';

import 'timeline/asset_timeline_settings_model.dart';

class AssetModel with ChangeNotifier {
  final _assetService = AssetService.singleton;
  final _settingsService = SettingsService.singleton;
  bool isInit = false;
  List<AssetItemModel> assets = [];
  AssetTimelineSettingsModel? assetTimelineSettings;

  Future<void> fetchAssetsTimelineSettings() async {
    try {
      final DocumentSnapshot doc =
          await _settingsService.getDoc(AssetTimelineSettingsModel.id).get();
      final data = doc.data()! as Map<String, dynamic>;
      assetTimelineSettings = AssetTimelineSettingsModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAssets() async {
    try {
      final docs = await _assetService.getDocs();
      final List<AssetItemModel> assets = [];
      for (final QueryDocumentSnapshot doc in docs) {
        final data = doc.data()! as Map<String, dynamic>;
        final asset = AssetItemModel.fromJson(data);
        assets.add(asset);
      }
      this.assets = assets;
      isInit = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<String>> getAvailableTypesImagePath(
      BuildContext ctx) async {
    final manifestContent =
        await DefaultAssetBundle.of(ctx).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap =
        json.decode(manifestContent) as Map<String, dynamic>;
    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('images/types/'))
        .where((String key) => key.contains('.png'))
        .toList();
    return imagePaths;
  }

  AssetItemModel findAssetByProductType(ProductType? productType) {
    return assets
        .firstWhere((asset) => asset.assignedProductType == productType);
  }

  List<AssetItemModel> getAssetExistsInOrder(OrderModel orderModel) {
    return assets
        .where((assetItem) =>
            orderModel.checkProductsContainsType(assetItem.assignedProductType))
        .toList();
  }

  Future<DateTime> findTheLatestAssetEndIncludeOrder(OrderModel order,
      [List<AssetItemModel>? assetExistsInOrder]) async {
    await fetchAssets();
    assetExistsInOrder ??= getAssetExistsInOrder(order);

    DateTime theLatestAssetEnd = DateTime.now();
    for (final asset in assetExistsInOrder) {
      DateTime assetPlannedEnd = asset.queueProducts.isNotEmpty
          ? asset.queueProducts.last.plannedEndProcessingDate
          : DateTime.now();
      final List<OrderProductModel> productsByType =
          order.getProductsForType(asset.assignedProductType);
      final int assignedProductsTime =
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
    final List<AssetProductModel> queueAllProductsInAssetsForEmployee = [];
    for (final QueryDocumentSnapshot doc in docs) {
      final data = doc.data()! as Map<String, dynamic>;
      final AssetItemModel assetItemModel = AssetItemModel.fromJson(data);
      queueAllProductsInAssetsForEmployee.addAll(assetItemModel.queueProducts);
    }
    return queueAllProductsInAssetsForEmployee;
  }
}
