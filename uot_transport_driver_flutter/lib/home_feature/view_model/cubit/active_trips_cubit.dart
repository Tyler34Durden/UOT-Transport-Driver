import 'package:bloc/bloc.dart';
import 'active_trips_state.dart';
import '../../model/repository/active_trips_repository.dart';

class ActiveTripsCubit extends Cubit<ActiveTripsState> {
  final ActiveTripsRepository _activeTripsRepository;

  ActiveTripsCubit({ActiveTripsRepository? repository})
      : _activeTripsRepository = repository ?? ActiveTripsRepository(),
        super(ActiveTripsInitial());

  Future<void> fetchTodayTrips() async {
    emit(ActiveTripsLoading());
    try {
      final trips = await _activeTripsRepository.fetchTodayTrips();
      emit(ActiveTripsSuccess(trips: trips));
    } catch (e) {
      emit(ActiveTripsFailure(error: e.toString()));
    }
  }
}