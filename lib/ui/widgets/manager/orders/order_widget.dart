import 'package:flutter/material.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/orders/enums/order_enum_status.dart';
import 'package:sopi/models/orders/order_item_model.dart';
import 'dart:async';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/shared_styles.dart';
import 'package:sopi/ui/shared/systems_parameters.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:sopi/ui/widgets/manager/orders/order_item_widget.dart';

class OrderWidget extends StatefulWidget {
  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  Timer _timer;
  String _timeNow;
  String _prepareTime;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    _timeNow = formatDateToString(DateTime.now(), format: 'HH:mm:ss');
    _prepareTime = formatDateToString(DateTime.now(), format: 'mm:ss');
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
            Expanded(flex: 3, child: _buildOrdersListWidget(OrderStatus.PROCESSING)),
            _buildDateTimeNowWidget(),
            Expanded(flex: 3, child: _buildOrdersListWidget(OrderStatus.WAITING)),
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
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize40),
          ),
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
              future: null, ///TODO TMP
              builder: (ctx, snapshot) {
                return !snapshot.hasData
                    ? LoadingDataInProgressWidget()
                    : ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (_, int index) {
                          OrderItemModel order = OrderItemModel.fromJson(
                              snapshot.data.docs[index].data());
                          return OrderItemWidget(order);
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
