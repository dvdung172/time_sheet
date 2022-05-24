import 'package:client/presentation/providers/timesheet_provider.dart';
import 'package:client/presentation/widgets/leave_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:provider/provider.dart';

class NewTimeSheet extends StatefulWidget {
  const NewTimeSheet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewTimeSheet();
  }
}

class _NewTimeSheet extends State<NewTimeSheet> {
  final List _headers = [
    'Date',
    'General Coming',
    'Over Time',
    'Leave',
    'Task Content'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Time Sheet'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.save_outlined))
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<TimeSheetProvider>(
        builder: (context, provider, child) {
          return ExpandableTable(
            headerHeight: 50,
            firstColumnWidth: 100,
            header: ExpandableTableHeader(
                firstCell: Container(
                    margin: const EdgeInsets.all(1),
                    child: Center(
                        child: Text(
                      _headers[0],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ))),
                children: List.generate(
                    _headers.length - 1,
                    (index) => Container(
                        margin: const EdgeInsets.all(1),
                        child: Center(
                            child: Text(
                          _headers[index + 1],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))))),
            rows: List.generate(
                DateUtils.getDaysInMonth(provider.timeSheet.sheetsDate.year,
                    provider.timeSheet.sheetsDate.month),
                (rowIndex) => ExpandableTableRow(
                        height: 60,
                        firstCell: Container(
                          margin: const EdgeInsets.only(bottom: 1),
                          color:
                              provider.timeSheet.rows[rowIndex].date.weekday > 5
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.2)
                                  : null,
                          child: Center(
                            child: Text(DateFormat('EE, dd/MM').format(
                                provider.timeSheet.rows[rowIndex].date)),
                          ),
                        ),
                        children: <Widget>[
                          //General Coming
                          Container(
                            margin: const EdgeInsets.only(bottom: 1),
                            color:
                                provider.timeSheet.rows[rowIndex].date.weekday >
                                        5
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.2)
                                    : null,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              controller: TextEditingController(
                                  text: provider
                                      .timeSheet.rows[rowIndex].generalComing
                                      .toString()),
                              onChanged: (String value) {
                                if (value == '') {
                                  value = '0';
                                }
                                provider.timeSheet.rows[rowIndex]
                                    .generalComing = double.parse(value);
                                print(provider
                                    .timeSheet.rows[rowIndex].generalComing);
                              },
                            ),
                          ),
                          //Overtime
                          Container(
                            margin: const EdgeInsets.only(bottom: 1),
                            color:
                                provider.timeSheet.rows[rowIndex].date.weekday >
                                        5
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.2)
                                    : null,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              controller: TextEditingController(
                                  text: provider
                                      .timeSheet.rows[rowIndex].overTime
                                      .toString()),
                              onChanged: (String value) {
                                if (value == '') {
                                  value = '0';
                                }
                                provider.timeSheet.rows[rowIndex].overTime =
                                    double.parse(value);
                              },
                            ),
                          ),
                          //Leave
                          Container(
                            margin: const EdgeInsets.only(bottom: 1),
                            color:
                                provider.timeSheet.rows[rowIndex].date.weekday >
                                        5
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.2)
                                    : null,
                            child: FlatButton(
                              onPressed: () {
                                showDialog(
                                        context: context,
                                        builder: (_) => const LeaveDialog())
                                    .then((value) {
                                  if (value != null) {
                                    provider.setLeave(rowIndex, value[0],
                                        double.parse(value[1]));
                                    provider.timeSheet.rows[rowIndex].generalComing-= double.parse(value[1]);
                                  }
                                });
                              },
                              child: Center(
                                child: Text(provider
                                            .timeSheet.rows[rowIndex].leave ==
                                        null
                                    ? '-'
                                    : '${provider.timeSheet.rows[rowIndex].leave!.reason}: ${provider.timeSheet.rows[rowIndex].leave!.timeoff}'),
                              ),
                            ),
                          ),
              Container(
                margin: const EdgeInsets.only(bottom: 1),
                color:
                provider.timeSheet.rows[rowIndex].date.weekday >
                    5
                    ? Theme.of(context)
                    .primaryColor
                    .withOpacity(0.2)
                    : null,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.center,
                  decoration:
                  const InputDecoration(border: InputBorder.none),
                  controller: TextEditingController(
                      text: provider
                          .timeSheet.rows[rowIndex].contents ?? ''),
                  onChanged: (String value) {
                    if(value ==''){
                      provider.timeSheet.rows[rowIndex].contents = null;
                    }
                    provider.timeSheet.rows[rowIndex].contents =
                        value;
                  },
                ),
              ),

                        ])),
          );
        },
      ),
    );
  }
}
