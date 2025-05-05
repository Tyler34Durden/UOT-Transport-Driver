// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
// import 'package:uot_transport_driver_flutter/core/app_colors.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view/screens/trip_details_screen.dart';

// class InActiveTripsWidget extends StatelessWidget {
//   final String busId;
//   final String tripId;
//   final String tripState;
//   final Map<String, dynamic> firstTripRoute;
//   final Map<String, dynamic> lastTripRoute;

//   const InActiveTripsWidget({
//     super.key,
//     required this.busId,
//     required this.tripId,
//     required this.tripState,
//     required this.firstTripRoute,
//     required this.lastTripRoute,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // استخراج البيانات من الخرائط
//     final String firstExpectedTime = firstTripRoute['expectedTime'] ?? '11';
//     final String lastExpectedTime = lastTripRoute['expectedTime'] ?? '00';
//     final String firstStation = firstTripRoute['stationName'] ?? 'xx';
//     final String lastStation = lastTripRoute['stationName'] ?? 'yy';


//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => TripDetailsScreen(
//               tripId: tripId,
//               busId: busId,
//               tripState: tripState,
//               firstTripRoute: firstTripRoute,
//               lastTripRoute: lastTripRoute,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade500),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: const EdgeInsets.all(8),
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
//                   // عرض رقم الحافلة
//                   AppText(
//                     lbl: 'الحافلة رقم: $busId',
//                    style: const TextStyle(
//                       fontSize: 18,
//                       color: AppColors.textColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 const SizedBox(height: 8),
//                   Row(
//                     textDirection: TextDirection.rtl,
//                     children: [
//                       AppText( lbl: firstStation,
//                       style: const TextStyle(
//                       fontSize: 14,
//                       color: AppColors.textColor,
//                     ),),
//                       const SizedBox(width: 5),
//                       SvgPicture.asset(
//                         'assets/icons/arrow-right-circle.svg',
//                         width: 20,
//                         height: 20,
//                       ),
//                       const SizedBox(width: 5),
//                       AppText( lbl: lastStation,
//                       style: const TextStyle(
//                       fontSize: 14,
//                       color: AppColors.textColor,
//                     ),),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               children: [
//                    AppText(lbl: '$firstExpectedTime - $lastExpectedTime',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: AppColors.textColor,
//                     ),
//                   ),

//               ],
//             ),
//             const SizedBox(width: 8),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/screens/trip_details_screen.dart';

class InActiveTripsWidget extends StatelessWidget {
  final String busId;
  final String tripId;
  final String tripState;
  final Map<String, dynamic> firstTripRoute;
  final Map<String, dynamic> lastTripRoute;

  const InActiveTripsWidget({
    super.key,
    required this.busId,
    required this.tripId,
    required this.tripState,
    required this.firstTripRoute,
    required this.lastTripRoute,
  });

  @override
  Widget build(BuildContext context) {
    // استخراج البيانات من الخرائط
    final String firstExpectedTime = firstTripRoute['expectedTime'] ?? '11';
    final String lastExpectedTime = lastTripRoute['expectedTime'] ?? '00';
    final String firstStation = firstTripRoute['stationName'] ?? 'xx';
    final String lastStation = lastTripRoute['stationName'] ?? 'yy';

    return GestureDetector(
      onTap: () {
        // تحويل tripId إلى int قبل تمريره
        final int id = int.tryParse(tripId) ?? 0;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TripDetailsScreen(
              tripId: id,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
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
                  // عرض رقم الحافلة
                  AppText(
                    lbl: 'الحافلة رقم: $busId',
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      AppText(
                        lbl: firstStation,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      SvgPicture.asset(
                        'assets/icons/arrow-right-circle.svg',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 5),
                      AppText(
                        lbl: lastStation,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                AppText(
                  lbl: '$firstExpectedTime - $lastExpectedTime',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}