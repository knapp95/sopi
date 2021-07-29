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
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/client/products/product_item_dialog.dart'
    as product_client;
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:sopi/ui/widgets/common/products/list/products_empty_list.dart';
import 'package:sopi/ui/widgets/manager/common/asset_show_image.dart';
import 'package:sopi/ui/widgets/manager/company/products/product_item_dialog_widget.dart'
    as product_manager;

class ProductsList extends StatelessWidget {
  final _productService = ProductService.singleton;
  final List<ProductItemModel> displayProductsList;

  ProductsList(this.displayProductsList, {Key? key}) : super(key: key);

  void _editProduct(ProductItemModel product) {
    showScaleDialog(product_manager.ProductItemDialogWidget(product));
  }

  Future<void> _removeProduct(String? pid) async {
    await _productService.removeDoc(pid);

    Provider.of<ProductsModel>(Get.context!, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsLoaded =
        Provider.of<ProductsModel>(context, listen: false).isInit;
    final isManager =
        Provider.of<UserModel>(context, listen: false).typeAccount ==
            UserType.manager;
    return !productsLoaded
        ? const LoadingDataInProgressWidget()
        : displayProductsList.isEmpty
            ? const ProductEmptyList()
            : ListView.builder(
                itemCount: displayProductsList.length,
                itemBuilder: (_, int index) {
                  final ProductItemModel product = displayProductsList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => !isManager
                          ? showScaleDialog(
                              product_client.ProductItemDialog(product))
                          : null,
                      child: Card(
                        elevation: defaultElevation,
                        shape: shapeCard,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                product.name!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                product.description!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: AssetShowImage(product.imageUrl,
                                  fromAsset: false),
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
                                        icon: const FaIcon(
                                          FontAwesomeIcons.dollarSign,
                                        ),
                                        label: Text(
                                          product.price!.toStringAsFixed(2),
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: null,
                                        icon: const FaIcon(
                                          FontAwesomeIcons.clock,
                                        ),
                                        label:
                                            Text('${product.prepareTime} min'),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {},
                                        icon: const FaIcon(
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
                                                  _editProduct(product),
                                              icon: const FaIcon(
                                                  FontAwesomeIcons.pencilAlt),
                                              label: const Text('Edit'),
                                            ),
                                            TextButton.icon(
                                              style: TextButton.styleFrom(
                                                primary: Colors.red,
                                              ),
                                              onPressed: () =>
                                                  _removeProduct(product.pid),
                                              icon: const FaIcon(
                                                FontAwesomeIcons.trash,
                                              ),
                                              label: const Text('Remove'),
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
                    ),
                  );
                },
              );
  }
}
