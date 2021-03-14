import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:sopi/factory/order_factory.dart';
import 'package:sopi/models/orders/order_item_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/shared_styles.dart';
import 'package:sopi/ui/shared/systems_parameters.dart';

class OrderWidget extends StatefulWidget {
  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  OrderItemModel _upcomingOrder;
  List<OrderItemModel> _pastOrders;
  OrderFactory _orderFactory = OrderFactory.singleton;

  @override
  void didChangeDependencies() {
    _orderFactory.processingOrderForUser.then(
      (value) => setState(
        () {
          _upcomingOrder = value;
        },
      ),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          children: [
            _upcomingOrder != null ? Expanded(flex: 3, child: _buildUpcomingOrderWidget()) : Text('No order'),
            Expanded(flex: 2, child: _buildPastOrdersWidget()),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingOrderWidget() {
    return Column(
      children: [
        Expanded(child: Lottie.asset('assets/animations/processing.json')),
        Container(
          decoration: getBoxDecoration(primaryColor, all: false),
          child: Center(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '#${_upcomingOrder.humanNumber}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 40),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.clock,
                          color: Colors.white,
                          size: 25,
                        ),
                        formSizedBoxWidth,
                        Text(
                          '${_upcomingOrder.createDate}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                            child: Text(
                          'Cancel order',
                          style: TextStyle(color: Colors.white),
                        )),
                        FlatButton(
                            child: Text(
                          'Confirm pick',
                          style: TextStyle(color: Colors.white),
                        )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Text('Your\'s order #5'),
      ],
    );
  }

  Widget _buildPastOrdersWidget() {
    return Column(
      children: [
        Text('Past orders'),
        ListTile(
          leading: Icon(Icons.timelapse),
          title: Text('Order number #11'),
        ),
      ],
    );
  }
}
