import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/admin/domain/repositories/admin_repository.dart';
import 'package:diar_tunis/features/authentication/domain/entities/user.dart';
import 'package:injectable/injectable.dart';

@injectable
class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource _remoteDataSource;

  AdminRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    try {
      final response = await _remoteDataSource.getUsers();

      if (response.isSuccess && response.data != null) {
        final users = response.data!.data
            .map((model) => model.toDomain())
            .toList();
        return Right(users);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get users: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> createUser(
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await _remoteDataSource.createUser(userData);

      if (response.isSuccess && response.data != null) {
        return Right(response.data!.toDomain());
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to create user: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await _remoteDataSource.updateUser(
        int.parse(userId),
        userData,
      );

      if (response.isSuccess && response.data != null) {
        return Right(response.data!.toDomain());
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update user: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> updateUserStatus(
    String userId,
    String status,
  ) async {
    try {
      final response = await _remoteDataSource.updateUser(int.parse(userId), {
        'status': status,
      });

      if (response.isSuccess && response.data != null) {
        return Right(response.data!.toDomain());
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update user status: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userId) async {
    try {
      final response = await _remoteDataSource.deleteUser(int.parse(userId));

      if (response.isSuccess) {
        return const Right(null);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to delete user: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Property>>> getAllProperties() async {
    try {
      final response = await _remoteDataSource.getAllProperties();

      if (response.isSuccess && response.data != null) {
        final properties = response.data!.data
            .map((model) => model.toDomain())
            .toList();
        return Right(properties);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get properties: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Property>> updatePropertyStatus(
    String propertyId,
    String status,
  ) async {
    try {
      final response = await _remoteDataSource.updatePropertyStatus(
        int.parse(propertyId),
        status,
      );

      if (response.isSuccess && response.data != null) {
        return Right(response.data!.toDomain());
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to update property status: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Property>> createProperty(
    Map<String, dynamic> propertyData,
  ) async {
    try {
      // This method would need to be implemented in the remote datasource
      // For now, return an error indicating it's not implemented
      return Left(ServerFailure(message: 'Create property not implemented'));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to create property: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Property>> updateProperty(
    String propertyId,
    Map<String, dynamic> propertyData,
  ) async {
    try {
      // This method would need to be implemented in the remote datasource
      // For now, return an error indicating it's not implemented
      return Left(ServerFailure(message: 'Update property not implemented'));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update property: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteProperty(String propertyId) async {
    try {
      final response = await _remoteDataSource.deleteProperty(
        int.parse(propertyId),
      );

      if (response.isSuccess) {
        return const Right(null);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to delete property: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllBookings() async {
    try {
      final response = await _remoteDataSource.getAllBookings();

      if (response.isSuccess && response.data != null) {
        // Convert booking models to maps since the interface expects maps
        final bookings = response.data!.data
            .map((model) => model.toJson())
            .toList();
        return Right(bookings);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get bookings: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateBookingStatus(
    String bookingId,
    String status,
  ) async {
    try {
      final response = await _remoteDataSource.updateBookingStatus(
        int.parse(bookingId),
        status,
      );

      if (response.isSuccess && response.data != null) {
        return Right(response.data!.toJson());
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to update booking status: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking(String bookingId) async {
    return updateBookingStatus(bookingId, 'cancelled').then((result) {
      return result.fold((failure) => Left(failure), (_) => const Right(null));
    });
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getAllExperiences() async {
    try {
      // This method would need to be implemented in the remote datasource
      // For now, return an empty list
      return const Right([]);
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get experiences: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateExperienceStatus(
    String experienceId,
    String status,
  ) async {
    try {
      // This method would need to be implemented in the remote datasource
      return Left(
        ServerFailure(message: 'Update experience status not implemented'),
      );
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to update experience status: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllPayments() async {
    try {
      // This method would need to be implemented in the remote datasource
      return const Right([]);
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get payments: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updatePaymentStatus(
    String paymentId,
    String status,
  ) async {
    try {
      // This method would need to be implemented in the remote datasource
      return Left(
        ServerFailure(message: 'Update payment status not implemented'),
      );
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to update payment status: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getAllServiceProviders() async {
    try {
      // This method would need to be implemented in the remote datasource
      return const Right([]);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to get service providers: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateServiceProviderStatus(
    String providerId,
    String status,
  ) async {
    try {
      // This method would need to be implemented in the remote datasource
      return Left(
        ServerFailure(
          message: 'Update service provider status not implemented',
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to update service provider status: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats() async {
    try {
      final response = await _remoteDataSource.getStatistics();

      if (response.isSuccess && response.data != null) {
        return Right(response.data!.toJson());
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get statistics: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getRecentActivities() async {
    try {
      // This method would need to be implemented in the remote datasource
      return const Right([]);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to get recent activities: ${e.toString()}',
        ),
      );
    }
  }
}
