import 'package:flutter/material.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/back_header.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/departure_arrival_widget.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/google_map_widget.dart';

class TripDetailsScreen extends StatelessWidget {
  final String tripId;
  final String busId;
  final String tripState;
  final Map<String, dynamic> firstTripRoute;
  final Map<String, dynamic> lastTripRoute;

  const TripDetailsScreen({
    super.key,
    required this.tripId,
    required this.busId,
    required this.tripState,
    required this.firstTripRoute,
    required this.lastTripRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const BackHeader(),
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppText(
                  lbl: ' الرحلة: #$tripState',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Icon(
                  Icons.qr_code_2,
                  size: 180,
                ),
                const SizedBox(height: 20),
                const AppText(
                  lbl: 'المحطة القادمة :',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                DepartureArrivalWidget(
                  firstTripRoute: {},
                  lastTripRoute: {},
                ),
                const SizedBox(height: 20),
                GoogleMapWidget(location: '',),
                const SizedBox(height: 20),
                AppButton(
                  lbl: 'وصلت المحطة',
                  color: AppColors.primaryColor,
                  onPressed: () {
                    // Handle booking here
                  },
                ),
                const SizedBox(height: 20),
                AppButton(
                  lbl: 'تأخرت الرحلة',
                  color: AppColors.btnColor,
                  onPressed: () {
                    // Handle booking here
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
