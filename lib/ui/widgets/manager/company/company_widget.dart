import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/models/products/products_model.dart';
import 'package:sopi/ui/widgets/common/products/buttons/product_buttons.dart';
import 'package:sopi/ui/widgets/common/products/list/products_list.dart';

import 'assets/assets_list_widget.dart';
import 'employees/employees_widget.dart';

class CompanyWidget extends StatefulWidget {
  @override
  _CompanyWidgetState createState() => _CompanyWidgetState();
}

class _CompanyWidgetState extends State<CompanyWidget> {
  bool _isInit = true;
  List<ProductItemModel> _products = [];

  Future<Null> _loadProducts() async {
    ProductsModel products = Provider.of<ProductsModel>(context);
    if (!products.isInit) {
      await products.fetchProducts();
    }
    _products = products.products;
  }

  @override
  void didChangeDependencies()  {
    if (_isInit) {
      _loadProducts();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                tabs: [
                  Tab(
                    icon:
                        Icon(Icons.supervised_user_circle, color: Colors.white),
                  ),
                  Tab(icon: Icon(Icons.food_bank, color: Colors.white)),
                  Tab(icon: Icon(Icons.kitchen, color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            EmployeesWidget(),
            ProductsList(_products),
            ExampleDragAndDrop(),
          ],
        ),
        floatingActionButton: ProductButtons(),
      ),
    );
  }
}
