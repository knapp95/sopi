import 'package:json_annotation/json_annotation.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';
import 'package:sopi/models/products/primitive_product_item_model.dart';
import 'package:sopi/models/products/product_item_model.dart';

part 'order_product_model.g.dart';

@JsonSerializable()
class OrderProductModel extends PrimitiveProductItemModel {
  int extraPrepareTime = 0;

  int get totalPrepareTime => extraPrepareTime + (count! * prepareTime!);
  DateTime? startProcessingDate;
  DateTime? completeDate;

  OrderProductModel();

  factory OrderProductModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProductModelToJson(this);

  OrderProductModel.fromProduct(ProductItemModel product) {
    pid = product.pid;
    name = product.name;
    type = product.type;
    count = product.count;
    prepareTime = product.prepareTime;
  }

  void setAsComplete() {
    completeDate = DateTime.now();
  }
}
