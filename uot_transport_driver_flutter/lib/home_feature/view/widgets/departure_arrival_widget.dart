// // // import 'package:flutter/material.dart';
// // // import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
// // // import 'package:uot_transport_driver_flutter/core/app_colors.dart';

// // // class DepartureArrivalWidget extends StatelessWidget {
// // //   final Map<String, dynamic> firstTripRoute;
// // //   final Map<String, dynamic> lastTripRoute;

// // //   const DepartureArrivalWidget({
// // //     super.key,
// // //     required this.firstTripRoute,
// // //     required this.lastTripRoute,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     // قراءة البيانات من firstTripRoute بحسب الاستجابة
// // //     final String orderNumber = firstTripRoute['OrderNumber']?.toString() ?? 'غير متوفر';
// // //     final String stationName = firstTripRoute['stationName'] ?? 'غير متوفر';
// // //     // الوقت نصي كما هو في الاستجابة "23:10"
// // //     final String time = firstTripRoute['time']?.toString() ?? 'غير متوفر';

// // //     // جلب عدد الذكور والإناث: استخدام بيانات lastTripRoute إذا كانت غير فارغة، وإلا استخدام firstTripRoute
// // //     final int maleCount = (lastTripRoute.isNotEmpty ? lastTripRoute['maleCount'] : firstTripRoute['maleCount']) ?? 0;
// // //     final int femaleCount = (lastTripRoute.isNotEmpty ? lastTripRoute['femaleCount'] : firstTripRoute['femaleCount']) ?? 0;

// // //     return Row(
// // //       children: [
// // //         Expanded(
// // //           child: Container(
// // //             margin: const EdgeInsets.all(2),
// // //             padding: const EdgeInsets.all(10),
// // //             decoration: BoxDecoration(
// // //               color: AppColors.backgroundColor,
// // //               borderRadius: BorderRadius.circular(10),
// // //               border: Border.all(color: AppColors.primaryColor),
// // //             ),
// // //             child: Row(
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               children: [
// // //                 const SizedBox(width: 10),
// // //                 Flexible(
// // //                   child: AppText(
// // //                     lbl: 'الترتيب: $orderNumber\nالمحطة: $stationName\nالوقت: $time',
// // //                     style: const TextStyle(
// // //                       color: AppColors.primaryColor,
// // //                       fontSize: 16,
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //         Expanded(
// // //           child: Container(
// // //             margin: const EdgeInsets.all(2),
// // //             padding: const EdgeInsets.all(10),
// // //             decoration: BoxDecoration(
// // //               color: AppColors.backgroundColor,
// // //               borderRadius: BorderRadius.circular(10),
// // //               border: Border.all(color: AppColors.primaryColor),
// // //             ),
// // //             child: Column(
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               children: [
// // //                 const AppText(
// // //                   lbl: 'الحاجزين',
// // //                   style: TextStyle(
// // //                     color: AppColors.primaryColor,
// // //                     fontSize: 16,
// // //                     fontWeight: FontWeight.bold,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 5),
// // //                 Row(
// // //                   mainAxisAlignment: MainAxisAlignment.center,
// // //                   children: [
// // //                     const Icon(Icons.male, color: Colors.blue),
// // //                     const SizedBox(width: 5),
// // //                     AppText(
// // //                       lbl: '$maleCount',
// // //                       style: const TextStyle(
// // //                         color: AppColors.primaryColor,
// // //                         fontSize: 16,
// // //                         fontWeight: FontWeight.bold,
// // //                       ),
// // //                     ),
// // //                     const SizedBox(width: 10),
// // //                     const Icon(Icons.female, color: Colors.pink),
// // //                     const SizedBox(width: 5),
// // //                     AppText(
// // //                       lbl: '$femaleCount',
// // //                       style: const TextStyle(
// // //                         color: AppColors.primaryColor,
// // //                         fontSize: 16,
// // //                         fontWeight: FontWeight.bold,
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
// // import 'package:uot_transport_driver_flutter/core/app_colors.dart';

// // class DepartureArrivalWidget extends StatelessWidget {
// //   final Map<String, dynamic> tripRoute;

// //    DepartureArrivalWidget({
// //     super.key,
// //     required this.tripRoute,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     // قراءة البيانات من tripRoute بحسب الاستجابة
// //     final String orderNumber =
// //         tripRoute['OrderNumber']?.toString() ?? 'غير متوفر';
// //     final String stationName = tripRoute['stationName'] ?? 'غير متوفر';
// //     final String time = tripRoute['time']?.toString() ?? 'غير متوفر';

// //     // جلب عدد الذكور والإناث من نفس tripRoute
// //     final int maleCount = tripRoute['maleCount'] ?? 0;
// //     final int femaleCount = tripRoute['femaleCount'] ?? 0;

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
// //                     lbl: 'الوقت: $time',
// //                     style: const TextStyle(
// //                       color: AppColors.primaryColor,
// //                       fontSize: 18,
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
// //                         const SizedBox(height: 5),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     AppText(
// //                       lbl: 'الحاجزين',
// //                       style: TextStyle(
// //                         color: AppColors.primaryColor,
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
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
// import 'package:logger/logger.dart';
// import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
// import 'package:uot_transport_driver_flutter/core/app_colors.dart';

// class DepartureArrivalWidget extends StatelessWidget {
//   final Logger logger = Logger();

//   final Map<String, dynamic> tripRoute;
//   final Map<String, dynamic>? nextTripRoute; // معامل بيانات المحطة القادمة

//   DepartureArrivalWidget({
//     super.key,
//     required this.tripRoute,
//     this.nextTripRoute,
//   });

//   @override
//   Widget build(BuildContext context) {

//     final int maleCount = tripRoute['maleCount'] ?? 0;
//     final int femaleCount = tripRoute['femaleCount'] ?? 0;
//     final String timeFromTrip = tripRoute['time']?.toString() ?? 'غير متوفر';
//     final String displayedTime =
//         (tripRoute['state']?.toString() == 'Reached' && nextTripRoute != null)
//             ? nextTripRoute!['time']?.toString() ?? timeFromTrip
//             : timeFromTrip;

//     logger.i(' الوقت  $displayedTime ');
//     logger.i(' nextTripRoute  $nextTripRoute ');

//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.all(2),
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: AppColors.backgroundColor,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: AppColors.primaryColor),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(width: 10),
//                     Flexible(
//                       child: AppText(
//                         lbl: 'الوقت: $displayedTime',
//                         style: const TextStyle(
//                           color: AppColors.primaryColor,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.all(2),
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: AppColors.backgroundColor,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: AppColors.primaryColor),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         AppText(
//                           lbl: 'الحاجزين',
//                           style: TextStyle(
//                             color: AppColors.primaryColor,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const Icon(Icons.male, color: Colors.blue),
//                         const SizedBox(width: 5),
//                         AppText(
//                           lbl: '$maleCount',
//                           style: const TextStyle(
//                             color: AppColors.primaryColor,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         const Icon(Icons.female, color: Colors.pink),
//                         const SizedBox(width: 5),
//                         AppText(
//                           lbl: '$femaleCount',
//                           style: const TextStyle(
//                             color: AppColors.primaryColor,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
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
  final Map<String, dynamic> nextTripRoute;
  final int delayMinutes;

  DepartureArrivalWidget({
    super.key,
    required this.tripRoute,
    required this.nextTripRoute,
    this.delayMinutes = 0,
  });

  @override
  Widget build(BuildContext context) {
    // 1) نحدد الوقت الأساسي حسب حالة المحطّة
    final bool reached =
        tripRoute['state']?.toString().toLowerCase() == 'reached';
    final String baseTime = (reached && nextTripRoute != null)
        ? nextTripRoute['time']?.toString() ?? '00:00'
        : tripRoute['time']?.toString() ?? '00:00';

    // 2) نفك الساعات والدقائق ونضيف عليها delayMinutes
    final parts = baseTime.split(':');
    int h = int.tryParse(parts[0]) ?? 0;
    int m = int.tryParse(parts[1]) ?? 0;
    m += delayMinutes;
    h += m ~/ 60;
    m = m % 60;
    final displayedTime =
        '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';

    // 3) باقي البيانات
    final int maleCount = tripRoute['maleCount'] ?? 100;
    final int femaleCount = tripRoute['femaleCount'] ?? 100;
    final int nextMaleCount = nextTripRoute['maleCount'] ?? 100;
    final int nextFemaleCount = nextTripRoute['femaleCount'] ?? 100;

    logger.i('عدد الذكور: ${tripRoute['maleCount'] ?? 100.0}');
    logger.i('عدد الإناث: ${tripRoute['femaleCount'] ?? 100.0}');
    logger.i('nextTripRoute i: $nextTripRoute');
    logger.i('رحلة التالية: ${nextTripRoute['id']}');
    logger.i('عدد الذكور في الرحلة التالية: $nextMaleCount');
    logger.i('عدد الإناث في الرحلة التالية: $nextFemaleCount');

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
                          lbl: 'الحاجزين ',
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
