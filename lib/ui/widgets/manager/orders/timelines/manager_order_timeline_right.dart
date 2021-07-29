import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/assets/asset_model.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/assets/timeline/asset_timeline_settings_model.dart';
import 'package:sopi/models/orders/order_model.dart';
import 'package:sopi/services/orders/order_service.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/manager/common/asset_show_image.dart';

class ManagerOrderTimelineRight extends StatelessWidget {
  final AssetItemModel _assetItem;
  final AssetTimelineSettingsModel _assetTimelineSettingsModel =
      Provider.of<AssetModel>(Get.context!).assetTimelineSettings!;

  final _orderService = OrderService.singleton;

  ManagerOrderTimelineRight(this._assetItem, {Key? key}) : super(key: key);

  List<AssetProductModel> get availableQueueProductsTimeline =>
      _assetItem.getQueueProductsTimeline(
        _assetTimelineSettingsModel.availableStartTimeline,
        _assetTimelineSettingsModel.availableEndTimeline,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          AssetShowImage(_assetItem.imagePath),
          Expanded(child: _buildWaitingBlocks()),
        ],
      ),
    );
  }

  double _getEmptySpaceBetweenBlocks(int index) {
    final AssetProductModel waitingProduct =
        availableQueueProductsTimeline[index];
    late int differenceInMinutes;
    if (index == 0) {
      differenceInMinutes = waitingProduct.plannedStartProcessingDate
          .difference(_assetTimelineSettingsModel.availableStartTimeline)
          .inMinutes;
    } else {
      final AssetProductModel earlierProduct =
          availableQueueProductsTimeline[index - 1];
      differenceInMinutes = waitingProduct.plannedStartProcessingDate
          .difference(earlierProduct.plannedEndProcessingDate)
          .inMinutes;
    }
    return _getHeightForMinutes(differenceInMinutes);
  }

  double _getHeightForMinutes(int minutes) {
    return minutes < 0
        ? 0
        : 33 * (minutes / _assetTimelineSettingsModel.differenceInMinutes);
  }

  Widget _buildWaitingBlocks() {
    return Container(
      color: _assetItem.color.withOpacity(0.05),
      width: 80,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: availableQueueProductsTimeline.length,
        itemBuilder: (_, int index) {
          final AssetProductModel waitingProduct =
              availableQueueProductsTimeline[index];
          double heightBlock =
              _getHeightForMinutes(waitingProduct.totalPrepareTime);
          if (index == 0) {
            final int startBeforeTimeline = _assetTimelineSettingsModel
                .availableStartTimeline
                .difference(waitingProduct.plannedStartProcessingDate)
                .inMinutes;
            if (startBeforeTimeline > 0) {
              heightBlock = _getHeightForMinutes(
                  waitingProduct.totalPrepareTime - startBeforeTimeline);
            }
          }
          return Column(
            children: [
              FutureBuilder(
                builder: (context, orderSnap) {
                  final OrderModel? order = orderSnap.data as OrderModel?;
                  if (orderSnap.connectionState == ConnectionState.none ||
                      order == null) {
                    return Container();
                  }

                  return Padding(
                    padding: EdgeInsets.only(
                        top: _getEmptySpaceBetweenBlocks(index)),
                    child: Container(
                      decoration:
                          getBoxDecoration(order.color, withOpacity: 0.9),
                      height: heightBlock,
                      child: Center(
                          child: Text(
                        '#${order.humanNumber}',
                        style: const TextStyle(color: Colors.white),
                      )),
                    ),
                  );
                },
                future: _orderService.getOrderById(waitingProduct.oid),
              ),
            ],
          );
        },
      ),
    );
  }
}
