import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_service.dart';
import '../datasources/property_remote_datasource.dart';

@injectable
class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyRemoteDataSource _remoteDataSource;

  PropertyRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<PaginatedResponse<Property>>> getProperties({
    int page = 1,
    int perPage = 15,
    String? search,
    String? city,
    String? type,
    double? minPrice,
    double? maxPrice,
    int? guests,
  }) async {
    try {
      final response = await _remoteDataSource.getProperties(
        page: page,
        perPage: perPage,
        search: search,
        city: city,
        type: type,
        minPrice: minPrice,
        maxPrice: maxPrice,
        guests: guests,
      );

      if (response.isSuccess && response.data != null) {
        final paginatedResponse = PaginatedResponse<Property>(
          data: response.data!.data.map((model) => model.toDomain()).toList(),
          currentPage: response.data!.currentPage,
          lastPage: response.data!.lastPage,
          total: response.data!.total,
          perPage: response.data!.perPage,
        );

        return ApiResponse<PaginatedResponse<Property>>(
          success: true,
          data: paginatedResponse,
          message: response.message,
        );
      } else {
        return ApiResponse<PaginatedResponse<Property>>(
          success: false,
          message: response.message,
          errors: response.errors,
        );
      }
    } catch (e) {
      return ApiResponse<PaginatedResponse<Property>>(
        success: false,
        message: 'Failed to get properties: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<Property>> getProperty(int id) async {
    try {
      final response = await _remoteDataSource.getProperty(id);

      if (response.isSuccess && response.data != null) {
        return ApiResponse<Property>(
          success: true,
          data: response.data!.toDomain(),
          message: response.message,
        );
      } else {
        return ApiResponse<Property>(
          success: false,
          message: response.message,
          errors: response.errors,
        );
      }
    } catch (e) {
      return ApiResponse<Property>(
        success: false,
        message: 'Failed to get property: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<List<Property>>> getFeaturedProperties({
    int limit = 10,
  }) async {
    try {
      final response = await _remoteDataSource.getFeaturedProperties(
        limit: limit,
      );

      if (response.isSuccess && response.data != null) {
        final properties = response.data!
            .map((model) => model.toDomain())
            .toList();

        return ApiResponse<List<Property>>(
          success: true,
          data: properties,
          message: response.message,
        );
      } else {
        return ApiResponse<List<Property>>(
          success: false,
          message: response.message,
          errors: response.errors,
        );
      }
    } catch (e) {
      return ApiResponse<List<Property>>(
        success: false,
        message: 'Failed to get featured properties: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<List<Destination>>> getPopularDestinations() async {
    try {
      final response = await _remoteDataSource.getPopularDestinations();

      if (response.isSuccess && response.data != null) {
        final destinations = response.data!
            .map((model) => model.toDomain())
            .toList();

        return ApiResponse<List<Destination>>(
          success: true,
          data: destinations,
          message: response.message,
        );
      } else {
        return ApiResponse<List<Destination>>(
          success: false,
          message: response.message,
          errors: response.errors,
        );
      }
    } catch (e) {
      return ApiResponse<List<Destination>>(
        success: false,
        message: 'Failed to get popular destinations: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<List<Category>>> getPropertyCategories() async {
    try {
      final response = await _remoteDataSource.getPropertyCategories();

      if (response.isSuccess && response.data != null) {
        final categories = response.data!
            .map((model) => model.toDomain())
            .toList();

        return ApiResponse<List<Category>>(
          success: true,
          data: categories,
          message: response.message,
        );
      } else {
        return ApiResponse<List<Category>>(
          success: false,
          message: response.message,
          errors: response.errors,
        );
      }
    } catch (e) {
      return ApiResponse<List<Category>>(
        success: false,
        message: 'Failed to get property categories: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<PaginatedResponse<Property>>> searchProperties({
    required String query,
    int page = 1,
    int perPage = 15,
    String? city,
    String? type,
    double? minPrice,
    double? maxPrice,
    int? guests,
  }) async {
    return await getProperties(
      page: page,
      perPage: perPage,
      search: query,
      city: city,
      type: type,
      minPrice: minPrice,
      maxPrice: maxPrice,
      guests: guests,
    );
  }
}
