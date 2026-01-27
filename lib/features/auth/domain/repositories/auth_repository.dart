// TODO Implement this library.
import 'package:autotech/core/error/failures.dart';
// import 'package:autotech/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart' hide Failure;
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);

  Future<Either<Failure, UserEntity>> register({required String name, required String email, required String password, required String phone});
}