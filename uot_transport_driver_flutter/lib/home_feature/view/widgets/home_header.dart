// import 'package:flutter/material.dart';
// import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
// import 'package:uot_transport_driver_flutter/core/app_colors.dart';

// class HomeHeader extends StatelessWidget {
//   const HomeHeader({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: AppColors.backgroundColor,
//         border: Border(
//           bottom: BorderSide(
//             color: AppColors.primaryColor, // لون الخط
//             width: 1.0, // عرض الخط
//           ),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 25,
//           vertical: 25,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const SizedBox(
//               child: Image(
//                 image: AssetImage('assets/images/logo-02-svg 1.png'),
//               ),
//             ),
//             const AppText(
//               lbl: 'مرحبًا، وسن',
//               style: TextStyle(
//                   color: AppColors.primaryColor,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/screens/profie_screen.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/core/app_icons.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  Future<String> _getUserFullName() async {
    final prefs = await SharedPreferences.getInstance();
    final userProfileJson = prefs.getString('user_profile');
    if (userProfileJson != null) {
      final userData = jsonDecode(userProfileJson);
      return userData['fullName'] ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: AppColors.primaryColor,
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image(
              image: AssetImage('assets/images/logo-02-svg 1.png'),
            ),

            IconButton(
             icon: SvgPicture.asset(AppIcons.settings,
                width: 28, height: 28, color: AppColors.primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DriverProfile()),
              );
            },
            ),


            // FutureBuilder<String>(
            //   future: _getUserFullName(),
            //   builder: (context, snapshot) {
            //     final fullName = snapshot.hasData ? snapshot.data! : '';
            //     return AppText(
            //       lbl: '$fullName ، مرحبًا ',
            //       style: const TextStyle(
            //         color: AppColors.primaryColor,
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
