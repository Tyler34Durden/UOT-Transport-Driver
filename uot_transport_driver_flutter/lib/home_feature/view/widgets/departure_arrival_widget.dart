import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';

class DepartureArrivalWidget extends StatelessWidget {
  final Logger logger = Logger();
  final Map<String, dynamic> tripRoute;
  final Map<String, dynamic> nextTripRoute;
  final int delayMinutes;

  DepartureArrivalWidget({
    super.key,
    required this.tripRoute,
    required this.nextTripRoute,
    this.delayMinutes = 0,
  });

  @override
  Widget build(BuildContext context) {
    final int maleCount = tripRoute['maleCount'] ?? 100;
    final int femaleCount = tripRoute['femaleCount'] ?? 100;
    final int nextMaleCount = nextTripRoute['maleCount'] ?? 100;
    final int nextFemaleCount = nextTripRoute['femaleCount'] ?? 100;

    return Column(
      children: [
        Row(
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
                        lbl: (nextTripRoute['state']?.toString() == 'InTransit' && nextTripRoute.isNotEmpty)
                            ? 'الوصول المتوقع: ${nextTripRoute['time']?.toString() ?? ''}  #${nextTripRoute['id'] ?? ''}'
                            : 'الوصول الفعلي: ${tripRoute['time']?.toString() ?? ''}  # ${tripRoute['id'] ?? ''}',
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            lbl: 'الحاجزين ',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5),
                          SvgPicture.asset(
                            'assets/icons/maleIcon.svg',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(width: 5),
                          AppText(
                            lbl: (nextTripRoute['state']?.toString() == 'InTransit' && nextTripRoute.isNotEmpty)
                                ? '$nextMaleCount'
                                : '$maleCount',
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          SvgPicture.asset(
                            'assets/icons/femaleIcone.svg',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(width: 5),
                          AppText(
                            lbl: (nextTripRoute['state']?.toString() == 'InTransit' && nextTripRoute.isNotEmpty)
                                ? '$nextFemaleCount '
                                : '$femaleCount',
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}