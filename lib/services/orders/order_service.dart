import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:get/get.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/generic/generic_response_model.dart';
import 'package:sopi/models/orders/enums/order_enum_status.dart';
import 'package:sopi/models/orders/order_model.dart';

import '../authentication/authentication_service.dart';

class OrderService {
  final _ordersCollection = FirebaseFirestore.instance.collection('orders');
  static final OrderService _singleton = OrderService._internal();

  factory OrderService() {
    return _singleton;
  }

  OrderService._internal();

  static OrderService get singleton => _singleton;

  Future<OrderModel> getOrderById(String? oid) async {
    final DocumentSnapshot documentSnapshot =
        await _ordersCollection.doc(oid).get();
    final data = documentSnapshot.data()! as Map<String, dynamic>;
    return OrderModel.fromJson(data);
  }

  DocumentReference getDoc({String? oid}) {
    return _ordersCollection.doc(oid);
  }

  Future<void> updateOrderStatusToProcessing(String oid) async {
    _ordersCollection.doc(oid).update(
        {'status': EnumToString.convertToString(OrderStatus.processing)});
  }

  void updateOrder(OrderModel order) {
    try {
      final data = order.toJson();
      _ordersCollection.doc(order.oid).update(data);
      showBottomNotification(
        Get.context,
        GenericResponseModel('Order update successfully.'),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeAllOrders() async {
    final docs = (await _ordersCollection.get()).docs;
    for (final QueryDocumentSnapshot doc in docs) {
      await doc.reference.delete();
    }
  }

  Stream<QuerySnapshot> get processingOrderClient {
    return _ordersCollection
        .where('clientID', isEqualTo: AuthenticationService.uid)
        .where('status',
            isNotEqualTo: EnumToString.convertToString(OrderStatus.received))
        .snapshots();
  }

  Stream<QuerySnapshot> get pastOrdersClient {
    return _ordersCollection
        .where('clientID', isEqualTo: AuthenticationService.uid)
        .where('status',
            isEqualTo: EnumToString.convertToString(OrderStatus.received))
        .snapshots();
  }

  Future<int?> getNextHumanNumberForOrder() async {
    int? humanNumber = 1;
    final QuerySnapshot query =
        await _ordersCollection.orderBy('humanNumber').limitToLast(1).get();

    /// After 99 order's increment's is reset

    if (query.docs.isNotEmpty && query.docs.first['humanNumber'] < 99 as bool) {
      humanNumber = query.docs.first['humanNumber'] + 1 as int;
    }
    return humanNumber;
  }
}
