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

  ///TODO add configure,save this field
  String? aid;
  String? name;
  String? imagePath;
  @ColorSerializer()
  Color color = randomColor;
  @JsonKey(ignore: true)
  bool editMode = false;
  ProductType assignedProductType = ProductType.BURGER;
  List<String> assignedEmployeesIds = [];
  List<AssetProductModel> queueProducts = [];

  AssetItemModel();

  List<AssetProductModel> get waitingProducts {
    return this
        .queueProducts
        .where((element) => element.status == AssetEnumStatus.WAITING)
        .toList();
  }

  AssetProductModel? get processingProduct {
    return this.queueProducts.firstWhereOrNull(
        (element) => element.status == AssetEnumStatus.PROCESSING);
  }

  /// Get's products from queue who startTimeline < product < endTimeline
  List<AssetProductModel> getQueueProductsTimeline(
      DateTime availableStartTimeLine, DateTime availableEndTimeLine) {
    return this.queueProducts.where((product) {
      return product.plannedEndProcessingDate.isAfter(availableStartTimeLine) &&
          product.plannedStartProcessingDate.isBefore(availableEndTimeLine);
    }).toList();
  }

  factory AssetItemModel.fromJson(Map<String, dynamic> json) =>
      _$AssetItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetItemModelToJson(this);

  void changeValueInForm(String fieldName, value) {
    try {
      if (value == null) return;
      switch (fieldName) {
        case 'name':
          this.name = value;
          break;
        case 'assignedProductType':
          this.assignedProductType = value;
          break;
        case 'maxWaitingTime':
          this.maxWaitingTime = value;
          break;
        case 'assignedEmployeesIds':
          this.assignedEmployeesIds = List.from(value);
          break;
      }
    } catch (e) {
      throw e;
    }
  }
  Future<void> saveAssetToFirebase() async {
    try {
      final _document = _assetService.getDoc(this.aid);
      bool isNew = this.aid == null;

      if (isNew) {
        this.aid = _document.id;
      }
      final data = this.toJson();
      if (isNew) {
        await _document.set(data);
      } else {
        await _document.update(data);
      }
    } catch (e) {
      throw e;
    }
  }

  /// CALLING WHEN EMPLOYEE SET ACTUAL PREPARE PRODUCT AS COMPLETED
  Future<void> completeProcessingProduct() async {
    this.processingProduct!.status = AssetEnumStatus.PAST;
    AssetProductModel? firstWaitingProduct =
        this.waitingProducts.length > 0 ? this.waitingProducts.first : null;
    if (firstWaitingProduct != null) {
      firstWaitingProduct.status = AssetEnumStatus.PROCESSING;
      this.updateProcessingProduct(firstWaitingProduct);
    }
    await this.updateQueueProducts();
  }

  Future<void> updateProcessingProduct(
      AssetProductModel assetProductModel) async {
    final oid = assetProductModel.oid;
    final pid = assetProductModel.pid;

    OrderModel order = await _orderService.getOrderById(oid);

    OrderProductModel orderProductModel = order.getProductByPid(pid)!;
    orderProductModel.startProcessingDate = DateTime.now();
    _orderService.updateOrder(order);
  }

  /// Add product to queque as WAITING, if queue don't have PROCESSING product set it
  Future<void> addProductsFromOrderToQueue(String oid,
      DateTime theLatestAssetEnd, List<OrderProductModel> products) async {
    int totalPrepareTime = products.fold(0,
        (previousValue, element) => previousValue + element.totalPrepareTime);
    for (OrderProductModel product in products) {
      AssetProductModel assetProductModel = AssetProductModel.fromOrder(
        product.name,
        product.pid,
        oid,
        product.totalPrepareTime,
      );
      if (this.processingProduct == null) {
        assetProductModel.status = AssetEnumStatus.PROCESSING;
      }
      assetProductModel.plannedStartProcessingDate = this
          .getPlannedStartProcessingDate(theLatestAssetEnd, totalPrepareTime);

      totalPrepareTime = totalPrepareTime - product.totalPrepareTime;
      this.queueProducts.add(assetProductModel);
      await this.updateQueueProducts();
    }
  }

  DateTime getPlannedStartProcessingDate(
      DateTime theLatestAssetEnd, int totalPrepareTime) {
    late DateTime plannedStartProcessingDate;
    if (this.maxWaitingTime == null) {
      plannedStartProcessingDate = this.queueProducts.isNotEmpty
          ? this.queueProducts.last.plannedEndProcessingDate
          : DateTime.now();
    } else {
      plannedStartProcessingDate = theLatestAssetEnd.add(
        Duration(minutes: -totalPrepareTime),
      );
    }
    return plannedStartProcessingDate;
  }

  Future<void> updateQueueProducts() async {
    List<dynamic> queueProductsJson = [];
    for (AssetProductModel assetProduct in this.queueProducts) {
      queueProductsJson.add(assetProduct.toJson());
    }
    final data = {'queueProducts': queueProductsJson};
    await _assetService.updateDoc(this.aid, data);
  }
}
