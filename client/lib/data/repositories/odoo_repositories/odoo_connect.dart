import 'package:client/data/models/app_session.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class OdooConnect{
  final client = OdooClient('http://172.29.4.126:8069');

  Future<dynamic> authentication(String email, String password) async {
    try {
      var res = await client.authenticate('odoo', email, password);
      AppSession.session = res ;
      return res;
    } on OdooException catch (e) {
      print(e);
    }
  }
  Future<dynamic> callUser() async {
    try {
      await client.authenticate('odoo', 'admin', 'admin');
      var res = await client.callKw({
        'model': 'account.analytic.line',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [['user_id','=',1]],
          'fields': [],
        },
      });
      return res;
    } on OdooException catch (e) {
      print(e);
    }
  }
}