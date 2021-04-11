import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/orders/order_item_model.dart';
import 'package:sopi/models/orders/order_product_model.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/services/orders/order_service.dart';
import 'package:sopi/services/products/product_service.dart';
import 'package:sopi/ui/shared/animations.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/shared_styles.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:sopi/ui/widgets/employee/orders/dialogs/order_dialog_addExtraTime_widget.dart';

class OrderProcessingWidget extends StatefulWidget {
  final AssetProductModel assetProductModel;

  const OrderProcessingWidget(this.assetProductModel);

  @override
  _OrderProcessingWidgetState createState() => _OrderProcessingWidgetState(
      this.assetProductModel.oid, this.assetProductModel.pid);
}

class _OrderProcessingWidgetState extends State<OrderProcessingWidget> {
  final _orderService = OrderService.singleton;
  final String oid;
  final String pid;
  Duration _timePrepare;
  Timer _timer;

  _OrderProcessingWidgetState(this.oid, this.pid);

  OrderItemModel _orderItemModel;
  OrderProductModel _orderProductModel;
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
      _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    }

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get startOrderTimeDisplay {
    return  durationInMinutes(_timePrepare);
  }

  Future<Null> _loadData() async {
    final productService = ProductService.singleton;
    _orderItemModel = await _orderService.getOrderById(this.oid);
    _orderProductModel = _orderItemModel.getProductByPid(pid);
    _productItemModel = await productService.getProductById(this.pid);
    setState(() {
      _isLoading = false;
    });
  }

  void _getTime() {
    if (_isLoading) return;
    setState(() {
      final now = DateTime.now();
      _timePrepare = now.difference(_orderItemModel.createDate);
    });
  }

  ///TODO
  void _completeOrderDialog() {}

  void _addTimeToOrder() async {
    final result = await showScaleDialog(
      OrderDialogAddExtraTimeWidget(_orderProductModel.prepareTime,
          _orderProductModel.extraPrepareTime, _orderItemModel.createDate),
    );
    if (result != null) {
      _orderProductModel.extraPrepareTime = result;
      _orderService.updateOrder(oid, _orderItemModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingDataInProgressWidget()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: shapeCard,
              elevation: defaultElevation,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: 0.5,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(_productItemModel.imageUrl),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                        _buildPositionedInfo(
                          label1: 'Order #${_orderItemModel.humanNumber}',
                          label2: '${_productItemModel.name}',
                          left: 15.0,
                        ),
                        _buildPositionedInfo(
                          child1: _buildTimeOrder(),
                          child2: _buildPrepareTimeWidget(),
                          right: 15.0,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                          style: TextButton.styleFrom(
                            primary: primaryColor,
                          ),
                          onPressed: _addTimeToOrder,
                          icon: FaIcon(
                            FontAwesomeIcons.stopwatch,
                          ),
                          label: Text(
                            'Change order time',
                          )),
                      TextButton.icon(
                          style: TextButton.styleFrom(
                            primary: primaryColor,
                          ),
                          onPressed: _completeOrderDialog,
                          icon: FaIcon(
                            FontAwesomeIcons.checkCircle,
                          ),
                          label: Text(
                            'As completed',
                          )),
                    ],
                  )
                ],
              ),
            ),
          );
  }

  Widget _buildPositionedInfo(
      {String label1,
      String label2,
      Widget child1,
      Widget child2,
      left,
      right}) {
    return Positioned(
      left: left,
      right: right,
      bottom: 30,
      child: Column(
        crossAxisAlignment:
            left != null ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: <Widget>[
          child1 ?? _buildOrderInfoRow(label1),
          formSizedBoxHeight,
          child2 ?? _buildOrderInfoRow(label2),
        ],
      ),
    );
  }

  Widget _buildOrderInfoRow(String label) {
    return Container(
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTimeOrder() {
    int prepareTime = _orderProductModel.prepareTime;
    int extraTime = _orderProductModel.extraPrepareTime;

    return Container(
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.clock,
              size: 14,
              color: Colors.white,
            ),
            formSizedBoxWidth,
            Text(
              '$prepareTime:00',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            if (extraTime != 0)
              Text(
                extraTime > 0 ? '+$extraTime' : '-${extraTime.abs()}',
                style: TextStyle(
                    color: extraTime > 0 ? Colors.red : Colors.white,
                    fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrepareTimeWidget() {
    return Container(
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.clock,
              size: 14,
              color: Colors.white,
            ),
            formSizedBoxWidth,
            Text(
              '$startOrderTimeDisplay',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
