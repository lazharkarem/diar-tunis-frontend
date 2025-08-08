import 'package:diar_tunis/features/authentication/domain/usecases/check_auth_status_usecase.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/login_usecase.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/register_usecase.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.checkAuthStatusUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) {
        print('[AuthBloc] Login successful. User type: ${user.userType}');
        print('[AuthBloc] User: ${user.toString()}');
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await registerUseCase(
      RegisterParams(
        name: '${event.firstName} ${event.lastName}',
        email: event.email,
        password: event.password,
        confirmPassword: event.password,
        userType: event.userType,
        phone: event.phone,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('[AuthBloc] Logout requested');
    emit(AuthLoading());

    final result = await logoutUseCase(NoParams());

    result.fold(
      (failure) {
        print('[AuthBloc] Logout failed: ${failure.message}');
        emit(AuthError(message: failure.message));
      },
      (_) {
        print('[AuthBloc] Logout successful, emitting AuthUnauthenticated');
        emit(AuthUnauthenticated());
      },
    );
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    // First check if user is logged in
    final isLoggedInResult = await checkAuthStatusUseCase(NoParams());
    
    final isLoggedIn = isLoggedInResult.fold(
      (failure) => false,
      (loggedIn) => loggedIn,
    );

    if (isLoggedIn) {
      // User is logged in, get current user
      final userResult = await getCurrentUserUseCase(NoParams());
      
      userResult.fold(
        (failure) => emit(AuthUnauthenticated()),
        (user) {
          print('[AuthBloc] Auth check successful. User type: ${user.userType}');
          print('[AuthBloc] User: ${user.toString()}');
          emit(AuthAuthenticated(user: user));
        },
      );
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
