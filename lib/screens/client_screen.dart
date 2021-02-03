import 'package:flutter/material.dart';
import 'package:sopi/models/basket_model.dart';
import 'package:sopi/screens/basket/basket_bottom_widget.dart';

import 'account/account_screen.dart';
import 'menu/menu_screen.dart';
import 'orders/order_screen.dart';

class ClientScreen extends StatefulWidget {
  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  int _bottomSelectedIndex = 0;

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
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white30,
        selectedItemColor: Colors.white,
        currentIndex: _bottomSelectedIndex,
        items: _buildBottomNavBarItems(),
      ),
    );
  }

  Widget _buildPageView() {
    print('BUILD PAGE VIEW');
    List<Widget> children = [];
    List<Widget> widgets = [MenuScreen(), OrderScreen(), AccountScreen()];

    /// If basket no empty add bottom widget with basket info
    if (BasketModel.products.isEmpty) {
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
