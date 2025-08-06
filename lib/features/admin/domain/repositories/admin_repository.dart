import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/authentication/domain/entities/user.dart';

abstract class AdminRepository {
  // Users Management
  Future<Either<Failure, List<User>>> getAllUsers();
  Future<Either<Failure, User>> updateUserStatus(String userId, String status);
  Future<Either<Failure, User>> createUser(Map<String, dynamic> userData);
  Future<Either<Failure, User>> updateUser(String userId, Map<String, dynamic> userData);
  Future<Either<Failure, void>> deleteUser(String userId);

  // Properties Management
  Future<Either<Failure, List<Property>>> getAllProperties();
  Future<Either<Failure, Property>> updatePropertyStatus(String propertyId, String status);
  Future<Either<Failure, Property>> createProperty(Map<String, dynamic> propertyData);
  Future<Either<Failure, Property>> updateProperty(String propertyId, Map<String, dynamic> propertyData);
  Future<Either<Failure, void>> deleteProperty(String propertyId);

  // Bookings Management
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllBookings();
  Future<Either<Failure, Map<String, dynamic>>> updateBookingStatus(String bookingId, String status);
  Future<Either<Failure, void>> cancelBooking(String bookingId);

  // Experiences Management
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllExperiences();
  Future<Either<Failure, Map<String, dynamic>>> updateExperienceStatus(String experienceId, String status);

  // Payments Management
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllPayments();
  Future<Either<Failure, Map<String, dynamic>>> updatePaymentStatus(String paymentId, String status);

  // Service Providers Management
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllServiceProviders();
  Future<Either<Failure, Map<String, dynamic>>> updateServiceProviderStatus(String providerId, String status);

  // Statistics & Dashboard
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats();
  Future<Either<Failure, List<Map<String, dynamic>>>> getRecentActivities();
}

