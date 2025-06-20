import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'driver_auth_state.dart';
import 'package:uot_transport_driver_flutter/auth_feature/model/repository/driver_auth_repository.dart';

class DriverAuthCubit extends Cubit<DriverAuthState> {
  final DriverAuthRepository _authRepository;

  DriverAuthCubit({DriverAuthRepository? authRepository})
      : _authRepository = authRepository ?? DriverAuthRepository(),
        super(DriverAuthInitial());

  Future<void> login(Map<String, dynamic> loginData) async {
    emit(DriverAuthLoading());
    try {
      print("before repo data in login");
      final response = await _authRepository.login(loginData);
      print("after repo data in login");
      final Map<String, dynamic> user = response.data['user'];
      final String token = response.data['token'];
      emit(DriverAuthSuccess(user: user, token: token));
      print("Login successful: $user, Token: $token");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('driver_user', jsonEncode(user));
      await prefs.setString('driver_token', token);

       } on DioError catch (dioErr) {
      // لو رد السيرفر 500
      if (dioErr.response?.statusCode == 500) {
        final data = dioErr.response!.data;
        final body = data is String ? json.decode(data) : data;
        final msg = body['message'] ?? 'حدث خطأ ما';
        final err = body['error'] ?? '';
        emit(DriverAuthFailure(error: '$msg\n$err'));
      } else {
        // أخطاء أخرى من Dio
        emit(DriverAuthFailure(error: dioErr.message ?? ''));
      }
    } catch (e) {
      emit(DriverAuthFailure(error: e.toString()));
    }
  }
  // Future<void> changePassword(
  //     String token, Map<String, dynamic> passwordData) async {
  //   emit(DriverAuthLoading());
  //   try {
  //     final responseData =
  //         await _authRepository.changePassword(token, passwordData);
  //     emit(DriverPasswordChangeSuccess(responseData));
  //   } catch (e) {
  //     emit(DriverAuthFailure(error: e.toString()));
  //   }
  // }
  

Future<void> changePassword(
    String token, Map<String, dynamic> passwordData) async {
  emit(DriverAuthLoading());
  try {
    final responseData =
        await _authRepository.changePassword(token, passwordData);
    emit(DriverPasswordChangeSuccess(responseData));
  } on DioError catch (dioErr) {
    final status = dioErr.response?.statusCode;
    final data = dioErr.response?.data;
    final body = data is String
        ? json.decode(data)
        : data as Map<String, dynamic>? ?? {};

    if (status == 403) {
      final msg = body['message'] ?? 'غير مسموح';
      emit(DriverPasswordChangeFailure(error: msg));
    }
    else if (status == 422) {
      // رسالة عامة
      final msg = body['message'] ?? 'Validation error';
      // جمع الأخطاء المفصلة
      final errors = body['errors'] as Map<String, dynamic>? ?? {};
      final detail = errors.values
          .expand((v) => List<String>.from(v))
          .join('\n');
      final fullMsg = detail.isNotEmpty ? '$msg\n$detail' : msg;
      emit(DriverPasswordChangeFailure(error: fullMsg));
    }
    else {
      emit(DriverPasswordChangeFailure(error: dioErr.message ?? ''));
    }
  } catch (e) {
    emit(DriverPasswordChangeFailure(error: e.toString()));
  }
}
}
