import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  // private constructor, do not allow to initalize instance of this class
  Constants._();

  /// Key
  static const apiTokenKey = '__api_token_key__';

  static const double DEFAULT_PAGE_PADDING = 20;
}

class Endpoints {
  // Base url
  static final baseURL = dotenv.env['API_URL'];
  static final apiURL = '$baseURL/api';
  static final imageURL = '$baseURL/img';

  // Auth
  static final String authApiURL = '$apiURL/auth';
  static final String logoutApiURL = '$apiURL/logout';


  //timessheet
  static final String timeSheetApiUrl = '$apiURL/timeSheet';
}

class ResultCode {
  static const int success = 0;
  static const int error = 1;
  static const int fatal = 9999;
}

final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi-VN');
