import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/factory/order_factory.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/orders/order_model.dart';
import 'package:sopi/models/orders/products/order_product_model.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/services/orders/order_service.dart';
import 'package:sopi/services/products/product_service.dart';
import 'package:sopi/ui/shared/animations.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/common/dialogs/confirm_dialog.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:sopi/ui/widgets/employee/orders/dialogs/employee_order_dialog_add_extra_time_widget.dart';

class EmployeeOrderProcessingItemWidget extends StatefulWidget {
  final AssetProductModel assetProductModel;

  const EmployeeOrderProcessingItemWidget(this.assetProductModel, Key? key)
      : super(key: key);

  @override
  _EmployeeOrderProcessingItemWidgetState createState() =>
      _EmployeeOrderProcessingItemWidgetState();
}

class _EmployeeOrderProcessingItemWidgetState
    extends State<EmployeeOrderProcessingItemWidget> {
  final OrderFactory _orderFactory = OrderFactory.singleton;
  final _orderService = OrderService.singleton;
  late String? oid;
  late String? pid;
  Duration? _timePrepare;
  late Timer _timer;

  late OrderModel _orderModel;
  OrderProductModel? _orderProductModel;
  late ProductItemModel _productItemModel;

  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    if (_isInit) {
      oid = widget.assetProductModel.oid;
      pid = widget.assetProductModel.pid;
      setState(() {
        _isLoading = true;
      });
      _loadData();
      _isInit = false;
      _timer =
          Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    }

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get startOrderTimeDisplay {
    return durationInMinutes(_timePrepare);
  }

  Future<void> _loadData() async {
    final productService = ProductService.singleton;
    _orderModel = await _orderService.getOrderById(oid);
    _orderProductModel = _orderModel.getProductByPid(pid);
    _productItemModel = await productService.getProductById(pid);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  void _getTime() {
    if (_isLoading) return;
    setState(() {
      final now = DateTime.now();
      _timePrepare = now.difference(_orderProductModel!.startProcessingDate!);
    });
  }

  Future<void> _completeOrderDialog() async {
    final bool confirm = await showScaleDialog(
      ConfirmDialog('Set ${_productItemModel.name} as done?'),
    ) as bool;
    if (confirm == true) {
      _orderProductModel!.setAsComplete();
      _orderService.updateOrder(_orderModel);
      _orderFactory.completeOrderProduct(oid, _orderProductModel!);
    }
  }

  Future<void> _addTimeToOrder() async {
    final int? result = await showScaleDialog(
      EmployeeOrderDialogAddExtraTimeWidget(_orderProductModel!.prepareTime,
          _orderProductModel!.extraPrepareTime, _orderModel.createDate),
    ) as int?;
    if (result != null) {
      _orderProductModel!.extraPrepareTime = result;
      _orderService.updateOrder(_orderModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingDataInProgressWidget()
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
                                image:
                                    NetworkImage(_productItemModel.imageUrl!),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                        _buildPositionedInfo(
                          label1: 'Order #${_orderModel.humanNumber}',
                          label2: _productItemModel.name,
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
                          icon: const FaIcon(
                            FontAwesomeIcons.stopwatch,
                          ),
                          label: const Text(
                            'Change order time',
                          )),
                      TextButton.icon(
                          style: TextButton.styleFrom(
                            primary: primaryColor,
                          ),
                          onPressed: _completeOrderDialog,
                          icon: const FaIcon(
                            FontAwesomeIcons.checkCircle,
                          ),
                          label: const Text(
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
      {String? label1,
      String? label2,
      Widget? child1,
      Widget? child2,
      double? left,
      double? right}) {
    return Positioned(
      left: left,
      right: right,
      bottom: 30,
      child: Column(
        crossAxisAlignment:
            left != null ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: <Widget>[
          child1 ?? _buildOrderInfoRow(label1!),
          formSizedBoxHeight,
          child2 ?? _buildOrderInfoRow(label2!),
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
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTimeOrder() {
    final int? prepareTime = _orderProductModel!.prepareTime;
    final int extraTime = _orderProductModel!.extraPrepareTime;

    return Container(
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.clock,
              size: 14,
              color: Colors.white,
            ),
            formSizedBoxWidth,
            Text(
              '$prepareTime:00',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
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
            const FaIcon(
              FontAwesomeIcons.clock,
              size: 14,
              color: Colors.white,
            ),
            formSizedBoxWidth,
            Text(
              startOrderTimeDisplay,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
