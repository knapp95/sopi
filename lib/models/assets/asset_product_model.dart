import 'package:json_annotation/json_annotation.dart';
import 'package:sopi/models/assets/enums/asset_enum_status.dart';
import 'package:sopi/models/orders/products/order_product_model.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';
import 'package:sopi/models/products/primitive_product_item_model.dart';

part 'asset_product_model.g.dart';

@JsonSerializable()
class AssetProductModel extends PrimitiveProductItemModel {
  String? oid;
  late int totalPrepareTime;
  AssetEnumStatus? status = AssetEnumStatus.waiting;
  late DateTime plannedStartProcessingDate;

  DateTime get plannedEndProcessingDate =>
      plannedStartProcessingDate.add(Duration(minutes: totalPrepareTime));

  AssetProductModel(String? name, String? pid, this.oid, this.totalPrepareTime)
      : super(pid: pid, name: name);

  AssetProductModel.fromOrder(this.oid, OrderProductModel orderProduct)
      : super(pid: orderProduct.pid, name: orderProduct.name) {
    totalPrepareTime = orderProduct.totalPrepareTime;
  }


  factory AssetProductModel.fromJson(Map<String, dynamic> json) =>
      _$AssetProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetProductModelToJson(this);
}
