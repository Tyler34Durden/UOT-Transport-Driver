import 'package:bloc/bloc.dart';
          import 'package:dio/dio.dart';
          import 'package:logger/logger.dart';
          import 'active_trips_state.dart';
          import '../../model/repository/active_trips_repository.dart';

          class ActiveTripsCubit extends Cubit<ActiveTripsState> {
            final ActiveTripsRepository _activeTripsRepository;
            final Logger _logger = Logger();

            ActiveTripsCubit({ActiveTripsRepository? repository})
                : _activeTripsRepository = repository ?? ActiveTripsRepository(),
                  super(ActiveTripsInitial());

            Future<void> fetchTodayTrips() async {
              emit(ActiveTripsLoading());
              try {
                final trips = await _activeTripsRepository.fetchTodayTrips();
                emit(ActiveTripsSuccess(trips: trips));
              } on DioException catch (e) {
                _logger.e('Error while fetching active trips: $e');
                final errorData = e.response?.data;
                if (errorData is Map && errorData['message'] != null) {
                  // Use the specific Arabic error message from the server
                  emit(ActiveTripsFailure(error: errorData['message']));
                } else {
                  // Provide a user-friendly Arabic message instead of technical details
                  emit(ActiveTripsFailure(error: 'حدث خطأ أثناء جلب رحلات اليوم'));
                }
              } catch (e) {
                _logger.e('Unexpected error: $e');
                // Provide a generic Arabic error message
                emit(ActiveTripsFailure(error: 'حدث خطأ غير متوقع'));
              }
            }
          }