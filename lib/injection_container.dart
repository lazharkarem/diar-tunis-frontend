// Core imports
import 'package:diar_tunis/core/network/api_service.dart';
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
// Properties imports
import 'package:diar_tunis/features/properties/data/datasources/property_remote_datasource.dart';
import 'package:diar_tunis/features/properties/data/repositories/property_repository_impl.dart';
import 'package:diar_tunis/features/properties/domain/repositories/property_repository.dart';
import 'package:diar_tunis/features/properties/domain/usecases/get_featured_properties_usecase.dart';
import 'package:diar_tunis/features/properties/domain/usecases/get_popular_destinations_usecase.dart';
import 'package:diar_tunis/features/properties/domain/usecases/get_properties_usecase.dart';
import 'package:diar_tunis/features/properties/domain/usecases/get_property_categories_usecase.dart';
import 'package:diar_tunis/features/properties/domain/usecases/search_properties_usecase.dart';
import 'package:diar_tunis/features/properties/presentation/cubit/properties_cubit.dart';
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

  // Properties Cubit
  sl.registerFactory(
    () => PropertiesCubit(
      sl(), // GetPropertiesUseCase
      sl(), // GetFeaturedPropertiesUseCase
      sl(), // GetPopularDestinationsUseCase
      sl(), // GetPropertyCategoriesUseCase
      sl(), // SearchPropertiesUseCase
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

  // Use Cases - Properties
  sl.registerLazySingleton(() => GetPropertiesUseCase(sl()));
  sl.registerLazySingleton(() => GetFeaturedPropertiesUseCase(sl()));
  sl.registerLazySingleton(() => GetPopularDestinationsUseCase(sl()));
  sl.registerLazySingleton(() => GetPropertyCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => SearchPropertiesUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl(sl()));
  sl.registerLazySingleton<PropertyRepository>(() => PropertyRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PropertyRemoteDataSource>(
    () => PropertyRemoteDataSourceImpl(sl()),
  );

  // Core
  sl.registerLazySingleton(() => ApiService());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => InternetConnection());

  sl.registerLazySingleton(() => Dio());

  sl.registerLazySingleton(() => SecureStorage());
}
