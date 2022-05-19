import 'package:client/core/logger.dart';
import 'package:client/data/models/timesheet.dart';
import 'package:client/data/repositories/mocks/timesheet_repository_mock.dart';
import 'package:flutter/material.dart';

class TimeSheetProvider extends ChangeNotifier {
  // final TimeSheetRepositoryMock timSheetRepository;
  // bool loading = false;
  // TimeSheet? timeSheet;
  //
  // TimeSheetProvider(this.timSheetRepository);
  //
  // Future<void> getTimeSheetById(int timeSheetId) async {
  //   loading = true;
  //   notifyListeners();
  //
  //   logger.d('getTimeSheet');
  //
  //   final value = await timSheetRepository.getTimeSheetById(timeSheetId);
  //   loading = false;
  //   timeSheet = value;
  //   notifyListeners();
  // }

  final TimeSheetRepositoryMock timeSheetRepository;
  bool loading = false;
  List<TimeSheet> timeSheets = [];

  TimeSheetProvider(this.timeSheetRepository);

  void getAllTimeSheets() async {

    logger.d('getProducts');

    if (timeSheets.isEmpty) {

      loading = true;
      notifyListeners();
      final value = await timeSheetRepository.getAllTimeSheet();
      loading = false;
      timeSheets = value;
      notifyListeners();
    }
  }
}
