import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants.dart';
import 'package:client/core/logger.dart';
import 'package:client/data/models/timesheet.dart';
import 'package:client/data/models/user.dart';
import 'package:client/data/repositories/api_connection.dart';


class UserRepository {
  final ApiConnection connection;

  UserRepository(this.connection);

  Future<User> getUserById(int timeSheetId) async {
    var response = await connection.execute(ApiRequest(
      endPoint: '${Endpoints.timeSheetApiUrl}/$timeSheetId',
      method: ApiMethod.get,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
    ));

    return User.fromJson(json.decode(response.body));
  }
  Future<List<User>> getAllUser() async {
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
}
