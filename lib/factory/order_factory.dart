import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sopi/models/orders/order_item_model.dart';

class OrderFactory {
  static final OrderFactory _singleton = OrderFactory._internal();
  final _ordersCollection = FirebaseFirestore.instance.collection('orders');

  factory OrderFactory() {
    return _singleton;
  }

  OrderFactory._internal();

  static OrderFactory get singleton => _singleton;

  List<OrderItemModel> actualProcessing;

//VARIABLES
  List<OrderItemModel> processOrders;

//  ///Trzeba ustawić jakiś priorytet bo dłuższe zamówienia mogą czekać dłużej
//  np. wchodzą zamówienia w kolejności 10min 50min 10min 10min 10min ..
  void sortQueueByDurationTimesAndPriority() {
/* processOrders.sort((a, b) =>
a.time.waiting > b.time.waiting);

processOrders.forEach((order) {
  if (order.currentPositionInQueue == null) {
    order.currentPositionInQueue = processOrders.indexOf(order);
  } else {

  }
});
*/
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

  ///Dodanie zamówienia
  Future<void> addOrder(OrderItemModel order) async {
    order.humanNumber = await this.getHumanNumberForOrder();

    final document = _ordersCollection.doc();

    final data = order.toJson();
    document.set(data);

    // processOrders.add(order);
    // calculateProcess();
  }

  Future<int> getHumanNumberForOrder() async {
    int humanNumber = 1;
    QuerySnapshot query =
        await _ordersCollection.orderBy('humanNumber').limitToLast(1).get();

    /// After 99 order's increment's is reset
    if (query.docs.isNotEmpty && query.docs.first['humanNumber'] < 99) {
      humanNumber = query.docs.first['humanNumber'];
    }
    return humanNumber;
  }

  Stream<List<OrderItemModel>> getOrders() {
    return _ordersCollection.snapshots().map((snapShot) => snapShot.docs
        .map((document) => OrderItemModel.fromJson(document.data()))
        .toList());
  }

  void calculateProcess() {
/*
      processOrders.sortQueueByDurationTimesAndPriority();
if (actualProccessing == null) {
  actualProccessing = processOrders.first;
}

*/
  }
}
