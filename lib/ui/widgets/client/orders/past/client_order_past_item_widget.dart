import 'package:flutter/material.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/orders/order_model.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';

class ClientOrderPastItemWidget extends StatelessWidget {
  final OrderModel orderPast;

  ClientOrderPastItemWidget(this.orderPast);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    );
    return Card(
      shape: shapeCard,
      elevation: defaultElevation,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('#${orderPast.humanNumber}', style: textStyle),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: orderPast.products
                  .map((product) => Row(
                        children: [
                          Text('${product.count}x ', style: textStyle),
                          Text(product.name!, style: textStyle),
                        ],
                      ))
                  .toList(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.attach_money),
                    Text('${fixedDouble(orderPast.totalPrice)}',
                        style: textStyle),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.date_range),
                    Text('${formatDateToString(orderPast.createDate)}',
                        style: textStyle),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
