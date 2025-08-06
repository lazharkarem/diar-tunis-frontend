import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/features/authentication/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String userType,
    String? phone,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, User>> refreshToken();

  Future<Either<Failure, void>> forgotPassword({required String email});

  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String password,
  });

  Future<Either<Failure, User>> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    String? avatar,
  });

  Future<bool> isLoggedIn();
}
