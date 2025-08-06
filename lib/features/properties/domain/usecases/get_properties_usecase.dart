import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/core/network/api_service.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/usecase.dart';
import 'package:diar_tunis/features/properties/domain/repositories/property_repository.dart';

class GetPropertiesUseCase
    implements UseCase<PaginatedResponse<Property>, GetPropertiesParams> {
  final PropertyRepository repository;

  GetPropertiesUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedResponse<Property>>> call(
    GetPropertiesParams params,
  ) async {
    try {
      final response = await repository.getProperties(
        page: params.page,
        perPage: params.perPage,
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

class GetPropertiesParams {
  final int page;
  final int perPage;

  const GetPropertiesParams({required this.page, required this.perPage});
}
