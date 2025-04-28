import 'package:flutter/material.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';

class DepartureArrivalWidget extends StatelessWidget {
  final Map<String, dynamic> firstTripRoute;
  final Map<String, dynamic> lastTripRoute;

  const DepartureArrivalWidget({
    super.key,
    required this.firstTripRoute,
    required this.lastTripRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primaryColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Flexible(
                  child: AppText(
                    lbl: 'الوصول المتوقع: ${firstTripRoute['expectedTime'] ?? 'غير متوفر'}',
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // const Icon(Icons.departure_board, color: Colors.green),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primaryColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Flexible(
                  child: AppText(
                    lbl: 'الحاجزين: ${lastTripRoute['expectedTime'] ?? 'غير متوفر'}',
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.person, color: Colors.green),
              ],
            ),
          ),
        ),
      ],
    );
  }
}