import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sopi/factory/order_factory.dart';
import 'package:sopi/models/orders/order_item_model.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/models/products/products_model.dart';
import 'package:sopi/ui/shared/shared_styles.dart';
import 'package:sopi/ui/widgets/common/products/dialogs/product_item_dialog_client.dart';
import 'package:sopi/ui/widgets/common/products/dialogs/product_item_dialog_manager.dart';
import 'products_list_empty.dart';
import 'package:get/get.dart';

class ProductsList extends StatefulWidget {
  final List<ProductItemModel> displayProductsList;
  final bool isManager;

  ProductsList(this.displayProductsList, {this.isManager = false});

  @override
  _ProductsListState createState() => _ProductsListState();
}

/// TODO when mocked orders done back to stateless widget
class _ProductsListState extends State<ProductsList> {
  OrderItemModel _mockedOrder = OrderItemModel(products: []);

  void _editProduct(String pid) {
    Get.dialog(ProductItemDialogManager(pid: pid));
  }

  void _addToOrderListMocked(String pid) {
    ProductItemModel product = widget.displayProductsList.firstWhere((element) => element.pid == pid);
    if (_mockedOrder.products.contains(product)) {
      product.count = product.count + 1;
    } else {
      _mockedOrder.products.add(product);
    }
  }

  void _submitOrderMocked(String pid) {
    _mockedOrder.createDate = DateTime.now();
    OrderFactory _ordersFactory = OrderFactory();

    _ordersFactory.addOrder(_mockedOrder);

  }

  void _removeProduct(String pid) {
    widget.displayProductsList
        .firstWhere((element) => element.pid == pid)
        .removeProduct();
    Provider.of<ProductsModel>(Get.context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return widget.displayProductsList.length == 0
        ? ProductListEmpty()
        : ListView.builder(
            itemCount: widget.displayProductsList.length,
            itemBuilder: (_, int index) {
              ProductItemModel product = widget.displayProductsList[index];
              return InkWell(
                onTap: () => !widget.isManager
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
                      if (this.widget.isManager)
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
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
                                  /// MOCKED TO DELETE
                                  Column(
                                    children: [
                                      Text('ORDER :'),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          _buildButtonWithLabel(
                                            product.pid,
                                            _addToOrderListMocked,
                                            FontAwesomeIcons.plus,
                                            'Add to order list',
                                            Colors.red,
                                          ),
                                          _buildButtonWithLabel(
                                            product.pid,
                                            _submitOrderMocked,
                                            FontAwesomeIcons.equals,
                                            'Submit order',
                                            Colors.red,
                                          ),
                                        ],
                                      ),
                                    ],
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
