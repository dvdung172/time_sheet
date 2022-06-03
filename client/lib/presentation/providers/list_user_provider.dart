import 'package:client/data/models/user.dart';
import 'package:client/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class ListUserProvider extends ChangeNotifier {

  final UserRepository userRepository;
  bool loading = false;
  List<User> users = [];

  ListUserProvider(this.userRepository);

  void getAllUser() async {
    loading = true;
    notifyListeners();
    final value = await userRepository.getAllUser();
    loading = false;
    users= value;
    notifyListeners();

  }


}
