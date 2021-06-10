import 'package:sopi/models/assets/enums/asset_enum_status.dart';
import 'package:sopi/models/products/primitive_product_item_model.dart';

class AssetProductModel extends PrimitiveProductItemModel {
  String oid;
  int totalPrepareTime;
  DateTime startProcessingDate;
  AssetEnumStatus status = AssetEnumStatus.WAITING;
  AssetProductModel(String name, String pid, this.oid, this.totalPrepareTime)
      : super(pid: pid, name: name);

  AssetProductModel.fromJson(Map<String, dynamic> data) : super.fromJson(data) {
    try {
      this.oid = data['oid'];
      this.totalPrepareTime = data['totalPrepareTime'];
      this.startProcessingDate = data['startProcessingDate']?.toDate();
      this.status = getAssetStatusFromString(data['status']);
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['pid'] = this.pid;
      data['oid'] = this.oid;
      data['totalPrepareTime'] = this.totalPrepareTime;
      data['name'] = this.name;
      data['startProcessingDate'] = this.startProcessingDate;
      data['status'] = this.status.toString();
    } catch (e) {
      throw e;
    }
    return data;
  }
}
