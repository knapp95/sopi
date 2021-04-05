import 'package:sopi/models/products/primitive_product_item_model.dart';

class AssetProductModel extends PrimitiveProductItemModel {
  String oid;
  int totalPrepareTime;

  AssetProductModel(String pid, this.oid, this.totalPrepareTime)
      : super(pid: pid);

  AssetProductModel.fromJson(Map<String, dynamic> data) : super.fromJson(data) {
    try {
      this.oid = data['oid'];
      this.totalPrepareTime = data['totalPrepareTime'];
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
    } catch (e) {
      throw e;
    }
    return data;
  }
}
