import 'package:flutter/material.dart';
import 'package:sopi/models/menu_model.dart';
import 'package:sopi/models/product_item_model.dart';
import 'package:sopi/screens/menu/menu_list_products.dart';
import 'menu_list_products.dart';

class MenuScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<MenuScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  TabController _tabController;
  TextEditingController _searchController;
  bool _searchActive = false;

  @override
  void initState() {
    _searchController = TextEditingController();
    _tabController =
        TabController(length: MenuModel.productsTypes.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearchTextChange(String text) {
    ///TODO
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchActive
            ? _buildSearchSection()
            : Text(
                'Thomas, eat something tasty',
                style: TextStyle(color: Colors.white),
              ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _searchActive = true;
              });
              print('11');
            },
          )
        ],
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: _buildTabs(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _buildTabsContent(),
      ),
    );
  }

  List<Widget> _buildTabs() {
    List<Widget> tabs = [];
    MenuModel.productsTypes.forEach((tab) {
      tabs.add(
        Tab(
          child: Text(
            tab.name,
            style: TextStyle(
              fontWeight: _selectedIndex == tabs.length
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
    return tabs;
  }

  List<Widget> _buildTabsContent() {
    List<Widget> tabsContent = MenuModel.productsTypes.map((type) {
      List<ProductItemModel> productsByType =
          MenuModel.getSortedProductsByType(type.id);
      return MenuListProducts(productsByType);
    }).toList();
    return tabsContent;
  }

  Widget _buildSearchSection() {
    return TextField(
      controller: _searchController,
      onEditingComplete: () => setState(() {
        _searchActive = false;
      }),
      decoration: InputDecoration(
        icon: IconButton(
          onPressed: () {
            setState(() {
              _searchController.clear();
            });
          },
          icon: Icon(
            Icons.clear,
            color: Colors.red,
          ),
        ),
        hintText: 'Filter the list',
        hintStyle: TextStyle(color: Colors.white),
        border: InputBorder.none,
      ),
      style: TextStyle(color: Colors.white),
      onChanged: _onSearchTextChange,
    );
  }
}
