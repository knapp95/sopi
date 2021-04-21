import 'package:flutter/material.dart';
import 'package:sopi/models/orders/order_item_model.dart';
import 'package:sopi/services/orders/order_service.dart';
import 'package:sopi/ui/shared/systems_parameters.dart';
import 'package:sopi/ui/widgets/client/orders/past/client_order_past_empty_widget.dart';
import 'package:sopi/ui/widgets/client/orders/past/client_order_past_item_widget.dart';
import 'package:sopi/ui/widgets/client/orders/processing/client_order_processing_empty_widget.dart';
import 'package:sopi/ui/widgets/client/orders/processing/client_order_processing_item_widget.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/loadingDataInProgress/loading_data_in_progress_widget.dart';

class ClientOrderWidget extends StatefulWidget {
  @override
  _ClientOrderWidgetState createState() => _ClientOrderWidgetState();
}

class _ClientOrderWidgetState extends State<ClientOrderWidget> {
  OrderService _orderService = OrderService.singleton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSection(
                title: 'Actual order',
                child: _buildProcessingOrderWidget(),
              ),
              _buildSection(
                title: 'Past orders',
                child: _buildPastOrdersWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({String title, Widget child}) {
    return Padding(
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
    );
  }

  Widget _buildProcessingOrderWidget() {
    return StreamBuilder(
      stream: _orderService.processingOrderClient,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) return LoadingDataInProgressWidget();
        if (snapshot.data.docs.isEmpty)
          return ClientOrderProcessingEmptyWidget();
        final QueryDocumentSnapshot doc = snapshot.data.docs[0];
        OrderItemModel orderProcessing = OrderItemModel.fromJson(doc.data());
        return ClientOrderProcessingItemWidget(orderProcessing);
      },
    );
  }

  Widget _buildPastOrdersWidget() {
    return StreamBuilder(
      stream: _orderService.pastOrdersClient,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) return LoadingDataInProgressWidget();
        if (snapshot.data.docs.isEmpty) return ClientOrderPastEmptyWidget();

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (_, int index) {
            QueryDocumentSnapshot orderDoc = snapshot.data.docs[index];
            OrderItemModel pastOrder = OrderItemModel.fromJson(orderDoc.data());
            return ClientOrderPastItemWidget(pastOrder);
          },
        );
      },
    );
  }
}