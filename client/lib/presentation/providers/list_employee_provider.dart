import 'package:hsc_timesheet/data/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:hsc_timesheet/data/repositories/index.dart';

class ListEmployeeProvider extends ChangeNotifier {
  final EmployeeRepository employeeRepository;
  bool loading = false;
  String? error;
  List<Employee> users = [];

  ListEmployeeProvider(this.employeeRepository);

  Future<void> getAllEmployee() async {
    loading = true;
    notifyListeners();
    final response = await employeeRepository.getEmployeeList();
    loading = false;
    // print('===============');
    // print(response.data);
    if (response.status == 0) {
      users = response.data ?? [];
      error = null;
    } else {
      users = [];
      error = response.errors![0].message;
    }

    notifyListeners();
  }
}
