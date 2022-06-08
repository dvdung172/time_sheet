import 'dart:io';

import 'package:client/data/models/app_session.dart';
import 'package:client/data/models/employee.dart';
import 'package:client/data/models/user.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class EmployeeRepository{

  final client = AppSession.baseURL;

  Future<List<Employee>> callListEmployee() async {
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
            '__last_update',
            'user_id',
          ],
        },
      });
      final List<Employee> user = await res
          .map<Employee>((item) => Employee.fromRPC(item))
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