import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hsc_timesheet/core/constants.dart';
import 'package:hsc_timesheet/core/exceptions/api_exception.dart';
import 'package:hsc_timesheet/core/exceptions/remote_exception.dart';
import 'package:hsc_timesheet/core/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:hsc_timesheet/data/repositories/server/api_connection.dart';
import 'package:http/http.dart';

class ApiConnectionMock extends ApiConnection {
  ApiConnectionMock({required ApiConfig apiConfig})
      : super(apiConfig: apiConfig);

  @override
  Future<Response> execute(ApiRequest request) async {
    if (await (Connectivity().checkConnectivity()) != ConnectivityResult.none) {
      final future = rootBundle.loadString(request.endPoint);
      return future
          .then((v) => _parseResponse(Response(v, HttpStatus.ok, headers: {
                HttpHeaders.contentTypeHeader: 'application/json;charset=utf-8'
              })))
          .catchError(_handleError);
    }
    throw RemoteException(errorMessage: tr('messages.no_internet_connection'));
  }

  Future<Response> _handleError(Object error) {
    logger.e(error);
    if (error is ApiException) throw error;
    if (error is Exception) throw error;
    throw Exception(tr('messages.server_error'));
  }

  Future<Response> _parseResponse(Response response) async {
    if (response.statusCode != HttpStatus.ok) {
      logger.e('APIs error with status ${response.statusCode}', response.body);
      throw ApiException(
          statusCode: response.statusCode, cause: tr('messages.server_error'));
    }
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>?;
    final resultCode = (jsonResponse?['result'] as int?) ?? ResultCode.fatal;
    if (resultCode != ResultCode.success) {
      logger.e('APIs error with status ${response.statusCode}', jsonResponse);
      throw ApiException(
          statusCode: response.statusCode,
          cause: jsonResponse?['message'] as String? ??
              tr('messages.server_error'));
    }

    return response;
  }
}
