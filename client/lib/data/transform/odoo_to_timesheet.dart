import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hsc_timesheet/core/logger.dart';
import 'package:hsc_timesheet/data/repositories/odoo_repositories/odoo_timesheet_repository.dart';

import '../models/index.dart';

class TimeSheetTransform {
  //
  List<TimeSheet> transform(List<OdooTimeSheetRow> odooTimesheetList) {
    final List<TimeSheet> timesheetList = <TimeSheet>[];
    final dateFormatter = DateFormat('yyyyMM');

    var groupByMonth = groupBy(odooTimesheetList,
        (OdooTimeSheetRow obj) => dateFormatter.format(obj.date));

    groupByMonth.forEach((date, groupedRowsByMonth) {
      final timesheetByOneMonth =
          transformByOneMonth(groupedRowsByMonth);
      if (timesheetByOneMonth != null) {
        timesheetList.add(timesheetByOneMonth);
      }
    });

    return timesheetList;
  }

  TimeSheet? transformByOneMonth(
      List<OdooTimeSheetRow> odooTimesheetList) {
    if (odooTimesheetList.isEmpty) {
      return null;
    }

    var firstOdooRow = odooTimesheetList[0];
    var firstDate = firstOdooRow.date;
    var fistDateOfMonth = DateTime(firstDate.year, firstDate.month, 1);
    TimeSheet timesheetRow = TimeSheet(
      sheetsDate: fistDateOfMonth,
      employeeId: firstOdooRow.employeeId,
      rows: [],
      userId: firstOdooRow.userId,
    );

    var groupByDate =
        groupBy(odooTimesheetList, (OdooTimeSheetRow obj) => obj.date);
    groupByDate.forEach((date, groupedRowsByDate) {
      late double generalComing = 0;
      late double overTime = 0;
      late Leave? leave = null;
      String contents = '';

      // Group
      for (var odooRow in groupedRowsByDate) {
        if (odooRow.projectName == 'Over Time') {
          overTime = odooRow.unitAmount;
        }
        // TODO: leaves?
        else if (odooRow.projectName == 'Leave') {
          leave = Leave(reason: odooRow.taskName, timeoff: odooRow.unitAmount);
        }
        // end leave
        else {
          generalComing = odooRow.unitAmount;
        }

        if (odooRow.name != null) {
          if (odooRow.name!.isNotEmpty) {
            if (contents.isNotEmpty) {
              if (contents == odooRow.name) {
                contents = odooRow.name!;
              } else {
                contents += '\r\n';
                contents += odooRow.name!;
              }
            } else {
              contents += odooRow.name!;
            }
          }
        }
      }
      SheetsRow newRow = SheetsRow(
        date: groupedRowsByDate[0].date,
        generalComing: generalComing,
        overTime: overTime,
        leave: leave,
        contents: contents,
      );
      timesheetRow.addRow(newRow);
    });

    return timesheetRow;
  }
}
