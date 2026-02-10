import 'package:autotech/data/datasource/remote/dio/dio_client.dart';
import 'package:autotech/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:autotech/features/auth/controllers/auth_controller.dart';
import 'package:autotech/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:autotech/features/auth/domain/repository/auth_repository.dart';
import 'package:autotech/features/auth/domain/services/auth_service.dart';
import 'package:autotech/features/auth/domain/services/auth_service_interface.dart';
import 'package:autotech/features/repairs/controllers/repairs_controller.dart';
import 'package:autotech/features/repairs/data/repository/repairs_repository.dart';
import 'package:autotech/features/repairs/domain/services/repairs_service.dart';
import 'package:autotech/features/repairs/domain/services/repairs_service_interface.dart';
import 'package:autotech/helper/network_info.dart';
import 'package:autotech/util/app_constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(
    () => DioClient(
      AppConstants.baseUrl,
      sl(),
      loggingInterceptor: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton(
    () => AuthRepository(dioClient: sl(), sharedPreferences: sl()),
  );
  sl.registerLazySingleton(
    () => RepairsRepository(dioClient: sl(), sharedPreferences: sl()),
  );

  // Providers
  sl.registerFactory(() => AuthController(authServiceInterface: sl()));
  sl.registerFactory(() => RepairsController(repairsServiceInterface: sl()));

  //interface
  AuthRepoInterface authRepoInterface = AuthRepository(
    dioClient: sl(),
    sharedPreferences: sl(),
  );
  RepairsServiceInterface repairsRepoInterface = RepairsRepository(
    dioClient: sl(),
    sharedPreferences: sl(),
  );

  sl.registerLazySingleton(() => authRepoInterface);
  sl.registerLazySingleton(() => repairsRepoInterface);
  AuthServiceInterface authServiceInterface = AuthService(
    authRepoInterface: sl(),
  );
  RepairsServiceInterface repairsServiceInterface = RepairsService(
   repairsRepoInterface:  sl(),
  );
  sl.registerLazySingleton(() => authServiceInterface);
  // sl.registerLazySingleton(() => repairsServiceInterface);

  //services
  sl.registerLazySingleton(() => AuthService(authRepoInterface: sl()));
  sl.registerLazySingleton(() => RepairsService(repairsRepoInterface: sl()));
}
