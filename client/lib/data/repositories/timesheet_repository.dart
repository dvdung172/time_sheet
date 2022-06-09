import 'package:hsc_timesheet/core/base/base_response.dart';
import 'package:hsc_timesheet/data/models/timesheet.dart';

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
}
