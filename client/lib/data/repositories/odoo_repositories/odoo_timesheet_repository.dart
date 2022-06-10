import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:hsc_timesheet/core/base/base_response.dart';
import 'package:hsc_timesheet/core/logger.dart';
import 'package:hsc_timesheet/data/models/timesheet.dart';
import 'package:hsc_timesheet/data/repositories/index.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import 'odoo_connect.dart';

class OdooTimeSheetRepository extends TimeSheetRepository with OdooConnect {
  final OdooClient client;

  OdooTimeSheetRepository(this.client);

  @override
  Future<BaseResponse<List<TimeSheet>>> getAllTimeSheet(int userId) async {
    try {
      var data = await client.callKw({
        'model': 'account.analytic.line',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['user_id', '=', userId],
            // ["date", ">=", "2022-06-01"],
            // ["date", "<=", "2022-06-30"],
          ],
          'fields': [
            'user_id',
            'unit_amount',
            'project_id',
            'employee_id',
            'task_id',
            'date',
            'display_name',
          ],
        },
      });
      logger.d('getAllTimeSheet: $data');
      final List<TimeSheet> timeSheets = await data
          .map<TimeSheet>((item) => TimeSheet.fromJson(item))
          .toList();

      return BaseResponse.success(timeSheets);
    } on OdooException catch (e) {
      await handleError(e);
      return BaseResponse.fail([e.message]);
    } on Exception catch (e) {
      await handleError(e);
      return BaseResponse.fail([tr('message.server_error')]);
    }
  }

  @override
  Future<BaseResponse<TimeSheet>> getTimeSheetById(int timeSheetId) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      final data = await rootBundle.loadString('assets/mocks/one_sheet.json');
      var timesheetData = TimeSheet.fromJson(json.decode(data));

      return BaseResponse.success(timesheetData);
    } on OdooException catch (e) {
      await handleError(e);
      return BaseResponse.fail([e.message]);
    } on Exception catch (e) {
      await handleError(e);
      return BaseResponse.fail([tr('message.server_error')]);
    }
  }

  @override
  Future<BaseResponse<List<TimeSheet>>> getTimeSheetUnApproved() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      final data = await rootBundle.loadString('assets/mocks/all_sheets.json');

      final List<TimeSheet> timeSheets = await json
          .decode(data)
          .map<TimeSheet>((item) => TimeSheet.fromJson(item))
          .toList();
      var unapprovedList =
          timeSheets.where((e) => e.approval == false).toList();

      return BaseResponse.success(unapprovedList);
    } on OdooException catch (e) {
      await handleError(e);
      return BaseResponse.fail([e.message]);
    } on Exception catch (e) {
      await handleError(e);
      return BaseResponse.fail([tr('message.server_error')]);
    }
  }
}
