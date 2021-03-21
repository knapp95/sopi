import 'package:sopi/models/orders/enums.dart';
import 'package:sopi/models/products/product_item_model.dart';


class OrderItemModel {
  Status status;
  DateTime createDate;
  String clientID;
  List<String> assignedPerson;
  int currentPositionInQueue;
  int humanNumber;
  List<ProductItemModel> products = [];

  OrderItemModel.fromBasket({
    this.createDate,
    this.status = Status.WAITING,
    this.clientID,
    this.assignedPerson,
    this.currentPositionInQueue,
    this.humanNumber,
    this.products,
  });

  OrderItemModel.fromJson(Map<String, dynamic> data) {
    try {
      this.createDate = data['createDate']?.toDate();
      this.status = getStatusFromString(data['status']);
      this.clientID = data['clientID']?.toString();

      this.assignedPerson = data['assignedPerson'];
      this.humanNumber = data['humanNumber'];
      List<dynamic> extractedProducts = data['products'];
      if (extractedProducts != null) {
        List<ProductItemModel> productsTmp = [];
        for (dynamic product in extractedProducts) {
          productsTmp.add(ProductItemModel.fromJson(product));
        }
        this.products = productsTmp;
      }

    } catch (e) {
      throw e;
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['createDate'] = this.createDate;
      data['status'] = this.status.toString();
      data['clientID'] = this.clientID;
      data['humanNumber'] = this.humanNumber;
      data['prepareTime'] = this.prepareTime;
      if (this.products != null) {
        List<dynamic> productsTmp = [];
        for (ProductItemModel product in this.products) {
          productsTmp.add(product.toJson());
        }
        data['products'] = productsTmp;
      }
    } catch (e) {
      throw e;
    }
    return data;
  }


  int get prepareTime {
    int prepareTime = 0;
    try {
      this.products.forEach((product) {
        prepareTime += product.count * product.prepareTime;
      });
    } catch (e) {
      throw e;
    }
    return prepareTime;
  }

}
