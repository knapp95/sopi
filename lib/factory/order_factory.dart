import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/assets/assets_model.dart';
import 'package:sopi/models/orders/order_item_model.dart';
import 'package:sopi/models/orders/products/order_product_model.dart';
import 'package:sopi/services/assets/asset_service.dart';
import 'package:sopi/services/orders/order_service.dart';

class OrderFactory {
  final _assetService = AssetService.singleton;
  final _orderService = OrderService.singleton;
  static final OrderFactory _singleton = OrderFactory._internal();
  AssetsModel _assets = Provider.of<AssetsModel>(Get.context, listen: false);

  factory OrderFactory() {
    return _singleton;
  }

  OrderFactory._internal();

  static OrderFactory get singleton => _singleton;

  Future<int> createOrder(
      List<OrderProductModel> products, double summaryPrice) async {
    final humanNumber = await _orderService.getNextHumanNumberForOrder();
    OrderItemModel newOrder = OrderItemModel.fromBasket(
      products: products,
      createDate: DateTime.now(),
      humanNumber: humanNumber,
      totalPrice: summaryPrice,
    );
    final document = _orderService.getDoc();
    final data = newOrder.toJson();
    document.set(data);
    await this.addNewOrderToProcess(document.id, newOrder);
    return humanNumber;
  }

  Future<Null> addNewOrderToProcess(String oid, OrderItemModel newOrder) async {
    await _assets.fetchAssets();
    for (OrderProductModel product in newOrder.products) {
      AssetItemModel assignedAsset =
          _assets.findAssetByProductType(product.type);
      await assignedAsset.addProduct(
          product.name, product.pid, oid, product.totalPrepareTime);
      if (assignedAsset.processingProduct.oid == oid) {
        await _orderService.updateOrderStatusToProcessing(oid);
      }
    }
  }

  Future<Null> completeOrderProduct(
      String oid, OrderProductModel orderProductModel) async {
    await _assets.fetchAssets();
    AssetItemModel assignedAsset =
        _assets.findAssetByProductType(orderProductModel.type);
    assignedAsset.completeProcessingProduct();
  }

  /// Clear assigned orders in assets, and all orders collection
  Future<Null> clearDataFactory() async {
    await _assets.fetchAssets();
    for (AssetItemModel asset in _assets.assets) {
      final data = {
        'waitingProducts': [],
        'processingProduct': FieldValue.delete(),
      };
      await _assetService.updateDoc(asset.aid, data);
    }
    await _orderService.removeAllOrders();
  }
}
