import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/features/authentication/domain/entities/user.dart';
import 'package:diar_tunis/features/authentication/domain/repositories/auth_repository.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/usecase.dart';
import 'package:equatable/equatable.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
