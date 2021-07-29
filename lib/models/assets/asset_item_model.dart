import 'dart:ui';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/assets/enums/asset_enum_status.dart';
import 'package:sopi/models/orders/order_model.dart';
import 'package:sopi/models/orders/products/order_product_model.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';
import 'package:sopi/models/serializers/color_serializer.dart';
import 'package:sopi/services/assets/asset_service.dart';
import 'package:sopi/services/orders/order_service.dart';

part 'asset_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetItemModel {
  final _orderService = OrderService.singleton;
  final _assetService = AssetService.singleton;
  int? maxWaitingTime;

  bool get isNew => aid == null;

  String? aid;
  String? name;
  String? imagePath;
  @ColorSerializer()
  Color color = randomColor;
  @JsonKey(ignore: true)
  bool editMode = false;
  ProductType assignedProductType = ProductType.burger;
  List<String> assignedEmployeesIds = [];
  List<AssetProductModel> queueProducts = [];

  AssetItemModel();

  List<AssetProductModel> get waitingProducts {
    return queueProducts
        .where((element) => element.status == AssetEnumStatus.waiting)
        .toList();
  }

  AssetProductModel? get processingProduct {
    return queueProducts.firstWhereOrNull(
        (element) => element.status == AssetEnumStatus.processing);
  }

  /// Get's products from queue who startTimeline < product < endTimeline
  List<AssetProductModel> getQueueProductsTimeline(
      DateTime availableStartTimeLine, DateTime availableEndTimeLine) {
    return queueProducts.where((product) {
      return product.plannedEndProcessingDate.isAfter(availableStartTimeLine) &&
          product.plannedStartProcessingDate.isBefore(availableEndTimeLine);
    }).toList();
  }

  factory AssetItemModel.fromJson(Map<String, dynamic> json) =>
      _$AssetItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetItemModelToJson(this);

  void changeValueInForm(String fieldName, dynamic value) {
    try {
      if (value == null) return;
      switch (fieldName) {
        case 'name':
          name = value as String?;
          break;
        case 'assignedProductType':
          assignedProductType = value as ProductType;
          break;
        case 'maxWaitingTime':
          maxWaitingTime = value as int;
          break;
        case 'assignedEmployeesIds':
          assignedEmployeesIds = List.from(value as List<dynamic>);
          break;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveAssetToFirebase() async {
    try {
      final _document = _assetService.getDoc(aid);
      final bool isNew = aid == null;

      if (isNew) {
        aid = _document.id;
      }
      final data = toJson();
      if (isNew) {
        await _document.set(data);
      } else {
        await _document.update(data);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// CALLING WHEN EMPLOYEE SET ACTUAL PREPARE PRODUCT AS COMPLETED
  Future<void> completeProcessingProduct() async {
    processingProduct!.status = AssetEnumStatus.past;
    final AssetProductModel? firstWaitingProduct =
        waitingProducts.isNotEmpty ? waitingProducts.first : null;
    if (firstWaitingProduct != null) {
      firstWaitingProduct.status = AssetEnumStatus.processing;
      updateProcessingProduct(firstWaitingProduct);
    }
    await updateQueueProducts();
  }

  Future<void> updateProcessingProduct(
      AssetProductModel assetProductModel) async {
    final oid = assetProductModel.oid;
    final pid = assetProductModel.pid;

    final OrderModel order = await _orderService.getOrderById(oid);

    final OrderProductModel orderProductModel = order.getProductByPid(pid)!;
    orderProductModel.startProcessingDate = DateTime.now();
    _orderService.updateOrder(order);
  }

  /// Add product to queque as WAITING, if queue don't have PROCESSING product set it
  Future<void> addProductsFromOrderToQueue(String oid,
      DateTime theLatestAssetEnd, List<OrderProductModel> products) async {
    int totalPrepareTime = products.fold(0,
        (previousValue, element) => previousValue + element.totalPrepareTime);
    for (final OrderProductModel product in products) {
      final AssetProductModel assetProductModel = AssetProductModel.fromOrder(
        product.name,
        product.pid,
        oid,
        product.totalPrepareTime,
      );
      if (processingProduct == null) {
        assetProductModel.status = AssetEnumStatus.processing;
      }
      assetProductModel.plannedStartProcessingDate =
          getPlannedStartProcessingDate(theLatestAssetEnd, totalPrepareTime);

      totalPrepareTime = totalPrepareTime - product.totalPrepareTime;
      queueProducts.add(assetProductModel);
      await updateQueueProducts();
    }
  }

  DateTime getPlannedStartProcessingDate(
      DateTime theLatestAssetEnd, int totalPrepareTime) {
    late DateTime plannedStartProcessingDate;
    if (maxWaitingTime == null) {
      plannedStartProcessingDate = queueProducts.isNotEmpty
          ? queueProducts.last.plannedEndProcessingDate
          : DateTime.now();
    } else {
      plannedStartProcessingDate = theLatestAssetEnd.add(
        Duration(minutes: -totalPrepareTime),
      );
    }
    return plannedStartProcessingDate;
  }

  Future<void> updateQueueProducts() async {
    final List<dynamic> queueProductsJson = [];
    for (final assetProduct in queueProducts) {
      queueProductsJson.add(assetProduct.toJson());
    }
    final data = {'queueProducts': queueProductsJson};
    await _assetService.updateDoc(aid, data);
  }
}
