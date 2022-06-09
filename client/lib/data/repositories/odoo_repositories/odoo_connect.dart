import 'package:hsc_timesheet/core/constants.dart';
import 'package:hsc_timesheet/core/extensions.dart';
import 'package:hsc_timesheet/core/logger.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:network_info_plus/network_info_plus.dart';

class OdooConnect {
  final client = OdooClient(Endpoints.baseURL);

  Future<void> handleError(Exception e, {String? additionalMessage}) async {
    var networkInfo = await _getNetworkInfo();

    logger.i('------------------------');
    if (additionalMessage != null) {
      logger.e(additionalMessage);
    }
    logger.e(e);
    logger.i('network: $networkInfo');
    logger.e(
        'stacktrace: ${StackTrace.current.getStackTrace(maxFrames: 8).join('. ')}');
    logger.i('------------------------');
  }

  Future<String> _getNetworkInfo() async {
    try {
      final info = NetworkInfo();

      var wifiIP = await info.getWifiIP(); // 192.168.1.100
      // 2001:0db8:85a3:0000:0000:8a2e:0370:7334
      var wifiIPv6 = await info.getWifiIPv6();
      var wifiSubmask = await info.getWifiSubmask(); // 255.255.255.0
      var wifiGateway = await info.getWifiGatewayIP(); // 192.168.1.1

      return '{ip: $wifiIP, ipV6: $wifiIPv6, subnet: $wifiSubmask, gateway: $wifiGateway}';
    } on Exception catch (e) {
      return 'N/A (${e.toString()})';
    }
  }
}
