import 'package:bloc/bloc.dart';
import 'trip_details_state.dart';
import 'package:uot_transport_driver_flutter/home_feature/model/repository/trip_details_repository.dart';

class TripDetailsCubit extends Cubit<TripDetailsState> {
  final TripDetailsRepository _repository;

  TripDetailsCubit({TripDetailsRepository? repository})
      : _repository = repository ?? TripDetailsRepository(),
        super(TripDetailsInitial());

  Future<void> fetchTripDetails(int tripId) async {
    emit(TripDetailsLoading());
    try {
      final data = await _repository.fetchTripDetails(tripId);
      // يُفترض أن الرد يحتوي على: tripId، tripState، وtripRoute
      emit(TripDetailsSuccess(tripDetails: data));
    } catch (e) {
      emit(TripDetailsFailure(error: e.toString()));
    }
  }
}