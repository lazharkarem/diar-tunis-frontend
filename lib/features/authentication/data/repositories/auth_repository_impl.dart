import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/features/authentication/data/datasources/auth_local_datasource.dart';
import 'package:diar_tunis/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:diar_tunis/features/authentication/domain/entities/user.dart';
import 'package:diar_tunis/features/authentication/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String userType,
    String? phone,
    String? address,
    String? businessName,
    String? businessDescription,
    String? licenseNumber,
    int? yearsOfExperience,
  }) async {
    try {
      final response = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        userType: userType,
        phone: phone,
        address: address,
        businessName: businessName,
        businessDescription: businessDescription,
        licenseNumber: licenseNumber,
        yearsOfExperience: yearsOfExperience,
      );

      if (response.isSuccess && response.data != null) {
        final authResponse = response.data!;
        await _localDataSource.cacheToken(authResponse.accessToken);
        return Right(authResponse.user.toDomain());
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Registration failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      if (response.isSuccess && response.data != null) {
        final authResponse = response.data!;
        await _localDataSource.cacheToken(authResponse.accessToken);
        await _localDataSource.cacheUser(authResponse.user);
        return Right(authResponse.user.toDomain());
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> getProfile() async {
    try {
      final response = await _remoteDataSource.getProfile();

      if (response.isSuccess && response.data != null) {
        return Right(response.data!.toDomain());
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get profile: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // First try to get cached user if we have a valid token
      final token = await _localDataSource.getToken();
      if (token != null && token.isNotEmpty) {
        final cachedUser = await _localDataSource.getLastUser();
        if (cachedUser != null) {
          // Return cached user, but we might want to refresh in background
          return Right(cachedUser.toDomain());
        }
      }
      return Left(ServerFailure(message: 'No cached user found'));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get cached user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? businessName,
    String? businessDescription,
    String? licenseNumber,
    int? yearsOfExperience,
  }) async {
    try {
      final response = await _remoteDataSource.updateProfile(
        name: name,
        email: email,
        phone: phone,
        address: address,
        businessName: businessName,
        businessDescription: businessDescription,
        licenseNumber: licenseNumber,
        yearsOfExperience: yearsOfExperience,
      );

      if (response.isSuccess && response.data != null) {
        return Right(response.data!.toDomain());
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update profile: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> refreshToken() async {
    try {
      return Left(ServerFailure(message: 'Refresh token not implemented'));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to refresh token: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearToken();
      await _localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      // Clear local data even if remote logout fails
      await _localDataSource.clearToken();
      await _localDataSource.clearUser();
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = await _localDataSource.getToken();
      return Right(token != null && token.isNotEmpty);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to check login status: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getStatistics() async {
    try {
      return Left(
        ServerFailure(message: 'Statistics endpoint not implemented'),
      );
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get statistics: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    try {
      return Left(ServerFailure(message: 'Forgot password not implemented'));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to send reset email: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String password,
  }) async {
    try {
      return Left(ServerFailure(message: 'Reset password not implemented'));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to reset password: ${e.toString()}'),
      );
    }
  }
}
