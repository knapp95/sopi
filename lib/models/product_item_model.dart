import 'dart:math';

class ProductItemModel {
  int pid;
  String imageUrl;
  String name;
  String description;
  double price;
  String type;
  bool isVeg;
  int count;

  ProductItemModel({
    this.pid,
    this.imageUrl,
    this.name,
    this.description,
    this.price,
    this.type,
    this.isVeg = false,
    this.count = 1,
  });

  double get rate {
    var rng = Random();
    return rng.nextInt(6).toDouble();
  }

  int get prepareTime {
    var rng = Random();
    return rng.nextInt(90);
  }
}
