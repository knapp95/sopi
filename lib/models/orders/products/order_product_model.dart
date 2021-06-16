import 'package:sopi/models/products/primitive_product_item_model.dart';
import 'package:sopi/models/products/product_item_model.dart';

class OrderProductModel extends PrimitiveProductItemModel {
  int extraPrepareTime = 0;

  int get totalPrepareTime =>
      this.extraPrepareTime + (this.count! * this.prepareTime!);
  bool isComplete = false;
  DateTime? startProcessingDate;
  DateTime? completeDate;

  OrderProductModel();

  OrderProductModel.fromProduct(ProductItemModel product) {
    this.pid = product.pid;
    this.name = product.name;
    this.type = product.type;
    this.count = product.count;
    this.prepareTime = product.prepareTime;
  }

  OrderProductModel.fromJson(Map<String, dynamic> data) : super.fromJson(data) {
    try {
      this.isComplete = data['isComplete'] ?? false;
      this.startProcessingDate = data['startProcessingDate']?.toDate();
      this.completeDate = data['completeDate']?.toDate();
      this.extraPrepareTime = data['extraPrepareTime'] ?? 0;
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['startProcessingDate'] = this.startProcessingDate;
      if (this.isComplete) {
        data['isComplete'] = this.isComplete;
        data['completeDate'] = this.completeDate;
      }

      data['extraPrepareTime'] = this.extraPrepareTime;
    } catch (e) {
      throw e;
    }
    data.addAll(super.toJson());
    return data;
  }

  void setAsComplete() {
    this.isComplete = true;
    this.completeDate = DateTime.now();
  }
}
