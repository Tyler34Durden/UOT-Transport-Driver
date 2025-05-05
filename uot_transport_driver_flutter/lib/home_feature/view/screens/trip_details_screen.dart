// // import 'package:flutter/material.dart';
// // import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
// // import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
// // import 'package:uot_transport_driver_flutter/core/app_colors.dart';
// // import 'package:uot_transport_driver_flutter/home_feature/view/widgets/back_header.dart';
// // import 'package:uot_transport_driver_flutter/home_feature/view/widgets/departure_arrival_widget.dart';
// // import 'package:uot_transport_driver_flutter/home_feature/view/widgets/google_map_widget.dart';

// // class TripDetailsScreen extends StatelessWidget {
// //   final String tripId;
// //   final String busId;
// //   final String tripState;
// //   final Map<String, dynamic> firstTripRoute;
// //   final Map<String, dynamic> lastTripRoute;

// //   const TripDetailsScreen({
// //     super.key,
// //     required this.tripId,
// //     required this.busId,
// //     required this.tripState,
// //     required this.firstTripRoute,
// //     required this.lastTripRoute,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Directionality(
// //       textDirection: TextDirection.rtl,
// //       child: Scaffold(
// //         appBar: const BackHeader(),
// //         backgroundColor: AppColors.backgroundColor,
// //         body: SingleChildScrollView(
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: [
// //                 AppText(
// //                   lbl: ' الرحلة: #$tripState',
// //                   style: const TextStyle(
// //                     fontSize: 24,
// //                     fontWeight: FontWeight.bold,
// //                     color: AppColors.primaryColor,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 Icon(
// //                   Icons.qr_code_2,
// //                   size: 180,
// //                 ),
// //                 const SizedBox(height: 20),
// //                 const AppText(
// //                   lbl: 'المحطة القادمة :',
// //                   style: TextStyle(
// //                     fontSize: 20,
// //                     color: AppColors.primaryColor,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 DepartureArrivalWidget(
// //                   firstTripRoute: {},
// //                   lastTripRoute: {},
// //                 ),
// //                 const SizedBox(height: 20),
// //                 GoogleMapWidget(location: '',),
// //                 const SizedBox(height: 20),
// //                 AppButton(
// //                   lbl: 'وصلت المحطة',
// //                   color: AppColors.primaryColor,
// //                   onPressed: () {
// //                     // Handle booking here
// //                   },
// //                 ),
// //                 const SizedBox(height: 20),
// //                 AppButton(
// //                   lbl: 'تأخرت الرحلة',
// //                   color: AppColors.btnColor,
// //                   onPressed: () {
// //                     // Handle booking here
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:uot_transport_driver_flutter/core/app_colors.dart';
// import 'package:uot_transport_driver_flutter/core/core_widgets/back_header.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view/widgets/google_map_widget.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view/widgets/departure_arrival_widget.dart';
// import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
// import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/active_trips_cubit.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/active_trips_state.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/trip_details_cubit.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/trip_details_state.dart';

// class TripDetailsScreen extends StatefulWidget {
//   final int tripId;
//   const TripDetailsScreen({super.key, required this.tripId});

//   @override
//   State<TripDetailsScreen> createState() => _TripDetailsScreenState();
// }

// class _TripDetailsScreenState extends State<TripDetailsScreen> {
//   late TripDetailsCubit _tripDetailsCubit;

//   @override
//   void initState() {
//     super.initState();
//     _tripDetailsCubit = TripDetailsCubit();
//     _tripDetailsCubit.fetchTripDetails(widget.tripId);
//   }

//   @override
//   void dispose() {
//     _tripDetailsCubit.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<TripDetailsCubit>.value(
//       value: _tripDetailsCubit,
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//           appBar: const BackHeader(),
//           backgroundColor: AppColors.backgroundColor,
//           body: BlocBuilder<TripDetailsCubit, TripDetailsState>(
//             builder: (context, state) {
//               if (state is TripDetailsLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is TripDetailsFailure) {
//                 return Center(
//                     child: Text('فشل جلب بيانات الرحلة: ${state.error}'));
//               } else if (state is TripDetailsSuccess) {
//                 final data = state.tripDetails;
//                 final tripState = data['tripState'] ?? '';
//                 final tripRoute = data['tripRoute'] ?? {};

//                 // داخل TripDetailsScreen (من داخل build أو initState)
//                 final activeTripsState =
//                     context.watch<ActiveTripsCubit>().state;
//                 if (activeTripsState is ActiveTripsSuccess) {
//                   // يمكن البحث عن البيانات الخاصة بالرحلة المطلوبة عن طريق مطابقة tripId
//                   final currentTrip = activeTripsState.trips.firstWhere(
//                     (trip) =>
//                         trip['tripId'].toString() == widget.tripId.toString(),
//                     orElse: () => {},
//                   );

//                   // يمكنك استخراج البيانات المطلوبة من currentTrip
//                   final firstTripRoute = Map<String, dynamic>.from(
//                       currentTrip['firstTripRoute'] ?? {});
//                   final lastTripRoute = Map<String, dynamic>.from(
//                       currentTrip['lastTripRoute'] ?? {});

//                   // يمكنك الآن استخدامها لعرض التفاصيل داخل الصفحة
//                 }
//                 return SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [

// Row(
//   children: [
//     AppText(
//       lbl: 'الرحلة: ${firstTripRoute['stationName'] ?? 'غير متوفر'}',
//       style: const TextStyle(
//         fontSize: 14,
//         color: AppColors.textColor,
//       ),
//       overflow: TextOverflow.ellipsis,
//     ),
//     const SizedBox(width: 5),
//     SvgPicture.asset(
//       'assets/icons/arrow-right-circle.svg',
//       width: 20,
//       height: 20,
//     ),
//     AppText(
//       lbl: '${lastTripRoute['stationName'] ?? 'غير متوفر'}',
//       style: const TextStyle(
//         fontSize: 14,
//         color: AppColors.textColor,
//       ),
//       overflow: TextOverflow.ellipsis,
//     ),
//   ],
//   ),

//                         const SizedBox(height: 20),
//                         const Icon(
//                           Icons.qr_code_2,
//                           size: 180,
//                         ),
//                         const SizedBox(height: 20),
//                         const AppText(
//                           lbl: 'المحطة القادمة :',
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: AppColors.primaryColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         DepartureArrivalWidget(
//                           // تمرير بيانات الطريق من الـ API
//                           firstTripRoute: tripRoute,
//                           lastTripRoute: {},
//                         ),
//                         const SizedBox(height: 20),
//                         GoogleMapWidget(
//                           // تمرير الموقع من بيانات الطريق
//                           location: tripRoute['location'] ?? '',
//                         ),
//                         const SizedBox(height: 20),
//                         AppButton(
//                           lbl: 'وصلت المحطة',
//                           color: AppColors.primaryColor,
//                           onPressed: () {
//                             // منطق عند وصول المركبة للمحطة
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         AppButton(
//                           lbl: 'تأخرت الرحلة',
//                           color: AppColors.btnColor,
//                           onPressed: () {
//                             // منطق تأخر الرحلة
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }
//               return Container();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/core/core_widgets/back_header.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/google_map_widget.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/departure_arrival_widget.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/active_trips_cubit.dart';
import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/active_trips_state.dart';
import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/trip_details_cubit.dart';
import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/trip_details_state.dart';

class TripDetailsScreen extends StatefulWidget {
  final int tripId;
  const TripDetailsScreen({super.key, required this.tripId});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  late TripDetailsCubit _tripDetailsCubit;

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
                // بيانات من TripDetailsCubit (افتراضية في حالة عدم توفر بيانات ActiveTripsCubit)
                final tripRoute = data['tripRoute'] ?? {};

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

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // عرض اسم المحطة من بيانات firstTripRoute
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
                        const SizedBox(height: 20),
                        const Icon(
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
                        // تمرير بيانات الطريق إلى DepartureArrivalWidget
                        DepartureArrivalWidget(
                          firstTripRoute: finalFirstTripRoute,
                          lastTripRoute: finalLastTripRoute,
                        ),
                        const SizedBox(height: 20),
                        // عرض الخريطة باستخدام الموقع الموجود في firstTripRoute
                        GoogleMapWidget(
                          location: finalFirstTripRoute['location'] ?? '',
                        ),
                        const SizedBox(height: 20),
                        AppButton(
                          lbl: 'وصلت المحطة',
                          color: AppColors.primaryColor,
                          onPressed: () {
                            // منطق عند وصول المركبة للمحطة
                          },
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
