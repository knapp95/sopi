import 'package:sopi/models/orders/order_item_model.dart';

class OrderFactory {
  static final OrderFactory _singleton = OrderFactory._internal();

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
  void addOrderToQueue(OrderItemModel order) {
/*

processOrders.add(order);
calculateProcess();
 */
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
