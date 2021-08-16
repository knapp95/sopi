import 'dart:math';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/assets/asset_model.dart';
import 'package:sopi/models/orders/order_model.dart';
import 'package:sopi/models/orders/products/order_product_model.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/models/products/products_model.dart';
import 'package:sopi/services/assets/asset_service.dart';
import 'package:sopi/services/orders/order_service.dart';

class OrderFactory {
  final _assetService = AssetService.singleton;
  final _orderService = OrderService.singleton;
  static final OrderFactory _singleton = OrderFactory._internal();
  final AssetModel _assets = Provider.of<AssetModel>(Get.context!);

  factory OrderFactory() {
    return _singleton;
  }

  OrderFactory._internal();

  static OrderFactory get singleton => _singleton;

  Future<void> generateOrders(int ordersCount) async {
    List<ProductItemModel> products = [];
    for (int i = 0; i < ordersCount; i++) {
      final int productsCount = Random().nextInt(8) + 1;

      if (products.isEmpty) {
        final ProductsModel _productsModel =
            Provider.of<ProductsModel>(Get.context!, listen: false);
        await _productsModel.fetchProducts();
        products = _productsModel.products;
      }
      products.shuffle();

      final List<ProductItemModel> randomProducts =
          products.length > productsCount
              ? products.sublist(0, productsCount)
              : products;
      double summaryPrice = 0.0;
      final List<OrderProductModel> randomProductsOrder = [];
      for (final ProductItemModel product in randomProducts) {
        if (product.type == ProductType.burger ||
            product.type == ProductType.pasta) {
          randomProductsOrder.add(OrderProductModel.fromProduct(product));
          summaryPrice += product.count! * product.price!;
        }
      }
      await createOrder(randomProductsOrder, summaryPrice);
    }
  }

  Future<int?> createOrder(
      List<OrderProductModel> products, double summaryPrice) async {
    final humanNumber = await _orderService.getNextHumanNumberForOrder();
    final OrderModel newOrder = OrderModel.fromBasket(
      products: products,
      createDate: DateTime.now(),
      humanNumber: humanNumber,
      totalPrice: summaryPrice,
    );

    final document = _orderService.getDoc();
    newOrder.oid = document.id;
    final data = newOrder.toJson();

    document.set(data);
    await addNewOrderToProcess(newOrder);
    return humanNumber;
  }


  Future<void> addNewOrderToProcess(OrderModel newOrder) async {
    final RequiredOrderInformation requiredOrderInformation =
        await _assets.findTheLastAssetEndIncludeOrder(newOrder);
    await _assets.addNewOrderToProcess(newOrder, requiredOrderInformation);
  }

  Future<void> completeOrderProduct(
      String? oid, OrderProductModel orderProductModel) async {
    final AssetItemModel assignedAsset =
        await _assets.findAssetByProductType(orderProductModel.type);
    assignedAsset.completeProcessingProduct();
  }

  /// Clear assigned orders in assets, and all orders collection
  Future<void> clearDataFactory() async {
    for (final AssetItemModel asset in await _assets.assets()) {
      final data = {
        'queueProducts': [],
      };
      await _assetService.updateDoc(asset.aid, data);
    }
    await _orderService.removeAllOrders();
  }
}
