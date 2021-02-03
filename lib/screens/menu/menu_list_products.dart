import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sopi/models/menu_model.dart';
import 'package:sopi/models/product_item_model.dart';
import 'package:sopi/screens/product_item_screen.dart';

import 'menu_list_noAvailable.dart';

class MenuListProducts extends StatelessWidget {
  final List<ProductItemModel> displayProductsList;

  MenuListProducts(this.displayProductsList);

  void _openProductItemScreen(BuildContext ctx, ProductItemModel product) {
    showDialog(context: ctx, child: ProductItemScreen(product));
  }

  @override
  Widget build(BuildContext context) {
    return displayProductsList.length == 0
        ? MenuListNoAvailable()
        : ListView.builder(
            itemCount: displayProductsList.length,
            itemBuilder: (_, int index) {
              ProductItemModel product = displayProductsList[index];
              return InkWell(
                onTap: () => _openProductItemScreen(context, product),
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          product.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          product.description,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        trailing:
                            Image.network(product.imageUrl, fit: BoxFit.cover),
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                _buildIconWithLabel(
                                  FontAwesomeIcons.dollarSign,
                                  product.price.toStringAsFixed(2),
                                ),
                                _buildIconWithLabel(
                                  FontAwesomeIcons.clock,
                                  '${product.prepareTime} min',
                                ),
                                _buildIconWithLabel(
                                  FontAwesomeIcons.solidStar,
                                  '${product.rate} / ${MenuModel.maxAvailableRate.toStringAsFixed(2)}',
                                  Colors.yellow,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildIconWithLabel(IconData icon, String label, [Color color]) {
    return Row(
      children: <Widget>[
        FaIcon(
          icon,
          color: color,
        ),
        SizedBox(width: 5),
        Text(label),
      ],
    );
  }
}
