import 'package:json_annotation/json_annotation.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';
import 'package:sopi/models/products/primitive_product_item_model.dart';
import 'package:sopi/models/products/product_item_model.dart';

part 'order_product_model.g.dart';

@JsonSerializable()
class OrderProductModel extends PrimitiveProductItemModel {

  int extraPrepareTime = 0;
  int get totalPrepareTime =>
      this.extraPrepareTime + (this.count! * this.prepareTime!);
  DateTime? startProcessingDate;
  DateTime? completeDate;

  OrderProductModel();


  factory OrderProductModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProductModelToJson(this);

  OrderProductModel.fromProduct(ProductItemModel product) {
    this.pid = product.pid;
    this.name = product.name;
    this.type = product.type;
    this.count = product.count;
    this.prepareTime = product.prepareTime;
  }

  void setAsComplete() {
    this.completeDate = DateTime.now();
  }
}
