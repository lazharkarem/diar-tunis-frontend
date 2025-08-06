import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/features/authentication/domain/entities/user.dart';
import 'package:diar_tunis/features/authentication/domain/repositories/auth_repository.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/usecase.dart';

class GetUserProfileUseCase implements UseCase<User, NoParams> {
  final AuthRepository repository;

  GetUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
