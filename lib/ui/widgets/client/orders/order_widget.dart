import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:sopi/models/orders/order_item_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/shared_styles.dart';
import 'package:sopi/ui/shared/systems_parameters.dart';
import 'package:sopi/ui/widgets/client/orders/order_item_widget.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class OrderWidget extends StatefulWidget {
  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  OrderItemModel _prepareOrder;

  @override
  void didChangeDependencies() {


    /// TODO old
//    _orderFactory.prepareOrderForUser.then(
//      (value) => setState(
//        () {
//          _prepareOrder = value;
//        },
//      ),
//    );
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
            Expanded(
                flex: 3,
                child: _prepareOrder == null
                    ? Text('No order')
                    : _buildPrepareOrderWidget()),
            Expanded(flex: 2, child: _buildPastOrdersWidget()),
          ],
        ),
      ),
    );
  }

  Widget _buildPrepareOrderWidget() {
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
                      '#${_prepareOrder.humanNumber}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize40),
                    ),
                    StepProgressIndicator(
                      totalSteps: 4,
                      currentStep: 2,
                      size: 20,
                      unselectedColor: Colors.white,
                      selectedColor: accentColor,
                      roundedEdges: Radius.circular(10),
                    ),
                    Text(
                      'Waiting in queueue',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text('${_prepareOrder.status}',
                        style: TextStyle(
                          color: Colors.white,
                        )),
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
                          '${_prepareOrder.createDate}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize20),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {},

                          ///TODO
                          child: Text(
                            'Cancel order',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                            onPressed: () {},

                            /// TODO
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Past orders',
            style: TextStyle(color: Colors.grey),
          ),
          Expanded(
            child: FutureBuilder(
              future: null, //_orderFactory.completedOrdersForUser, ///TODO OLD
              builder: (ctx, snapshot) {
                return !snapshot.hasData
                    ? LoadingDataInProgressWidget()
                    : ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, int index) {
                          OrderItemModel order = snapshot.data[index];
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
