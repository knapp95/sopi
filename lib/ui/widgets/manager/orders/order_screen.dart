import 'package:flutter/material.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/orders/order_item_model.dart';
import 'package:sopi/models/orders/orders_model.dart';
import 'dart:async';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/shared_styles.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<OrderItemModel> _pastOrders;
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
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          children: [
            Expanded(flex: 3, child: _buildOrdersListWidget()),
            _buildDateTimeNowWidget(),
            Expanded(flex: 3, child: _buildOrdersInQueueWidget()),
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

  Widget _buildOrdersListWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Actual prepare',
            style: TextStyle(color: Colors.grey),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: OrdersModel.mockedActualOrders.length,
              itemBuilder: (_, int index) {
                OrderItemModel order = OrdersModel.mockedActualOrders[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          '#${order.oid}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Text(
                                    _prepareTime,
                                    style: _mainTimeStyle,
                                  ),
                                  Text(
                                    '${formatDateToString(order.createDate, format: 'HH:mm')}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: _buildAssignedPersonToOrderWidget(
                                    order.assignedPerson),
                              ),
                            ),
                            Expanded(child: Icon(Icons.settings))
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAssignedPersonToOrderWidget(List<String> assignedPerson) {
    return assignedPerson
        .map(
          (person) => Row(
            children: [
              Icon(Icons.person, color: Colors.grey),
              formSizedBoxWidth,
              Text(
                person,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        )
        .toList();
  }

  Widget _buildOrdersInQueueWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'In queque',
            style: TextStyle(color: Colors.grey),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: OrdersModel.mockedQueueOrders.length,
              itemBuilder: (_, int index) {
                OrderItemModel order = OrdersModel.mockedQueueOrders[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          '#${order.oid}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                    '${formatDateToString(order.createDate, format: 'HH:mm')}',
                                    style: _mainTimeStyle),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: _buildAssignedPersonToOrderWidget(
                                    order.assignedPerson),
                              ),
                            ),
                            Expanded(child: Icon(Icons.settings))
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle _mainTimeStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
