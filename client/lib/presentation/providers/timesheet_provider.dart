
import 'package:client/data/models/timesheet.dart';
import 'package:client/data/repositories/mocks/timesheet_repository_mock.dart';
import 'package:flutter/material.dart';
class TimeSheetProvider extends ChangeNotifier {

  final TimeSheetRepositoryMock timeSheetRepository;
  TimeSheetProvider(this.timeSheetRepository);

  late DateTime date;
  late TimeSheet _timesheet;
  late bool loading = false;



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
        _timesheet = TimeSheet(rows: list, sheetsDate: _date, userId: 1, approval: false);

  }
  void setLeave(int index, String reason, double timeoff){
    if(timeoff == 0){
      _timesheet.rows[index].leave = null;
    }else {
      _timesheet.rows[index].leave = Leave(
        reason: reason,
        timeoff: timeoff);
    }
    notifyListeners();
  }
  void getTimeSheetById(int userId) async {

    loading = true;
    notifyListeners();
    final value=await timeSheetRepository.getTimeSheetById(1);
    loading = false;
    _timesheet= value;
    print(value);
    notifyListeners();
  }

}
