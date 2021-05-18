import 'dart:math';
import 'dart:ui';

import 'package:sopi/models/orders/enums/order_enum_status.dart';
import 'package:sopi/services/authentication_service.dart';

import 'products/order_product_model.dart';

class OrderItemModel {
  OrderStatus status = OrderStatus.WAITING;
  DateTime createDate;
  String clientID;
  List<String> assignedPerson;
  int currentPositionInQueue;
  Color color;
  int humanNumber;
  List<OrderProductModel> products = [];
  double totalPrice;

  OrderItemModel.fromBasket({
    this.createDate,
    this.humanNumber,
    this.products,
    this.totalPrice,
  }) {
    this.clientID = AuthenticationService.uid;
  }

  OrderItemModel.fromJson(Map<String, dynamic> data) {
    try {
      this.createDate = data['createDate']?.toDate();
      this.status = getOrderStatusFromString(data['status']);
      this.clientID = data['clientID'];

      this.assignedPerson = data['assignedPerson'];
      this.humanNumber = data['humanNumber'];
      this.color = Color(data['color']);
      List<dynamic> extractedProducts = data['products'];
      if (extractedProducts != null) {
        List<OrderProductModel> productsTmp = [];
        for (dynamic product in extractedProducts) {
          productsTmp.add(OrderProductModel.fromJson(product));
        }
        this.products = productsTmp;
      }
      this.totalPrice = data['totalPrice']?.toDouble();
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['createDate'] = this.createDate;
      data['status'] = this.status.toString();
      data['clientID'] = this.clientID;
      data['humanNumber'] = this.humanNumber;
      data['prepareTime'] = this.prepareTime;
      data['color'] = Random().nextInt(0xffffffff);
      if (this.products != null) {
        List<dynamic> productsTmp = [];
        for (OrderProductModel product in this.products) {
          productsTmp.add(product.toJson());
        }
        data['products'] = productsTmp;
      }
      data['totalPrice'] = this.totalPrice;
    } catch (e) {
      throw e;
    }
    return data;
  }

  int get prepareTime {
    int prepareTime = 0;
    try {
      this.products.forEach((product) {
        prepareTime +=
            product.extraPrepareTime + (product.count * product.prepareTime);
      });
    } catch (e) {
      throw e;
    }
    return prepareTime;
  }

  OrderProductModel getProductByPid(String pid) {
    return this
        .products
        .firstWhere((element) => element.pid == pid, orElse: () => null);
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
