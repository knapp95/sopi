import 'package:sopi/models/products/primitive_product_item_model.dart';
import 'package:sopi/models/products/product_item_model.dart';

class OrderProductModel extends PrimitiveProductItemModel {
  int extraPrepareTime = 0;
  int get totalPrepareTime =>
      this.extraPrepareTime + (this.count * this.prepareTime);

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
      this.extraPrepareTime = data['extraPrepareTime'] ?? 0;
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['extraPrepareTime'] = this.extraPrepareTime;
    } catch (e) {
      throw e;
    }
    data.addAll(super.toJson());
    return data;
  }
}
