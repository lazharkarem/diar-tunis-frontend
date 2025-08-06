import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/exceptions.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/core/network/network_info.dart';
import 'package:diar_tunis/features/authentication/data/datasources/auth_local_datasource.dart';
import 'package:diar_tunis/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:diar_tunis/features/authentication/domain/entities/user.dart';
import 'package:diar_tunis/features/authentication/domain/repositories/auth_repository.dart';
import 'package:diar_tunis/features/authentication/data/models/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final AuthResponseModel response = await remoteDataSource.login(email, password);
        await localDataSource.cacheUser(response.user);
        await localDataSource.cacheToken(response.accessToken);
        return Right(response.user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String userType,
    String? phone,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final AuthResponseModel response = await remoteDataSource.register(
          email: email,
          password: password,
          name: firstName, // Change according to API
          phone: phone ?? '',
        );
        await localDataSource.cacheUser(response.user);
        await localDataSource.cacheToken(response.accessToken);
        return Right(response.user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getUserProfile();
        await localDataSource.cacheUser(result);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      try {
        final cachedUser = await localDataSource.getLastUser();
        if (cachedUser != null) {
          return Right(cachedUser);
        } else {
          return const Left(CacheFailure(message: 'No cached user found'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUser();
      await localDataSource.clearToken();
      if (await networkInfo.isConnected) {
        await remoteDataSource.logout();
      }
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await localDataSource.getToken();
      return token != null && token.isNotEmpty;
    } on CacheException {
      return false;
    }
  }

  @override
  Future<Either<Failure, User>> refreshToken() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.refreshToken();
        await localDataSource.cacheUser(result.user);
        await localDataSource.cacheToken(result.accessToken);
        return Right(result.user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.forgotPassword(email);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(token, password);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    String? avatar,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateProfile(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          avatar: avatar,
        );
        await localDataSource.cacheUser(result);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
