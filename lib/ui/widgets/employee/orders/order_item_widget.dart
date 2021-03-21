import 'package:flutter/material.dart';
import 'package:sopi/models/orders/order_item_model.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/ui/shared/shared_styles.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderItemModel order;

  OrderItemWidget(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '#${order.humanNumber}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                        '${formatDateToString(order.createDate, format: 'HH:mm')}',
                        style: _mainTimeStyle),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children:
                        _buildAssignedPersonToOrderWidget(order.products),
                  ),
                ),
                Expanded(child: Text('${order.prepareTime}')),
              ],
            ),

          ],
        ),
      ),
    );
  }

  List<Widget> _buildAssignedPersonToOrderWidget(List<ProductItemModel> products) {
    return products
            .map(
              (product) => Row(
                children: [
                  Text('${product.count}x',style: TextStyle(fontWeight: FontWeight.bold),),
                  formSizedBoxWidth,
                  Text(
                    product.name,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
            .toList();
  }
}

TextStyle _mainTimeStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
