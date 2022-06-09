import 'package:hsc_timesheet/presentation/providers/index.dart';
import 'package:hsc_timesheet/presentation/views/home_screen.dart';
import 'package:hsc_timesheet/presentation/views/login_screen.dart';
import 'package:hsc_timesheet/presentation/views/create_timesheet_screen.dart';
import 'package:hsc_timesheet/presentation/views/manage_view.dart';
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
  static const newTimeSheet = '/new_time_sheet';
  static const manageView = '/manage_view';
}

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  Routes.login: (BuildContext context) => MultiProvider(
        child: const LoginScreen(),
        providers: [
          ChangeNotifierProvider.value(value: sl<AuthProvider>()),
        ],
      ),
  Routes.home: (BuildContext context) => MultiProvider(
        child: HomeScreen(),
        providers: [
          ChangeNotifierProvider.value(value: sl<TabIndex>()),
          ChangeNotifierProvider.value(value: sl<TimeSheetProvider>()),
          ChangeNotifierProvider.value(value: sl<ListTimeSheetsProvider>()),
          ChangeNotifierProvider.value(value: sl<ListEmployeeProvider>()),
          // ChangeNotifierProvider.value(value: sl<ListTimeSheetsProvider>()..getTimeSheetUnapproved()),
          // ChangeNotifierProvider.value(value: sl<ListEmployeeProvider>()..getAllEmployee()),
        ],
      ),
  Routes.newTimeSheet: (BuildContext context) => MultiProvider(
        child: const NewTimeSheet(),
        providers: [
          ChangeNotifierProvider.value(value: sl<TimeSheetProvider>()),
        ],
      ),
  Routes.manageView: (BuildContext context) => MultiProvider(
        child: const ManageView(),
        providers: [
          ChangeNotifierProvider.value(value: sl<TabIndex>()),
          ChangeNotifierProvider.value(value: sl<ListTimeSheetsProvider>()),
          ChangeNotifierProvider.value(value: sl<TimeSheetProvider>()),
          ChangeNotifierProvider.value(value: sl<ListEmployeeProvider>()),
        ],
      ),
};
