import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/services/assets/asset_service.dart';
import 'package:sopi/ui/shared/systems_parameters.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sopi/ui/widgets/employee/orders/processing/employee_order_processing_empty_widget.dart';
import 'package:sopi/ui/widgets/employee/orders/processing/employee_order_processing_item_widget.dart';
import 'package:sopi/ui/widgets/employee/orders/waiting/employee_order_waiting_item_widget.dart';
import '../../common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'waiting/employee_order_waiting_empty_widget.dart';

class EmployeeOrderWidget extends StatefulWidget {
  @override
  _EmployeeOrderWidgetState createState() => _EmployeeOrderWidgetState();
}

class _EmployeeOrderWidgetState extends State<EmployeeOrderWidget> {
  final _assetService = AssetService.singleton;

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
    return StreamBuilder(
      stream: _assetService.processingOrderEmployee,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) return LoadingDataInProgressWidget();
        if (snapshot.data.docs.isEmpty) return EmployeeOrderProcessingEmptyWidget();

        final Map<String, dynamic> data =
            snapshot.data.docs[0].get('processingProduct');
        AssetProductModel assetProduct = AssetProductModel.fromJson(data);
        return Expanded(
            child:
                EmployeeOrderProcessingItemWidget(assetProduct, ObjectKey(assetProduct)));
      },
    );
  }

  Widget _buildWaitingOrders() {
    return StreamBuilder(
      stream: _assetService.waitingOrdersEmployee,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) return LoadingDataInProgressWidget();
        List<AssetProductModel> assetProducts = [];
        if (snapshot.data.docs.isEmpty) return EmployeeOrderWaitingEmptyWidget();

        for (QueryDocumentSnapshot assetDocSnapshot
            in snapshot.data.docs.toList()) {
          List<dynamic> waitingProducts =
              assetDocSnapshot.get('waitingProducts');
          waitingProducts.forEach((waitingProduct) {
            AssetProductModel assetProduct =
                AssetProductModel.fromJson(waitingProduct);
            assetProducts.add(assetProduct);
          });
        }
        return Expanded(
          child: assetProducts.isEmpty
              ? EmployeeOrderWaitingEmptyWidget()
              : ListView.builder(
                  itemCount: assetProducts.length,
                  itemBuilder: (_, int index) {
                    AssetProductModel assetProduct = assetProducts[index];
                    return EmployeeOrderWaitingItemWidget(
                      assetProduct,
                      ObjectKey(assetProduct),
                    );
                  },
                ),
        );
      },
    );
  }
}
