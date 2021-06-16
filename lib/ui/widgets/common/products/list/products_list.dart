import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/models/products/products_model.dart';
import 'package:sopi/models/user/enums/user_enum_type.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/services/products/product_service.dart';
import 'package:sopi/ui/shared/animations.dart';
import 'package:sopi/ui/widgets/client/products/product_item_dialog.dart'
as productClient;
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:sopi/ui/widgets/common/products/list/productsEmpty_list.dart';
import 'package:sopi/ui/widgets/manager/company/products/product_item_dialog.dart' as productManager;

class ProductsList extends StatelessWidget {
  final _productService = ProductService.singleton;
  final List<ProductItemModel> displayProductsList;

  ProductsList(this.displayProductsList);

  void _editProduct(String? pid) {
    showScaleDialog(productManager.ProductItemDialog(pid: pid));
  }

  void _removeProduct(String? pid) async {
    await _productService.removeDoc(pid);

    Provider.of<ProductsModel>(Get.context!, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsLoaded =
        Provider.of<ProductsModel>(context, listen: false).isInit;
    final isManager =
        Provider.of<UserModel>(context, listen: false).typeAccount ==
            UserType.MANAGER;
    return !productsLoaded
        ? LoadingDataInProgressWidget()
        : this.displayProductsList.length == 0
            ? ProductEmptyList()
            : ListView.builder(
                itemCount: this.displayProductsList.length,
                itemBuilder: (_, int index) {
                  ProductItemModel product = this.displayProductsList[index];
                  return InkWell(
                    onTap: () => !isManager
                        ? showScaleDialog(
                            productClient.ProductItemDialog(product))
                        : null,
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              product.name!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              product.description!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: product.imageUrl != null
                                ? Image.network(product.imageUrl!,
                                    fit: BoxFit.cover)
                                : Image.asset(
                                    'assets/images/no_photo.png',
                                  ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    TextButton.icon(
                                      onPressed: null,
                                      icon: FaIcon(
                                        FontAwesomeIcons.dollarSign,
                                      ),
                                      label: Text(
                                        product.price!.toStringAsFixed(2),
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: null,
                                      icon: FaIcon(
                                        FontAwesomeIcons.clock,
                                      ),
                                      label: Text('${product.prepareTime} min'),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {},
                                      icon: FaIcon(
                                        FontAwesomeIcons.solidStar,
                                        color: Colors.yellow,
                                      ),
                                      label: Text(
                                          '${product.rate} / ${ProductsModel.maxAvailableRate.toStringAsFixed(2)}'),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          if (isManager)
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
                                          TextButton.icon(
                                            onPressed: () =>
                                                _editProduct(product.pid),
                                            icon: FaIcon(
                                                FontAwesomeIcons.pencilAlt),
                                            label: Text('Edit'),
                                          ),
                                          TextButton.icon(
                                            style: TextButton.styleFrom(
                                              primary: Colors.red,
                                            ),
                                            onPressed: () =>
                                                _removeProduct(product.pid),
                                            icon: FaIcon(
                                              FontAwesomeIcons.trash,
                                            ),
                                            label: Text(
                                              'Remove',
                                            ),
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
}
