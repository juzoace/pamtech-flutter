import 'package:autotech/core/error/failures.dart';
import 'package:autotech/core/usecase/usecase.dart';
import 'package:autotech/core/common/entities/user.dart';
import 'package:autotech/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
