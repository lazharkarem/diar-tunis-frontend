import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/usecase.dart';
import 'package:diar_tunis/features/properties/domain/repositories/property_repository.dart';
import 'package:diar_tunis/features/shared/domain/entities/property_category.dart';

class GetPropertyCategoriesUseCase
    implements UseCase<List<PropertyCategory>, NoParams> {
  final PropertyRepository repository;

  GetPropertyCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<PropertyCategory>>> call(NoParams params) async {
    try {
      final response = await repository.getPropertyCategories();
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
