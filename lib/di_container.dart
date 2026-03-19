import 'package:autotech/data/datasource/remote/dio/dio_client.dart';
import 'package:autotech/data/datasource/remote/dio/logging_interceptor.dart';

import 'package:autotech/features/auth/controllers/auth_controller.dart';
import 'package:autotech/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:autotech/features/auth/domain/repository/auth_repository.dart';
import 'package:autotech/features/auth/domain/services/auth_service.dart';
import 'package:autotech/features/auth/domain/services/auth_service_interface.dart';
import 'package:autotech/features/dashboard/controllers/home_controller.dart';
import 'package:autotech/features/dashboard/data/home_repository.dart';
import 'package:autotech/features/dashboard/domain/services/home_service.dart';
import 'package:autotech/features/dashboard/domain/services/home_service_interface.dart';
import 'package:autotech/features/profile/controllers/profile_controller.dart';
import 'package:autotech/features/profile/data/repository/profile_repository.dart';
import 'package:autotech/features/profile/domain/services/profile_service.dart';
import 'package:autotech/features/profile/domain/services/profile_service_interface.dart';

import 'package:autotech/features/repairs/controllers/repairs_controller.dart';
import 'package:autotech/features/repairs/data/repository/repairs_repository.dart';
import 'package:autotech/features/repairs/domain/services/repairs_service.dart';
import 'package:autotech/features/repairs/domain/services/repairs_service_interface.dart';
import 'package:autotech/features/requests/controllers/requests_controller.dart';
import 'package:autotech/features/profile/controllers/profile_controller.dart';
import 'package:autotech/features/requests/data/repository/requests_repository.dart';
import 'package:autotech/features/requests/domain/services/request_service.dart';
import 'package:autotech/features/requests/domain/services/requests_service_interface.dart';

import 'package:autotech/features/settings/controller/settings_controller.dart';
import 'package:autotech/features/settings/data/repository/settings_repository.dart';
import 'package:autotech/features/settings/domain/services/settings_service.dart';
import 'package:autotech/features/settings/domain/services/settings_service_interface.dart';

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
  sl.registerLazySingleton(
    () => SettingsRepository(dioClient: sl(), sharedPreferences: sl()),
  );
  sl.registerLazySingleton(
    () => RequestsRepository(dioClient: sl(), sharedPreferences: sl()),
  );
  sl.registerLazySingleton(
    () => HomeRepository(dioClient: sl(), sharedPreferences: sl()),
  );

  // Providers
  sl.registerFactory(() => AuthController(authServiceInterface: sl()));
  sl.registerFactory(() => RepairsController(repairsServiceInterface: sl()));
  sl.registerFactory(() => SettingsController(settingsServiceInterface: sl()));
  sl.registerFactory(() => RequestsController(requestsServiceInterface: sl()));
  sl.registerFactory(() => ProfileController(profileServiceInterface: sl()));
  sl.registerFactory(() => HomeController(homeServiceInterface: sl()));

  //interface
  AuthRepoInterface authRepoInterface = AuthRepository(
    dioClient: sl(),
    sharedPreferences: sl(),
  );
  RepairsServiceInterface repairsRepoInterface = RepairsRepository(
    dioClient: sl(),
    sharedPreferences: sl(),
  );
  SettingsServiceInterface settingsRepoInterface = SettingsRepository(
    dioClient: sl(),
    sharedPreferences: sl(),
  );
  RequestsServiceInterface requestsRepoInterface = RequestsRepository(
    dioClient: sl(),
    sharedPreferences: sl(),
  );
  ProfileServiceInterface profileRepoInterface = ProfileRepository(
    dioClient: sl(),
    sharedPreferences: sharedPreferences,
  );

  HomeServiceInterface homeRepoInterface = HomeRepository(
    dioClient: sl(),
    sharedPreferences: sharedPreferences,
  );

  sl.registerLazySingleton(() => authRepoInterface);
  sl.registerLazySingleton(() => repairsRepoInterface);
  sl.registerLazySingleton(() => settingsRepoInterface);
  sl.registerLazySingleton(() => requestsRepoInterface);
  sl.registerLazySingleton(() => profileRepoInterface);
  sl.registerLazySingleton(() => homeRepoInterface);

  AuthServiceInterface authServiceInterface = AuthService(
    authRepoInterface: sl(),
  );
  RepairsServiceInterface repairsServiceInterface = RepairsService(
    repairsRepoInterface: sl(),
  );
  SettingsServiceInterface settingsServiceInterface = SettingsService(
    settingsRepoInterface: sl(),
  );
  RequestsServiceInterface requestsServiceInterface = RequestsService(
    requestsRepoInterface: sl(),
  );
  ProfileServiceInterface profileServiceInterface = ProfileService(
    profileRepoInterface: sl(),
  );

  HomeServiceInterface homeServiceInterface = HomeService(
    homeRepoInterface: sl(),
  );

  sl.registerLazySingleton(() => authServiceInterface);

  //services
  sl.registerLazySingleton(() => AuthService(authRepoInterface: sl()));
  sl.registerLazySingleton(() => RepairsService(repairsRepoInterface: sl()));
  sl.registerLazySingleton(() => SettingsService(settingsRepoInterface: sl()));
  sl.registerLazySingleton(() => RequestsService(requestsRepoInterface: sl()));
  sl.registerLazySingleton(() => ProfileService(profileRepoInterface: sl()));
  sl.registerLazySingleton(() => HomeService(homeRepoInterface: sl()));
}
