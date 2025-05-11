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
// //     // قراءة البيانات من firstTripRoute بحسب الاستجابة
// //     final String orderNumber = firstTripRoute['OrderNumber']?.toString() ?? 'غير متوفر';
// //     final String stationName = firstTripRoute['stationName'] ?? 'غير متوفر';
// //     // الوقت نصي كما هو في الاستجابة "23:10"
// //     final String time = firstTripRoute['time']?.toString() ?? 'غير متوفر';

// //     // جلب عدد الذكور والإناث: استخدام بيانات lastTripRoute إذا كانت غير فارغة، وإلا استخدام firstTripRoute
// //     final int maleCount = (lastTripRoute.isNotEmpty ? lastTripRoute['maleCount'] : firstTripRoute['maleCount']) ?? 0;
// //     final int femaleCount = (lastTripRoute.isNotEmpty ? lastTripRoute['femaleCount'] : firstTripRoute['femaleCount']) ?? 0;

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
// //                     lbl: 'الترتيب: $orderNumber\nالمحطة: $stationName\nالوقت: $time',
// //                     style: const TextStyle(
// //                       color: AppColors.primaryColor,
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
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
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 const AppText(
// //                   lbl: 'الحاجزين',
// //                   style: TextStyle(
// //                     color: AppColors.primaryColor,
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 5),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     const Icon(Icons.male, color: Colors.blue),
// //                     const SizedBox(width: 5),
// //                     AppText(
// //                       lbl: '$maleCount',
// //                       style: const TextStyle(
// //                         color: AppColors.primaryColor,
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     const Icon(Icons.female, color: Colors.pink),
// //                     const SizedBox(width: 5),
// //                     AppText(
// //                       lbl: '$femaleCount',
// //                       style: const TextStyle(
// //                         color: AppColors.primaryColor,
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
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
//   final Map<String, dynamic> tripRoute;

//    DepartureArrivalWidget({
//     super.key,
//     required this.tripRoute,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // قراءة البيانات من tripRoute بحسب الاستجابة
//     final String orderNumber =
//         tripRoute['OrderNumber']?.toString() ?? 'غير متوفر';
//     final String stationName = tripRoute['stationName'] ?? 'غير متوفر';
//     final String time = tripRoute['time']?.toString() ?? 'غير متوفر';

//     // جلب عدد الذكور والإناث من نفس tripRoute
//     final int maleCount = tripRoute['maleCount'] ?? 0;
//     final int femaleCount = tripRoute['femaleCount'] ?? 0;

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
//                     lbl: 'الوقت: $time',
//                     style: const TextStyle(
//                       color: AppColors.primaryColor,
//                       fontSize: 18,
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
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                         const SizedBox(height: 5),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     AppText(
//                       lbl: 'الحاجزين',
//                       style: TextStyle(
//                         color: AppColors.primaryColor,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Icon(Icons.male, color: Colors.blue),
//                     const SizedBox(width: 5),
//                     AppText(
//                       lbl: '$maleCount',
//                       style: const TextStyle(
//                         color: AppColors.primaryColor,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     const Icon(Icons.female, color: Colors.pink),
//                     const SizedBox(width: 5),
//                     AppText(
//                       lbl: '$femaleCount',
//                       style: const TextStyle(
//                         color: AppColors.primaryColor,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';

class DepartureArrivalWidget extends StatelessWidget {
  final Logger logger = Logger();

  final Map<String, dynamic> tripRoute;
  final Map<String, dynamic>? nextTripRoute; // معامل بيانات المحطة القادمة

  DepartureArrivalWidget({
    super.key,
    required this.tripRoute,
    this.nextTripRoute,
  });

  @override
  Widget build(BuildContext context) {

    final int maleCount = tripRoute['maleCount'] ?? 0;
    final int femaleCount = tripRoute['femaleCount'] ?? 0;
    final String timeFromTrip = tripRoute['time']?.toString() ?? 'غير متوفر';
    final String displayedTime =
        (tripRoute['state']?.toString() == 'Reached' && nextTripRoute != null)
            ? nextTripRoute!['time']?.toString() ?? timeFromTrip
            : timeFromTrip;

    logger.i(' الوقت  $displayedTime ');
    logger.i(' nextTripRoute  $nextTripRoute ');

    return Column(
      children: [
        Row(
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
                        lbl: 'الوقت: $displayedTime',
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 18,
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
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          lbl: 'الحاجزين',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
        ),
      ],
    );
  }
}
