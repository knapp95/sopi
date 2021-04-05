import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sopi/models/orders/enums/order_enum_status.dart';
import 'package:sopi/models/orders/order_item_model.dart';

class OrderService {
  final _ordersCollection = FirebaseFirestore.instance.collection('orders');
  static final OrderService _singleton = OrderService._internal();

  factory OrderService() {
    return _singleton;
  }

  OrderService._internal();

  static OrderService get singleton => _singleton;

  Future<OrderItemModel> getOrderById(String oid) async {
    DocumentSnapshot documentSnapshot = await _ordersCollection.doc(oid).get();
    final data = documentSnapshot.data();
    return OrderItemModel.fromJson(data);
  }

  DocumentReference getDoc({String oid}) {
    return _ordersCollection.doc(oid);
  }

  void updateOrderStatusToProcessing(oid) {
    _ordersCollection
        .doc(oid)
        .update({'status': OrderStatus.PROCESSING.toString()});
  }


  Future<int> getNextHumanNumberForOrder() async {
    int humanNumber = 1;
    QuerySnapshot query =

    await _ordersCollection.orderBy('humanNumber').limitToLast(1).get();
    /// After 99 order's increment's is reset
    if (query.docs.isNotEmpty && query.docs.first['humanNumber'] < 99) {
      humanNumber = query.docs.first['humanNumber'] + 1;
    }
    return humanNumber;
  }


}
