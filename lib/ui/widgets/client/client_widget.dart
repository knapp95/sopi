import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/basket/basket_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/widgets/client/basket/basket_button_widget.dart';
import 'package:sopi/ui/widgets/common/account/account_widget.dart';
import 'package:sopi/ui/widgets/common/products/product_widget.dart';

import 'basket/basket_bottom_widget.dart';
import 'orders/client_order_widget.dart';

class ClientWidget extends StatefulWidget {
  const ClientWidget({Key? key}) : super(key: key);

  @override
  _ClientWidgetState createState() => _ClientWidgetState();
}

class _ClientWidgetState extends State<ClientWidget> {
  final PageController _pageController = PageController();
  late BasketModel _basket;

  int _bottomSelectedIndex = 0;

  @override
  void didChangeDependencies() {
    _basket = Provider.of<BasketModel>(context);
    super.didChangeDependencies();
  }

  void _bottomTapped(int index) {
    setState(() {
      _bottomSelectedIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void _pageChanged(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  void _displaySummaryBasket() {
    showMaterialModalBottomSheet(
      expand: false,
      context: Get.context!,
      backgroundColor: Colors.transparent,
      builder: (context) => BasketBottomWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _bottomTapped,
        backgroundColor: primaryColor,
        unselectedItemColor: Colors.white30,
        selectedItemColor: Colors.white,
        currentIndex: _bottomSelectedIndex,
        items: _buildBottomNavBarItems(),
      ),
    );
  }

  Widget _buildPageView() {
    List<Widget> children = [];
    const List<Widget> widgets = [
      ProductWidget(),
      ClientOrderWidget(),
      AccountWidget()
    ];

    /// If basket no empty add bottom widget with basket info
    if (_basket.products.isEmpty) {
      children = widgets;
    } else {
      for (final Widget element in widgets) {
        children.add(
          Column(
            children: [
              Expanded(child: element),
              BasketButtonWidget(
                'Display basket',
                '\$${fixedDouble(_basket.summaryPrice)}',
                onPressedHandler: _displaySummaryBasket,
                color: primaryColor,
                backgroundColor: Colors.white,
              ),
            ],
          ),
        );
      }
    }
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        _pageChanged(index);
      },
      children: children,
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavBarItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.food_bank,
        ),
        label: 'Menu',
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.list_alt,
        ),
        label: 'Orders',
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.person,
        ),
        label: 'Account',
      ),
    ];
  }
}
