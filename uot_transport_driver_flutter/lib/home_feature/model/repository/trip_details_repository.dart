import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport_driver_flutter/core/api_service.dart';

class TripDetailsRepository {
  final ApiService _apiService;
  final Logger logger = Logger();

  TripDetailsRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<Map<String, dynamic>> fetchTripDetails(int tripId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      logger.i('TripDetailsRepository: جلب تفاصيل الرحلة بالمعرّف $tripId');
      
      // استدعاء الـ API باستخدام endpoint: herokuURL/trip/<<id>>/driver
      final response = await _apiService.getRequest('trip/$tripId/driver', token: token);
      logger.i('TripDetailsRepository: تم استلام الرد ${response.data}');
      
      return response.data;
    } on DioError catch (e) {
      logger.e('TripDetailsRepository: DioError - ${e.message}');
      rethrow;
    } catch (e) {
      logger.e('TripDetailsRepository: خطأ غير متوقع - $e');
      rethrow;
    }
  }
}