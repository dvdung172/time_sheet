import 'package:client/core/di.dart';
import 'package:client/presentation/providers/bottom_navigation_bar_provider.dart';
import 'package:client/presentation/views/tabs/products/product_list_tab.dart';
import 'package:client/presentation/views/tabs/settings_tab.dart';
import 'package:client/presentation/views/tabs/shopping_cart_tab.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key) {
    _tabList = <Widget>[
      const ProductListTab(key: ValueKey(0)),
      const ShoppingCartTab(key: ValueKey(1)),
      const SettingsTab(key: ValueKey(2)),
    ];
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final List<Widget> _tabList;
  final _tabTitleList = [
    tr('tabs.home.title'),
    tr('tabs.shoppingcart.title'),
    tr('tabs.settings.title'),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = sl<BottomNavigationBarProvider>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_tabTitleList[provider.currentIndex]),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: AppDrawer(scaffoldKey: _scaffoldKey),
      body: _tabList[provider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: tr('tabs.home.title'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: tr('tabs.shoppingcart.title'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: tr('tabs.settings.title'),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: provider.currentIndex,
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          provider.currentIndex = index;
        },
      ),
    );
  }
}
