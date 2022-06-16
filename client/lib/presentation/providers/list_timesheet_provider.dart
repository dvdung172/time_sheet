import 'package:hsc_timesheet/core/logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:hsc_timesheet/data/repositories/index.dart';
import 'package:hsc_timesheet/presentation/providers/base_provider.dart';

import '../../data/models/index.dart';

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
      if(timeSheets.isNotEmpty){
        for(int i = 0; i<timeSheets.length;i++ ){
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

  Future<void> getAllApprovedTimesheets(int userId) async {
    loading = true;
    notifyListeners();
    var response = await timeSheetRepository.getAllTimeSheet(userId);
    loading = false;

    if (response.status == 0) {
      approvedTimeSheets = (response.data ?? [])
          .where((element) => element.approval == true)
          .toList();
      error = null;
      if(approvedTimeSheets.isNotEmpty){
        for(int i = 0; i<approvedTimeSheets.length;i++ ){
          approvedTimeSheets[i] = fillTimeSheet(approvedTimeSheets[i]);
        }
      }
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
      if(unapprovedTimeSheets.isNotEmpty){
        for(int i = 0; i<unapprovedTimeSheets.length;i++ ){
          unapprovedTimeSheets[i] = fillTimeSheet(unapprovedTimeSheets[i]);
        }
      }
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
      for (int i = 0; i < count; i++) {
        for (var item in timeSheet.rows) {
          if(item.date.day == (i+1)){
            list[i] = item;
          }
      }
    }
      timeSheet = TimeSheet(sheetsDate: _date, employeeId: timeSheet.employeeId, rows: list, approval: timeSheet.approval);
      return timeSheet;
  }

}
