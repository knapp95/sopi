import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sopi/models/orders/enums/order_enum_status.dart';
import 'package:sopi/models/serializers/color_serializer.dart';
import 'package:sopi/services/authentication/authentication_service.dart';

import 'products/order_product_model.dart';

part 'order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderModel {
  OrderStatus? status = OrderStatus.WAITING;
  DateTime? createDate;
  String? clientID;
  List<String>? assignedPerson;
  @ColorSerializer()
  Color color = Color(Random().nextInt(0xffffffff));
  int? humanNumber;
  List<OrderProductModel>? products = [];
  double? totalPrice;

  OrderModel();

  OrderModel.fromBasket({
    this.createDate,
    this.humanNumber,
    this.products,
    this.totalPrice,
  }) {
    this.clientID = AuthenticationService.uid;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  int get prepareTime {
    int prepareTime = 0;
    try {
      this.products!.forEach((product) {
        prepareTime +=
            product.extraPrepareTime + (product.count! * product.prepareTime!);
      });
    } catch (e) {
      throw e;
    }
    return prepareTime;
  }

  OrderProductModel? getProductByPid(String? pid) {
    return this.products!.firstWhereOrNull((element) => element.pid == pid);
  }

  String get statusDisplay {
    switch (this.status) {
      case OrderStatus.WAITING:
        return 'Order waiting to start';
      case OrderStatus.PROCESSING:
        return 'Order is processing';
      case OrderStatus.COMPLETED:
        return 'Order is complete';
      case OrderStatus.CANCELLED:
        return 'Order is cancelled';
      default:
        return 'Almost done';
    }
  }
}
