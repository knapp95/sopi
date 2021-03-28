import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sopi/common/collections.dart';
import 'package:sopi/models/orders/enums/order_enum_status.dart';
import 'package:sopi/models/orders/order_item_model.dart';
import 'package:sopi/services/authentication_service.dart';

class OrderFactory {
  static final OrderFactory _singleton = OrderFactory._internal();

  factory OrderFactory() {
    return _singleton;
  }

  OrderFactory._internal();

  static OrderFactory get singleton => _singleton;

//  ///Trzeba ustawić jakiś priorytet bo dłuższe zamówienia mogą czekać dłużej
//  np. wchodzą zamówienia w kolejności 10min 50min 10min 10min 10min ..

  /// If processing order's is empty, set first waiting as process.
  Future<Null> trySetFirstUnProcessingOrder() async {
    QuerySnapshot processingOrders = await this.processingOrders.get();
    if (processingOrders.docs.isEmpty) {
      QuerySnapshot waitingOrders = await this.waitingOrders.get();
      ordersCollection
          .doc(waitingOrders.docs.first.id)
          .update({'status': OrderStatus.PROCESSING.toString()});
    } else {}
  }

  Future<int> getHumanNumberForOrder() async {
    int humanNumber = 1;
    QuerySnapshot query =
        await ordersCollection.orderBy('humanNumber').limitToLast(1).get();

    /// After 99 order's increment's is reset
    if (query.docs.isNotEmpty && query.docs.first['humanNumber'] < 99) {
      humanNumber = query.docs.first['humanNumber'] + 1;
    }
    return humanNumber;
  }

  Query get waitingOrders {
    return ordersCollection
        .where('status', isEqualTo: OrderStatus.WAITING.toString())
        .orderBy('prepareTime');
  }

  Query get processingOrders {
    return ordersCollection.where('status',
        isEqualTo: OrderStatus.PROCESSING.toString());
  }

  Query get completedOrders {
    return ordersCollection.where('status',
        isEqualTo: OrderStatus.COMPLETED.toString());
  }

  Future<List<OrderItemModel>> get completedOrdersForUser async {
    List<OrderItemModel> completedOrdersForUser = [];
    final uid = AuthenticationService.uid;
    QuerySnapshot query =
        await completedOrders.where('clientID', isEqualTo: uid).get();
    query.docs.forEach((queryDoc) {
      completedOrdersForUser.add(OrderItemModel.fromJson(queryDoc.data()));
    });
    return completedOrdersForUser;
  }

  Future<OrderItemModel> get prepareOrderForUser async {
    OrderItemModel prepareOrderForUser;
    final uid = AuthenticationService.uid;
    Query queryPrepareOrders = ordersCollection.where('status',
        whereIn: [OrderStatus.WAITING.toString(), OrderStatus.PROCESSING.toString()]);
    QuerySnapshot query =
        await queryPrepareOrders.where('clientID', isEqualTo: uid).get();
    if (query.docs.isNotEmpty) {
      DocumentSnapshot doc = query.docs.first;
      prepareOrderForUser = OrderItemModel.fromJson(doc.data());
    }
    return prepareOrderForUser;
  }

  void calculateProcess() {
/*
      processOrders.sortQueueByDurationTimesAndPriority();
if (actualProccessing == null) {
  actualProccessing = processOrders.first;
}

*/
  }

  Future<Null> addOrder(OrderItemModel order) async {
    order.humanNumber = await this.getHumanNumberForOrder();
    final document = ordersCollection.doc();
    final data = order.toJson();
    document.set(data);
    this.trySetFirstUnProcessingOrder();
  }

  Future<Null> completedOrder(String id) async {
    await ordersCollection.doc(id).update({'status': OrderStatus.COMPLETED.toString()});
    await this.trySetFirstUnProcessingOrder();
  }

  ///Klient anulował aktualnie przygotowywane zamówienie
  void cancelOrder(OrderItemModel order) {
/*
  if (actualProccessing?.pid == order.pid) {
  remove actualProccessing;
  calculateProcess();
} else {
  processOrders.removeFirstWhere(el) => el.pid == pid;
}
*/
  }
}
