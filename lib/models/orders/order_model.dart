import 'dart:ui';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/orders/enums/order_enum_status.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';
import 'package:sopi/models/serializers/color_serializer.dart';
import 'package:sopi/services/authentication/authentication_service.dart';

import 'products/order_product_model.dart';

part 'order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderModel {
  late String oid;
  OrderStatus? status = OrderStatus.waiting;
  DateTime? createDate;
  String? clientID;
  List<String>? assignedPerson;
  @ColorSerializer()
  Color color = randomColor;
  int? humanNumber;
  List<OrderProductModel> products = [];
  double? totalPrice;

  OrderModel();

  OrderModel.fromBasket({
    this.createDate,
    this.humanNumber,
    required this.products,
    this.totalPrice,
  }) {
    clientID = AuthenticationService.uid;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  int get prepareTime {
    int prepareTime = 0;
    try {
      for (final OrderProductModel product in products) {
        prepareTime +=
            product.extraPrepareTime + (product.count! * product.prepareTime!);
      }
    } catch (e) {
      rethrow;
    }
    return prepareTime;
  }

  OrderProductModel? getProductByPid(String? pid) {
    return products.firstWhereOrNull((element) => element.pid == pid);
  }

  String get statusDisplay {
    switch (status) {
      case OrderStatus.waiting:
        return 'Order waiting to start';
      case OrderStatus.processing:
        return 'Order is processing';
      case OrderStatus.completed:
        return 'Order is complete';
      case OrderStatus.cancelled:
        return 'Order is cancelled';
      default:
        return 'Almost done';
    }
  }

  List<OrderProductModel> getProductsForType(ProductType type) {
    return products.where((element) => element.type == type).toList();
  }

  bool checkProductsContainsType(ProductType type) {
    return products.any((product) => type == product.type);
  }
}
