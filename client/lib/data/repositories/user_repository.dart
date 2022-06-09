import 'package:hsc_timesheet/core/base/base_response.dart';
import 'package:hsc_timesheet/data/models/user.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class UserRepository {
  Future<BaseResponse<OdooSession>> authenticate(
      String email, String password) async {
    throw UnimplementedError('UserRepository.authentication');
  }

  Future<BaseResponse<User>> callUser(int id) async {
    throw UnimplementedError('UserRepository.callUser');
  }

  Future<BaseResponse<List<User>>> callListUser() async {
    throw UnimplementedError('UserRepository.callListUser');
  }
}
