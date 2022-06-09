import 'dart:convert';
import 'dart:io';

import 'package:hsc_timesheet/core/constants.dart';
import 'package:hsc_timesheet/core/logger.dart';
import 'package:hsc_timesheet/data/models/timesheet.dart';
import 'api_connection.dart';

class ServerTimeSheetRepository {
  final ApiConnection connection;

  ServerTimeSheetRepository(this.connection);

  Future<TimeSheet> getTimeSheetById(int timeSheetId) async {
    var response = await connection.execute(ApiRequest(
      endPoint: '${Endpoints.timeSheetApiUrl}/$timeSheetId',
      method: ApiMethod.get,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
    ));

    return TimeSheet.fromJson(json.decode(response.body));
  }

  Future<List<TimeSheet>> getAllTimeSheet(int user) async {
    var response = await connection.execute(ApiRequest(
      endPoint: Endpoints.timeSheetApiUrl,
      method: ApiMethod.get,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
    ));

    logger.d('Response: ${response.body}');

    final productList = await json
        .decode(response.body)
        .map<TimeSheet>((item) => TimeSheet.fromJson(item))
        .toList();
    return productList;
  }

  Future<List<TimeSheet>> getTimeSheetUnApproved() async {
    var response = await connection.execute(ApiRequest(
      endPoint: '${Endpoints.timeSheetApiUrl}/approve=false',
      method: ApiMethod.get,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
    ));

    logger.d('Response: ${response.body}');

    final productList = await json
        .decode(response.body)
        .map<TimeSheet>((item) => TimeSheet.fromJson(item))
        .toList();
    return productList;
  }
}
