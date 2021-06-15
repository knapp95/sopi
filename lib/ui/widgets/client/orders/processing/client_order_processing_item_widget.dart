import 'package:flutter/material.dart';
import 'package:sopi/models/orders/order_model.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:lottie/lottie.dart';
import 'package:sopi/ui/shared/app_colors.dart';

class ClientOrderProcessingItemWidget extends StatelessWidget {
  final OrderModel orderProcessing;
  ClientOrderProcessingItemWidget(this.orderProcessing);
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
                    Text('~11:22', style: textStyle),

                    ///TODO
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
