import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  AuthCubit(
    this._loginUseCase,
    this._registerUseCase,
    this._getProfileUseCase,
    this._updateProfileUseCase,
    this._logoutUseCase,
    this._checkAuthStatusUseCase,
  ) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    try {
      final isLoggedIn = await _checkAuthStatusUseCase();

      if (isLoggedIn) {
        final result = await _getProfileUseCase();

        if (result.isSuccess && result.data != null) {
          emit(AuthAuthenticated(user: result.data!));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    try {
      final result = await _loginUseCase(
        LoginParams(email: email, password: password),
      );

      if (result.isSuccess && result.data != null) {
        emit(AuthAuthenticated(user: result.data!));
      } else {
        emit(AuthError(message: result.message, errors: result.errors));
      }
    } catch (e) {
      emit(AuthError(message: 'Login failed: ${e.toString()}'));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String userType,
    String? phone,
    String? address,
    String? businessName,
    String? businessDescription,
    String? licenseNumber,
    int? yearsOfExperience,
  }) async {
    emit(AuthLoading());

    try {
      final result = await _registerUseCase(
        RegisterParams(
          name: name,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          userType: userType,
          phone: phone,
          address: address,
          businessName: businessName,
          businessDescription: businessDescription,
          licenseNumber: licenseNumber,
          yearsOfExperience: yearsOfExperience,
        ),
      );

      if (result.isSuccess && result.data != null) {
        emit(AuthAuthenticated(user: result.data!));
      } else {
        emit(AuthError(message: result.message, errors: result.errors));
      }
    } catch (e) {
      emit(AuthError(message: 'Registration failed: ${e.toString()}'));
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? businessName,
    String? businessDescription,
    String? licenseNumber,
    int? yearsOfExperience,
  }) async {
    if (state is! AuthAuthenticated) return;

    final currentState = state as AuthAuthenticated;
    emit(AuthLoading());

    try {
      final result = await _updateProfileUseCase(
        UpdateProfileParams(
          name: name,
          email: email,
          phone: phone,
          address: address,
          businessName: businessName,
          businessDescription: businessDescription,
          licenseNumber: licenseNumber,
          yearsOfExperience: yearsOfExperience,
        ),
      );

      if (result.isSuccess && result.data != null) {
        emit(AuthAuthenticated(user: result.data!));
      } else {
        emit(AuthError(message: result.message, errors: result.errors));
        // Restore previous state after error
        emit(currentState);
      }
    } catch (e) {
      emit(AuthError(message: 'Profile update failed: ${e.toString()}'));
      // Restore previous state after error
      emit(currentState);
    }
  }

  Future<void> logout() async {
    try {
      await _logoutUseCase();
    } catch (e) {
      // Continue with logout even if API call fails
    } finally {
      emit(AuthUnauthenticated());
    }
  }

  void clearError() {
    if (state is AuthError) {
      emit(AuthUnauthenticated());
    }
  }
}
