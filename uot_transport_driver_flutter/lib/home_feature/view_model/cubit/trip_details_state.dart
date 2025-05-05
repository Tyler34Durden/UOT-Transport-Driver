abstract class TripDetailsState {}

class TripDetailsInitial extends TripDetailsState {}

class TripDetailsLoading extends TripDetailsState {}

class TripDetailsSuccess extends TripDetailsState {
  final Map<String, dynamic> tripDetails;
  TripDetailsSuccess({required this.tripDetails});
}

class TripDetailsFailure extends TripDetailsState {
  final String error;
  TripDetailsFailure({required this.error});
}