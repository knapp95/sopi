import 'package:flutter/material.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/widgets/common/account/account_widget.dart';
import 'package:sopi/ui/widgets/manager/company/manager_company_widget.dart';
import 'package:sopi/ui/widgets/manager/orders/manager_order_widget.dart';

class ManagerWidget extends StatefulWidget {
  const ManagerWidget({Key? key}) : super(key: key);

  @override
  _ManagerWidgetState createState() => _ManagerWidgetState();
}

class _ManagerWidgetState extends State<ManagerWidget> {
  final PageController _pageController = PageController();

  int _bottomSelectedIndex = 0;

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
    const List<Widget> children = [
      ManagerOrderWidget(),
      ManagerCompanyWidget(),
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
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.list_alt,
        ),
        label: 'Orders',
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.business,
        ),
        label: 'Company',
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
