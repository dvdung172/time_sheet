import 'dart:io';

import 'package:client/data/models/app_session.dart';
import 'package:client/data/models/user.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class UserRepository{

  final client = AppSession.baseURL;

  Future<dynamic> callUser(int id) async {
    try {
      var res = await client.callKw({
        'model': 'res.users',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [ ['id', '=', id],],
          'fields': ['id','name','email','__last_update',''],
        },
      });
      return User.fromRPC(res[0]);
    } on OdooException catch (e) {
      print(e);
      client.close();
      exit(-1);
    }
  }
}