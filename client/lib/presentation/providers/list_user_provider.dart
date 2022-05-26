import 'package:client/data/models/timesheet.dart';
import 'package:client/data/models/user.dart';
import 'package:client/data/repositories/mocks/user_repository_mock.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class ListUserProvider extends ChangeNotifier {

  final UserRepositoryMock userRepository;
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
