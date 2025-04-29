abstract class DriverAuthState {}

class DriverAuthInitial extends DriverAuthState {}

class DriverAuthLoading extends DriverAuthState {}

class DriverAuthSuccess extends DriverAuthState {
  final Map<String, dynamic> user;
  final String token;

  DriverAuthSuccess({
    required this.user,
    required this.token,
  });
}

class DriverAuthFailure extends DriverAuthState {
  final String error;

  DriverAuthFailure({required this.error});
}