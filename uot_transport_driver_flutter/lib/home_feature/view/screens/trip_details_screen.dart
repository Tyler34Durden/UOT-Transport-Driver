import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/core/core_widgets/back_header.dart';
import 'package:uot_transport_driver_flutter/home_feature/model/repository/trip_details_repository.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/google_map_widget.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/departure_arrival_widget.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/qr_widget.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/trips_dialog_widget.dart';
import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/active_trips_cubit.dart';
import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/active_trips_state.dart';
import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/trip_details_cubit.dart';
import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/trip_details_state.dart';

class TripDetailsScreen extends StatefulWidget {
  final int tripId;
  TripDetailsScreen({super.key, required this.tripId});
  final Logger logger = Logger();

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  late TripDetailsCubit _tripDetailsCubit;
  bool _hasDeparted = false; // لتتبع ما إذا تم تنفيذ زر "غادرت المحطة"

  @override
  void initState() {
    super.initState();
    _tripDetailsCubit = TripDetailsCubit();
    _tripDetailsCubit.fetchTripDetails(widget.tripId);
  }

  @override
  void dispose() {
    _tripDetailsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TripDetailsCubit>.value(
      value: _tripDetailsCubit,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: const BackHeader(),
          backgroundColor: AppColors.backgroundColor,
          body: BlocBuilder<TripDetailsCubit, TripDetailsState>(
            builder: (context, state) {
              if (state is TripDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TripDetailsFailure) {
                return Center(
                    child: Text('فشل جلب بيانات الرحلة: ${state.error}'));
              } else if (state is TripDetailsSuccess) {
                final data = state.tripDetails;
                // جلب بيانات "tripRoute" من الاستجابة
                final Map<String, dynamic> tripRoute = data['tripRoute'] ?? {};
                final Map<String, dynamic> nextTripRoute =
                    data['nextTripRoute'] ?? {};

                // تعريف المتغيرات النهائية مع قيم افتراضية
                Map<String, dynamic> finalFirstTripRoute = tripRoute;
                Map<String, dynamic> finalLastTripRoute = {};

                // جلب بيانات ActiveTripsCubit إن كانت الحالة ناجحة واستخدامها في حال توفرها
                final activeTripsState =
                    context.watch<ActiveTripsCubit>().state;
                if (activeTripsState is ActiveTripsSuccess) {
                  final currentTrip = activeTripsState.trips.firstWhere(
                    (trip) =>
                        trip['tripId'].toString() == widget.tripId.toString(),
                    orElse: () => {},
                  );
                  if (currentTrip.isNotEmpty) {
                    finalFirstTripRoute = Map<String, dynamic>.from(
                        currentTrip['firstTripRoute'] ?? {});
                    finalLastTripRoute = Map<String, dynamic>.from(
                        currentTrip['lastTripRoute'] ?? {});
                  }
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    _tripDetailsCubit.fetchTripDetails(widget.tripId);
                  },
                  // AlwaysScrollableScrollPhysics ensures إمكانية التحديث حتى وإن لم يكن المحتوى ممتلئ.
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // عرض اسم المحطة (من tripRoute)
                          Row(
                            children: [
                              AppText(
                                lbl: 'الرحلة:',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 10),
                              AppText(
                                lbl:
                                    '${finalFirstTripRoute['stationName'] ?? 'غير متوفر'}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 5),
                              SvgPicture.asset(
                                'assets/icons/arrow-right-circle.svg',
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(width: 5),
                              AppText(
                                lbl:
                                    '${finalLastTripRoute['stationName'] ?? 'غير متوفر'}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // عرض QR واستخدام بيانات tripRoute
                          QRWidget(
                            tripId: widget.tripId.toString(),
                            tripRouteId: tripRoute['id']?.toString() ?? '',
                          ),
                          const SizedBox(height: 10),
                          AppText(
                            lbl: tripRoute['state'] == 'InTransit'
                                ? 'وصلت محطة : ${tripRoute['stationName'] ?? 'غير متوفر'}'
                                : 'المحطة القادمة : ${nextTripRoute['stationName'] ?? 'غير متوفر'}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // تمرير بيانات tripRoute إلى DepartureArrivalWidget
                          DepartureArrivalWidget(
                            tripRoute: tripRoute,
                            nextTripRoute:
                                nextTripRoute, // تمرير بيانات nextTripRoute
                          ),
                          const SizedBox(height: 20),
                          // عرض الخريطة باستخدام الموقع من tripRoute
                          GoogleMapWidget(
                            location: tripRoute['location'] ?? '',
                          ),
                          const SizedBox(height: 20),
                          // زر محدد حسب حالة الرحلة
                          _hasDeparted
                              ? AppButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible:
                                          true, // أو true حسب حاجتك
                                      builder: (BuildContext context) {
                                        return TripsDialog(
                                          title: const AppText(
                                            lbl: 'هل وصلت محطة: الفرناج؟',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                          content: const AppText(
                                            lbl:
                                                'سوف تقوم بتحديث حالة الرحلة , الوصول لمحطة: الفرناج.',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.textColor,
                                            ),
                                          ),
                                          actions: [
                                            AppButton(
                                              onPressed: () async {
                                                final int? routeId =
                                                    nextTripRoute['id'];
                                                if (routeId != null) {
                                                  try {
                                                    await TripDetailsRepository()
                                                        .updateTripRouteStatus(
                                                            routeId, 'Reached');
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'تم تحديث الحالة إلى Reached')),
                                                    );
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      // إعادة ضبط الحالة لإظهار زر "غادرت المحطة"
                                                      _hasDeparted = false;
                                                    });
                                                  } catch (e) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'فشل تحديث الحالة')),
                                                    );
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'بيانات المحطة غير متوفرة')),
                                                  );
                                                }
                                              },
                                              lbl: 'وصلت',
                                              height: 50,
                                              width: 400,
                                            ),
                                            const SizedBox(height: 10),
                                            const AppButton(
                                              onPressed: null,
                                              lbl: 'إلغاء',
                                              height: 50,
                                              width: 400,
                                              color: AppColors.secondaryColor,
                                              textColor: AppColors.primaryColor,
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  lbl: 'وصلت المحطة',
                                  color: AppColors.primaryColor,
                                )
                              : AppButton(
                                  onPressed: () async {
                                    final int? nextTripRouteid =
                                        nextTripRoute['id'];
                                    if (nextTripRouteid != null) {
                                      try {
                                        await TripDetailsRepository()
                                            .updateTripRouteStatus(
                                                nextTripRouteid, 'InTransit');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'تم تحديث الحالة إلى InTransit')),
                                        );
                                        setState(() {
                                          _hasDeparted = true;
                                        });
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('فشل تحديث الحالة')),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'بيانات المحطة غير متوفرة')),
                                      );
                                    }
                                  },
                                  lbl: 'غادرت المحطة',
                                  color: Colors.green,
                                ),
                          const SizedBox(height: 20),
                          AppButton(
                            lbl: 'تأخرت الرحلة',
                            color: AppColors.btnColor,
                            onPressed: () {
                              // منطق تأخر الرحلة
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
