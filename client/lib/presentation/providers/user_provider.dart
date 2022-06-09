import 'package:hsc_timesheet/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:hsc_timesheet/data/repositories/user_repository.dart';
import 'package:hsc_timesheet/presentation/providers/base_provider.dart';

class UserProvider extends ChangeNotifier with BaseProvider {
  final UserRepository userRepository;
  bool loading = false;
  String? error;
  late User? currentUser;

  UserProvider(this.userRepository);

  Future<void> getUserById(int id) async {
    loading = true;
    notifyListeners();
    final response = await userRepository.getUserById(id);
    loading = false;
    if (response.status == 0) {
      currentUser = response.data;
      error = null;
    } else {
      currentUser = null;
      error = response.errors![0].message;
    }

    notifyListeners();
  }
}
