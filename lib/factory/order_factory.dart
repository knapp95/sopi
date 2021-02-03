import 'package:sopi/models/order_item_model.dart';

class OrderFactory {
  static final OrderFactory _singleton = OrderFactory._internal();

  factory OrderFactory() {
    return _singleton;
  }

  OrderFactory._internal();

  static OrderFactory get singleton => _singleton;


  OrderItemModel get upcomingOrder =>
      OrderItemModel(oid: 1243789,
          prepareTime: 25,
          waitingTimes: 10,
          currentPositionInQueue: 5);


  List<OrderItemModel> _pastOrders;


//  //Zasada działania
//
//
//
//  /// Możemy też przyjąć że mamy np. 2 piece więc musiały by się komunikować 2 "fabryki"
//
//  FactoryOrders {
//  SingleOrder actualProccessing = null;
//
//  ///VARIABLES
//  List<SingleOrder> processOrders;
//
//
//  ///Trzeba ustawić jakiś priorytet bo dłuższe zamówienia mogą czekać dłużej
//  np. wchodzą zamówienia w kolejności 10min 50min 10min 10min 10min ..
//
//  sortQueueByDurationTimesAndPriority(
//  processOrders.sort(a,b) => (a.time.waiting > b.time.waiting);
//
//  processOrders.forEach(order) {
//    if (order.currentPositionInQueue == null) {
//      order.currentPositionInQueue = processOrders.indexOf(order);
//    } else {
//
//    }
//  };
//  );
//
//  cancelOrder(SingleOrder order) {
//    ///Klient anulował aktualnie przygotowywane zamówienie
//    if (actualProccessing?.pid == order.pid) {
//      remove actualProccessing;
//      calculateProcess();
//    } else {
//      processOrders.removeFirstWhere(el) => el.pid == pid;
//    }
//  }
//
//  calculateProcess() {
//    processOrders.sortQueueByDurationTimesAndPriority();
//    if (actualProccessing == null) {
//      actualProccessing = processOrders.first;
//    }
//  }
//
//
//  addOrderToQueque(SingleOrder order) {
//    processOrders.add(order);
//    calculateProcess();
//  }
//
//}
//
//
/////Dodanie zamówienia
//_factory.addOrderToQueque(order);
//
//
//
/////Anuluwanie zamówienia
//_factory.cancelOrder(order);
}
