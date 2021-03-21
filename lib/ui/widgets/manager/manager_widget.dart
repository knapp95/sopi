import 'package:flutter/material.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/widgets/common/account/account_widget.dart';
import 'package:sopi/ui/widgets/common/products/product_widget.dart';
import 'package:sopi/ui/widgets/manager/employees/employees_widget.dart';
import 'package:sopi/ui/widgets/manager/orders/order_widget.dart';
import 'package:sopi/ui/widgets/manager/statistics/statistics_widget.dart';

class ManagerWidget extends StatefulWidget {
  @override
  _ManagerWidgetState createState() => _ManagerWidgetState();
}

class _ManagerWidgetState extends State<ManagerWidget> {
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
        backgroundColor: primaryColor,
        unselectedItemColor: Colors.white30,
        selectedItemColor: Colors.white,
        currentIndex: _bottomSelectedIndex,
        items: _buildBottomNavBarItems(),
      ),
    );
  }

  Widget _buildPageView() {
    List<Widget> children = [
      ProductWidget(),
      EmployeesWidget(),
      OrderWidget(),
      StatisticsWidget(),
      AccountWidget()
    ];
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
          Icons.supervised_user_circle,
        ),
        label: 'Employees',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.list_alt,
        ),
        label: 'Orders',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.pie_chart,
        ),
        label: 'Statistics',
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
