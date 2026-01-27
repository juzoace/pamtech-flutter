import 'package:autotech/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:get_it/get_it.dart';
// import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Data sources
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(),
  );

  // Repositories
  // serviceLocator.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(remoteDataSource: serviceLocator()),
  // );
  // Use cases
  serviceLocator.registerFactory(
    () => LoginUseCase(serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => RegisterUseCase(serviceLocator()),
  );

  // Providers
  serviceLocator.registerFactory(
    () => AuthProvider(loginUseCase: serviceLocator(), registerUseCase: serviceLocator()),
  );
  
}