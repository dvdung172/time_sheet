import 'dart:convert';

import 'package:client/data/models/timesheet.dart';
import 'package:client/data/repositories/api_connection.dart';
import 'package:client/data/repositories/timesheet_repository.dart';
import 'package:flutter/services.dart';

class TimeSheetRepositoryMock extends TimeSheetRepository {
  TimeSheetRepositoryMock({required ApiConnection connection})
      : super(connection);

  @override
  Future<TimeSheet> getTimeSheetById(int timeSheetId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final data = await rootBundle.loadString('assets/mocks/one_sheet.json');
    return TimeSheet.fromJson(json.decode(data));
    
  }
}
