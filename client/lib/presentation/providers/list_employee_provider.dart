import 'package:client/data/models/employee.dart';
import 'package:client/data/models/user.dart';
import 'package:client/data/repositories/odoo_repositories/employee_repository.dart';
import 'package:client/data/repositories/odoo_repositories/user_repository.dart';
// import 'package:client/data/repositories/user_repository.dart';

import 'package:flutter/material.dart';

class ListEmployeeProvider extends ChangeNotifier {

  final EmployeeRepository employeeRepository;
  bool loading = false;
  List<Employee> users = [];

  ListEmployeeProvider(this.employeeRepository);

  void getAllUser() async {
    loading = true;
    notifyListeners();
    final value = await employeeRepository.callListEmployee();
    loading = false;
    users= value;
    notifyListeners();
  }


}
