import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hsc_timesheet/core/constants.dart';
import 'package:hsc_timesheet/data/repositories/index.dart';
import 'package:hsc_timesheet/data/repositories/mocks/api_connection_mock.dart';
import 'package:hsc_timesheet/data/repositories/mocks/timesheet_repository_mock.dart';
import 'package:hsc_timesheet/data/repositories/odoo_repositories/odoo_employee_repository.dart';
import 'package:hsc_timesheet/data/repositories/odoo_repositories/odoo_timesheet_repository.dart';
import 'package:hsc_timesheet/data/repositories/odoo_repositories/odoo_user_repository.dart';
import 'package:hsc_timesheet/data/repositories/server/api_connection.dart';
import 'package:hsc_timesheet/presentation/providers/index.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

// import '../presentation/providers/timesheet_creation_provider.dart';

/// service locator
final sl = GetIt.instance;

/// Dependency injection utility
class DI {
  static Future<void> init() async {
    sl.registerLazySingleton<ApiConnection>(
      () => !kDebugMode
          ? ApiConnection(apiConfig: ApiConfig())
          : ApiConnectionMock(apiConfig: ApiConfig()),
    );

    ///
    /// Repositories
    ///
    sl.registerLazySingleton<OdooClient>(
          () => OdooClient(Endpoints.baseURL),
    );
    sl.registerLazySingleton<TimeSheetRepository>(
      // () => TimeSheetRepositoryMock(connection: sl()),
          () => OdooTimeSheetRepository(sl()),
    );
    sl.registerLazySingleton<UserRepository>(
      () => OdooUserRepository(sl()),
    );
    sl.registerLazySingleton<EmployeeRepository>(
      () => OdooEmployeeRepository(sl()),
    );

    ///
    /// Providers
    ///
    sl.registerLazySingleton<AuthProvider>(
      () => AuthProvider(sl()),
    );
    sl.registerLazySingleton<TabIndex>(
      () => TabIndex(),
    );
    sl.registerLazySingleton<TimeSheetProvider>(
      () => TimeSheetProvider(sl()),
    );
    sl.registerLazySingleton<ListTimeSheetsProvider>(
      () => ListTimeSheetsProvider(sl()),
    );
    sl.registerLazySingleton<ListEmployeeProvider>(
      () => ListEmployeeProvider(sl()),
    );
    sl.registerLazySingleton<UserProvider>(
      () => UserProvider(sl()),
    );
  }
}
