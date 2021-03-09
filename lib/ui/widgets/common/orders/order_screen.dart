import 'package:flutter/material.dart';
import 'package:sopi/factory/order_factory.dart';
import 'package:sopi/models/orders/order_item_model.dart';

import 'order_noAvailable.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderItemModel _upcomingOrder;
  List<OrderItemModel> _pastOrders;

  @override
  void didChangeDependencies() {
  //  _pastOrders = [OrderFactory.singleton.upcomingOrder];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _buildUpcomingOrderWidget()),
          Expanded(flex: 2, child: _buildPastOrdersWidget()),
        ],
      ),
    );
  }

  Widget _buildUpcomingOrderWidget() {
    return Column(
      children: [
        Text('Upcoming'),
        _upcomingOrder == null
            ? OrderNoAvailable()
            : ListTile(
                leading: Icon(Icons.timelapse),
                title: Text('Order number #${_upcomingOrder.oid}'),
              ),
      ],
    );
  }

  Widget _buildPastOrdersWidget() {
    return Column(
      children: [
        Text('Past orders'),
        ListTile(
          leading: Icon(Icons.timelapse),
          title: Text('Order number #${_pastOrders.first.oid}'),
        ),
      ],
    );
  }

}
