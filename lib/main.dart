import 'package:diar_tunis/app/themes/app_theme.dart';
import 'package:diar_tunis/config/routes/app_router.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:diar_tunis/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => di.sl<AuthBloc>())],
      child: MaterialApp.router(
        title: 'Diar Tunis',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
