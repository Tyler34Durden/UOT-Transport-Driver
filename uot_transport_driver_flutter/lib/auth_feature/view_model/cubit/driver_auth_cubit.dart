import 'dart:convert';
      import 'package:bloc/bloc.dart';
      import 'package:dio/dio.dart';
      import 'package:logger/logger.dart';
      import 'package:shared_preferences/shared_preferences.dart';
      import 'driver_auth_state.dart';
      import 'package:uot_transport_driver_flutter/auth_feature/model/repository/driver_auth_repository.dart';

      class DriverAuthCubit extends Cubit<DriverAuthState> {
        final DriverAuthRepository _authRepository;
        final Logger _logger = Logger();

        DriverAuthCubit({DriverAuthRepository? authRepository})
            : _authRepository = authRepository ?? DriverAuthRepository(),
              super(DriverAuthInitial());

        Future<void> login(Map<String, dynamic> loginData) async {
          emit(DriverAuthLoading());
          try {
            _logger.i("Attempting login");
            final response = await _authRepository.login(loginData);
            final Map<String, dynamic> user = response.data['user'];
            final String token = response.data['token'];

            _logger.i("Login successful");
            emit(DriverAuthSuccess(user: user, token: token));

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('driver_user', jsonEncode(user));
            await prefs.setString('driver_token', token);
          } on DioException catch (dioErr) {
            _logger.e("Login error: $dioErr");

            if (dioErr.response?.statusCode == 500) {
              final data = dioErr.response!.data;
              final body = data is String ? json.decode(data) : data;
              final msg = body['message'] ?? 'حدث خطأ في الخادم';
              final err = body['error'] ?? '';
              emit(DriverAuthFailure(error: '$msg\n$err'));
            } else {
              final errorData = dioErr.response?.data;
              if (errorData is Map && errorData['message'] != null) {
                emit(DriverAuthFailure(error: errorData['message']));
              } else {
                emit(DriverAuthFailure(error: 'فشل تسجيل الدخول، يرجى المحاولة مرة أخرى'));
              }
            }
          } catch (e) {
            _logger.e("Unexpected login error: $e");
            emit(DriverAuthFailure(error: 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى'));
          }
        }

        Future<void> changePassword(
            String token, Map<String, dynamic> passwordData) async {
          emit(DriverAuthLoading());
          try {
            _logger.i("Attempting password change");
            final responseData =
                await _authRepository.changePassword(token, passwordData);
            _logger.i("Password change successful");
            emit(DriverPasswordChangeSuccess(responseData));
          } on DioException catch (dioErr) {
            _logger.e("Password change error: $dioErr");

            final status = dioErr.response?.statusCode;
            final data = dioErr.response?.data;
            final body = data is String
                ? json.decode(data)
                : data as Map<String, dynamic>? ?? {};

            if (status == 403) {
              final msg = body['message'] ?? 'غير مسموح بهذه العملية';
              emit(DriverPasswordChangeFailure(error: msg));
            } else if (status == 422) {
              final msg = body['message'] ?? 'خطأ في البيانات المدخلة';
              final errors = body['errors'] as Map<String, dynamic>? ?? {};
              final detail = errors.values
                  .expand((v) => List<String>.from(v))
                  .join('\n');
              final fullMsg = detail.isNotEmpty ? '$msg\n$detail' : msg;
              emit(DriverPasswordChangeFailure(error: fullMsg));
            } else {
              final errorData = dioErr.response?.data;
              if (errorData is Map && errorData['message'] != null) {
                emit(DriverPasswordChangeFailure(error: errorData['message']));
              } else {
                emit(DriverPasswordChangeFailure(error: 'فشل تغيير كلمة المرور، يرجى المحاولة مرة أخرى'));
              }
            }
          } catch (e) {
            _logger.e("Unexpected password change error: $e");
            emit(DriverPasswordChangeFailure(error: 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى'));
          }
        }
      }