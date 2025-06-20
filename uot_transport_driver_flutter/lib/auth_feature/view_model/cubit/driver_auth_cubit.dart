import 'dart:convert';

import 'package:bloc/bloc.dart';
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
       // حفظ ל־SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('driver_user', jsonEncode(user));
    await prefs.setString('driver_token', token);
 
    } catch (e) {
      emit(DriverAuthFailure(error: e.toString()));
    }
  }
    Future<void> changePassword(String token, Map<String, dynamic> passwordData) async {
      emit(DriverAuthLoading());
      try {
        final responseData = await _authRepository.changePassword(token, passwordData);
        emit(DriverPasswordChangeSuccess(responseData));
      } catch (e) {
        emit(DriverAuthFailure(error: e.toString()));
      }
    }
}