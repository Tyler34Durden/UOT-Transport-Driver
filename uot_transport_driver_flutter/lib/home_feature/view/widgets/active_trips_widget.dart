// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
// import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
// import 'package:uot_transport_driver_flutter/core/app_colors.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view/screens/trip_details_screen.dart';

// class ActiveTripsWidget extends StatelessWidget {
//   final String busId;
//   final String tripId; // التأكد من أن هذا النص يمثل رقم الرحلة
//   final String tripState;
//   final Map<String, dynamic> firstTripRoute;
//   final Map<String, dynamic> lastTripRoute;

//   const ActiveTripsWidget({
//     Key? key,
//     required this.busId,
//     required this.tripId,
//     required this.tripState,
//     required this.firstTripRoute,
//     required this.lastTripRoute,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // استخراج البيانات من الخرائط
//     final String firstExpectedTime = firstTripRoute['expectedTime'] ?? '11';
//     final String lastExpectedTime = lastTripRoute['expectedTime'] ?? '00';
//     final String firstStation = firstTripRoute['stationName'] ?? 'xx';
//     final String lastStation = lastTripRoute['stationName'] ?? 'yy';

//     // تحويل الحالة لنص العرض
//     final String displayTripState = tripState == 'soon'
//         ? 'قيد الانتظار'
//         : tripState == 'active'
//             ? 'انطلق'
//             : tripState;

//     // تحديد لون الزر بناءً على الحالة
//     final Color buttonColor;
//     final Color buttonTextColor;
//     if (tripState == 'soon') {
//       buttonColor = Colors.grey[600]!;
//       buttonTextColor = Colors.white;
//     } else if (tripState == 'active') {
//       buttonColor = Colors.green;
//       buttonTextColor = Colors.white;
//     } else {
//       buttonColor = AppColors.secondaryColor;
//       buttonTextColor = AppColors.primaryColor;
//     }

//     return GestureDetector(
//       onTap: () {
//         // تحويل tripId إلى int؛ إذا كانت القيمة غير قابلة للتحويل سيتم تمرير 0
//         final int id = int.tryParse(tripId) ?? 0;
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => TripDetailsScreen(
//               tripId: id,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade500),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: const EdgeInsets.all(10),
//         child: Row(
//           textDirection: TextDirection.rtl,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             const SizedBox(width: 5),
//             SvgPicture.asset(
//               'assets/icons/bus.svg',
//               width: 40,
//               height: 40,
//             ),
//             const SizedBox(width: 20),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   AppText(
//                     lbl: 'الحافلة رقم: $busId',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       color: AppColors.textColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   AppText(
//                     lbl: '$firstExpectedTime - $lastExpectedTime',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: AppColors.textColor,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     textDirection: TextDirection.rtl,
//                     children: [
//                       Flexible(
//                         child: AppText(
//                           lbl: firstStation,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: AppColors.textColor,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       const SizedBox(width: 5),
//                       SvgPicture.asset(
//                         'assets/icons/arrow-right-circle.svg',
//                         width: 20,
//                         height: 20,
//                       ),
//                       Flexible(
//                         child: AppText(
//                           lbl: lastStation,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: AppColors.textColor,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Flexible(
//                   child: AppButton(
//                     lbl: displayTripState,
//                     onPressed: () {
//                       final int id = int.tryParse(tripId) ?? 0;
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => TripDetailsScreen(
//                             tripId: id,
//                           ),
//                         ),
//                       );
//                     },
//                     color: buttonColor,
//                     textColor: buttonTextColor,
//                     width: 117.5,
//                     height: 36,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/home_feature/model/repository/trip_details_repository.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/screens/trip_details_screen.dart';

class ActiveTripsWidget extends StatelessWidget {
  final String busId;
  final String tripId; // التأكد من أن هذا النص يمثل رقم الرحلة
  final String tripState;
  final Map<String, dynamic> firstTripRoute;
  final Map<String, dynamic> lastTripRoute;

  const ActiveTripsWidget({
    Key? key,
    required this.busId,
    required this.tripId,
    required this.tripState,
    required this.firstTripRoute,
    required this.lastTripRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // استخراج البيانات من الخرائط
    final String firstExpectedTime = firstTripRoute['expectedTime'] ?? '11';
    final String lastExpectedTime = lastTripRoute['expectedTime'] ?? '00';
    final String firstStation = firstTripRoute['stationName'] ?? 'xx';
    final String lastStation = lastTripRoute['stationName'] ?? 'yy';

    // تحويل الحالة لنص العرض
    final String displayTripState = tripState == 'soon'
        ? 'قيد الانتظار'
        : tripState == 'active'
            ? 'انطلق'
            : tripState;

    // تحديد لون الزر بناءً على الحالة
    final Color buttonColor;
    final Color buttonTextColor;
    if (tripState == 'soon') {
      buttonColor = Colors.grey[600]!;
      buttonTextColor = Colors.white;
    } else if (tripState == 'active') {
      buttonColor = Colors.green;
      buttonTextColor = Colors.white;
    } else {
      buttonColor = AppColors.secondaryColor;
      buttonTextColor = AppColors.primaryColor;
    }

    return GestureDetector(
      // onTap: () {
      //   // الانتقال فقط إذا كانت الحالة active
      //   final int id = int.tryParse(tripId) ?? 0;
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (context) => TripDetailsScreen(
      //         tripId: id,
      //       ),
      //     ),
      //   );
      // },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 5),
            SvgPicture.asset(
              'assets/icons/bus.svg',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(
                    lbl: 'الحافلة رقم: $busId',
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    lbl: '$firstExpectedTime - $lastExpectedTime',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Flexible(
                        child: AppText(
                          lbl: firstStation,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 5),
                      SvgPicture.asset(
                        'assets/icons/arrow-right-circle.svg',
                        width: 20,
                        height: 20,
                      ),
                      Flexible(
                        child: AppText(
                          lbl: lastStation,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                           Flexible(
                  child: AppButton(
                    lbl: displayTripState,
                    onPressed: () async {
                      if (tripState == 'soon') {
                        // نفترض أنّ بيانات المحطة الأولى تحتوي على مُعرّف المسار
                        final int routeId = firstTripRoute['id'] ?? 0;
                        if (routeId != 0) {
                          try {
                            await TripDetailsRepository().updateTripRouteStatus(routeId, 'Reached');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم تحديث الحالة إلى Reached')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('فشل تحديث الحالة')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('بيانات المحطة غير متوفرة')),
                          );
                        }
                      } else if (tripState == 'active') {
                        final int id = int.tryParse(tripId) ?? 0;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TripDetailsScreen(tripId: id),
                          ),
                        );
                      }
                    },
                    color: buttonColor,
                    textColor: buttonTextColor,
                    width: 117.5,
                    height: 36,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
