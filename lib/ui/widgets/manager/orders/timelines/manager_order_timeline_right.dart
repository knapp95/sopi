import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/assets/asset_type_mocked.dart';
import 'package:sopi/models/orders/order_item_model.dart';
import 'package:sopi/services/orders/order_service.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/manager/orders/timelines/manager_order_timeline_footer.dart';

class ManagerOrderTimelineRight extends StatefulWidget {
  final AssetItemModel asset;

  ManagerOrderTimelineRight(this.asset);

  @override
  _ManagerOrderTimelineRightState createState() =>
      _ManagerOrderTimelineRightState(asset);
}

class _ManagerOrderTimelineRightState extends State<ManagerOrderTimelineRight> {
  final AssetItemModel _asset;
  final _orderService = OrderService.singleton;

  _ManagerOrderTimelineRightState(this._asset);

  AssetTypeMocked get assetTypeMocked =>
      assetsTypeMocked[_asset.assignedProductType];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          _buildWaitingBlocks(),
          Positioned(
            top: 600,

            ///TODO
            child: ManagerOrderTimelineFooter(
                _asset.name, assetTypeMocked.iconPath),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingBlocks() {
    return Padding(
      padding: EdgeInsets.only(top: 224),
      child: Container(
          width: 75,
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _asset.waitingProducts.length,
              itemBuilder: (_, int index) {
                AssetProductModel waitingProduct =
                    _asset.waitingProducts[index];
                double heightBlock =
                    32 * (waitingProduct.totalPrepareTime / 15);
                return Container(
                  child: Column(
                    children: [
                      FutureBuilder(
                        builder: (context, orderSnap) {
                          if (orderSnap.connectionState ==
                                      ConnectionState.none &&
                                  orderSnap.hasData == null ||
                              orderSnap.data == null) {
                            return Container();
                          }
                          OrderItemModel order = orderSnap.data;
                          return Container(
                            decoration:
                                getBoxDecoration(order.color, withOpacity: 0.9),
                            height: heightBlock,
                            child: Center(
                                child: Text(
                              '#${order.humanNumber} ',
                              style: TextStyle(color: Colors.white),
                            )),
                          );
                        },
                        future: _orderService.getOrderById(waitingProduct.oid),
                      ),
                      SizedBox(height: 30)
                    ],
                  ),
                );
              })),
    );
  }
}
