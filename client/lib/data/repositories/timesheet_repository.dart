import 'package:hsc_timesheet/core/base/base_response.dart';
import 'package:hsc_timesheet/data/models/timesheet.dart';

import '../models/index.dart';

class TimeSheetRepository {
  Future<BaseResponse<List<TimeSheet>>> getAllTimeSheet(int userId) async {
    throw UnimplementedError('TimeSheetRepository.getAllTimeSheet');
  }

  Future<BaseResponse<TimeSheet>> getTimeSheetById(int timeSheetId) async {
    throw UnimplementedError('TimeSheetRepository.getTimeSheetById');
  }

  Future<BaseResponse<List<TimeSheet>>> getTimeSheetUnApproved() async {
    throw UnimplementedError('TimeSheetRepository.getTimeSheetUnApproved');
  }

  Future<BaseResponse<int>> getProjectId(String name) async {
    throw UnimplementedError('TimeSheetRepository.getProjectId');
  }

  Future<BaseResponse<int>> getTaskId(String name) async {
    throw UnimplementedError('TimeSheetRepository.getTaskId');
  }

  Future<BaseResponse<int>> createOdooTimeSheet(OdooTimeSheetRow row) async {
    throw UnimplementedError('TimeSheetRepository.getProjectId');
  }
  Future<BaseResponse<bool>> editOdooRow(OdooTimeSheetRow row) async {
    throw UnimplementedError('TimeSheetRepository.getProjectId');
  }
}
