import 'package:hsc_timesheet/core/di.dart';
import 'package:hsc_timesheet/core/logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:hsc_timesheet/data/repositories/index.dart';
import 'package:hsc_timesheet/presentation/providers/base_provider.dart';
import 'package:hsc_timesheet/presentation/providers/index.dart';

import '../../data/models/index.dart';

class ListTimeSheetsProvider extends ChangeNotifier with BaseProvider {
  final TimeSheetRepository timeSheetRepository;
  bool loading = false;
  String? error;
  List<TimeSheet> timeSheets = [];
  List<TimeSheet> unapprovedTimeSheets = [];
  List<TimeSheet> approvedTimeSheets = [];

  ListTimeSheetsProvider(this.timeSheetRepository);

  int currentUser = sl<UserProvider>().currentUser!.id;
  int currentEmployee = sl<UserProvider>().currentUser!.employeeIds[0];

  void getAllTimeSheets(int employeeId) async {
    loading = true;
    notifyListeners();
    var response = await timeSheetRepository.getAllTimeSheet(employeeId);
    loading = false;
    if (response.status == 0) {
      timeSheets = response.data ?? [];
      if (timeSheets.isNotEmpty) {
        for (int i = 0; i < timeSheets.length; i++) {
          timeSheets[i] = fillTimeSheet(timeSheets[i]);
        }
      }
      error = null;
    } else {
      timeSheets = [];
      error = response.errors![0].message;
    }

    notifyListeners();
  }

  Future<void> getAllApprovedTimeSheets(int employeeId) async {
    loading = true;
    notifyListeners();
    var response = await timeSheetRepository.getTimeSheetApproved(employeeId);
    loading = false;
    if (response.status == 0) {
      approvedTimeSheets = response.data ?? [];

      if (approvedTimeSheets.isNotEmpty) {
        for (int i = 0; i < approvedTimeSheets.length; i++) {
          approvedTimeSheets[i] = fillTimeSheet(approvedTimeSheets[i]);
        }
      }
      error = null;
    } else {
      approvedTimeSheets = [];
      error = response.errors![0].message;
    }

    notifyListeners();
  }

  Future<void> getAllUnApprovedTimeSheets() async {
    loading = true;
    notifyListeners();
    var response = await timeSheetRepository.getTimeSheetUnApproved();
    loading = false;
    if (response.status == 0) {
      unapprovedTimeSheets = response.data ?? [];

      if (unapprovedTimeSheets.isNotEmpty) {
        for (int i = 0; i < unapprovedTimeSheets.length; i++) {
          unapprovedTimeSheets[i] = fillTimeSheet(unapprovedTimeSheets[i]);
        }
      }
      error = null;
    } else {
      unapprovedTimeSheets = [];
      error = response.errors![0].message;
    }
    logger.d(unapprovedTimeSheets[0].employeeId);
    notifyListeners();
  }

  List<TimeSheet> get4Month(DateTime userCreatedDate) {
    DateFormat dateFormat = DateFormat(DateFormat.YEAR_NUM_MONTH);
    List<TimeSheet> list = [];
    for (int i = 3; i >= 0; i--) {
      final date = DateTime(userCreatedDate.year, userCreatedDate.month - i);
      var ts = timeSheets.firstWhereOrNull((element) =>
          dateFormat.format(element.sheetsDate) == dateFormat.format(date));
      if (ts != null) {
        list.add(ts);
      }
    }
    return list;
  }

  TimeSheet fillTimeSheet(TimeSheet timeSheet) {
    DateTime _date = timeSheet.sheetsDate;
    int count = DateUtils.getDaysInMonth(_date.year, _date.month);
    List<SheetsRow> list = List.generate(
        count,
        (index) => SheetsRow(
            date: DateTime(_date.year, _date.month, index + 1),
            generalComing: 0,
            overTime: 0,
            leave: null,
            contents: ''));
    for (int i = 0; i < count; i++) {
      for (var item in timeSheet.rows) {
        if (item.date.day == (i + 1)) {
          list[i] = item;
        }
      }
    }
    timeSheet = TimeSheet(
        sheetsDate: _date,
        employeeId: timeSheet.employeeId,
        rows: list,
        userId: timeSheet.userId);
    return timeSheet;
  }
}
