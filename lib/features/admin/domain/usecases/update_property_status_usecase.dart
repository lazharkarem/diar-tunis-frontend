import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/core/usecases/usecase.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/admin/domain/repositories/admin_repository.dart';

class UpdatePropertyStatusUseCase implements UseCase<Property, UpdatePropertyStatusParams> {
  final AdminRepository repository;

  UpdatePropertyStatusUseCase(this.repository);

  @override
  Future<Either<Failure, Property>> call(UpdatePropertyStatusParams params) async {
    return await repository.updatePropertyStatus(params.propertyId, params.status);
  }
}

class UpdatePropertyStatusParams extends Equatable {
  final String propertyId;
  final String status;

  const UpdatePropertyStatusParams({
    required this.propertyId,
    required this.status,
  });

  @override
  List<Object> get props => [propertyId, status];
}

