// Core imports
import 'package:diar_tunis/core/network/network_info.dart';
import 'package:diar_tunis/core/storage/secure_storage.dart';
// Admin imports
import 'package:diar_tunis/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:diar_tunis/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:diar_tunis/features/admin/domain/repositories/admin_repository.dart';
import 'package:diar_tunis/features/admin/domain/usecases/get_all_properties_usecase.dart';
import 'package:diar_tunis/features/admin/domain/usecases/get_all_users_usecase.dart';
import 'package:diar_tunis/features/admin/domain/usecases/update_property_status_usecase.dart';
import 'package:diar_tunis/features/admin/presentation/bloc/admin_bloc.dart';
// Authentication imports
import 'package:diar_tunis/features/authentication/data/datasources/auth_local_datasource.dart';
import 'package:diar_tunis/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:diar_tunis/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:diar_tunis/features/authentication/domain/repositories/auth_repository.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/check_auth_status_usecase.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/get_statistics_usecase.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/get_user_profile_usecase.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/login_usecase.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/register_usecase.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/update_profile_usecase.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:diar_tunis/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Authentication Cubit (NEW)
  sl.registerFactory(
    () => AuthCubit(
      sl(), // LoginUseCase
      sl(), // RegisterUseCase
      sl(), // GetProfileUseCase
      sl(), // UpdateProfileUseCase
      sl(), // LogoutUseCase
      sl(), // CheckAuthStatusUseCase
      sl(), // GetStatisticsUseCase
    ),
  );

  // Features - Authentication Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      getUserProfileUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  // Admin Bloc
  sl.registerFactory(
    () => AdminBloc(
      getAllPropertiesUseCase: sl(),
      updatePropertyStatusUseCase: sl(),
      getAllUsersUseCase: sl(),
    ),
  );

  // Use Cases - Authentication
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  // sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl())); // NEW
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl())); // NEW
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl())); // NEW
  sl.registerLazySingleton(() => GetStatisticsUseCase(sl())); // NEW
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Use Cases - Admin
  sl.registerLazySingleton(() => GetAllUsersUseCase(sl()));
  sl.registerLazySingleton(() => GetAllPropertiesUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePropertyStatusUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(dio: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => InternetConnection());

  sl.registerLazySingleton(() => Dio());

  sl.registerLazySingleton(() => SecureStorage());
}
