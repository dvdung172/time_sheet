import 'package:flutter/cupertino.dart';
import 'package:hsc_timesheet/core/base/base_response.dart';
import 'package:hsc_timesheet/data/models/app_session.dart';
import 'package:hsc_timesheet/data/repositories/user_repository.dart';
import 'package:hsc_timesheet/presentation/providers/base_provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class AuthProvider extends ChangeNotifier with BaseProvider {
  final UserRepository userRepository;

  AuthProvider(this.userRepository);

  OdooSession? currentUser;

  Future<BaseResponse<OdooSession>> login(String email, String password) async {
    var response = await userRepository.authenticate(email, password);
    if (response.status == 0) {
      currentUser = response.data;
      AppSession.currentUser = response.data;
    }

    return response;
  }

  Future<void> logout() {
    throw UnimplementedError('AuthProvider.logout');

    // currentUser = null;
    // AppSession.currentUser = null;
  }
}
