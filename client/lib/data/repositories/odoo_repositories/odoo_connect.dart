import 'dart:io';

import 'package:client/data/models/app_session.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class OdooConnect {
  final client = AppSession.baseURL;

  Future<dynamic> authentication(String email, String password) async {
    try {
      var res = await client.authenticate('odoo', email, password);
      AppSession.session = res;
      return res.userId;
    } on OdooException catch (e) {
      print(e);
    }
  }

  Future<dynamic> getAllTimeSheet(int userId) async {
    try {
      var res = await client.callKw({
        'model': 'account.analytic.line',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['user_id', '=', userId],
          ],
          'fields': [
            'user_id',
            'account_id',
            'name',
            'unit_amount',
            'date',
            'display_name',
          ],
        },
      });
      return res;
    } on OdooException catch (e) {
      print(e);
      client.close();
      exit(-1);
    }
  }

}
