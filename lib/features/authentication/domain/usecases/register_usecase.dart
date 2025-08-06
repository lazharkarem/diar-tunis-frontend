import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/features/authentication/domain/entities/user.dart';
import 'package:diar_tunis/features/authentication/domain/repositories/auth_repository.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/usecase.dart';
import 'package:equatable/equatable.dart';

class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      password: params.password,
      firstName: params.firstName,
      lastName: params.lastName,
      userType: params.userType,
      phone: params.phone,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String userType;
  final String? phone;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.userType,
    this.phone,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    firstName,
    lastName,
    userType,
    phone,
  ];
}
