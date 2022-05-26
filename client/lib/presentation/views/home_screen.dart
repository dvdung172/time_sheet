import 'package:client/core/di.dart';
import 'package:client/presentation/providers/list_timesheet_provider.dart';
import 'package:client/presentation/providers/tab_index.dart';
import 'package:client/presentation/providers/timesheet_provider.dart';
import 'package:client/presentation/views/tabs/dashboard_tab.dart';
import 'package:client/presentation/views/tabs/manage_tab.dart';
import 'package:client/presentation/views/tabs/settings_tab.dart';
import 'package:client/presentation/views/tabs/viewsheets_tab.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

import '../../core/routes.dart';
import '../widgets/custom_month_picker.dart';
import 'app_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key) {
    _tabList = <Widget>[
       const DashBoardTab(key: ValueKey(0)),
      const ViewSheets(key: ValueKey(1)),
      const ManageTab(key:ValueKey(2)),
      const SettingsTab(key: ValueKey(3)),
    ];
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final List<Widget> _tabList;
  final _tabTitleList = [
    tr('tabs.home.title'),
    tr('tabs.views.title'),
    tr('tabs.manage.title'),
    tr('tabs.settings.title'),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TabIndex>(context);
    Future.delayed(Duration.zero, () {
      //your code goes here
      sl<ListTimeSheetsProvider>().getAllTimeSheets(1);
    });
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_tabTitleList[provider.currentIndex]),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: AppDrawer(scaffoldKey: _scaffoldKey),
      body: _tabList[provider.currentIndex],
      floatingActionButton: provider.currentIndex==0? FloatingActionButton(
        onPressed: () {
          DatePicker.showPicker(
            context,
            pickerModel: CustomMonthPicker(
                minTime: DateTime(2020, 1, 1),
                maxTime: DateTime.now(),
                currentTime: DateTime.now()),
            showTitleActions: true,
            onConfirm: (date) {
              sl<TimeSheetProvider>().createTimeSheet(date);
              Navigator.pushNamed(context, Routes.newTimeSheet);
            },
          );
        },
        // onPressed: () { Navigator.pushNamed(context, Routes.newTimeSheet);
        // },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.border_color),
      ):null,
    );
  }
}


