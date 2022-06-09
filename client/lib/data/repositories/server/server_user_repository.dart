import 'dart:convert';
import 'dart:io';

import 'package:hsc_timesheet/core/constants.dart';
import 'package:hsc_timesheet/core/logger.dart';
import 'package:hsc_timesheet/data/models/timesheet.dart';
import 'package:hsc_timesheet/data/models/user.dart';
import 'package:hsc_timesheet/data/repositories/server/api_connection.dart';

class ServerUserRepository {
  final ApiConnection connection;

  ServerUserRepository(this.connection);

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

  // Future<void> saveCredential(String username, String password) {
  //   SharedPreferecens.save('username', username);
  //   SharedPreferecens.save('password', password);
  // }
  //
  // Future<void> readCredential() {
  //   SharedPreferecens.save('username', username);
  //   SharedPreferecens.save('password', password);
  // }

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
