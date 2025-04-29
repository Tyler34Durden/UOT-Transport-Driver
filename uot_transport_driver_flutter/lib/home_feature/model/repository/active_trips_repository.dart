import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport_driver_flutter/core/api_service.dart';

class ActiveTripsRepository {
  final ApiService _apiService;
  final Logger logger = Logger();

  ActiveTripsRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<List<Map<String, dynamic>>> fetchTodayTrips() async {
    try {
      logger.i('ActiveTripsRepository: بدء عملية جلب الرحلات.');
      
      // استرداد التوكن من SharedPreferences
      logger.i('ActiveTripsRepository: جلب التوكن من SharedPreferences.');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      if (token.isEmpty) {
        logger.w('ActiveTripsRepository: التوكن فارغ، قد لا يكون المستخدم مسجلاً.');
      } else {
        logger.i('ActiveTripsRepository: التوكن موجود.');
      }
      
      logger.i('ActiveTripsRepository: إرسال طلب GET إلى endpoint "trip/driver/todayTrips".');
      final response = await _apiService.getRequest(
        'trip/driver/todayTrips',
        token: token,
      );
      
      logger.i('ActiveTripsRepository: تم استلام الرد، حالة الاستجابة: ${response.statusCode}.');
      logger.i('ActiveTripsRepository: بيانات الرد: ${response.data}');
      
      final List data = response.data;
      logger.i('ActiveTripsRepository: عدد الرحلات المسترجعة: ${data.length}.');
      return List<Map<String, dynamic>>.from(data);
      
    } on DioError catch (e) {
      logger.e('ActiveTripsRepository: DioError أثناء جلب الرحلات.');
      logger.e('الرسالة: ${e.message}');
      logger.e('نوع الخطأ: ${e.type}');
      logger.e('الخادم: ${e.response?.statusCode ?? "لا يوجد استجابة"}');
      logger.e('بيانات الخطأ: ${e.response?.data ?? "لا توجد بيانات"}');
      rethrow;
    } catch (e) {
      logger.e('ActiveTripsRepository: خطأ غير متوقع: $e');
      rethrow;
    }
  }
}