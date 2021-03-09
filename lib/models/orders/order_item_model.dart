import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/models/products/products_model.dart';

class OrderItemModel {
   DateTime createDate;
  final List<String> assignedPerson;
  final int currentPositionInQueue;
  final int oid;
  final int waitingTimes;
  final int prepareTime;

  List<ProductItemModel> products = [];

  OrderItemModel({
    this.createDate,
    this.assignedPerson,
    this.currentPositionInQueue,
    this.oid,
    this.waitingTimes,
    this.prepareTime,
    this.products,
  });
}



