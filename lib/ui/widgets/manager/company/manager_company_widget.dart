import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sopi/ui/widgets/common/products/buttons/product_buttons.dart';
import 'package:sopi/ui/widgets/manager/company/assets/asset_widget.dart';
import 'package:sopi/ui/widgets/manager/company/products/products_widget.dart';

import 'employees/employees_widget.dart';

class ManagerCompanyWidget extends StatelessWidget {
  const ManagerCompanyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
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
        body: const TabBarView(
          children: [
            EmployeesWidget(),
            ProductsWidget(),
            AssetWidget(),
          ],
        ),
        floatingActionButton: const ProductButtons(),
      ),
    );
  }
}
