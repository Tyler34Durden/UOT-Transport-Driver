import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/active_trips_widget.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/home_header.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/inactive_trips_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: HomeHeader(),
      ),
      body: Padding(
        // padding: const EdgeInsets.all(16),
        padding: const EdgeInsets.only(top: 80 + 16, left: 16, right: 16),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText(
              textAlign: TextAlign.right,
              lbl: ':رحلات اليوم',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            ActiveTripsWidget(
              busId: 'busId',
              tripId: 'tripId',
              tripState: 'tripState',
              firstTripRoute: {'from': 'from', 'to': 'to'},
              lastTripRoute: {'from': 'from', 'to': 'to'},
            ),
            SizedBox(height: screenHeight * 0.02),
            ActiveTripsWidget(
              busId: 'busId',
              tripId: 'tripId',
              tripState: 'tripState',
              firstTripRoute: {'from': 'from', 'to': 'to'},
              lastTripRoute: {'from': 'from', 'to': 'to'},
            ),
            SizedBox(height: screenHeight * 0.02),
            AppText(
              textAlign: TextAlign.right,
              lbl: ':الرحلات المنتهية',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

             InActiveTripsWidget(
              busId: 'busId',
              tripId: 'tripId',
              tripState: 'tripState',
              firstTripRoute: {'from': 'from', 'to': 'to'},
              lastTripRoute: {'from': 'from', 'to': 'to'},
            ),
          ],
        ),
      ),
    );
  }
}
