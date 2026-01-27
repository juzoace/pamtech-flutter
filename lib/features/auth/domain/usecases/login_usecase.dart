import 'package:autotech/core/error/failures.dart';
import 'package:autotech/features/auth/domain/entities/user_entity.dart' hide UserEntity;
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:autotech/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:autotech/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:autotech/features/auth/domain/repositories/auth_repository.dart';
import 'package:autotech/features/auth/presentation/providers/auth_provider.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  // Future<Either<Failure, UserEntity>> execute(String email, String password) {
  //   return repository.login(email, password);
  // }
}




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

  // Providers
  // serviceLocator.registerFactory(
  //   () => AuthProvider(loginUseCase: serviceLocator()),
  // );
}