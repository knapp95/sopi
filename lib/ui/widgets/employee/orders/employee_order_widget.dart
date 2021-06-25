import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/assets/assets_model.dart';
import 'package:sopi/models/assets/enums/asset_enum_status.dart';
import 'package:sopi/services/assets/asset_service.dart';
import 'package:sopi/ui/shared/systems_parameters.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
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
        child: StreamBuilder(
            stream: _assetService.queueProductsInAssetsForEmployee,
            builder: (ctx, snapshot) {
              if (!snapshot.hasData) return LoadingDataInProgressWidget();
              if ((snapshot.data! as QuerySnapshot).docs.isEmpty)
                return EmployeeOrderWaitingEmptyWidget();
              List<AssetProductModel> allQueueProductsInAssetsForEmployee =
                  AssetsModel.getAllQueueProductsInAssetsForEmployee(
                      (snapshot.data! as QuerySnapshot).docs);

              AssetProductModel? processingProduct =
                  allQueueProductsInAssetsForEmployee.firstWhereOrNull(
                      (element) =>
                          element.status == AssetEnumStatus.PROCESSING);
              List<AssetProductModel> waitingProducts =
                  allQueueProductsInAssetsForEmployee
                      .where((element) =>
                          element.status == AssetEnumStatus.WAITING)
                      .toList();
              return Column(
                children: [
                  _buildSection(
                    title: 'Actual prepare',
                    child: _buildProcessingOrder(processingProduct),
                  ),
                  _buildSection(
                    title: 'Waiting',
                    child: _buildWaitingOrders(waitingProducts),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget _buildSection({required String title, Widget? child}) {
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
            child!,
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingOrder(AssetProductModel? processingProduct) {
    return processingProduct != null
        ? Expanded(
            child: EmployeeOrderProcessingItemWidget(
                processingProduct, ObjectKey(processingProduct)))
        : EmployeeOrderProcessingEmptyWidget();
  }

  Widget _buildWaitingOrders(List<AssetProductModel> waitingProducts) {
    return Expanded(
      child: waitingProducts.isEmpty
          ? EmployeeOrderWaitingEmptyWidget()
          : ListView.builder(
              itemCount: waitingProducts.length,
              itemBuilder: (_, int index) {
                AssetProductModel assetProduct = waitingProducts[index];
                return EmployeeOrderWaitingItemWidget(
                  assetProduct,
                  ObjectKey(assetProduct),
                );
              },
            ),
    );
  }
}
