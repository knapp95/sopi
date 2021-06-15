import 'enums/product_enum_type.dart';

abstract class PrimitiveProductItemModel {
  String pid;
  String name;
  ProductType type;
  int count = 1;
  int prepareTime;
  DateTime createDate;

  bool get isVeg => this.type == ProductType.VEGE;

  PrimitiveProductItemModel({this.pid, this.name}) {
    this.createDate = DateTime.now();
  }

  PrimitiveProductItemModel.fromJson(Map<String, dynamic> data) {
    try {
      this.pid = data['pid'];
      this.name = data['name'];
      this.type = getProductTypeFromString(data['type']);
      this.count = data['count'] ?? 1;
      this.prepareTime = data['prepareTime'];
      this.createDate = data['createDate']?.toDate();
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['pid'] = this.pid;
      data['name'] = this.name;
      data['type'] = this.type.toString();
      data['count'] = this.count;
      data['prepareTime'] = this.prepareTime;
      data['createDate'] = this.createDate;
    } catch (e) {
      throw e;
    }
    return data;
  }
}
