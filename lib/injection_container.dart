import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
import 'package:diar_tunis/features/authentication/domain/usecases/get_user_profile_usecase.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/login_usecase.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/register_usecase.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
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

  // Authentication Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Admin Use cases
  sl.registerLazySingleton(() => GetAllPropertiesUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePropertyStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetAllUsersUseCase(sl()));

  // Authentication Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Admin Repository
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Authentication Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl()),
  );

  // Admin Data sources
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(dio: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );
  sl.registerLazySingleton<SecureStorage>(
    () => SecureStorage(),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => InternetConnection());
}
