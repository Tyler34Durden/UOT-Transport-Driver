import 'package:bloc/bloc.dart';
          import 'package:dio/dio.dart';
          import 'package:logger/logger.dart';
          import 'trip_details_state.dart';
          import 'package:uot_transport_driver_flutter/home_feature/model/repository/trip_details_repository.dart';

          class TripDetailsCubit extends Cubit<TripDetailsState> {
            final TripDetailsRepository _repository;
            final Logger _logger = Logger();

            TripDetailsCubit({TripDetailsRepository? repository})
                : _repository = repository ?? TripDetailsRepository(),
                  super(TripDetailsInitial());

            Future<void> fetchTripDetails(int tripId) async {
              emit(TripDetailsLoading());
              try {
                final data = await _repository.fetchTripDetails(tripId);
                emit(TripDetailsSuccess(tripDetails: data));
              } on DioException catch (e) {
                _logger.e('Error while fetching trip details: $e');
                final errorData = e.response?.data;
                if (errorData is Map && errorData['message'] != null) {
                  // Extract the specific Arabic error message
                  emit(TripDetailsFailure(error: errorData['message']));
                } else {
                  emit(TripDetailsFailure(error: 'حدث خطأ أثناء جلب بيانات الرحلة'));
                }
              } catch (e) {
                _logger.e('Unexpected error: $e');
                emit(TripDetailsFailure(error: 'حدث خطأ غير متوقع'));
              }
            }
          }