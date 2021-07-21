import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/assets/asset_model.dart';
import 'package:sopi/models/orders/order_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';

class ClientOrderProcessingItemWidget extends StatelessWidget {
  final OrderModel orderProcessing;
  final _assets = Provider.of<AssetModel>(Get.context!);

  ClientOrderProcessingItemWidget(this.orderProcessing);

  Future<String> get processingEndDate async {
    DateTime processingEndDateTmp =
        await _assets.findTheLatestAssetEndIncludeOrder(orderProcessing);
    String processingEndDate = formatDateToString(
      processingEndDateTmp,
      format: 'HH:mm',
    );
    return processingEndDate;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
    return Column(
      children: [
        Lottie.asset('assets/animations/processing.json'),
        Card(
          elevation: defaultElevation,
          color: primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('#${orderProcessing.humanNumber}', style: textStyle),
                Text('${orderProcessing.statusDisplay}', style: textStyle),
                Row(
                  children: [
                    Icon(
                      Icons.timer,
                      color: Colors.white,
                    ),
                    formSizedBoxWidth,
                    FutureBuilder(
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.data == null) {
                          return Container();
                        } else {
                          return Text('${snapshot.data}', style: textStyle);
                        }
                      },
                      future: processingEndDate,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
