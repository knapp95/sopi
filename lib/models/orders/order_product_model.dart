import 'package:sopi/models/products/primitive_product_item_model.dart';
import 'package:sopi/models/products/product_item_model.dart';

class OrderProductModel extends PrimitiveProductItemModel {

  int get totalPrepareTime => this.count * this.prepareTime;
  OrderProductModel();

  OrderProductModel.fromProduct(ProductItemModel product) {
    this.pid = product.pid;
    this.name = product.name;
    this.type = product.type;
    this.count = product.count;
    this.prepareTime = product.prepareTime;
  }

  OrderProductModel.fromJson(Map<String, dynamic> data) : super.fromJson(data);

  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}
