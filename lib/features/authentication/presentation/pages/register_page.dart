import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_event.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_state.dart';
import 'package:diar_tunis/features/authentication/presentation/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration successful!')),
            );
            // Navigate based on user type
            switch (state.user.userType.toLowerCase()) {
              case 'admin':
                context.go('/admin_dashboard');
                break;
              case 'host':
                context.go('/host_dashboard');
                break;
              case 'guest':
              case 'service_customer':
                context.go('/guest_home');
                break;
              default:
                context.go('/guest_home');
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create Your Account',
                    style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 32),
                  AuthForm(
                    isLogin: false,
                    isLoading: state is AuthLoading,
                    onSubmit: (email, password) {},
                    onRegister:
                        (email, password, firstName, lastName, userType) {
                          context.read<AuthBloc>().add(
                            AuthRegisterRequested(
                              email: email,
                              password: password,
                              firstName: firstName,
                              lastName: lastName,
                              userType: userType,
                            ),
                          );
                        },
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: Text(
                      'Already have an account? Login',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
