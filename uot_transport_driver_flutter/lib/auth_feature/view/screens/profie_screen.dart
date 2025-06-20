import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/screens/change_password_scren.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/screens/login_screen.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/core/core_widgets/back_header.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view_model/cubit/driver_auth_cubit.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view_model/cubit/driver_auth_state.dart';

class DriverProfile extends StatefulWidget {
  const DriverProfile({Key? key}) : super(key: key);

  @override
  _DriverProfileState createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
  @override
  void initState() {
    super.initState();
    _loadSavedUser();
  }

  Future<void> _loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('driver_user');
    final token = prefs.getString('driver_token');
    if (userJson != null && token != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      context.read<DriverAuthCubit>().emit(
            DriverAuthSuccess(user: userMap, token: token),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverAuthCubit, DriverAuthState>(
      builder: (context, state) {
        // في حالة النجاح نستخدم بيانات السائق من الحالة
        final String name = state is DriverAuthSuccess
            ? state.user['fullName'] ?? 'غير متوفر'
            : 'غير متوفر';
        final String email = state is DriverAuthSuccess
            ? state.user['email'] ?? 'غير متوفر'
            : 'غير متوفر';
        final String phone = state is DriverAuthSuccess
            ? state.user['phone'] ?? 'غير متوفر'
            : 'غير متوفر';

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: BackHeader(),
          body: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Center(
                      child: AppText(
                        lbl: 'بيانات السائق',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(26),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 30),
                          const AppText(
                            lbl: 'الإسم الثلاثي',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          AppText(
                            lbl: name,
                            style: const TextStyle(
                                fontSize: 18, color: AppColors.primaryColor),
                          ),
                          const SizedBox(height: 10),
                          const AppText(
                            lbl: 'البريد الإلكتروني',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          AppText(
                            lbl: email,
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const AppText(
                            lbl: 'رقم الهاتف',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          AppText(
                            lbl: phone,
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 60),
                          AppButton(
                            lbl: 'تغيير كلمة المرور',
                            color: AppColors.secondaryColor,
                            textColor: AppColors.primaryColor,
                      onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ChangePasswordScreen(),
                              ),
                            ).then((_) {
                              _loadSavedUser();
                            });
                          },
                        ),
                          const SizedBox(height: 20),
                          AppButton(
                            lbl: 'تسجيل خروج',
                            color: AppColors.primaryColor,
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: const AppText(
                              lbl:
                                  '* في حالة الرغبة في تغيير أي من الإسم أو البريد الإلكتروني أو رقم الهاتف الرجاء التواصل مع إدارة النقل الطلابي',
                              style: TextStyle(
                                  fontSize: 16, color: AppColors.textColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
