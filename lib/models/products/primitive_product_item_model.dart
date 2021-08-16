import 'enums/product_enum_type.dart';

class PrimitiveProductItemModel {

  String? pid;
  String? name;
  ProductType? type;
  int? count;
  int? prepareTime;
  DateTime? createDate;

  bool get isVeg => type == ProductType.vege;

  PrimitiveProductItemModel(
      {this.pid, this.name, this.type, this.count = 1, this.prepareTime}) {
    createDate = DateTime.now();
  }
}
