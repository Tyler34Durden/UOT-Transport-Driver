import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/home_feature/model/repository/trip_details_repository.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/screens/trip_details_screen.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/trips_dialog_widget.dart';

class ActiveTripsWidget extends StatefulWidget {
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
  _ActiveTripsWidgetState createState() => _ActiveTripsWidgetState();
}

class _ActiveTripsWidgetState extends State<ActiveTripsWidget> {
  late String _currentTripState;

  @override
  void initState() {
    super.initState();
    _currentTripState = widget.tripState;
  }

  @override
  Widget build(BuildContext context) {
    final String firstExpectedTime =
        widget.firstTripRoute['expectedTime'] ?? '--';
    final String lastExpectedTime =
        widget.lastTripRoute['expectedTime'] ?? '--';
    final String firstStation =
        widget.firstTripRoute['stationName'] ?? 'غير معروف';
    final String lastStation =
        widget.lastTripRoute['stationName'] ?? 'غير معروف';

    // احسب نص العرض واللون بناءً على _currentTripState
    final String displayState = _currentTripState == 'soon'
        ? 'قيد الانتظار'
        : _currentTripState == 'active'
            ? 'نشطة'
            : _currentTripState;
    final Color btnColor = _currentTripState == 'soon'
        ? Colors.grey[600]!
        : _currentTripState == 'active'
            ? Colors.green
            : AppColors.secondaryColor;
    final Color txtColor = Colors.white;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SvgPicture.asset('assets/icons/bus.svg', width: 40, height: 40),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  lbl: 'الحافلة رقم: ${widget.busId}',
                  style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                AppText(
                  lbl: '$firstExpectedTime - $lastExpectedTime',
                  style: const TextStyle(fontSize: 16, color: AppColors.textColor),
                ),
                const SizedBox(height: 4),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Flexible(
                      child: AppText(
                        lbl: firstStation,
                        style:
                            const TextStyle(fontSize: 14, color: AppColors.textColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2),
                    SvgPicture.asset(
                      'assets/icons/arrow-right-circle.svg',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 2),
                    Flexible(
                      child: AppText(
                        lbl: lastStation,
                        style:
                            const TextStyle(fontSize: 14, color: AppColors.textColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppButton(
            lbl: displayState,
            color: btnColor,
            textColor: txtColor,
            width: 117.5,
            height: 36,
            onPressed: () async {
              if (_currentTripState == 'soon') {
                final int routeId = widget.firstTripRoute['id'] ?? 0;
                if (routeId != 0) {
                  try {
                    await TripDetailsRepository().updateTripRouteStatus(routeId, 'Reached');
                    setState(() {
                      _currentTripState = 'active';
                    });
                    // Navigate to trip details after successful status update
                    final int id = int.tryParse(widget.tripId) ?? 0;
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TripDetailsScreen(tripId: id)),
                    );
                  } on DioException catch (e) {
                    // Handle server errors with specific error messages
                    final errorData = e.response?.data;
                    String errorMessage = '';

                    if (errorData is Map && errorData['message'] != null) {
                      errorMessage = errorData['message'];
                    } else {
                      errorMessage = e.toString();
                    }

                    showDialog(
                      context: context,
                      builder: (_) => TripsDialog(
                        title: Icon(
                          Icons.error_outline,
                          color: AppColors.btnColor,
                          size: 50,
                        ),
                        content: AppText(
                          textAlign: TextAlign.center,
                          lbl: errorMessage,
                          style: const TextStyle(fontSize: 16, color: AppColors.textColor),
                        ),
                        actions: [
                          Center(
                            child: AppButton(
                              lbl: 'حسناً',
                              onPressed: () => Navigator.pop(context),
                              height: 50,
                              width: 200,
                            ),
                          ),
                        ],
                      ),
                    );
                  } catch (e) {
                    // Generic error handling for other exceptions
                    showDialog(
                      context: context,
                      builder: (_) => TripsDialog(
                        title: Icon(
                          Icons.error_outline,
                          color: AppColors.btnColor,
                          size: 50,
                        ),
                        content: AppText(
                          textAlign: TextAlign.center,
                          lbl: e.toString(),
                          style: const TextStyle(fontSize: 16, color: AppColors.textColor),
                        ),
                        actions: [
                          Center(
                            child: AppButton(
                              lbl: 'حسناً',
                              onPressed: () => Navigator.pop(context),
                              height: 50,
                              width: 200,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
              } else if (_currentTripState == 'active') {
                final int id = int.tryParse(widget.tripId) ?? 0;
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => TripDetailsScreen(tripId: id)),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}