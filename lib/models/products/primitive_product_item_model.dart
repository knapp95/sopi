import 'enums/product_enum_type.dart';

abstract class PrimitiveProductItemModel {
  String pid;
  String name;
  ProductType type;
  int count = 1;
  int prepareTime;

  bool get isVeg => this.type == ProductType.VEGE;

  PrimitiveProductItemModel({this.pid});

  PrimitiveProductItemModel.fromJson(Map<String, dynamic> data) {
    try {
      this.pid = data['pid'];
      this.name = data['name'];
      this.type = getProductTypeFromString(data['type']);
      this.count = data['count'] ?? 1;
      this.prepareTime = data['prepareTime'];
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
    } catch (e) {
      throw e;
    }
    return data;
  }

}
