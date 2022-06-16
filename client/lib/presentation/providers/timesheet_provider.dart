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
  set timeSheet(TimeSheet value){
    _timeSheet = value;
    notifyListeners();
  }

  void createTimeSheet(DateTime _date) async {
    var currentUser = sl<UserProvider>().currentUser!.employeeIds;

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
        employeeId: currentUser,
        approval: false);
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

    await transformTimeSheetToOdoo(timeSheet).then((value) async {
      var odooRow = value;
      for (var row in odooRow!) {
        var response = await timeSheetRepository.createOdooTimeSheet(row!);
        if (response.status == 0) {
          error = null;
          logger.d('$response ok');
        } else {
          error = response.errors![0].message;
          logger.d('not ok');
        }
      }
    });

    loading = false;
    notifyListeners();
  }
  Future<void> editTimeSheet() async {
    loading = true;
    notifyListeners();

    print('=========================');

    await transformTimeSheetToOdoo(timeSheet).then((value) async {
      var odooRow = value;
      logger.d('transformed row: $odooRow');
      for (var row in odooRow!) {
        var response = await timeSheetRepository.editOdooRow(row!);//TODO: get OdooRowId
        if (response.status == 0) {
          error = null;
          logger.d('$response ok');
        } else {
          error = response.errors![0].message;
          logger.d('not ok');
        }
      }
    });

    loading = false;
    notifyListeners();
  }

  Future<List?> transformTimeSheetToOdoo(TimeSheet? timesheet) async {
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
    if (timesheet!.rows.isEmpty) {
      return null;
    }
    for (var row in timesheet.rows) {
      if (row.generalComing > 0) {
        odooRow.add(OdooTimeSheetRow(
            name: row.contents,
            projectIdOdoo: gcId,
            employeeIdOdoo: timesheet.employeeId,
            taskIdOdoo: null,
            date: row.date,
            userIdOdoo: null,
            unitAmount: row.generalComing));
      }
      if (row.overTime > 0) {
        odooRow.add(OdooTimeSheetRow(
            name: row.contents,
            projectIdOdoo: otId,
            employeeIdOdoo: timesheet.employeeId,
            taskIdOdoo: null,
            date: row.date,
            userIdOdoo: null,
            unitAmount: row.overTime));
      }
      if (row.leave != null) {
        odooRow.add(OdooTimeSheetRow(
            name: row.contents,
            projectIdOdoo: leaveId,
            employeeIdOdoo: timesheet.employeeId,
            taskIdOdoo: await timeSheetRepository
                .getTaskId(row.leave!.reason!)
                .then((value) => value.data!),
            date: row.date,
            userIdOdoo: null,
            unitAmount: row.leave!.timeoff!));
      }
    }
    return odooRow;
  }
}
