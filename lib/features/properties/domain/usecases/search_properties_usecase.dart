import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/core/network/api_service.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/usecase.dart';
import 'package:diar_tunis/features/properties/domain/repositories/property_repository.dart';

class SearchPropertiesUseCase
    implements UseCase<PaginatedResponse<Property>, SearchPropertiesParams> {
  final PropertyRepository repository;

  SearchPropertiesUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedResponse<Property>>> call(
    SearchPropertiesParams params,
  ) async {
    try {
      final response = await repository.searchProperties(
        query: params.query,
        page: params.page,
        perPage: params.perPage,
        city: params.city,
        type: params.type,
        minPrice: params.minPrice,
        maxPrice: params.maxPrice,
        guests: params.guests,
      );
      if (response.success) {
        return Right(
          response.data ??
              PaginatedResponse(
                data: [],
                currentPage: 1,
                lastPage: 1,
                total: 0,
                perPage: params.perPage,
              ),
        );
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class SearchPropertiesParams {
  final String query;
  final int page;
  final int perPage;
  final String? city;
  final String? type;
  final double? minPrice;
  final double? maxPrice;
  final int? guests;

  const SearchPropertiesParams({
    required this.query,
    required this.page,
    required this.perPage,
    this.city,
    this.type,
    this.minPrice,
    this.maxPrice,
    this.guests,
  });
}
