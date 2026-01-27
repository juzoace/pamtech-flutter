import 'package:autotech/core/common/entities/user.dart';
import 'package:autotech/core/errors/failures.dart' hide Failure;
import 'package:autotech/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dartz/dartz.dart' hide left;
import 'package:fpdart/fpdart.dart' hide Either, right;
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
// import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Object> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(userModel);
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Object> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );
      return right(userModel);
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, User>> currentUser() async {
  //   try {
  //     final userModel = await remoteDataSource.currentUser();
  //     return right(userModel);
  //   } on Exception catch (e) {
  //     return left(ServerFailure(e.toString()));
  //   }
  // }

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> register({required String name, required String email, required String password, required String phone}) {
    // TODO: implement register
    throw UnimplementedError();
  }
}