import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/basket/basket_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/widgets/common/orders/order_screen.dart';
import 'package:sopi/ui/widgets/common/products/menu_screen.dart';

import 'account/account_screen.dart';
import 'basket/basket_bottom_widget.dart';

class ClientScreen extends StatefulWidget {
  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  BasketModel _basket;

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
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void _pageChanged(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
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
    List<Widget> widgets = [MenuScreen(), OrderScreen(), AccountScreen()];

    /// If basket no empty add bottom widget with basket info
    if (isNullOrEmpty(_basket.products)) {
      children = widgets;
    } else {
      widgets.forEach((element) {
        children.add(
          Column(
            children: [
              Expanded(child: element),
              BasketBottomWidget(),
            ],
          ),
        );
      });
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
      BottomNavigationBarItem(
        icon: Icon(
          Icons.food_bank,
        ),
        label: 'Menu',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.list_alt,
        ),
        label: 'Orders',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.person,
        ),
        label: 'Account',
      ),
    ];
  }
}
