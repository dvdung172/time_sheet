import 'package:hsc_timesheet/core/di.dart';
import 'package:hsc_timesheet/core/routes.dart';
import 'package:hsc_timesheet/data/models/app_session.dart';
import 'package:hsc_timesheet/presentation/providers/list_timesheet_provider.dart';
import 'package:hsc_timesheet/presentation/providers/tab_index.dart';
import 'package:hsc_timesheet/presentation/providers/timesheet_creation_provider.dart';
import 'package:hsc_timesheet/presentation/views/tabs/dashboard_tab.dart';
import 'package:hsc_timesheet/presentation/views/tabs/manage_tab.dart';
import 'package:hsc_timesheet/presentation/views/tabs/settings_tab.dart';
import 'package:hsc_timesheet/presentation/views/tabs/viewsheets_tab.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hsc_timesheet/presentation/widgets/custom_month_picker.dart';
import 'package:provider/provider.dart';

import 'app_drawer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key) {
    _tabList = <Widget>[
      const DashBoardTab(key: ValueKey(0)),
      const ViewSheets(key: ValueKey(1)),
      const ManageTab(key: ValueKey(2)),
      const SettingsTab(key: ValueKey(3)),
    ];
  }

  late final List<Widget> _tabList;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _tabTitleList = [
    tr('tabs.home.title'),
    tr('tabs.views.title'),
    tr('tabs.manage.title'),
    tr('tabs.settings.title'),
  ];

  @override
  void initState() {
    super.initState();

    final timesheetProvider = sl<ListTimeSheetsProvider>();
    timesheetProvider.getAllTimeSheets(AppSession.currentUser!.userId);
  }

  @override
  Widget build(BuildContext context) {
    final tabIndexProvider = Provider.of<TabIndex>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_tabTitleList[tabIndexProvider.currentIndex]),
        backgroundColor: Theme.of(context).primaryColor,
        actions: tabIndexProvider.currentIndex == 1
            ? [
                IconButton(
                    onPressed: () async {
                      // var res = await OdooConnect()
                      //     .getAllTimeSheet(AppSession.session!.userId);
                      // List<User> res = await OdooConnect().callListUser();
                      // Map<String, dynamic> data = Map<String, dynamic>.from(json.decode(res));
                      // print(data['name']);
                      // print('\nUser info: \n' + res[1].toString());
                      // print(sl<ListTimeSheetsProvider>().timeSheets[0].toJson());
                    },
                    icon: const Icon(Icons.save_outlined)),
              ]
            : null,
      ),
      drawer: AppDrawer(scaffoldKey: _scaffoldKey),
      body: widget._tabList[tabIndexProvider.currentIndex],
      floatingActionButton: tabIndexProvider.currentIndex == 0
          ? FloatingActionButton(
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
            )
          : null,
    );
  }
}
