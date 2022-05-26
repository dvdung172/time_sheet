import 'package:client/core/di.dart';
import 'package:client/core/routes.dart';
import 'package:client/data/models/timesheet.dart';
import 'package:client/data/models/user.dart';
import 'package:client/presentation/providers/list_timesheet_provider.dart';
import 'package:client/presentation/providers/list_user_provider.dart';
import 'package:client/presentation/providers/timesheet_provider.dart';
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
  List<TimeSheet> listsheet = [];
  List<User> listUser = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      //your code goes here

      Provider.of<ListUserProvider>(context, listen: false).getAllUser();

      Provider.of<ListTimeSheetsProvider>(context, listen: false)
          .getTimeSheetUnapproved()
          .then((value) {
        setState(() {
          listsheet = value;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    listUser = Provider.of<ListUserProvider>(context, listen: false).users;
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
                                color: Theme.of(context).primaryColor,
                                width: 0.5))),
                    child: TabBarView(children: <Widget>[
                      ListView.builder(
                          itemCount: listsheet.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 165,
                              child: Card(
                                  child: Column(
                                children: [
                                  InkWell(
                                    splashColor: Colors.teal.withAlpha(30),
                                    onTap: () async {
                                      sl<TimeSheetProvider>().getTimeSheetById(
                                          listsheet[index].id!);
                                      Navigator.pushNamed(
                                          context, Routes.manageView,
                                          arguments: 'approval');
                                    },
                                    child: ListTile(
                                      isThreeLine: true,
                                      minVerticalPadding: 13,
                                      title: Text(
                                          'Time Sheet ${DateFormat('MM/yyyy').format(listsheet[index].sheetsDate)}'),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Employee's Name: ${listUser.firstWhereOrNull((element) => element.id == listsheet[index].userId)?.name} "),
                                          Text(
                                              "General Coming: ${listsheet[index].rows.map((e) => e.generalComing).toList().sum}"),
                                          Text(
                                              "OverTime: ${listsheet[index].rows.map((e) => e.overTime).toList().sum}"),
                                          Text(
                                              "Leave: ${listsheet[index].rows.map((e) => e.leave?.timeoff ?? 0).toList().sum}")
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
                                            MediaQuery.of(context).size.width /
                                                    2 -
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
                                            MediaQuery.of(context).size.width /
                                                    2 -
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
                          itemCount: listUser.length,
                          itemBuilder: (context, index) {
                            return Card(
                                child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                sl<ListTimeSheetsProvider>()
                                    .getAllTimeSheets(listUser[index].id);
                                print(listUser[index].id);
                                Navigator.pushNamed(context, Routes.manageView,
                                    arguments: 'employee');
                              },
                              child: ListTile(
                                leading: Image.network(listUser[index].avatar),
                                title: Text(listUser[index].name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(listUser[index].position),
                                  ],
                                ),
                                isThreeLine: true,
                              ),
                            ));
                          }),
                    ])),
              )
            ]));
  }
}
