import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants.dart';
import 'package:client/core/exceptions/api_exception.dart';
import 'package:client/core/exceptions/remote_exception.dart';
import 'package:client/core/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart';

class ApiConfig {
  int connectTimeout = 50000;
}

enum ApiMethod { get, post, put, delete }

class ApiRequest {
  ApiRequest({
    required this.endPoint,
    required this.method,
    this.headers,
    this.body,
    this.queryParameters,
  });

  String endPoint;
  ApiMethod method;
  dynamic body;
  Map<String, String>? headers;
  Map<String, String>? queryParameters;
}

class ApiConnection {
  ApiConnection({required this.apiConfig});

  final ApiConfig apiConfig;



  Future<Response> execute(ApiRequest request) async {
    Future<Response> future;
    if (await (Connectivity().checkConnectivity()) != ConnectivityResult.none) {
      switch (request.method) {
        case ApiMethod.get:
          future = _get(request);
          break;
        case ApiMethod.post:
          future = _post(request);
          break;
        case ApiMethod.delete:
          future = _delete(request);
          break;
        case ApiMethod.put:
          future = _put(request);
          break;
      }
      return future
          .then<Response>(_parseResponse)
          .timeout(Duration(milliseconds: apiConfig.connectTimeout))
          .catchError(_handleError);
    }
    throw RemoteException(errorMessage: tr('messages.no_internet_connection'));
  }

  Future<Response> _handleError(Object error) {
    if (error is SocketException) {
      throw RemoteException(
          errorMessage: tr('messages.can_not_connect_server'));
    }
    if (error is TimeoutException) {
      throw RemoteException(errorMessage: tr('messages.connection_timed_out'));
    }
    if (error is ApiException) throw error;
    if (error is Exception) throw error;
    throw Exception(tr('messages.server_error'));
  }

  Future<Response> _parseResponse(Response response) async {
    logger.d('${response.request?.method} ${response.request?.url}, response status: ${response.statusCode}');
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
          cause:
              jsonResponse?['message'] as String? ?? tr('messages.an_error'));
    }

    return response;
  }

  Future<Response> _get(ApiRequest request) async {
    var query = queryParametersToString(request.queryParameters ?? {});

    return get(
      Uri.parse("${request.endPoint}${query.isNotEmpty ? '?$query' : ''}"),
      headers: request.headers,
    );
  }

  Future<Response> _post(ApiRequest request) async {
    return post(Uri.parse(request.endPoint),
        headers: request.headers, body: request.body);
  }

  Future<Response> _put(ApiRequest request) async {
    return put(Uri.parse(request.endPoint),
        headers: request.headers, body: request.body);
  }

  Future<Response> _delete(ApiRequest request) async {
    return delete(Uri.parse(request.endPoint),
        headers: request.headers, body: request.body);
  }

  String queryParametersToString(Map<String, String> queryParameters) {
    var query = '';
    queryParameters.forEach((key, value) {
      query += '&$key=$value';
    });

    return query.replaceFirst(RegExp(r'&'), '');
  }
}
