import 'dart:convert';

import 'package:client/data/models/timesheet.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
class TimeSheetProvider extends ChangeNotifier {
  late DateTime date;
  late TimeSheet _timesheet;

  TimeSheet get timeSheet=> _timesheet;

  void createTimeSheet(DateTime _date){
        date = _date;
        List<SheetsRow> list = [];
        for(int i = 1; i<=DateUtils.getDaysInMonth(_date.year, _date.month); i ++ ){
          if(DateTime(_date.year,_date.month,i).weekday>5){
            list.add(SheetsRow(date: DateTime(_date.year, _date.month, i ), generalComing: 0, overTime: 0, contents: null, leave: null));
          }
          else {
            list.add(SheetsRow(date: DateTime(_date.year, _date.month, i ), generalComing: 8, overTime: 0, contents: null, leave: null));
          }
        }
        _timesheet = TimeSheet(rows: list, sheetsDate: _date, userId: 1);

  }
  void setLeave(int index, String reason, double timeoff){
    _timesheet.rows[index].leave = Leave(
        reason: reason,
        timeoff: timeoff);
    notifyListeners();
  }

}
