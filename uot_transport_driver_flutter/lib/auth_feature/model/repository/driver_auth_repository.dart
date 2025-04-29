import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uot_transport_driver_flutter/core/api_service.dart';

class DriverAuthRepository {
  final ApiService _apiService;
  final Logger logger = Logger();

  DriverAuthRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<Response> login(Map<String, dynamic> loginData) async {
    try {
      // الحصول على FCM Token وإضافته إلى بيانات تسجيل الدخول
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        loginData['fcm_token'] = fcmToken;
      }

      final response = await _apiService.postRequest('driver/login', loginData);

      // استخراج وحفظ بيانات التوكن والمستخدم
      final token = response.data['token'];
      final user = response.data['user'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_profile', jsonEncode(user));

      logger.i(
          'Token saved: $token, user data saved: $user, and FCM Token: $fcmToken');
      return response;
    } on DioError catch (e) {
      logger.e('DioError: ${e.message}');
      if (e.response != null) {
        logger.e('DioError Response: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
