import 'package:flutter/material.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key,});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: AppColors.primaryColor, // لون الخط
            width: 1.0, // عرض الخط
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 25,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
         
           
            const SizedBox(
              child: Image(
                image: AssetImage('assets/images/logo-02-svg 1.png'),
              ),
            ),
            const AppText(lbl: 'مرحبًا، وسن', style: TextStyle(color: AppColors.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),),
         
          ],
        ),
      ),
    );
  }
}