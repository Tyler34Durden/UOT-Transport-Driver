import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/screens/test_dialog_screen.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/active_trips_widget.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/home_header.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/inactive_trips_widget.dart';
import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/active_trips_cubit.dart';
import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/active_trips_state.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء جلب البيانات عند دخول الشاشة
    context.read<ActiveTripsCubit>().fetchTodayTrips();

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: HomeHeader(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 75, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // قسم الرحلات النشطة
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
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ActiveTripsSuccess) {
                    // فلترة الرحلات النشطة لاستبعاد تلك التي حالتها "completed"
                    final activeTrips = state.trips.where((trip) {
                      final stateValue =
                          trip['tripState'].toString().trim().toLowerCase();
                      return stateValue != 'completed';
                    }).toList();
                    if (activeTrips.isEmpty) {
                      return const Center(
                          child: Text('لا توجد رحلات نشطة متاحة اليوم.'));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: activeTrips.length,
                      itemBuilder: (context, index) {
                        final trip = activeTrips[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: ActiveTripsWidget(
                            busId: trip['busId'].toString(),
                            tripId: trip['tripId'].toString(),
                            tripState: trip['tripState'],
                            firstTripRoute: trip['firstTripRoute'],
                            lastTripRoute: trip['lastTripRoute'],
                          ),
                        );
                      },
                    );
                  } else if (state is ActiveTripsFailure) {
                    return Center(
                      child: Text('حدث خطأ أثناء جلب البيانات: ${state.error}'),
                    );
                  }
                  return const SizedBox();
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              // قسم الرحلات المنتهية
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
              BlocBuilder<ActiveTripsCubit, ActiveTripsState>(
                builder: (context, state) {
                  if (state is ActiveTripsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ActiveTripsSuccess) {
                    // فلترة الرحلات المنتهية (المكتملة)
                    final inactiveTrips = state.trips.where((trip) {
                      final stateValue =
                          trip['tripState'].toString().trim().toLowerCase();
                      return stateValue == 'completed';
                    }).toList();
                    if (inactiveTrips.isEmpty) {
                      return const Center(
                          child: Text('لا توجد رحلات منتهية متاحة اليوم.'));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: inactiveTrips.length,
                      itemBuilder: (context, index) {
                        final trip = inactiveTrips[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: InActiveTripsWidget(
                            busId: trip['busId'].toString(),
                            tripId: trip['tripId'].toString(),
                            tripState: trip['tripState'],
                            firstTripRoute: trip['firstTripRoute'],
                            lastTripRoute: trip['lastTripRoute'],
                          ),
                        );
                      },
                    );
                  } else if (state is ActiveTripsFailure) {
                    return Center(
                      child: Text('حدث خطأ أثناء جلب البيانات: ${state.error}'),
                    );
                  }
                  return const SizedBox();
                },
              ),
              AppButton(
                  lbl: 'اختبار التنبيه',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TestDialogScreen()),
                    );
                  }),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
