import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/models/products/products_model.dart';
import 'package:sopi/ui/widgets/common/products/list/products_list.dart';

class ProductsWidget extends StatefulWidget {
  const ProductsWidget({Key? key}) : super(key: key);

  @override
  _ProductsWidgetState createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  bool _isInit = true;
  List<ProductItemModel> _products = [];

  Future<void> _loadProducts() async {
    final ProductsModel products = Provider.of<ProductsModel>(context);
    if (!products.isInit) {
      await products.fetchProducts();
    }
    _products = products.products;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _loadProducts();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ProductsList(_products);
  }
}
