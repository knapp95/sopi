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

  Future<List<AssetItemModel>> assets() async {
    final List<AssetItemModel> assets = [];
    try {
      final docs = await _assetService.getDocs();

      for (final QueryDocumentSnapshot doc in docs) {
        final data = doc.data()! as Map<String, dynamic>;
        final asset = AssetItemModel.fromJson(data);
        assets.add(asset);
      }
    } catch (e) {
      rethrow;
    }
    return assets;
  }

  Future<AssetItemModel> getAsset(String? aid) async {
    final DocumentSnapshot asset = await _assetService.getDoc(aid).get();
    final data = asset.data()! as Map<String, dynamic>;
    return AssetItemModel.fromJson(data);
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

  Future<AssetItemModel> findAssetByProductType(
      ProductType? productType) async {
    return (await assets())
        .firstWhere((asset) => asset.assignedProductType == productType);
  }

  Future<Map<ProductType, List<AssetItemModel>>> getAssetsLinesExistsInOrder(
      OrderModel orderModel) async {
    final Map<ProductType, List<AssetItemModel>> assetsLinesExistsInOrder = {};
    for (final AssetItemModel assetItem in await assets()) {
      if (orderModel.checkProductsContainsType(assetItem.assignedProductType)) {
        assetsLinesExistsInOrder.update(assetItem.assignedProductType, (value) {
          value.add(assetItem);
          return value;
        }, ifAbsent: () => [assetItem]);
      }
    }
    return assetsLinesExistsInOrder;
  }

  Future<RequiredOrderInformation> findTheLastAssetEndIncludeOrder(
      OrderModel order) async {
    final Map<ProductType, List<AssetItemModel>> assetsLinesExistsInOrder =
        await getAssetsLinesExistsInOrder(order);
    DateTime theLastAssetPlannedEnd = DateTime.now();
    final Map<String, List<AssetProductModel>> productsFromOrderGroupedByAid = {};

    for (final entry in assetsLinesExistsInOrder.entries) {
      final productType = entry.key;
      final assetsLines = entry.value;
      final List<OrderProductModel> productsByType =
          order.getProductsForType(productType);
      productsByType
          .sort((a, b) => b.totalPrepareTime.compareTo(a.totalPrepareTime));
      for (final orderProduct in productsByType) {
        final AssetItemModel theFirstAssetPlannedEnd =
            AssetModel.sortAssetsLinesByPlannedEndProcessing(assetsLines).first;

        final assetProduct =
            AssetProductModel.fromOrder(order.oid, orderProduct);
        productsFromOrderGroupedByAid.update(theFirstAssetPlannedEnd.aid!,
            (value) {
          value.add(assetProduct);
          return value;
        }, ifAbsent: () => [assetProduct]);

        assetProduct.plannedStartProcessingDate =
            theFirstAssetPlannedEnd.lastPlannedEndProcessingDate;
        await theFirstAssetPlannedEnd.addProductToQueue(assetProduct);
      }
      final AssetItemModel theLastAssetFromThisTypeAPlannedEnd =
          AssetModel.sortAssetsLinesByPlannedEndProcessing(assetsLines).last;
      if (theLastAssetPlannedEnd.isBefore(
          theLastAssetFromThisTypeAPlannedEnd.lastPlannedEndProcessingDate)) {
        theLastAssetPlannedEnd =
            theLastAssetFromThisTypeAPlannedEnd.lastPlannedEndProcessingDate;
      }
    }
    return RequiredOrderInformation(
        productsFromOrderGroupedByAid, theLastAssetPlannedEnd);
  }

  Future<void> addNewOrderToProcess(OrderModel order,
      RequiredOrderInformation requiredOrderInformation) async {
    for (final entry
        in requiredOrderInformation.productsFromOrderGroupedByAid.entries) {
      final aid = entry.key;
      final assignedOrderProducts = entry.value;
      final asset = await _assetService.getAssetDoc(aid);
      int totalPrepareTime = assignedOrderProducts.fold(
          0,
          (int previousValue, element) =>
              previousValue + element.totalPrepareTime);
      for (final assetProduct in assignedOrderProducts) {
        assetProduct.plannedStartProcessingDate =
            asset.calculatePlannedStartProcessingDate(
                totalPrepareTime, requiredOrderInformation.theLastAssetEnd);
        totalPrepareTime = totalPrepareTime - assetProduct.totalPrepareTime;
        asset.addProductToQueue(assetProduct);
      }
      asset.updateQueueProducts();
    }
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

  static List<AssetItemModel> sortAssetsLinesByPlannedEndProcessing(
      List<AssetItemModel> assetsLines) {
    assetsLines.sort((first, second) {
      return first.lastPlannedEndProcessingDate
          .compareTo(second.lastPlannedEndProcessingDate);
    });
    return assetsLines;
  }
}

class RequiredOrderInformation {
  final Map<String, List<AssetProductModel>> productsFromOrderGroupedByAid;
  final DateTime theLastAssetEnd;

  RequiredOrderInformation(
      this.productsFromOrderGroupedByAid, this.theLastAssetEnd);
}
