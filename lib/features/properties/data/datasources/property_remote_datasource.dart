import 'package:dagger/dagger.dart';

import '../../../../core/network/api_service.dart';
import '../models/category_model.dart';
import '../models/destination_model.dart';
import '../models/property_model.dart';

abstract class PropertyRemoteDataSource {
  Future<ApiResponse<PaginatedResponse<PropertyModel>>> getProperties({
    int page = 1,
    int perPage = 15,
    String? search,
    String? city,
    String? type,
    double? minPrice,
    double? maxPrice,
    int? guests,
  });

  Future<ApiResponse<PropertyModel>> getProperty(int id);
  Future<ApiResponse<List<PropertyModel>>> getFeaturedProperties({
    int limit = 10,
  });
  Future<ApiResponse<List<DestinationModel>>> getPopularDestinations();
  Future<ApiResponse<List<CategoryModel>>> getPropertyCategories();
}

@injectable
class PropertyRemoteDataSourceImpl implements PropertyRemoteDataSource {
  final ApiService _apiService;

  PropertyRemoteDataSourceImpl(this._apiService);

  @override
  Future<ApiResponse<PaginatedResponse<PropertyModel>>> getProperties({
    int page = 1,
    int perPage = 15,
    String? search,
    String? city,
    String? type,
    double? minPrice,
    double? maxPrice,
    int? guests,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (search != null && search.isNotEmpty) queryParameters['search'] = search;
    if (city != null && city.isNotEmpty) queryParameters['city'] = city;
    if (type != null && type.isNotEmpty) queryParameters['type'] = type;
    if (minPrice != null) queryParameters['min_price'] = minPrice;
    if (maxPrice != null) queryParameters['max_price'] = maxPrice;
    if (guests != null) queryParameters['guests'] = guests;

    final response = await _apiService.get<Map<String, dynamic>>(
      '/search-properties',
      queryParameters: queryParameters,
    );

    if (response.isSuccess && response.data != null) {
      final paginatedResponse = PaginatedResponse.fromJson(
        response.data!,
        (json) => PropertyModel.fromJson(json),
      );

      return ApiResponse<PaginatedResponse<PropertyModel>>(
        success: true,
        data: paginatedResponse,
        message: response.message,
      );
    } else {
      return ApiResponse<PaginatedResponse<PropertyModel>>(
        success: false,
        message: response.message,
        errors: response.errors,
      );
    }
  }

  @override
  Future<ApiResponse<PropertyModel>> getProperty(int id) async {
    return await _apiService.get<PropertyModel>(
      '/properties/$id',
      fromJson: (json) => PropertyModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<List<PropertyModel>>> getFeaturedProperties({
    int limit = 10,
  }) async {
    final response = await _apiService.get<List<dynamic>>(
      '/featured-properties',
      queryParameters: {'limit': limit},
    );

    if (response.isSuccess && response.data != null) {
      final properties = response.data!
          .map((json) => PropertyModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return ApiResponse<List<PropertyModel>>(
        success: true,
        data: properties,
        message: response.message,
      );
    } else {
      return ApiResponse<List<PropertyModel>>(
        success: false,
        message: response.message,
        errors: response.errors,
      );
    }
  }

  @override
  Future<ApiResponse<List<DestinationModel>>> getPopularDestinations() async {
    final response = await _apiService.get<List<dynamic>>(
      '/popular-destinations',
    );

    if (response.isSuccess && response.data != null) {
      final destinations = response.data!
          .map(
            (json) => DestinationModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      return ApiResponse<List<DestinationModel>>(
        success: true,
        data: destinations,
        message: response.message,
      );
    } else {
      return ApiResponse<List<DestinationModel>>(
        success: false,
        message: response.message,
        errors: response.errors,
      );
    }
  }

  @override
  Future<ApiResponse<List<CategoryModel>>> getPropertyCategories() async {
    final response = await _apiService.get<List<dynamic>>(
      '/property-categories',
    );

    if (response.isSuccess && response.data != null) {
      final categories = response.data!
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return ApiResponse<List<CategoryModel>>(
        success: true,
        data: categories,
        message: response.message,
      );
    } else {
      return ApiResponse<List<CategoryModel>>(
        success: false,
        message: response.message,
        errors: response.errors,
      );
    }
  }
}
