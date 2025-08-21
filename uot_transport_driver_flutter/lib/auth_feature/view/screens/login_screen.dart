import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/screens/main_screen.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view_model/cubit/driver_auth_cubit.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view_model/cubit/driver_auth_state.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/trips_dialog_widget.dart';

import '../../../core/core_widgets/dt_loading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => TripsDialog(
        title: Icon(
          Icons.error_outline,
          color: AppColors.btnColor,
          size: 50,
        ),
        content: AppText(
          textAlign: TextAlign.center,
          lbl: message,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textColor,
          ),
        ),
        actions: [
          Center(
            child: AppButton(
              lbl: 'حسناً',
              onPressed: () => Navigator.of(context).pop(),
              height: 50,
              width: 100,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // الحصول على مقاسات الشاشة
    final screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocConsumer<DriverAuthCubit, DriverAuthState>(
        listenWhen: (previous, current) {
          final isLoginSuccess =
              previous is DriverAuthLoading && current is DriverAuthSuccess;
          final isLoginFailure =
              previous is DriverAuthLoading && current is DriverAuthFailure;
          return isLoginSuccess || isLoginFailure;
        },
        listener: (context, state) {
          if (state is DriverAuthSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => TripsDialog(
                title: SvgPicture.asset("assets/icons/check.svg",
                    height: 80, width: 80),
                content: AppText(
                  textAlign: TextAlign.center,
                  lbl: 'تم تسجيل الدخول بنجاح',
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            );
            // اغلاق الديالوج بعد ثانيتين
            Future.delayed(const Duration(seconds: 2))
                .then((_) => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainScreen(),
                      ),
                    ));
          } else if (state is DriverAuthFailure) {
            showErrorDialog(state.error);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 96, left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(
                            child: AppText(
                              lbl: 'تسجيل الدخول',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          const AppText(
                            textAlign: TextAlign.center,
                            lbl:
                                'سجّل دخولك للوصول إلى خدمات النقل الجامعي بسهولة وراحة',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          const AppText(
                            lbl: 'ادخل رقم الهاتف',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          AppInput(
                            suffixIcon: const Icon(Icons.phone_android_rounded),
                            hintText: 'رقم الهاتف',
                            textAlign: TextAlign.right,
                            controller: phoneController,
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          const AppText(
                            lbl: 'ادخل كلمة مرورك ',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          AppInput(
                            suffixIcon: const Icon(Icons.lock_rounded),
                            prefixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: AppColors.textColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            ),
                            hintText: 'كلمة المرور',
                            textAlign: TextAlign.right,
                            obscureText: obscurePassword,
                            controller: passwordController,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(height: screenHeight * 0.06),
                          state is DriverAuthLoading
                              ? const Center(child: DTLoading(isLoading: true))
                              : AppButton(
                                  lbl: 'تسجيل الدخول',
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  height: screenHeight * 0.07,
                                  //   onPressed: () {
                                  //     context.read<DriverAuthCubit>().login({
                                  //       "phone": phoneController.text,
                                  //       "password": passwordController.text,
                                  //     });
                                  //   },
                                  // ),
                                  onPressed: () {
                                    final phone = phoneController.text.trim();
                                    final password = passwordController.text;

                                    if (phone.isEmpty && phone.isEmpty) {
                                      showErrorDialog(
                                          ' الرجاء إدخال رقم الهاتف و كلمة المرور');
                                      return;
                                    }
                                    if (phone.isEmpty) {
                                      showErrorDialog('الرجاء إدخال رقم الهاتف');
                                      return;
                                    }
                                    final phoneRegex = RegExp(r'^[0-9]{10,}$');
                                    if (!phoneRegex.hasMatch(phone)) {
                                      showErrorDialog(
                                          'تنسيق رقم الهاتف غير صحيح');
                                      return;
                                    }
                                    if (password.isEmpty) {
                                      showErrorDialog('الرجاء إدخال كلمة المرور');
                                      return;
                                    }
                                    // إذا مرّ كل شيء بنجاح، ننادي الـ cubit
                                    context.read<DriverAuthCubit>().login({
                                      "phone": phone,
                                      "password": password,
                                    });
                                  },
                                ),
                          const Spacer(),
                          SizedBox(height: screenHeight * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
