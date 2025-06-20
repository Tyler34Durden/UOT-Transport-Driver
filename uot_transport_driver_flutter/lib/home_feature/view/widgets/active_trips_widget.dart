import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            // onPressed: () async {
            //   // عند الضغط على "قيد الانتظار" نجري تحديث الحالة أولاً ثم نعيد بناء الواجهة
            //   if (_currentTripState == 'soon') {
            //     final int routeId = widget.firstTripRoute['id'] ?? 0;
            //     if (routeId != 0) {
            //       try {
            //         await TripDetailsRepository()
            //             .updateTripRouteStatus(routeId, 'Reached');
            //         // مباشرةً عدّل الحالة محلياً
            //         setState(() {
            //           _currentTripState = 'active';
            //         });
                    
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           const SnackBar(content: Text('تم تحديث الحالة إلى انطلق')),
            //         );
            //       } catch (_) {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           const SnackBar(content: Text('فشل تحديث الحالة')),
            //         );
            //       }
            //     }
            //   }
            //   // عند الضغط على "انطلق" ننقل المستخدم إلى شاشة التفاصيل
            //   else if (_currentTripState == 'active') {
            //     final int id = int.tryParse(widget.tripId) ?? 0;
            //     Navigator.of(context).push(
            //       MaterialPageRoute(builder: (_) => TripDetailsScreen(tripId: id)),
            //     );
            //   }
            // },
            onPressed: () async {
        if (_currentTripState == 'soon') {
          final int routeId = widget.firstTripRoute['id'] ?? 0;
          if (routeId != 0) {
            try {
              // حدِّث الحالة على السيرفر
              await TripDetailsRepository()
                  .updateTripRouteStatus(routeId, 'Reached');
              // عدِّل الحالة محلياً
              setState(() {
                _currentTripState = 'active';
              });
              // عرض حوار النجاح
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => TripsDialog(
                  title: SvgPicture.asset("assets/icons/check.svg"),
                  content: const AppText(
                    lbl: 'تم تحديث الحالة إلى نشطة.',
                    style: TextStyle(fontSize: 20, color: AppColors.textColor),
                  ),
                ),
              );
              // انتظر ثم اغلق الحوار
              await Future.delayed(const Duration(seconds: 2));
              Navigator.pop(context);
            } catch (_) {
              // عرض حوار الخطأ
              showDialog(
                context: context,
                builder: (_) => TripsDialog(
                  title: const AppText(
                    lbl: 'فشل العملية',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  content: const AppText(
                    lbl: 'لم نتمكن من تحديث الحالة، حاول مرة أخرى.',
                    style: TextStyle(fontSize: 16, color: AppColors.textColor),
                  ),
                  actions: [
                    AppButton(
                      lbl: 'حسناً',
                      onPressed: () => Navigator.pop(context),
                      height: 50,
                      width: 200,
                   ),
              ],
            ),
          );
        }
      }
    }
    else if (_currentTripState == 'active') {
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