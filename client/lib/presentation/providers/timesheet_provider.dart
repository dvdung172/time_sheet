import 'package:hsc_timesheet/core/logger.dart';
import 'package:hsc_timesheet/data/models/odoo_timesheet_row.dart';
import 'package:hsc_timesheet/data/models/timesheet.dart';
import 'package:flutter/material.dart';
import 'package:hsc_timesheet/data/repositories/index.dart';

import '../../core/di.dart';
import 'index.dart';

class TimeSheetProvider extends ChangeNotifier with BaseProvider {
  final TimeSheetRepository timeSheetRepository;

  TimeSheetProvider(this.timeSheetRepository);

  late DateTime date;
  late TimeSheet _timeSheet;
  late bool loading = false;
  String? error;

  TimeSheet get timeSheet => _timeSheet;

  set timeSheet(TimeSheet value) {
    _timeSheet = value;
    notifyListeners();
  }

  void createTimeSheet(DateTime _date) async {
    var currentEmployee = sl<UserProvider>().currentUser!.employeeIds[0];
    var curentUser = sl<UserProvider>().currentUser!.id;
    date = _date;
    List<SheetsRow> list = [];
    for (int i = 1;
        i <= DateUtils.getDaysInMonth(_date.year, _date.month);
        i++) {
      if (DateTime(_date.year, _date.month, i).weekday > 5) {
        list.add(SheetsRow(
            date: DateTime(_date.year, _date.month, i),
            generalComing: 0,
            overTime: 0,
            contents: '',
            leave: null));
      } else {
        list.add(SheetsRow(
            date: DateTime(_date.year, _date.month, i),
            generalComing: 8,
            overTime: 0,
            contents: '',
            leave: null));
      }
    }
    timeSheet = TimeSheet(
        rows: list,
        sheetsDate: _date,
        employeeId: currentEmployee,
        userId: curentUser);
  }

  void setLeave(int index, String reason, double timeoff) {
    if (timeoff == 0) {
      timeSheet.rows[index].leave = null;
    } else {
      timeSheet.rows[index].leave = Leave(reason: reason, timeoff: timeoff);
    }
    notifyListeners();
  }

  Future<void> postTimeSheet() async {
    loading = true;
    notifyListeners();

    for (var row in timeSheet.rows) {
      await transformRowToOdoo(row, timeSheet.employeeId).then((value) async {
        var odooRow = value;
        for (OdooTimeSheetRow? row in odooRow!) {
          if (row!.unitAmount > 0) {
            var response = await timeSheetRepository.createOdooTimeSheet(row);
            if (response.status == 0) {
              error = null;
              logger.d('$response ok');
            } else {
              error = response.errors![0].message;
              logger.d('not ok');
            }
          }
        }
      });
    }

    loading = false;
    notifyListeners();
  }

  Future<void> editTimeSheet(SheetsRow row, int employeeId) async {
    loading = true;
    notifyListeners();

    await transformRowToOdoo(row, employeeId).then((value) async {
      var odooRow = value;
      for (OdooTimeSheetRow? row in odooRow!) {
        logger.d(row);
        if (row!.id != null) {
          if (row.unitAmount > 0) {
            var response = await timeSheetRepository.editOdooRow(row);
            if (response.status == 0) {
              error = null;
              logger.d('$response ok');
            } else {
              error = response.errors![0].message;
              logger.d('not ok');
            }
          } else {
            var response = await timeSheetRepository.deleteOdooRow(row);
            if (response.status == 0) {
              error = null;
              logger.d('$response ok');
            } else {
              error = response.errors![0].message;
              logger.d('not ok');
            }
          }
        } else if(row.unitAmount>0) {
          var response = await timeSheetRepository.createOdooTimeSheet(row);
          if (response.status == 0) {
            error = null;
            logger.d('$response ok');
          } else {
            error = response.errors![0].message;
            logger.d('not ok');
          }
        }
      }
    });

    loading = false;
    notifyListeners();
  }

  Future<void> approveTimeSheet(TimeSheet approvalTimeSheet) async {
    loading = true;
    notifyListeners();

    for (var row in approvalTimeSheet.rows) {
      await transformRowToOdoo(row, approvalTimeSheet.employeeId).then((value) async {
        var odooRow = value;
        for (OdooTimeSheetRow? row in odooRow!) {
          if (row!.unitAmount > 0) {
            var response = await timeSheetRepository.approveOdooRow(row);
            if (response.status == 0) {
              error = null;
              logger.d('$response ok');
            } else {
              error = response.errors![0].message;
              logger.d('not ok');
            }
          }
        }
      });
    }

    loading = false;
    notifyListeners();
  }

  Future<void> deleteTimeSheet(TimeSheet declineTimeSheet) async {
    loading = true;
    notifyListeners();

    for (var row in declineTimeSheet.rows) {
      await transformRowToOdoo(row, declineTimeSheet.employeeId).then((value) async {
        var odooRow = value;
        for (OdooTimeSheetRow? row in odooRow!) {
          if (row!.unitAmount > 0) {
            var response = await timeSheetRepository.deleteOdooRow(row);
            if (response.status == 0) {
              error = null;
              logger.d('$response ok');
            } else {
              error = response.errors![0].message;
              logger.d('not ok');
            }
          }
        }
      });
    }

    loading = false;
    notifyListeners();
  }


  Future<List?> transformRowToOdoo(SheetsRow row, int employeeId) async {
    int gcId = await timeSheetRepository
        .getProjectId('General coming')
        .then((value) => value.data!);

    int otId = await timeSheetRepository
        .getProjectId('Over Time')
        .then((value) => value.data!);
    int leaveId = await timeSheetRepository
        .getProjectId('Leave')
        .then((value) => value.data!);

    List<OdooTimeSheetRow?> odooRow = [];

    var rowGC = await timeSheetRepository
        .getRowId(gcId, row.date, employeeId)
        .then((value) => value.data);

    var rowOT = await timeSheetRepository
        .getRowId(otId, row.date, employeeId)
        .then((value) => value.data);

    var rowLeave = await timeSheetRepository
        .getRowId(leaveId, row.date, employeeId)
        .then((value) => value.data);
    odooRow.add(OdooTimeSheetRow(
        id: rowGC,
        name: row.contents,
        projectIdOdoo: gcId,
        employeeIdOdoo: employeeId,
        taskIdOdoo: null,
        date: row.date,
        userIdOdoo: null,
        unitAmount: row.generalComing));

    odooRow.add(OdooTimeSheetRow(
        id: rowOT,
        name: row.contents,
        projectIdOdoo: otId,
        employeeIdOdoo: employeeId,
        taskIdOdoo: null,
        date: row.date,
        userIdOdoo: null,
        unitAmount: row.overTime));

    odooRow.add(OdooTimeSheetRow(
        id: rowLeave,
        name: row.contents,
        projectIdOdoo: row.leave==null?null:leaveId,
        employeeIdOdoo: employeeId,
        taskIdOdoo: row.leave == null
            ? null
            : await timeSheetRepository
                .getTaskId(row.leave!.reason!)
                .then((value) => value.data!),
        date: row.date,
        userIdOdoo: null,
        unitAmount: row.leave == null ? 0 : row.leave!.timeoff!));

    logger.d(odooRow);
    return odooRow;
  }



}
