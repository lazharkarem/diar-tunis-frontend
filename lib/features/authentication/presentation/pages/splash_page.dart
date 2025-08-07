import 'package:diar_tunis/app/routes/app_routes.dart';
import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_event.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _backgroundColorAnimation = ColorTween(
      begin: AppColors.primary,
      end: AppColors.primaryDark,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoController.forward();
    _textController.forward();

    // Check authentication status after a delay
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.read<AuthBloc>().add(AuthCheckRequested());
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundColorAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _backgroundColorAnimation.value ?? AppColors.primary,
                  AppColors.primaryDark,
                ],
              ),
            ),
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                print('[SplashPage] Auth state: ${state.runtimeType}');
                if (state is AuthAuthenticated) {
                  print('[SplashPage] User authenticated. Type: ${state.user.userType}');
                  print('[SplashPage] User: ${state.user.toString()}');
                  switch (state.user.userType.toLowerCase()) {
                    case 'admin':
                      print('[SplashPage] Redirecting to admin');
                      context.go(AppRoutes.adminHome);
                      break;
                    case 'host':
                      print('[SplashPage] Redirecting to host');
                      context.go(AppRoutes.hostHome);
                      break;
                    default:
                      print('[SplashPage] Redirecting to guest (default)');
                      context.go(AppRoutes.guestHome);
                  }
                } else if (state is AuthUnauthenticated) {
                  print('[SplashPage] User not authenticated, going to login');
                  context.go(AppRoutes.login);
                } else if (state is AuthError) {
                  print('[SplashPage] Auth error, going to login');
                  context.go(AppRoutes.login);
                }
              },
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated logo
                          AnimatedBuilder(
                            animation: _logoAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _logoAnimation.value,
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(70),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.location_city,
                                    size: 70,
                                    color: AppColors.primary,
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 40),

                          // Animated app name
                          AnimatedBuilder(
                            animation: _textAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, 20 * (1 - _textAnimation.value)),
                                child: Opacity(
                                  opacity: _textAnimation.value,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Diar Tunis',
                                        style: AppTextStyles.h1.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Discover authentic Tunisian experiences',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: Colors.white.withValues(alpha: 0.9),
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 60),

                          // Loading indicator with animation
                          AnimatedBuilder(
                            animation: _textAnimation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _textAnimation.value,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.secondary,
                                        ),
                                        strokeWidth: 3,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      state is AuthLoading
                                          ? 'Checking authentication...'
                                          : 'Loading...',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.white.withValues(alpha: 0.8),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
