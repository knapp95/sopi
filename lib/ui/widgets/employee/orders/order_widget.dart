import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/factory/order_factory.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/orders/enums/order_enum_status.dart';
import 'package:sopi/services/assets/asset_service.dart';
import 'dart:async';
import 'package:sopi/ui/shared/systems_parameters.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sopi/ui/widgets/employee/orders/order_processing_widget.dart';
import 'package:sopi/ui/widgets/employee/orders/order_waiting_widget.dart';
import '../../common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'order_noAvailable_widget.dart';
import 'order_noProcessing_widget.dart';
import '../../common/products/list/productsEmpty_list.dart';

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
            _buildSection(
              title: 'Actual prepare',
              child: _buildProcessingOrder(),
            ),
            _buildSection(
              title: 'Waiting',
              child: _buildWaitingOrders(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({String title, Widget child}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Text(
                title,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingOrder() {
    return FutureBuilder(
      future: _assetService.processingOrderEmployee,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) return LoadingDataInProgressWidget();
        if (snapshot.data.docs.isEmpty) return OrderNoProcessingWidget();
        final Map<String, dynamic> data =
            snapshot.data.docs[0].get('processingProduct');
        AssetProductModel assetProduct = AssetProductModel.fromJson(data);

        return Expanded(child: OrderProcessingWidget(assetProduct));
      },
    );
  }

  Widget _buildWaitingOrders() {
    return FutureBuilder(
      future: _assetService.waitingOrdersEmployee,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) return LoadingDataInProgressWidget();

        if (snapshot.data.docs.isEmpty) return OrderNoAvailableWidget();
        return Expanded(
          child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (_, int index) {
              QueryDocumentSnapshot assetDocSnapshot =
                  snapshot.data.docs[index];
              List<dynamic> waitingProducts =
                  assetDocSnapshot.get('waitingProducts');
              return ListView.builder(
                itemCount: waitingProducts.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, int index) {
                  dynamic waitingProduct = waitingProducts[index];
                  AssetProductModel assetProduct =
                      AssetProductModel.fromJson(waitingProduct);
                  return OrderWaitingWidget(assetProduct);
                },
              );
            },
          ),
        );
      },
    );
  }
}
