import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/models/products/product_type_model.dart';
import 'package:sopi/models/products/products_model.dart';

import 'list/products_list.dart';

class ProductWidget extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductWidget>
    with TickerProviderStateMixin {
  bool _isInit = false;
  int _selectedIndex = 0;
  TabController? _tabController;
  TextEditingController? _searchController;

  bool _searchActive = false;
  late ProductsModel _products;
  List<ProductItemModel> _searchResult = [];

  @override
  void initState() {
    _searchController = TextEditingController();
    _tabController =
        TabController(length: ProductsModel.types.length, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _searchClear();
        _selectedIndex = _tabController!.index;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _products = Provider.of<ProductsModel>(context);
      _products.fetchProducts();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController!.dispose();
    _tabController!.dispose();
    super.dispose();
  }

  void _onSearchTextChange(String text) {
    setState(() {
      _searchResult.clear();
      if (text.isEmpty) {
        return;
      }
      ProductTypeModel openedProducts = ProductsModel.types[_selectedIndex];
      List<ProductItemModel> productsByType =
          _products.getSortedProductsByType(openedProducts.id);
      _searchResult = productsByType
          .where((product) => containsIgnoreCase(product.name!, text)!)
          .toList();
    });
  }

  void _searchClear() {
    _searchActive = false;
    _searchResult.clear();
    _searchController!.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchActive
            ? _buildSearchSection()
            : Text(
                'Thomas, eat something tasty',
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
    ProductsModel.types.forEach((tab) {
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
    List<Widget> tabsContent = ProductsModel.types.map((element) {
      List<ProductItemModel> productsByType = [];

      if (_searchResult.length != 0 || _searchController!.text.isNotEmpty) {
        productsByType = _searchResult;
      } else {
        productsByType = _products.getSortedProductsByType(element.id);
      }
      return ProductsList(productsByType);
    }).toList();
    return tabsContent;
  }

  Widget _buildSearchSection() {
    return TextField(
      controller: _searchController,
      onEditingComplete: () => setState(() {}),
      decoration: InputDecoration(
        icon: IconButton(
          onPressed: () {
            setState(() {
              _searchClear();
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
