import 'package:diar_tunis/features/admin/data/models/property_model.dart';
import 'package:diar_tunis/features/properties/domain/entities/category.dart';
import 'package:diar_tunis/features/shared/data/models/destination_model.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_service.dart' hide PaginatedResponse;
import '../../../../core/network/paginated_response.dart';

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
    try {
      print('Fetching properties with params: page=$page, perPage=$perPage, search=$search, city=$city, type=$type, minPrice=$minPrice, maxPrice=$maxPrice, guests=$guests');
      
      // First, check if we have a valid token
      final token = await _apiService.getToken();
      print('Current auth token: ${token != null ? 'Token exists' : 'No token found'}');
      
      if (token == null) {
        return ApiResponse<PaginatedResponse<PropertyModel>>(
          success: false,
          message: 'No authentication token found. Please log in again.',
          statusCode: 401,
        );
      }
      
      // Log token prefix for debugging (don't log the full token for security)
      if (token.length > 10) {
        print('Token prefix: ${token.substring(0, 10)}...');
      }
      
      print('Making API request to /host/properties...');
      final stopwatch = Stopwatch()..start();
      
      final response = await _apiService.get<Map<String, dynamic>>(
        '/host/properties',
        queryParameters: <String, dynamic>{
          'page': page,
          'per_page': perPage,
          if (search?.isNotEmpty ?? false) 'search': search,
          if (city != null && city.isNotEmpty) 'city': city,
          if (type != null && type.isNotEmpty) 'type': type,
          if (minPrice != null) 'min_price': minPrice,
          if (maxPrice != null) 'max_price': maxPrice,
          if (guests != null) 'guests': guests,
          // Add a timestamp to prevent caching
          '_': DateTime.now().millisecondsSinceEpoch,
        },
      );
      
      stopwatch.stop();
      print('API request completed in ${stopwatch.elapsedMilliseconds}ms');

      if (!response.isSuccess) {
        print('API Error: ${response.message}');
        print('Status code: ${response.statusCode}');
        print('Headers: ${response.headers}');
        
        // If unauthorized, print more details
        if (response.statusCode == 401) {
          print('Unauthorized - Please check if the user is logged in and the token is valid');
        }
        
        return ApiResponse<PaginatedResponse<PropertyModel>>(
          success: false,
          message: response.message ?? 'Failed to fetch properties',
          statusCode: response.statusCode,
        );
      }

      // Log the raw response for debugging
      final responseData = response.data;
      print('Raw properties response: $responseData');
      
      // Handle null response data
      if (responseData == null) {
        print('Error: No data received from server');
        return ApiResponse<PaginatedResponse<PropertyModel>>(
          success: false,
          message: 'No data received from server',
        );
      }
      
      // Log all top-level keys in the response
      print('Response keys: ${responseData.keys}');
      
      // Check if the response has a 'data' field
      if (responseData['data'] == null) {
        print('Error: Invalid response format - missing data field');
        print('Available keys: ${responseData.keys}');
        
        // If the response has a different structure, try to handle it
        if (responseData['properties'] != null) {
          print('Found properties key in response');
          responseData['data'] = responseData['properties'];
        } else if (responseData is List) {
          print('Response is a direct list, wrapping in data field');
          responseData['data'] = responseData;
        } else {
          return ApiResponse<PaginatedResponse<PropertyModel>>(
            success: false,
            message: 'Invalid response format: missing data field',
          );
        }
      }

      // Handle the case where the response might be a list
      if (responseData['data'] is List) {
        try {
          // Add detailed logging for debugging
          print('Parsing properties data...');
          
          // Parse each item individually to catch any parsing errors
          final items = (responseData['data'] as List).map<PropertyModel>((item) {
            try {
              print('Parsing property item: $item');
              return PropertyModel.fromJson(item as Map<String, dynamic>);
            } catch (e, stackTrace) {
              print('Error parsing property item: $e');
              print('Item data: $item');
              print('Stack trace: $stackTrace');
              rethrow;
            }
          }).toList();
          
          // Create the paginated response with the parsed items
          final paginatedResponse = PaginatedResponse<PropertyModel>(
            data: items,
            currentPage: responseData['current_page'] as int? ?? 1,
            perPage: responseData['per_page'] as int? ?? 15,
            total: responseData['total'] as int? ?? 0,
            lastPage: responseData['last_page'] as int? ?? 1,
          );

          return ApiResponse<PaginatedResponse<PropertyModel>>(
            success: true,
            data: paginatedResponse,
            message: response.message ?? 'Properties retrieved successfully',
          );
        } catch (e, stackTrace) {
          print('Error creating paginated response: $e');
          print('Stack trace: $stackTrace');
          return ApiResponse<PaginatedResponse<PropertyModel>>(
            success: false,
            message: 'Failed to parse properties data: $e',
          );
        }
      } else {
        return ApiResponse<PaginatedResponse<PropertyModel>>(
          success: false,
          message: 'Invalid response format: expected list of properties',
        );
      }
    } catch (e, stackTrace) {
      print('Error in getProperties: $e');
      print('Stack trace: $stackTrace');
      return ApiResponse<PaginatedResponse<PropertyModel>>(
        success: false,
        message: 'Error fetching properties: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<PropertyModel>> getProperty(int id) {
    return _apiService.get<PropertyModel>(
      '/properties/$id',
      fromJson: (dynamic json) => PropertyModel.fromJson(json as Map<String, dynamic>),
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
