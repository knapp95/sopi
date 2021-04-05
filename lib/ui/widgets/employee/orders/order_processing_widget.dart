import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/orders/order_item_model.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/services/orders/order_service.dart';
import 'package:sopi/services/products/product_service.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';

class OrderProcessingWidget extends StatefulWidget {
  final AssetProductModel assetProductModel;

  const OrderProcessingWidget(this.assetProductModel);

  @override
  _OrderProcessingWidgetState createState() => _OrderProcessingWidgetState();
}

class _OrderProcessingWidgetState extends State<OrderProcessingWidget> {
  OrderItemModel _orderItemModel;
  ProductItemModel _productItemModel;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _loadData();
      _isInit = false;
    }

    super.initState();
  }

  Future<Null> _loadData() async {
    final orderService = OrderService.singleton;
    final productService = ProductService.singleton;

    _orderItemModel =
        await orderService.getOrderById(widget.assetProductModel.oid);
    _productItemModel =
        await productService.getProductById(widget.assetProductModel.pid);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingDataInProgressWidget()
        : Card(
            child: Column(
              children: [
                Text(_orderItemModel.humanNumber.toString()),
                Text(_productItemModel.name.toString()),
                Text(widget.assetProductModel.oid),
              ],
            ),
          );
  }
}
