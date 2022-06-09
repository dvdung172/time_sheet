import 'package:easy_localization/easy_localization.dart';
import 'package:hsc_timesheet/core/base/base_response.dart';
import 'package:hsc_timesheet/data/models/user.dart';
import 'package:hsc_timesheet/data/repositories/user_repository.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import 'odoo_connect.dart';

class OdooUserRepository extends UserRepository with OdooConnect {
  @override
  Future<BaseResponse<OdooSession>> authenticate(
      String email, String password) async {
    try {
      var response = await client.authenticate('odoo', email, password);

      return BaseResponse.success(response);
    } on OdooException catch (e) {
      await handleError(e);
      return BaseResponse.fail([e.message]);
    } on Exception catch (e) {
      await handleError(e);
      return BaseResponse.fail([tr('message.server_error')]);
    }
  }

  @override
  Future<BaseResponse<User>> callUser(int id) async {
    try {
      var res = await client.callKw({
        'model': 'res.users',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['id', '=', id],
          ],
          'fields': ['id', 'name', 'email', '__last_update', ''],
        },
      });
      var user = User.fromJson(res[0]);

      return BaseResponse.success(user);
    } on OdooException catch (e) {
      handleError(e, additionalMessage: 'UserRepository.callUser($id) error');
      return BaseResponse.fail([e.message]);
    } on Exception catch (e) {
      await handleError(e);
      return BaseResponse.fail([tr('message.server_error')]);
    }
  }

  @override
  Future<BaseResponse<List<User>>> callListUser() async {
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

      var userList = await res.map<User>((e) => User.fromJson(e)).toList();

      return BaseResponse.success(userList);
    } on OdooException catch (e) {
      handleError(e, additionalMessage: 'UserRepository.callListUser() error');
      return BaseResponse.fail([e.message]);
    } on Exception catch (e) {
      await handleError(e);
      return BaseResponse.fail([tr('message.server_error')]);
    }
  }
}
