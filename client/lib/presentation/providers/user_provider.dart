import 'package:client/data/models/user.dart';
import 'package:client/data/repositories/odoo_repositories/user_repository.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {

  final UserRepository userRepository;
  bool loading = false;
  late User users ;

  UserProvider(this.userRepository);

  void callUser(int id) async {
    loading = true;
    notifyListeners();
    final value = await userRepository.callUser(id);
    loading = false;
    users= value;
    print(users.toString());
    notifyListeners();
  }


}