import 'package:client/data/repositories/api_connection.dart';
import 'package:client/data/repositories/mocks/api_connection_mock.dart';
import 'package:client/data/repositories/mocks/timesheet_repository_mock.dart';
import 'package:client/data/repositories/odoo_repositories/user_repository.dart';
import 'package:client/data/repositories/timesheet_repository.dart';
import 'package:client/presentation/providers/list_user_provider.dart';
import 'package:client/presentation/providers/tab_index.dart';
import 'package:client/presentation/providers/list_timesheet_provider.dart';
import 'package:client/presentation/providers/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../presentation/providers/timesheet_provider.dart';

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

    // Repositories
    sl.registerLazySingleton<TimeSheetRepository>(
      () => TimeSheetRepositoryMock(connection: sl()),
    );
    sl.registerLazySingleton<UserRepository>(
          () => UserRepository(),
    );

    // Providers
    sl.registerLazySingleton<TabIndex>(
      () => TabIndex(),
    );
    sl.registerLazySingleton<TimeSheetProvider>(
          () => TimeSheetProvider(sl()),
    );
    sl.registerLazySingleton<ListTimeSheetsProvider>(
      () => ListTimeSheetsProvider(sl()),
    );
    sl.registerLazySingleton<ListUserProvider>(
          () => ListUserProvider(sl()),
    );
    sl.registerLazySingleton<UserProvider>(
          () => UserProvider(sl()),
    );
  }
}
