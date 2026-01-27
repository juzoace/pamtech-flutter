import 'package:autotech/core/error/failures.dart';
// import 'package:autotech/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart' hide Failure;
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, UserEntity>> execute({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    return repository.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
  }
}
