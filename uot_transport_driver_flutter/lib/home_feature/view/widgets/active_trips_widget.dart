import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';

class ActiveTripsWidget extends StatelessWidget {
  final String busId;
  final String tripId;
  final String tripState;
  final Map<String, dynamic> firstTripRoute;
  final Map<String, dynamic> lastTripRoute;

  const ActiveTripsWidget({
    super.key,
    required this.busId,
    required this.tripId,
    required this.tripState,
    required this.firstTripRoute,
    required this.lastTripRoute,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => TripDetailsScreen(tripId: tripId,busId: busId, tripState: tripState, firstTripRoute: firstTripRoute, lastTripRoute: lastTripRoute),
        //   ),
        // );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 5),
            SvgPicture.asset('assets/icons/bus.svg'),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('اسم الحافلة'),
                  const Text("12:00 - 13:00"),
                  Row(
                            textDirection: TextDirection.rtl,

                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('من'),
                      const SizedBox(width: 5),
                      SvgPicture.asset('assets/icons/arrow-right-circle.svg'),
                      const SizedBox(width: 5),
                      const Text('الى'),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                const SizedBox(height: 15),
                AppButton(
                  lbl: "انطلق",
                  onPressed: () {},
                  color: AppColors.secondaryColor,
                  textColor: AppColors.primaryColor,
                  width: 92,
                  height: 36,
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
