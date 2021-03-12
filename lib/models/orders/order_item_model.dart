import 'package:sopi/models/products/product_item_model.dart';

class OrderItemModel {
  DateTime createDate;
  List<String> assignedPerson;
  int currentPositionInQueue;
  int humanNumber;

  List<ProductItemModel> products = [];

  OrderItemModel({
    this.createDate,
    this.assignedPerson,
    this.currentPositionInQueue,
    this.humanNumber,
    this.products,
  });

  OrderItemModel.fromJson(Map<String, dynamic> data) {
    try {
      this.createDate = data['createDate']?.toDate();
      this.assignedPerson = data['assignedPerson'];
      this.currentPositionInQueue = data['currentPositionInQueue'];
      this.humanNumber = data['humanNumber'];
      List<dynamic> extractedProducts = data['products'];
      if (extractedProducts != null) {
        List<ProductItemModel> productsTmp = [];
        for (dynamic product in extractedProducts) {
          productsTmp.add(ProductItemModel.fromJson(product));
        }
        this.products = productsTmp;
      }
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['createDate'] = this.createDate;
      data['humanNumber'] = this.humanNumber;
      if (this.products != null) {
        List<dynamic> productsTmp = [];
        for (ProductItemModel product in this.products) {
          productsTmp.add(product.toJson());
        }
        data['products'] = productsTmp;
      }
    } catch (e) {
      throw e;
    }
    return data;
  }
}
