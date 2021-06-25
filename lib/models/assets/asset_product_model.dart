import 'package:sopi/models/assets/enums/asset_enum_status.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';
import 'package:sopi/models/products/primitive_product_item_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'asset_product_model.g.dart';

@JsonSerializable()
class AssetProductModel extends PrimitiveProductItemModel {
  String? oid;
  int? totalPrepareTime;
  AssetEnumStatus? status = AssetEnumStatus.WAITING;

  factory AssetProductModel.fromJson(Map<String, dynamic> json) =>
      _$AssetProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetProductModelToJson(this);

  AssetProductModel(String? name, String? pid, this.oid, this.totalPrepareTime)
      : super(pid: pid, name: name);
}
