import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view_model/cubit/driver_auth_cubit.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view_model/cubit/driver_auth_state.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/core_widgets/back_header.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/core/response_dialog.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/trips_dialog_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _token = '';

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('auth_token') ?? '';
    });
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      showResponseDialog(
        context,
        success: false,
        message: 'كلمة المرور الجديدة غير متطابقة مع التأكيد',
      );
      return;
    }
    // تجهيز بيانات الطلب كما هو مطلوب من API
    final passwordData = {
      "currentPassword": _currentPasswordController.text.trim(),
      "password": _newPasswordController.text.trim(),
      "password_confirmation": _confirmPasswordController.text.trim(),
    };

    // استدعاء الدالة من الـ Cubit
    context.read<DriverAuthCubit>().changePassword(_token, passwordData);
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<DriverAuthCubit, DriverAuthState>(
      listener: (context, state) {
        if (state is DriverPasswordChangeSuccess) {
          // عرض ديالوج النجاح
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => TripsDialog(
              title: SvgPicture.asset("assets/icons/check.svg"),
              content: AppText(
                textAlign: TextAlign.center,
                lbl: state.responseData['message'] ??
                    'تم تغيير كلمة المرور بنجاح',
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.textColor,
                ),
              ),
            ),
          );
          // اغلاق الديالوج بعد ثانيتين
          Future.delayed(const Duration(seconds: 2))
              .then((_) => Navigator.of(context).pop());
        } else if (state is DriverAuthFailure) {
          // عرض ديالوج الخطأ
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
                lbl: state.error,
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
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: const BackHeader(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenHeight * 0.02),
                const Center(
                  child: AppText(
                    lbl: 'تغيير كلمة المرور',
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
                  lbl: 'ادخل كلمة المرور القديمة والجديدة لتغييرها',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),
                const AppText(
                  lbl: 'كلمة المرور القديمة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 10),
                AppInput(
                  suffixIcon: const Icon(Icons.lock_open_rounded),
                  controller: _currentPasswordController,
                  hintText: 'أدخل كلمة المرور القديمة',
                  textAlign: TextAlign.right,
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                const AppText(
                  lbl: 'كلمة المرور الجديدة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 10),
                AppInput(
                  suffixIcon: const Icon(Icons.lock_rounded),
                  controller: _newPasswordController,
                  hintText: 'أدخل كلمة المرور الجديدة',
                  textAlign: TextAlign.right,
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                const AppText(
                  lbl: 'تأكيد كلمة المرور الجديدة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 10),
                AppInput(
                  suffixIcon: const Icon(Icons.lock_rounded),
                  controller: _confirmPasswordController,
                  hintText: 'أعد إدخال كلمة المرور الجديدة',
                  textAlign: TextAlign.right,
                  obscureText: true,
                ),
                SizedBox(height: screenHeight * 0.04),
                AppButton(
                  lbl: 'تغيير كلمة المرور',
                  onPressed: _changePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
