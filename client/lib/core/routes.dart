import 'package:client/presentation/providers/bottom_navigation_bar_provider.dart';
import 'package:client/presentation/providers/product_detail_provider.dart';
import 'package:client/presentation/providers/product_list_provider.dart';
import 'package:client/presentation/views/home_screen.dart';
import 'package:client/presentation/views/login_screen.dart';
import 'package:client/presentation/views/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'di.dart';

class Routes {
  Routes._();

  static const root = '/';
  static const login = '/login';
  static const home = '/home';
  static const search = '/search';
  static const settings = '/settings';
  static const productDetails = '/product_details';
}

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  Routes.login: (BuildContext context) => const LoginScreen(),
  Routes.home: (BuildContext context) => MultiProvider(
        child: HomeScreen(),
        providers: [
          ChangeNotifierProvider.value(
              value: sl<BottomNavigationBarProvider>()),
          ChangeNotifierProvider.value(value: sl<ProductListProvider>()),
          // ChangeNotifierProvider.value(value: sl<ProductDetailProvider>()),
        ],
      ),
  Routes.productDetails: (BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as int;

    return MultiProvider(
      child: ProductDetail(productId),
      providers: [
        ChangeNotifierProvider.value(value: sl<ProductDetailProvider>()),
      ],
    );
  },

  // Routes.search: (BuildContext context) {
  //   var searchArguments = const SearchArguments.empty();
  //   if (null != ModalRoute.of(context)?.settings.arguments) {
  //     searchArguments =
  //         ModalRoute.of(context)!.settings.arguments as SearchArguments;
  //   }

  //   return StoreSearchScreen(searchArguments: searchArguments);
  // },
};
