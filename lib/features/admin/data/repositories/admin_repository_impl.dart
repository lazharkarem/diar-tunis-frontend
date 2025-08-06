import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/exceptions.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/core/network/network_info.dart';
import 'package:diar_tunis/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/admin/domain/repositories/admin_repository.dart';
import 'package:diar_tunis/features/authentication/domain/entities/user.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AdminRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Property>>> getAllProperties() async {
    if (await networkInfo.isConnected) {
      try {
        final properties = await remoteDataSource.getAllProperties();
        return Right(properties);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Property>> updatePropertyStatus(String propertyId, String status) async {
    if (await networkInfo.isConnected) {
      try {
        final property = await remoteDataSource.updatePropertyStatus(propertyId, status);
        return Right(property);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    if (await networkInfo.isConnected) {
      try {
        final users = await remoteDataSource.getAllUsers();
        return Right(users);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserStatus(String userId, String status) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.updateUserStatus(userId, status);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> createUser(Map<String, dynamic> userData) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.createUser(userData);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(String userId, Map<String, dynamic> userData) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.updateUser(userId, userData);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUser(userId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Property>> createProperty(Map<String, dynamic> propertyData) async {
    if (await networkInfo.isConnected) {
      try {
        final property = await remoteDataSource.createProperty(propertyData);
        return Right(property);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Property>> updateProperty(String propertyId, Map<String, dynamic> propertyData) async {
    if (await networkInfo.isConnected) {
      try {
        final property = await remoteDataSource.updateProperty(propertyId, propertyData);
        return Right(property);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProperty(String propertyId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteProperty(propertyId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllBookings() async {
    if (await networkInfo.isConnected) {
      try {
        final bookings = await remoteDataSource.getAllBookings();
        return Right(bookings);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateBookingStatus(String bookingId, String status) async {
    if (await networkInfo.isConnected) {
      try {
        final booking = await remoteDataSource.updateBookingStatus(bookingId, status);
        return Right(booking);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking(String bookingId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.cancelBooking(bookingId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllExperiences() async {
    if (await networkInfo.isConnected) {
      try {
        final experiences = await remoteDataSource.getAllExperiences();
        return Right(experiences);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateExperienceStatus(String experienceId, String status) async {
    if (await networkInfo.isConnected) {
      try {
        final experience = await remoteDataSource.updateExperienceStatus(experienceId, status);
        return Right(experience);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllPayments() async {
    if (await networkInfo.isConnected) {
      try {
        final payments = await remoteDataSource.getAllPayments();
        return Right(payments);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updatePaymentStatus(String paymentId, String status) async {
    if (await networkInfo.isConnected) {
      try {
        final payment = await remoteDataSource.updatePaymentStatus(paymentId, status);
        return Right(payment);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllServiceProviders() async {
    if (await networkInfo.isConnected) {
      try {
        final providers = await remoteDataSource.getAllServiceProviders();
        return Right(providers);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateServiceProviderStatus(String providerId, String status) async {
    if (await networkInfo.isConnected) {
      try {
        final provider = await remoteDataSource.updateServiceProviderStatus(providerId, status);
        return Right(provider);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats() async {
    if (await networkInfo.isConnected) {
      try {
        final stats = await remoteDataSource.getDashboardStats();
        return Right(stats);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getRecentActivities() async {
    if (await networkInfo.isConnected) {
      try {
        final activities = await remoteDataSource.getRecentActivities();
        return Right(activities);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }  
}

