import 'package:flutter/material.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/factory/order_factory.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/orders/enums/order_enum_status.dart';
import 'package:sopi/services/assets/asset_service.dart';
import 'dart:async';
import 'package:sopi/ui/shared/systems_parameters.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sopi/ui/widgets/employee/orders/order_processing_widget.dart';

class OrderWidget extends StatefulWidget {
  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  final _assetService = AssetService.singleton;

  OrderFactory _orderFactory = OrderFactory.singleton;
  Timer _timer;
  String _timeNow;
  String _prepareTime;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    _timeNow = formatDateToString(DateTime.now(), format: 'HH:mm:ss');
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime =
        formatDateToString(now, format: 'HH:mm:ss');

    setState(() {
      _timeNow = formattedDateTime;
      _prepareTime = formatDateToString(now, format: 'mm:ss');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          children: [
            Expanded(
                flex: 2, child: _buildOrdersListWidget(OrderStatus.PROCESSING)),
            Expanded(child: _buildOrdersListWidget(OrderStatus.WAITING)),
            //   Expanded(child: _buildOrdersListWidget(OrderStatus.WAITING)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersListWidget(OrderStatus status) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            status == OrderStatus.PROCESSING ? 'Actual prepare' : 'In queque',
            style: TextStyle(color: Colors.grey),
          ),
          Expanded(
            child: FutureBuilder(
              future: status == OrderStatus.PROCESSING  ? _assetService.processingOrderEmployee : _assetService.processingOrderEmployee,
              builder: (ctx, snapshot) {
                return !snapshot.hasData
                    ? LoadingDataInProgressWidget()
                    : status == OrderStatus.PROCESSING
                        ? _buildProcessingOrder(snapshot.data.docs[0])
                        : _buildWaitingOrders(snapshot.data.docs);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingOrder(QueryDocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.get('processingProduct');
    AssetProductModel assetProduct = AssetProductModel.fromJson(data);
    return OrderProcessingWidget(assetProduct);
  }

  Widget _buildWaitingOrders(List<QueryDocumentSnapshot> docs) {
    return Text('TODO');
  }

}
