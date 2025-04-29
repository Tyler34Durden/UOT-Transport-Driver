
abstract class ActiveTripsState {}

class ActiveTripsInitial extends ActiveTripsState {}

class ActiveTripsLoading extends ActiveTripsState {}

class ActiveTripsSuccess extends ActiveTripsState {
  final List<Map<String, dynamic>> trips;
  ActiveTripsSuccess({required this.trips});
}

class ActiveTripsFailure extends ActiveTripsState {
  final String error;
  ActiveTripsFailure({required this.error});
}