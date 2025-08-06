import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/usecase.dart';
import 'package:diar_tunis/features/properties/domain/repositories/property_repository.dart';
import 'package:diar_tunis/features/shared/domain/entities/destination.dart';

class GetPopularDestinationsUseCase
    implements UseCase<List<Destination>, NoParams> {
  final PropertyRepository repository;

  GetPopularDestinationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Destination>>> call(NoParams params) async {
    try {
      final response = await repository.getPopularDestinations();
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
