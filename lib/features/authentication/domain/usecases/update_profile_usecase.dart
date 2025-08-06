import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/features/authentication/domain/entities/user.dart';
import 'package:diar_tunis/features/authentication/domain/repositories/auth_repository.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/usecase.dart';
import 'package:equatable/equatable.dart';

class UpdateProfileUseCase implements UseCase<User, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      name: params.name,
      email: params.email,
      phone: params.phone,
      address: params.address,
      businessName: params.businessName,
      businessDescription: params.businessDescription,
      licenseNumber: params.licenseNumber,
      yearsOfExperience: params.yearsOfExperience,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? businessName;
  final String? businessDescription;
  final String? licenseNumber;
  final int? yearsOfExperience;

  const UpdateProfileParams({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.businessName,
    this.businessDescription,
    this.licenseNumber,
    this.yearsOfExperience,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    address,
    businessName,
    businessDescription,
    licenseNumber,
    yearsOfExperience,
  ];
}
