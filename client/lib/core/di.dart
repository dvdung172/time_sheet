import 'package:client/data/repositories/api_connection.dart';
import 'package:client/data/repositories/mocks/api_connection_mock.dart';
import 'package:client/data/repositories/mocks/product_repository_mock.dart';
import 'package:client/data/repositories/mocks/timesheet_repository_mock.dart';
import 'package:client/data/repositories/product_repository.dart';
import 'package:client/data/repositories/timesheet_repository.dart';
import 'package:client/presentation/providers/tab_index.dart';
import 'package:client/presentation/providers/product_detail_provider.dart';
import 'package:client/presentation/providers/product_list_provider.dart';
import 'package:client/presentation/providers/timesheet_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

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
    sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryMock(connection: sl()),
    );
    sl.registerLazySingleton<TimeSheetRepositoryMock>(
      () => TimeSheetRepositoryMock(connection: sl()),
    );

    // Providers
    sl.registerLazySingleton<TabIndex>(
      () => TabIndex(),
    );

    sl.registerLazySingleton<ProductListProvider>(
      () => ProductListProvider(sl()),
    );
    sl.registerLazySingleton<ProductDetailProvider>(
      () => ProductDetailProvider(sl()),
    );
    sl.registerLazySingleton<TimeSheetProvider>(
      () => TimeSheetProvider(sl()),
    );
  }
}
