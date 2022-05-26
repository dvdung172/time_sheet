import 'package:client/data/models/timesheet.dart';
import 'package:client/data/repositories/mocks/timesheet_repository_mock.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class ListTimeSheetsProvider extends ChangeNotifier {

  final TimeSheetRepositoryMock timeSheetRepository;
  bool loading = false;
  List<TimeSheet> timeSheets = [];

  ListTimeSheetsProvider(this.timeSheetRepository);

  void getAllTimeSheets(int userId) async {

      loading = true;
      notifyListeners();
      final value = await timeSheetRepository.getAllTimeSheet(userId);
      loading = false;
      timeSheets= value;
      notifyListeners();

  }

  List<TimeSheet> get4Month(DateTime userCreatedDate){
    DateFormat dateFormat=DateFormat(DateFormat.YEAR_NUM_MONTH);
    List<TimeSheet> list = [];
    for(int i=3;i>=0;i--){
      final date = DateTime(userCreatedDate.year, userCreatedDate.month - i);
      var ts = timeSheets.firstWhereOrNull((element) => dateFormat.format(element.sheetsDate) == dateFormat.format(date));
      if(ts != null){
        list.add(ts);
      }
    }
    return list;
  }

  Future<List<TimeSheet>> getTimeSheetUnapproved() async {
      loading = true;
      notifyListeners();
      final List<TimeSheet> value = await timeSheetRepository.getTimeSheetUnApproved();
      loading = false;
      notifyListeners();
      return value;
  }
}
