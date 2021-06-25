import 'enums/product_enum_type.dart';

class PrimitiveProductItemModel {
  String? pid;
  String? name;
  ProductType? type;
  int? count = 1;
  int? prepareTime;
  DateTime? createDate;

  bool get isVeg => this.type == ProductType.VEGE;

  PrimitiveProductItemModel(
      {this.pid, this.name, this.type, this.count, this.prepareTime}) {
    this.createDate = DateTime.now();
  }
}
