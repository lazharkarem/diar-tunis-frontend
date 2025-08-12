import 'package:diar_tunis/core/network/api_service.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/shared/domain/entities/destination.dart';
import 'package:diar_tunis/features/shared/domain/entities/property_category.dart';

abstract class PropertyRepository {
  Future<ApiResponse<PaginatedResponse<Property>>> getProperties({
    int page,
    int perPage,
    String? search,
    String? city,
    String? type,
    double? minPrice,
    double? maxPrice,
    int? guests,
  });

  Future<ApiResponse<Property>> getProperty(int id);

  Future<ApiResponse<List<Property>>> getFeaturedProperties({int limit});

  Future<ApiResponse<List<Destination>>> getPopularDestinations();

  Future<ApiResponse<List<PropertyCategory>>> getPropertyCategories();

  Future<ApiResponse<PaginatedResponse<Property>>> getHostProperties({
    int page = 1,
    int perPage = 10,
  });

  Future<ApiResponse<PaginatedResponse<Property>>> searchProperties({
    required String query,
    int page,
    int perPage,
    String? city,
    String? type,
    double? minPrice,
    double? maxPrice,
    int? guests,
  });
}
