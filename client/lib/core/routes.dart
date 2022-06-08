import 'package:client/presentation/providers/list_employee_provider.dart';
import 'package:client/presentation/providers/tab_index.dart';
import 'package:client/presentation/providers/list_timesheet_provider.dart';
import 'package:client/presentation/providers/timesheet_provider.dart';
import 'package:client/presentation/views/home_screen.dart';
import 'package:client/presentation/views/login_screen.dart';
import 'package:client/presentation/views/create_timesheet_screen.dart';
import 'package:client/presentation/views/manage_view.dart';
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
  Routes.login: (BuildContext context) => const LoginScreen(),
  Routes.home: (BuildContext context) => MultiProvider(
        child: HomeScreen(),
        providers: [
          ChangeNotifierProvider.value(value: sl<TabIndex>()),
          ChangeNotifierProvider.value(value: sl<ListTimeSheetsProvider>()),
          ChangeNotifierProvider.value(value: sl<TimeSheetProvider>()),
          ChangeNotifierProvider.value(value: sl<ListEmployeeProvider>()),
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
