// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
// import 'package:uot_transport_driver_flutter/core/app_colors.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view/screens/trip_details_screen.dart'; // تم الربط مع صفحة تفاصيل الرحلة

// class ActiveTripsWidget extends StatelessWidget {
//   final String busId;
//   final String tripId;
//   final String tripState;
//   final Map<String, dynamic> firstTripRoute;
//   final Map<String, dynamic> lastTripRoute;

//   const ActiveTripsWidget({
//     super.key,
//     required this.busId,
//     required this.tripId,
//     required this.tripState,
//     required this.firstTripRoute,
//     required this.lastTripRoute,
//   });

//   @override
//   Widget build(BuildContext context) {
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
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: const EdgeInsets.all(8),
//         child: Row(
//           textDirection: TextDirection.rtl,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(width: 5),
//             SvgPicture.asset('assets/icons/bus.svg'),
//             const SizedBox(width: 20),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   const Text('اسم الحافلة'),
//                   const Text("12:00 - 13:00"),
//                   Row(
//                     textDirection: TextDirection.rtl,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       const Text('من'),
//                       const SizedBox(width: 5),
//                       SvgPicture.asset('assets/icons/arrow-right-circle.svg'),
//                       const SizedBox(width: 5),
//                       const Text('الى'),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             Column(
//               children: [
//                 const SizedBox(height: 15),
//                 AppButton(
//                   lbl: "انطلق",
//                   onPressed: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => TripDetailsScreen(
//                           tripId: tripId,
//                           busId: busId,
//                           tripState: tripState,
//                           firstTripRoute: firstTripRoute,
//                           lastTripRoute: lastTripRoute,
//                         ),
//                       ),
//                     );
//                   },
//                   color: AppColors.secondaryColor,
//                   textColor: AppColors.primaryColor,
//                   width: 92,
//                   height: 36,
//                 ),
//               ],
//             ),
//             const SizedBox(width: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/screens/trip_details_screen.dart';

class ActiveTripsWidget extends StatelessWidget {
  final String busId;
  final String tripId;
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

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TripDetailsScreen(
              tripId: tripId,
              busId: busId,
              tripState: tripState,
              firstTripRoute: firstTripRoute,
              lastTripRoute: lastTripRoute,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text('الحافلة رقم: $busId',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  // عرض توقيت الرحلة كما هو متوقع (من - الى)
                  Text('$firstExpectedTime - $lastExpectedTime'),
                  // عرض أسماء المحطات مع أيقونة سهم الاتجاه
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(firstStation),
                      const SizedBox(width: 5),
                      SvgPicture.asset(
                        'assets/icons/arrow-right-circle.svg',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(lastStation),
                    ],
                  ),
                ],
              ),
            ),
            Column(
                mainAxisSize: MainAxisSize.min, // تحديد الحجم ليكون محصوراً بأن يُحاط حجم الأطفال فقط.

              children: [
                const SizedBox(height: 15),
                Flexible(
                  child: AppButton(
                    lbl: "$tripState",
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TripDetailsScreen(
                            tripId: tripId,
                            busId: busId,
                            tripState: tripState,
                            firstTripRoute: firstTripRoute,
                            lastTripRoute: lastTripRoute,
                          ),
                        ),
                      );
                    },
                    color: AppColors.secondaryColor,
                    textColor: AppColors.primaryColor,
                    width: 92,
                    height: 36,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
