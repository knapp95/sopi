import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/products_model.dart';
import 'package:sopi/models/product_item_model.dart';
import 'package:sopi/ui/shared/shared_styles.dart';
import 'package:sopi/ui/widgets/products/dialogs/product_item_dialog_client.dart';
import 'package:sopi/ui/widgets/products/dialogs/product_item_dialog_manager.dart';
import 'products_list_empty.dart';
import 'package:get/get.dart';

class ProductsList extends StatelessWidget {
  final List<ProductItemModel> displayProductsList;
  final bool isManager;

  ProductsList(this.displayProductsList, {this.isManager = false});

  void _editProduct(String pid) {
    Get.dialog(ProductItemDialogManager(pid: pid));
  }

  void _removeProduct(String pid) {
    displayProductsList
        .firstWhere((element) => element.pid == pid)
        .removeProduct();
    Provider.of<ProductsModel>(Get.context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return displayProductsList.length == 0
        ? ProductListEmpty()
        : ListView.builder(
            itemCount: displayProductsList.length,
            itemBuilder: (_, int index) {
              ProductItemModel product = displayProductsList[index];
              return InkWell(
                onTap: () => !isManager
                    ? Get.dialog(ProductItemDialogClient(product))
                    : null,
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
                        trailing: product.imageUrl != null
                            ? Image.network(product.imageUrl, fit: BoxFit.cover)
                            : Image.asset(
                              'assets/images/no_photo.png',
                            ),
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
                                  '${product.rate} / ${ProductsModel.maxAvailableRate.toStringAsFixed(2)}',
                                  Colors.yellow,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      if (this.isManager)
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  _buildButtonWithLabel(
                                    product.pid,
                                    _editProduct,
                                    FontAwesomeIcons.pencilAlt,
                                    'Edit',
                                    Colors.blue,
                                  ),
                                  _buildButtonWithLabel(
                                    product.pid,
                                    _removeProduct,
                                    FontAwesomeIcons.times,
                                    'Remove',
                                    Colors.red,
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

  Widget _buildButtonWithLabel(
      String pid, Function onPressed, IconData icon, String label,
      [Color color]) {
    return FlatButton(
      onPressed: () => onPressed(pid),
      child: Row(
        children: [
          FaIcon(
            icon,
            color: color,
          ),
          formSizedBoxWidth,
          Text(
            label,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
