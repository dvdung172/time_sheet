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
  Future<List<User>> callListUser() async {
    try {
      var res = await client.callKw({
        'model': 'hr.employee',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [],
          'fields': [
            'name',
            'image_small',
            'active',
            'id',
            'work_email',
            'job_id',
            'department_id',
            'work_phone',
            '__last_update'
          ],
        },
      });
      final List<User> user = await res
          .map<User>((item) => User.fromRPC(item))
          .toList();
      return user;
    } on OdooException catch (e) {
      print('/////');
      print(e);
      client.close();
      exit(-1);
    }
  }
}