import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/authentication/domain/entities/user.dart';
import 'package:diar_tunis/features/admin/domain/usecases/get_all_properties_usecase.dart';
import 'package:diar_tunis/features/admin/domain/usecases/update_property_status_usecase.dart';
import 'package:diar_tunis/features/admin/domain/usecases/get_all_users_usecase.dart';
import 'package:diar_tunis/core/usecases/usecase.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetAllPropertiesUseCase getAllPropertiesUseCase;
  final UpdatePropertyStatusUseCase updatePropertyStatusUseCase;
  final GetAllUsersUseCase getAllUsersUseCase;

  AdminBloc({
    required this.getAllPropertiesUseCase,
    required this.updatePropertyStatusUseCase,
    required this.getAllUsersUseCase,
  }) : super(AdminInitial()) {
    on<GetAllPropertiesEvent>(_onGetAllProperties);
    on<UpdatePropertyStatusEvent>(_onUpdatePropertyStatus);
    on<GetAllUsersEvent>(_onGetAllUsers);
  }

  Future<void> _onGetAllProperties(
    GetAllPropertiesEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    
    final result = await getAllPropertiesUseCase(NoParams());
    
    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (properties) => emit(PropertiesLoaded(properties)),
    );
  }

  Future<void> _onUpdatePropertyStatus(
    UpdatePropertyStatusEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    
    final result = await updatePropertyStatusUseCase(
      UpdatePropertyStatusParams(
        propertyId: event.propertyId,
        status: event.status,
      ),
    );
    
    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (property) => emit(PropertyStatusUpdated(property)),
    );
  }

  Future<void> _onGetAllUsers(
    GetAllUsersEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    
    final result = await getAllUsersUseCase(NoParams());
    
    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (users) => emit(UsersLoaded(users)),
    );
  }
}
