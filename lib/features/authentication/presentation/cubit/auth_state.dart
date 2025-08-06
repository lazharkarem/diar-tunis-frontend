part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final Map<String, dynamic>? errors;

  const AuthError({required this.message, this.errors});

  @override
  List<Object?> get props => [message, errors];

  bool get hasValidationErrors => errors != null && errors!.isNotEmpty;

  List<String> get validationErrorMessages {
    if (!hasValidationErrors) return [];

    final messages = <String>[];
    errors!.forEach((key, value) {
      if (value is List) {
        messages.addAll(value.map((e) => e.toString()));
      } else {
        messages.add(value.toString());
      }
    });

    return messages;
  }
}
