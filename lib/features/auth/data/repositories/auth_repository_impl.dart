// import 'package:autotech/core/constants/constants.dart';
// import 'package:autotech/core/error/exceptions.dart';
// import 'package:autotech/core/error/failures.dart';
// import 'package:autotech/core/network/connection_checker.dart';
// import 'package:autotech/features/auth/data/datasources/auth_remote_data_source.dart';
// import 'package:autotech/core/common/entities/user.dart';
// import 'package:autotech/features/auth/data/models/user_model.dart';
// import 'package:autotech/features/auth/domain/repository/auth_repository.dart';
// import 'package:fpdart/fpdart.dart';

// class AuthRepositoryImpl implements AuthRepository {
//   final AuthRemoteDataSource remoteDataSource;
//   final ConnectionChecker connectionChecker;
//   const AuthRepositoryImpl(
//     this.remoteDataSource,
//     this.connectionChecker,
//   );

//   @override
//   Future<Either<Failure, User>> currentUser() async {
//     try {
//       if (!await (connectionChecker.isConnected)) {
//         final session = remoteDataSource.currentUserSession;

//         if (session == null) {
//           return left(Failure('User not logged in!'));
//         }

//         return right(
//           UserModel(
//             id: session.user.id,
//             email: session.user.email ?? '',
//             name: '',
//           ),
//         );
//       }
//       final user = await remoteDataSource.getCurrentUserData();
//       if (user == null) {
//         return left(Failure('User not logged in!'));
//       }

//       return right(user);
//     } on ServerException catch (e) {
//       return left(Failure(e.message));
//     }
//   }

//   @override
//   Future<Either<Failure, User>> loginWithEmailPassword({
//     required String email,
//     required String password,
//   }) async {
//     return _getUser(
//       () async => await remoteDataSource.loginWithEmailPassword(
//         email: email,
//         password: password,
//       ),
//     );
//   }

//   @override
//   Future<Either<Failure, User>> signUpWithEmailPassword({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     return _getUser(
//       () async => await remoteDataSource.signUpWithEmailPassword(
//         name: name,
//         email: email,
//         password: password,
//       ),
//     );
//   }

//   Future<Either<Failure, User>> _getUser(
//     Future<User> Function() fn,
//   ) async {
//     try {
//       if (!await (connectionChecker.isConnected)) {
//         return left(Failure(Constants.noConnectionErrorMessage));
//       }
//       final user = await fn();

//       return right(user);
//     } on ServerException catch (e) {
//       return left(Failure(e.message));
//     }
//   }
// }



// import 'package:autotech/core/error/failures.dart';
import 'package:autotech/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/user_entity.dart';
// import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../../../core/errors/failures.dart';

abstract class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  // @override
  // Future<Either<Failure, UserEntity>> login(String email, String password) async {
  //   try {
  //     final response = await remoteDataSource.login(email, password);
  //     return Right(response.toEntity());
  //   } catch (e) {
  //     // return Left(ServerFailure(e.toString()));
  //   }
  // }


}

class UserEntity {
}