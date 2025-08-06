import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/core/usecases/usecase.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/admin/domain/repositories/admin_repository.dart';

class GetAllPropertiesUseCase implements UseCase<List<Property>, NoParams> {
  final AdminRepository repository;

  GetAllPropertiesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Property>>> call(NoParams params) async {
    return await repository.getAllProperties();
  }
}

