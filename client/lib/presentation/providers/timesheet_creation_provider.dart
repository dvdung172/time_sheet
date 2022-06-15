import 'package:hsc_timesheet/core/logger.dart';
import 'package:hsc_timesheet/data/models/app_session.dart';
import 'package:hsc_timesheet/data/models/odoo_timesheet_row.dart';
import 'package:hsc_timesheet/data/models/timesheet.dart';
import 'package:flutter/material.dart';
import 'package:hsc_timesheet/data/repositories/index.dart';
import 'package:hsc_timesheet/presentation/providers/base_provider.dart';

import '../../core/di.dart';
import 'index.dart';

class TimeSheetProvider extends ChangeNotifier with BaseProvider {
  final TimeSheetRepository timeSheetRepository;

  TimeSheetProvider(this.timeSheetRepository);

  late DateTime date;
  late TimeSheet _timesheet;
  late bool loading = false;
  String? error;

  TimeSheet get timeSheet => _timesheet;

  void createTimeSheet(DateTime _date) async {
    var currentUser = sl<UserProvider>().currentUser!.employeeIds;
    print(currentUser);

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
    _timesheet = TimeSheet(
        rows: list,
        sheetsDate: _date,
        employeeId: currentUser,
        approval: false);
  }

  void setLeave(int index, String reason, double timeoff) {
    if (timeoff == 0) {
      _timesheet.rows[index].leave = null;
    } else {
      _timesheet.rows[index].leave = Leave(reason: reason, timeoff: timeoff);
    }
    notifyListeners();
  }

  Future<void> postTimeSheet() async {

    loading = true;
    notifyListeners();

    await transformToOdoo(timeSheet).then((value) async {
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
    // transformToOdoo(timeSheet);
    // var response = await timeSheetRepository.createOdooTimeSheet(odooRow![0]!);


    loading = false;
    notifyListeners();
  }

  Future<List?> transformToOdoo(TimeSheet? timesheet) async {
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
            displayName: row.contents,
            projectIdOdoo: gcId,
            employeeIdOdoo: timesheet.employeeId,
            taskIdOdoo: null,
            date: row.date,
            userIdOdoo: null,
            unitAmount: row.generalComing));
      }
      if (row.overTime > 0) {
        odooRow.add(OdooTimeSheetRow(
            displayName: row.contents,
            projectIdOdoo: otId,
            employeeIdOdoo: timesheet.employeeId,
            taskIdOdoo: null,
            date: row.date,
            userIdOdoo: null,
            unitAmount: row.overTime));
      }
      if (row.leave != null) {
        odooRow.add(OdooTimeSheetRow(
            displayName: row.contents,
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
    logger.d(odooRow[1]);
    return odooRow;
  }
}
