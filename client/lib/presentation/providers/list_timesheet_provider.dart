import 'package:flutter/cupertino.dart';
import 'package:hsc_timesheet/core/logger.dart';
import 'package:hsc_timesheet/data/models/timesheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:hsc_timesheet/data/repositories/index.dart';
import 'package:hsc_timesheet/presentation/providers/base_provider.dart';

class ListTimeSheetsProvider extends ChangeNotifier with BaseProvider {
  final TimeSheetRepository timeSheetRepository;
  bool loading = false;
  String? error;
  List<TimeSheet> timeSheets = [];
  List<TimeSheet> unapprovedTimeSheets = [];
  List<TimeSheet> approvedTimeSheets = [];

  ListTimeSheetsProvider(this.timeSheetRepository);

  void getAllTimeSheets(int userId) async {
    loading = true;
    notifyListeners();
    var response = await timeSheetRepository.getAllTimeSheet(userId);
    loading = false;
    if (response.status == 0) {
      timeSheets=response.data??[];
      // if(timeSheets.isNotEmpty){
      //   timeSheets = timeSheets.replaceRange(0, timeSheets.length, [fillTimeSheet(timeSheets)]);
      // }
      //
      // print('========================${timeSheets[0].rows.length}');
      error = null;
    } else {
      timeSheets = [];
      error = response.errors![0].message;
    }

    notifyListeners();
  }

  void getAllApprovedTimesheets(int userId) async {
    loading = true;
    notifyListeners();
    var response = await timeSheetRepository.getAllTimeSheet(userId);
    loading = false;

    if (response.status == 0) {
      approvedTimeSheets = (response.data ?? [])
          .where((element) => element.approval == true)
          .toList();
      error = null;
    } else {
      error = response.errors![0].message;
      approvedTimeSheets = [];
    }
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

  Future<void> getTimeSheetUnapproved() async {
    loading = true;
    notifyListeners();
    var response = await timeSheetRepository.getTimeSheetUnApproved();
    loading = false;
    if (response.status == 0) {
      error = null;
      unapprovedTimeSheets = response.data ?? [];
    } else {
      error = response.errors![0].message;
      unapprovedTimeSheets = [];
    }
    notifyListeners();
  }

  TimeSheet fillTimeSheet(TimeSheet timeSheet) {
    DateTime _date = timeSheet.sheetsDate;
    int count = DateUtils.getDaysInMonth(_date.year, _date.month);
    List<SheetsRow> list = List.generate(count, (index) => SheetsRow(date:  DateTime(_date.year, _date.month, index+1), generalComing: 0, overTime: 0, leave: null, contents: ''));
      for (int i = 1; i <= count; i++) {
        for (var item in timeSheet.rows) {
          if(item.date.day == i){
            list[i] = item;
          }
      }
    }
      timeSheet = TimeSheet(sheetsDate: _date, userId: timeSheet.userId, rows: list, approval: timeSheet.approval);
      // print(timeSheet.rows.toString());
      return timeSheet;
  }
}
