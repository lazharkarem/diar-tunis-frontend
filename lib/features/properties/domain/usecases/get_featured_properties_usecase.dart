import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/usecase.dart';
import 'package:diar_tunis/features/properties/domain/repositories/property_repository.dart';
import 'package:equatable/equatable.dart';

class GetFeaturedPropertiesUseCase
    implements UseCase<List<Property>, FeaturedPropertiesParams> {
  final PropertyRepository repository;

  GetFeaturedPropertiesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Property>>> call(
    FeaturedPropertiesParams params,
  ) async {
    try {
      final response = await repository.getFeaturedProperties(
        limit: params.limit,
      );

      if (response.success) {
        return Right(response.data ?? []);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class FeaturedPropertiesParams extends Equatable {
  final int limit;

  const FeaturedPropertiesParams({required this.limit});

  @override
  List<Object> get props => [limit];
}
