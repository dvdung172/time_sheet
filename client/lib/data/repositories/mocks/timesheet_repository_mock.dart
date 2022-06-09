import 'dart:convert';

import 'package:hsc_timesheet/core/base/base_response.dart';
import 'package:hsc_timesheet/data/models/timesheet.dart';
import 'package:hsc_timesheet/data/repositories/server/api_connection.dart';
import 'package:hsc_timesheet/data/repositories/timesheet_repository.dart';
import 'package:flutter/services.dart';

class TimeSheetRepositoryMock extends TimeSheetRepository {
  TimeSheetRepositoryMock({required ApiConnection connection});

  @override
  Future<BaseResponse<TimeSheet>> getTimeSheetById(int timeSheetId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final data = await rootBundle.loadString('assets/mocks/one_sheet.json');
    return BaseResponse.success(TimeSheet.fromJson(json.decode(data)));
  }

  @override
  Future<BaseResponse<List<TimeSheet>>> getAllTimeSheet(int user) async {
    final data = await rootBundle.loadString('assets/mocks/all_sheets.json');

    // logger.d('Response: $data');

    final List<TimeSheet> timeSheets = await json
        .decode(data)
        .map<TimeSheet>((item) => TimeSheet.fromJson(item))
        .toList();
    return BaseResponse.success(
        timeSheets.where((e) => e.userId == user).toList());
  }

  @override
  Future<BaseResponse<List<TimeSheet>>> getTimeSheetUnApproved() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final data = await rootBundle.loadString('assets/mocks/all_sheets.json');

    final List<TimeSheet> timeSheets = await json
        .decode(data)
        .map<TimeSheet>((item) => TimeSheet.fromJson(item))
        .toList();
    return BaseResponse.success(
        timeSheets.where((e) => e.approval == false).toList());
  }
}
