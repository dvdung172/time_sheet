import 'package:hsc_timesheet/core/di.dart';
import 'package:hsc_timesheet/core/logger.dart';
import 'package:hsc_timesheet/core/routes.dart';
import 'package:hsc_timesheet/data/models/employee.dart';
import 'package:hsc_timesheet/data/models/timesheet.dart';
import 'package:hsc_timesheet/presentation/providers/index.dart';
// import 'package:hsc_timesheet/presentation/providers/list_timesheet_provider.dart';
// import 'package:hsc_timesheet/presentation/providers/timesheet_creation_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ManageTab extends StatefulWidget {
  const ManageTab({Key? key}) : super(key: key);

  @override
  State<ManageTab> createState() => _ManageTabState();
}

class _ManageTabState extends State<ManageTab> {
  bool visible = false;
  // List<TimeSheet> listsheet = [];
  List<Employee>? listUser = [];

  @override
  void initState() {
    // Provider.of<ListEmployeeProvider>(context, listen: false)
    //     .getAllEmployee();
    //
    // Provider.of<ListTimeSheetsProvider>(context, listen: false)
    //     .getTimeSheetUnapproved();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider =
        Provider.of<ListEmployeeProvider>(context, listen: false);
    final timesheetProvider =
        Provider.of<ListTimeSheetsProvider>(context, listen: false);
    listUser = employeeProvider.users;

    if (employeeProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (employeeProvider.error != null) {
      return Center(child: Text(employeeProvider.error!));
    }

    return DefaultTabController(
      length: 2, // length of tabs
      initialIndex: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TabBar(
            labelColor: Theme.of(context).primaryColor,
            indicatorColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black45,
            tabs: const [
              Tab(text: 'Approval'),
              Tab(text: 'Employee'),
            ],
          ),
          Expanded(
            child: Container(
              //height of TabBarView
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: Theme.of(context).primaryColor, width: 0.5))),
              child: TabBarView(
                children: <Widget>[
                  ListView.builder(
                      itemCount: timesheetProvider.unapprovedTimeSheets.length,
                      itemBuilder: (context, index) {
                        var rows =
                            timesheetProvider.unapprovedTimeSheets[index].rows;
                        var unapprovedTimesheetRow =
                            timesheetProvider.unapprovedTimeSheets[index];
                        return SizedBox(
                          height: 175,
                          child: Card(
                              child: Column(
                            children: [
                              InkWell(
                                splashColor: Colors.teal.withAlpha(30),
                                onTap: () async {
                                  Navigator.pushNamed(
                                      context, Routes.manageView,
                                      arguments: [index, "'approval'"]);
                                },
                                child: ListTile(
                                  isThreeLine: true,
                                  minVerticalPadding: 13,
                                  title: Text(
                                      'Time Sheet ${DateFormat('MM/yyyy').format(unapprovedTimesheetRow.sheetsDate)}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Employee's Name: ${listUser?.firstWhereOrNull((element) => element.id == unapprovedTimesheetRow.userId)?.name}"),
                                      Text(
                                          "General Coming: ${rows.map((e) => e.generalComing).toList().sum}"),
                                      Text(
                                        "OverTime: ${rows.map((e) => e.overTime).toList().sum}",
                                        style: rows
                                                    .map((e) => e.overTime)
                                                    .toList()
                                                    .sum >
                                                0
                                            ? const TextStyle(
                                                color: Colors.blue)
                                            : null,
                                      ),
                                      Text(
                                        "Leave: ${rows.map((e) => e.leave?.timeoff ?? 0).toList().sum}",
                                        style: rows
                                                    .map((e) =>
                                                        e.leave?.timeoff ?? 0)
                                                    .toList()
                                                    .sum ==
                                                0
                                            ? null
                                            : const TextStyle(
                                                color: Colors.red),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            10,
                                    child: TextButton(
                                      child: const Text('APPROVE'),
                                      onPressed: () {
                                        /* ... */
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            10,
                                    child: TextButton(
                                      child: const Text(
                                        'DECLINE',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        /* ... */
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                        );
                      }),
                  ListView.builder(
                    itemCount: listUser?.length ?? 0,
                    itemBuilder: (context, index) {
                      var idxUser = listUser?[index];
                      if (idxUser == null) {
                        return const SizedBox.shrink();
                      }

                      // var unique = idxUser.lastUpdate
                      //     .replaceAll(RegExp(r'[^0-9]'), '');
                      return Card(
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            sl<ListTimeSheetsProvider>()
                                .getAllApprovedTimesheets(idxUser.id);
                            logger.d('current userId: ${idxUser.id}');
                            Navigator.pushNamed(context, Routes.manageView,
                                arguments: 'employee');
                          },
                          child: ListTile(
                            leading: SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.network(
                                  'http://172.29.4.126:8069/web/image?model=hr.employee&id=12&field=image_medium&unique=05312022084057'),
                            ),
                            // leading: Image.network('https://i.pravatar.cc/100'),
                            title: Text(idxUser.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(idxUser.position),
                                Text(idxUser.workPhone),
                                Text(idxUser.email),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
