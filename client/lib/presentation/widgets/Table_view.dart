

import 'package:client/data/models/timesheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

class TableView extends StatelessWidget {
   TableView ({Key? key, required this.timeSheet}) : super(key: key);
   final TimeSheet timeSheet;
  final List _headers = [
    'Date',
    'General Coming',
    'Over Time',
    'Leave',
    'Task Content'
  ];
  @override
  Widget build(BuildContext context) {
    CustomeCell({
      required DateTime date,
      required Widget child,
    }) {
      return InkWell(
        onLongPress: (){},
        child: Container(
            margin: const EdgeInsets.only(bottom: 0.5),
            color: date.weekday > 5
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : null,
            child: Center(
              child: child,
            )),
      );
    }
    return Expanded(
      child: ExpandableTable(
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
                          style:
                          const TextStyle(fontWeight: FontWeight.bold),
                        ))))),
        rows: List.generate(
            timeSheet.rows.length,
                (rowIndex) => ExpandableTableRow(
                height: 60,
                firstCell: CustomeCell(
                    date: timeSheet.rows[rowIndex].date,
                    child: Text(DateFormat('EE, dd/MM').format(
                        DateTime(timeSheet.rows[rowIndex].date.year, timeSheet.rows[rowIndex].date.month,
                            rowIndex + 1)))),
                children: <Widget>[
                  CustomeCell(
                      date: timeSheet.rows[rowIndex].date,
                      child: Text(
                        timeSheet.rows[rowIndex].generalComing
                            .toString(),
                      )),
                  CustomeCell(
                      date: timeSheet.rows[rowIndex].date,
                      child: Text(
                        timeSheet.rows[rowIndex].overTime
                            .toString(),
                      )),
                  CustomeCell(
                      date: timeSheet.rows[rowIndex].date,
                      child: Text(timeSheet.rows[rowIndex].leave ==
                          null
                          ? '-'
                          : '${timeSheet.rows[rowIndex].leave?.reason}: ${timeSheet.rows[rowIndex].leave?.timeoff}')),
                  CustomeCell(
                      date: timeSheet.rows[rowIndex].date,
                      child: Text(
                        "${timeSheet.rows[rowIndex].contents}",
                      )),
                ])),
      ),
    );
  }
}
