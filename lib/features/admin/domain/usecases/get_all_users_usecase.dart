import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/core/usecases/usecase.dart';
import 'package:diar_tunis/features/authentication/domain/entities/user.dart';
import 'package:diar_tunis/features/admin/domain/repositories/admin_repository.dart';

class GetAllUsersUseCase implements UseCase<List<User>, NoParams> {
  final AdminRepository repository;

  GetAllUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(NoParams params) async {
    return await repository.getAllUsers();
  }
}

