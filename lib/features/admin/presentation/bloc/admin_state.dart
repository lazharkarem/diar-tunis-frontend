part of 'admin_bloc.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminError extends AdminState {
  final String message;

  const AdminError(this.message);

  @override
  List<Object> get props => [message];
}

class PropertiesLoaded extends AdminState {
  final List<Property> properties;

  const PropertiesLoaded(this.properties);

  @override
  List<Object> get props => [properties];
}

class PropertyStatusUpdated extends AdminState {
  final Property property;

  const PropertyStatusUpdated(this.property);

  @override
  List<Object> get props => [property];
}

class UsersLoaded extends AdminState {
  final List<User> users;

  const UsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UserStatusUpdated extends AdminState {
  final User user;

  const UserStatusUpdated(this.user);

  @override
  List<Object> get props => [user];
}
