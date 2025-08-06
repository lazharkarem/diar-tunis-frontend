// features/authentication/domain/usecases/get_statistics_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/features/authentication/domain/repositories/auth_repository.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/usecase.dart';

class GetStatisticsUseCase implements UseCase<Map<String, dynamic>, NoParams> {
  final AuthRepository repository;

  GetStatisticsUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) async {
    return await repository.getStatistics();
  }
}
