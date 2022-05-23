import 'package:client/core/theme.dart';
import 'package:client/data/models/timesheet.dart';
import 'package:client/presentation/providers/list_timesheet_provider.dart';
import 'package:client/presentation/widgets/custom_month_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ViewSheets extends StatefulWidget {
  const ViewSheets({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ViewSheets();
  }
}

class _ViewSheets extends State<ViewSheets> {
  late DateTime _date = DateTime.now();
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
      return Container(
          margin: const EdgeInsets.only(bottom: 0.5),
          color: date.weekday > 5
              ? Theme.of(context).primaryColor.withOpacity(0.4)
              : null,
          child: Center(
            child: child,
          ));
    }

    return Column(
      children: [
        Center(
          child: TextButton(
              onPressed: () {
                DatePicker.showPicker(
                  context,
                  pickerModel: CustomMonthPicker(
                      minTime: DateTime(2020, 1, 1),
                      maxTime: DateTime.now(),
                      currentTime: _date),
                  showTitleActions: true,
                  onConfirm: (date) {
                    setState(() {
                      _date = date;
                    });
                  },
                );
              },
              child: Text(
                DateFormat(DateFormat.YEAR_MONTH).format(_date),
                style: CustomTheme.mainTheme.textTheme.headline2,
              )),
        ),
        Consumer<ListTimeSheetsProvider>(builder: (context, provider, child) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final TimeSheet? timeSheet = provider.timeSheets.firstWhereOrNull(
              (p) =>
                  DateFormat(DateFormat.YEAR_MONTH)
                      .format(p.sheetsDate)
                      .compareTo(
                          DateFormat(DateFormat.YEAR_MONTH).format(_date)) ==
                  0);
          if (timeSheet == null) {
            return const Center(
              child: Text('No Time Sheet Available'),
            );
          } else {
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
                                    DateTime(_date.year, _date.month,
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
        })
      ],
    );
  }
}
