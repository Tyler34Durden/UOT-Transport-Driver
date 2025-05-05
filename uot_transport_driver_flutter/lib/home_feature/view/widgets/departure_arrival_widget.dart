// // import 'package:flutter/material.dart';
// // import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
// // import 'package:uot_transport_driver_flutter/core/app_colors.dart';

// // class DepartureArrivalWidget extends StatelessWidget {
// //   final Map<String, dynamic> firstTripRoute;
// //   final Map<String, dynamic> lastTripRoute;

// //   const DepartureArrivalWidget({
// //     super.key,
// //     required this.firstTripRoute,
// //     required this.lastTripRoute,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: [
// //         Expanded(
// //           child: Container(
// //             margin: const EdgeInsets.all(2),
// //             padding: const EdgeInsets.all(10),
// //             decoration: BoxDecoration(
// //               color: AppColors.backgroundColor,
// //               borderRadius: BorderRadius.circular(10),
// //               border: Border.all(color: AppColors.primaryColor),
// //             ),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 const SizedBox(width: 10),
// //                 Flexible(
// //                   child: AppText(
// //                     lbl: 'الوصول المتوقع: ${firstTripRoute['expectedTime'] ?? 'غير متوفر'}',
// //                     style: const TextStyle(
// //                       color: AppColors.primaryColor,
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //                 // const Icon(Icons.departure_board, color: Colors.green),
// //               ],
// //             ),
// //           ),
// //         ),
// //         Expanded(
// //           child: Container(
// //             margin: const EdgeInsets.all(2),
// //             padding: const EdgeInsets.all(10),
// //             decoration: BoxDecoration(
// //               color: AppColors.backgroundColor,
// //               borderRadius: BorderRadius.circular(10),
// //               border: Border.all(color: AppColors.primaryColor),
// //             ),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 const SizedBox(width: 10),
// //                 Flexible(
// //                   child: AppText(
// //                     lbl: 'الحاجزين: ${lastTripRoute['expectedTime'] ?? 'غير متوفر'}',
// //                     style: const TextStyle(
// //                       color: AppColors.primaryColor,
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //                 const Icon(Icons.person, color: Colors.green),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
// import 'package:uot_transport_driver_flutter/core/app_colors.dart';

// class DepartureArrivalWidget extends StatelessWidget {
//   final Map<String, dynamic> firstTripRoute;
//   final Map<String, dynamic> lastTripRoute;

//   const DepartureArrivalWidget({
//     super.key,
//     required this.firstTripRoute,
//     required this.lastTripRoute,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // استخدام بيانات firstTripRoute لعرض الترتيب واسم المحطة
//     final String orderNumber = firstTripRoute['OrderNumber']?.toString() ?? 'غير متوفر';
//     final String stationName = firstTripRoute['stationName'] ?? 'غير متوفر';
//     // استخدام بيانات lastTripRoute لعرض حالة المحطة وعدد الحاجزين
//     final String state = lastTripRoute['state'] ?? 'غير متوفر';
//     final int maleCount = lastTripRoute['maleCount'] ?? 0;
//     final int femaleCount = lastTripRoute['femaleCount'] ?? 0;
//     final String passengers = '$maleCount، $femaleCount';

//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             margin: const EdgeInsets.all(2),
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: AppColors.backgroundColor,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: AppColors.primaryColor),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(width: 10),
//                 Flexible(
//                   child: AppText(
//                     lbl: 'الترتيب: $orderNumber\nالمحطة: $stationName',
//                     style: const TextStyle(
//                       color: AppColors.primaryColor,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Expanded(
//           child: Container(
//             margin: const EdgeInsets.all(2),
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: AppColors.backgroundColor,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: AppColors.primaryColor),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(width: 10),
//                 Flexible(
//                   child: AppText(
//                     lbl: 'الحاجزين \n$maleCount',
//                     style: const TextStyle(
//                       color: AppColors.primaryColor,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const Icon(Icons.person, color: Colors.blue ,),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';

class DepartureArrivalWidget extends StatelessWidget {
  final Map<String, dynamic> firstTripRoute;
  final Map<String, dynamic> lastTripRoute;

  const DepartureArrivalWidget({
    super.key,
    required this.firstTripRoute,
    required this.lastTripRoute,
  });

  @override
  Widget build(BuildContext context) {
    // استخدام بيانات firstTripRoute لعرض الترتيب واسم المحطة
    final String orderNumber = firstTripRoute['OrderNumber']?.toString() ?? 'غير متوفر';
    final String stationName = firstTripRoute['stationName'] ?? 'غير متوفر';
    // استخدام بيانات lastTripRoute لعرض الحاجزين وعدد الذكور والإناث
    final int maleCount = lastTripRoute['maleCount'] ?? 0;
    final int femaleCount = lastTripRoute['femaleCount'] ?? 0;

    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primaryColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Flexible(
                  child: AppText(
                    lbl: 'الترتيب: $orderNumber\nالمحطة: $stationName',
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primaryColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppText(
                  lbl: 'الحاجزين',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.male, color: Colors.blue),
                    const SizedBox(width: 5),
                    AppText(
                      lbl: '$maleCount',
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.female, color: Colors.pink),
                    const SizedBox(width: 5),
                    AppText(
                      lbl: '$femaleCount',
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}