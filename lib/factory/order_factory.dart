import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/assets/assets_model.dart';
import 'package:sopi/models/orders/order_item_model.dart';
import 'package:sopi/models/orders/order_product_model.dart';
import 'package:sopi/services/orders/order_service.dart';

class OrderFactory {
  final _orderService = OrderService.singleton;
  static final OrderFactory _singleton = OrderFactory._internal();
  AssetsModel _assets = Provider.of<AssetsModel>(Get.context, listen: false);

  factory OrderFactory() {
    return _singleton;
  }

  OrderFactory._internal();

  static OrderFactory get singleton => _singleton;

  Future<int> createOrder(List<OrderProductModel> products) async {
    final humanNumber = await _orderService.getNextHumanNumberForOrder();
    OrderItemModel newOrder = OrderItemModel.fromBasket(
        products: products,
        createDate: DateTime.now(),
        humanNumber: humanNumber);
    final document = _orderService.getDoc();
    final data = newOrder.toJson();
    document.set(data);
    this.addNewOrderToProcess(document.id, newOrder);
    return humanNumber;
  }

  Future<Null> addNewOrderToProcess(String oid, OrderItemModel newOrder) async {
    await _assets.fetchAssets();
    newOrder.products.forEach((product) {
      AssetItemModel assignedAsset =
          _assets.findAssetByProductType(product.type);
      assignedAsset.addProduct(product.pid, oid, product.totalPrepareTime);
      if (assignedAsset.processingProduct.oid == oid) {
        _orderService.updateOrderStatusToProcessing(oid);
      }
    });
  }


//  Query get waitingOrders {
//    return ordersCollection
//        .where('status', isEqualTo: OrderStatus.WAITING.toString())
//        .orderBy('prepareTime');
//  }


//
//  Query get completedOrders {
//    return ordersCollection.where('status',
//        isEqualTo: OrderStatus.COMPLETED.toString());
//  }

//  Future<List<OrderItemModel>> get completedOrdersForUser async {
//    List<OrderItemModel> completedOrdersForUser = [];
//    final uid = AuthenticationService.uid;
//    QuerySnapshot query =
//        await completedOrders.where('clientID', isEqualTo: uid).get();
//    query.docs.forEach((queryDoc) {
//      completedOrdersForUser.add(OrderItemModel.fromJson(queryDoc.data()));
//    });
//    return completedOrdersForUser;
//  }

//  Future<OrderItemModel> get prepareOrderForUser async {
//    OrderItemModel prepareOrderForUser;
//    final uid = AuthenticationService.uid;
//    Query queryPrepareOrders = ordersCollection.where('status', whereIn: [
//      OrderStatus.WAITING.toString(),
//      OrderStatus.PROCESSING.toString()
//    ]);
//    QuerySnapshot query =
//        await queryPrepareOrders.where('clientID', isEqualTo: uid).get();
//    if (query.docs.isNotEmpty) {
//      DocumentSnapshot doc = query.docs.first;
//      prepareOrderForUser = OrderItemModel.fromJson(doc.data());
//    }
//    return prepareOrderForUser;
//  }

  void calculateProcess() {
/*
      processOrders.sortQueueByDurationTimesAndPriority();
if (actualProccessing == null) {
  actualProccessing = processOrders.first;
}

*/
  }

  ///TODO
  /// If processing order's is empty, set first waiting as process.
//  Future<Null> trySetFirstUnProcessingOrder() async {
//    QuerySnapshot processingOrders = await this.processingOrderEmployee;
//    if (processingOrders.docs.isEmpty) {
//      QuerySnapshot waitingOrders = await this.waitingOrders.get();
//      ordersCollection
//          .doc(waitingOrders.docs.first.id)
//          .update({'status': OrderStatus.PROCESSING.toString()});
//    } else {}
//  }

//  Future<Null> completedOrder(String id) async {
//    await ordersCollection
//        .doc(id)
//        .update({'status': OrderStatus.COMPLETED.toString()});
//    await this.trySetFirstUnProcessingOrder();
//  }

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
