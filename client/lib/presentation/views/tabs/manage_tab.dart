import 'package:hsc_timesheet/core/app_style.dart';
import 'package:hsc_timesheet/core/di.dart';
import 'package:hsc_timesheet/core/logger.dart';
import 'package:hsc_timesheet/core/routes.dart';
import 'package:hsc_timesheet/data/models/employee.dart';
import 'package:hsc_timesheet/presentation/providers/index.dart';
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
  List<Employee>? listEmployee = [];

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
        Provider.of<ListEmployeeProvider>(context);
    final listTimeSheetProvider =
        Provider.of<ListTimeSheetsProvider>(context);
    final timesheetProvider = sl<TimeSheetProvider>();
    listEmployee = employeeProvider.users;

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
                      itemCount: listTimeSheetProvider.unapprovedTimeSheets.length,
                      itemBuilder: (context, index) {
                        var rows =
                            listTimeSheetProvider.unapprovedTimeSheets[index].rows;
                        var unapprovedTimesheetRow =
                            listTimeSheetProvider.unapprovedTimeSheets[index];
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
                                      arguments: [index, "approval"]);
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
                                          "Employee's Name: ${listEmployee?.firstWhereOrNull((element) => element.id == unapprovedTimesheetRow.employeeId)?.name}"),
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
                                      onPressed: () async {
                                        //TODO rebuild state
                                        await timesheetProvider.approveTimeSheet(unapprovedTimesheetRow);

                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(timesheetProvider.error??'Declined Time Sheet ',
                                            textAlign: TextAlign.center,
                                            style: AppStyles.messageStyle,
                                          ),
                                          duration: const Duration(seconds: 2),
                                          backgroundColor: Colors.red,
                                        ));
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
                                      onPressed: () async {
                                        //TODO rebuild state

                                        await timesheetProvider.deleteTimeSheet(unapprovedTimesheetRow);

                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(timesheetProvider.error??'Declined Time Sheet ',
                                            textAlign: TextAlign.center,
                                            style: AppStyles.messageStyle,
                                          ),
                                          duration: const Duration(seconds: 2),
                                          backgroundColor: Colors.red,
                                        ));
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
                    itemCount: listEmployee?.length ?? 0,
                    itemBuilder: (context, index) {
                      var idxEmployee = listEmployee?[index];
                      if (idxEmployee == null) {
                        return const SizedBox.shrink();
                      }

                      // var unique = idxUser.lastUpdate
                      //     .replaceAll(RegExp(r'[^0-9]'), '');
                      return Card(
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            sl<ListTimeSheetsProvider>().getAllApprovedTimeSheets(idxEmployee.id);

                            logger.d('current userId: $idxEmployee');

                            // Navigator.pushNamed(context, Routes.manageView,
                            //     arguments: 'employee');
                            Navigator.pushNamed(context, Routes.manageView,
                                arguments: [index, "'employee'"]);
                          },
                          child: ListTile(
                            leading: SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.network(
                                  'http://172.29.4.126:8069/web/image?model=hr.employee&id=12&field=image_medium&unique=05312022084057'),
                            ),
                            // leading: Image.network('https://i.pravatar.cc/100'),
                            title: Text(idxEmployee.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(idxEmployee.position),
                                Text(idxEmployee.workPhone),
                                Text(idxEmployee.email),
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
