part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

class GetAllPropertiesEvent extends AdminEvent {}

class UpdatePropertyStatusEvent extends AdminEvent {
  final String propertyId;
  final String status;

  const UpdatePropertyStatusEvent({
    required this.propertyId,
    required this.status,
  });

  @override
  List<Object> get props => [propertyId, status];
}

class GetAllUsersEvent extends AdminEvent {}

class UpdateUserStatusEvent extends AdminEvent {
  final String userId;
  final String status;

  const UpdateUserStatusEvent({
    required this.userId,
    required this.status,
  });

  @override
  List<Object> get props => [userId, status];
}
