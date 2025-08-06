import 'package:diar_tunis/features/authentication/domain/usecases/get_user_profile_usecase.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_statistics_usecase.dart';
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
  final GetStatisticsUseCase _getStatisticsUseCase;

  AuthCubit(
    this._loginUseCase,
    this._registerUseCase,
    this._getProfileUseCase,
    this._updateProfileUseCase,
    this._logoutUseCase,
    this._checkAuthStatusUseCase,
    this._getStatisticsUseCase,
  ) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    try {
      final authResult = await _checkAuthStatusUseCase(NoParams());

      authResult.fold((failure) => emit(AuthUnauthenticated()), (
        isLoggedIn,
      ) async {
        if (isLoggedIn) {
          final profileResult = await _getProfileUseCase(NoParams());

          profileResult.fold(
            (failure) => emit(AuthUnauthenticated()),
            (user) => emit(AuthAuthenticated(user: user)),
          );
        } else {
          emit(AuthUnauthenticated());
        }
      });
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

      result.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (user) => emit(AuthAuthenticated(user: user)),
      );
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

      result.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (user) => emit(AuthAuthenticated(user: user)),
      );
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

      result.fold((failure) {
        emit(AuthError(message: failure.message));
        // Restore previous state after error
        emit(currentState);
      }, (user) => emit(AuthAuthenticated(user: user)));
    } catch (e) {
      emit(AuthError(message: 'Profile update failed: ${e.toString()}'));
      // Restore previous state after error
      emit(currentState);
    }
  }

  Future<void> getStatistics() async {
    if (state is! AuthAuthenticated) return;

    final currentState = state as AuthAuthenticated;
    emit(AuthLoading());

    try {
      final result = await _getStatisticsUseCase(NoParams());

      result.fold(
        (failure) {
          emit(AuthError(message: failure.message));
          // Restore previous state after error
          emit(currentState);
        },
        (statistics) {
          // For now, just restore the authenticated state
          // You might want to create a specific state for statistics
          emit(currentState);
        },
      );
    } catch (e) {
      emit(AuthError(message: 'Failed to get statistics: ${e.toString()}'));
      // Restore previous state after error
      emit(currentState);
    }
  }

  Future<void> logout() async {
    try {
      await _logoutUseCase(NoParams());
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
