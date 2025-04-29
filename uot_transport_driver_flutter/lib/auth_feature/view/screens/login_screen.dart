import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/screens/home_screen.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view_model/cubit/driver_auth_cubit.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view_model/cubit/driver_auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController phoneController;
  late TextEditingController passwordController;

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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<DriverAuthCubit, DriverAuthState>(
      listener: (context, state) {
        if (state is DriverAuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (state is DriverAuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Padding(
            padding: const EdgeInsets.only(top: 96, left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  lbl: 'سجّل دخولك للوصول إلى خدمات النقل الجامعي بسهولة وراحة',
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
                  hintText: 'كلمة المرور ',
                  textAlign: TextAlign.right,
                  obscureText: true,
                  controller: passwordController,
                ),
                SizedBox(height: screenHeight * 0.02),
                AppText(
                  lbl: 'هل نسيت كلمة مرورك؟',
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.right,
                  onTap: () {
                    // التعامل مع حدث نسيان كلمة المرور 
                    print('Forgot password tapped!');
                  },
                ),
                SizedBox(height: screenHeight * 0.06),
                state is DriverAuthLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AppButton(
                        lbl: 'تسجيل الدخول',
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.07,
                        onPressed: () {
                          context.read<DriverAuthCubit>().login({
                            "phone": phoneController.text,
                            "password": passwordController.text,
                          });
                        },
                      ),
                const Spacer(),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        );
      },
    );
  }
}