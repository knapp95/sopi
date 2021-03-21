import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/factory/order_factory.dart';
import 'package:sopi/models/orders/order_item_model.dart';
import 'dart:async';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/shared_styles.dart';
import 'package:sopi/ui/shared/systems_parameters.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sopi/models/orders/enums.dart';
import 'package:sopi/ui/widgets/employee/orders/order_item_widget.dart';

class OrderWidget extends StatefulWidget {
  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
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

  Query getSource(Status status) {
    return status == Status.PROCESSING
        ? _orderFactory.processingOrders
        : _orderFactory.waitingOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          children: [
            Expanded(flex: 3, child: _buildOrdersListWidget(Status.PROCESSING)),
            _buildDateTimeNowWidget(),
            Expanded(flex: 3, child: _buildOrdersListWidget(Status.WAITING)),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeNowWidget() {
    return Expanded(
      child: Container(
        decoration: getBoxDecoration(primaryColor, all: false),
        child: Center(
          child: Text(
            _timeNow,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersListWidget(Status status) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            status == Status.PROCESSING ? 'Actual prepare' : 'In queque',
            style: TextStyle(color: Colors.grey),
          ),
          Expanded(
            child: FutureBuilder(
              future: getSource(status).get(),
              builder: (ctx, snapshot) {
                return !snapshot.hasData
                    ? LoadingDataInProgressWidget()
                    : ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (_, int index) {
                          QueryDocumentSnapshot queryDoc =
                              snapshot.data.docs[index];
                          OrderItemModel order =
                              OrderItemModel.fromJson(queryDoc.data());

                          return Dismissible(
                              key: UniqueKey(),
                              child: OrderItemWidget(order),
                              background: _buildDismissibleBackground(),
                              resizeDuration: Duration(seconds: 1),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (_) async {
                                snapshot.data.removeAt(index);
                                await _orderFactory.completedOrder(queryDoc.id);
                              });
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissibleBackground() {
    return Container(
      color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          formSizedBoxWidth,
          FaIcon(
            FontAwesomeIcons.check,
            color: Colors.white,
          ),
          formSizedBoxWidth,
          Text(
            'Order is completed',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
