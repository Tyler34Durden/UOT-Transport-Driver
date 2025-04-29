

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/active_trips_widget.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/home_header.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/inactive_trips_widget.dart';
import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/active_trips_cubit.dart';
import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/active_trips_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تأكد من استدعاء جلب البيانات عند دخول الشاشة
    context.read<ActiveTripsCubit>().fetchTodayTrips();

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: HomeHeader(),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 80 + 16, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
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
              BlocBuilder<ActiveTripsCubit, ActiveTripsState>(
                builder: (context, state) {
                  if (state is ActiveTripsLoading) {
                    return const Center(
                        child: CircularProgressIndicator());
                  } else if (state is ActiveTripsSuccess) {
                    if (state.trips.isEmpty) {
                      return const Center(
                          child: Text('لا توجد رحلات متاحة اليوم.'));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.trips.length,
                      itemBuilder: (context, index) {
                        final trip = state.trips[index];
                        return ActiveTripsWidget(
                          busId: trip['busId'].toString(),
                          tripId: trip['tripId'].toString(),
                          tripState: trip['tripState'],
                          firstTripRoute: trip['firstTripRoute'],
                          lastTripRoute: trip['lastTripRoute'],
                        );
                      },
                    );
                  } else if (state is ActiveTripsFailure) {
                    return Center(
                        child: Text(
                            'حدث خطأ أثناء جلب البيانات: ${state.error}'));
                  }
                  return const SizedBox();
                },
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
      ),
    );
  }
}