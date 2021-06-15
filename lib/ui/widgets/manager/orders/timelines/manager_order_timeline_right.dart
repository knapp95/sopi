import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/assets/asset_timeline_settings.dart';
import 'package:sopi/models/assets/asset_type_mocked.dart';
import 'package:sopi/models/orders/order_model.dart';
import 'package:sopi/services/orders/order_service.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/manager/orders/timelines/manager_order_timeline_footer.dart';

class ManagerOrderTimelineRight extends StatelessWidget {
  final AssetItemModel assetItem;
  final _orderService = OrderService.singleton;

  // this.firstAvailableDisplayTimeline, this.lastAvailableDisplayTimeline
  ManagerOrderTimelineRight(
    this.assetItem,
  );

  AssetTypeMocked get assetTypeMocked =>
      assetsTypeMocked[assetItem.assignedProductType];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ManagerOrderTimelineFooter(assetItem.name, assetTypeMocked.iconPath),
          Expanded(child: _buildWaitingBlocks()),
        ],
      ),
    );
  }

  double _getEmptySpaceBetweenBlocks(int index) {
    AssetProductModel waitingProduct = assetItem.queueProductsTimeline[index];
    if (index == 0) {
      int differenceInMinutes = AssetTimelineSettings.availableStartTimeline
          .difference(waitingProduct.createDate)
          .inMinutes;
      return _getHeightForMinutes(differenceInMinutes);
    } else {
      AssetProductModel earlierProduct =
          assetItem.queueProductsTimeline[index - 1];
      int differenceMinutes = waitingProduct.createDate
              .difference(earlierProduct.createDate)
              .inMinutes -
          earlierProduct.totalPrepareTime;
      return _getHeightForMinutes(differenceMinutes);
    }
  }

  double _getHeightForMinutes(int minutes) {
    return minutes < 0
        ? 0
        : 32 * (minutes / AssetTimelineSettings.differenceInMinutes);
  }

  Widget _buildWaitingBlocks() {
    return Container(
      width: 75,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: assetItem.queueProductsTimeline.length,
        itemBuilder: (_, int index) {
          AssetProductModel waitingProduct =
              assetItem.queueProductsTimeline[index];
          double heightBlock =
              _getHeightForMinutes(waitingProduct.totalPrepareTime);
          if (index == 0) {
            int startBeforeTimeline = AssetTimelineSettings
                .availableStartTimeline
                .difference(waitingProduct.createDate)
                .inMinutes;
            if (startBeforeTimeline > 0) {
              heightBlock = _getHeightForMinutes(
                  waitingProduct.totalPrepareTime - startBeforeTimeline);
            }
          }
          return Container(
            child: Column(
              children: [
                FutureBuilder(
                  builder: (context, orderSnap) {
                    if (orderSnap.connectionState == ConnectionState.none &&
                            orderSnap.hasData == null ||
                        orderSnap.data == null) {
                      return Container();
                    }
                    OrderModel order = orderSnap.data;
                    return Padding(
                      padding: EdgeInsets.only(
                          top: _getEmptySpaceBetweenBlocks(index)),
                      child: Container(
                        width: 70,
                        decoration:
                            getBoxDecoration(order.color, withOpacity: 0.9),
                        height: heightBlock,
                        child: Center(
                            child: Text(
                          '#${order.humanNumber}',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    );
                  },
                  future: _orderService.getOrderById(waitingProduct.oid),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
