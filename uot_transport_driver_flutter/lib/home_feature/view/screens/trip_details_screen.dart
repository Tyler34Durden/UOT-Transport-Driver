// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:logger/logger.dart';
// import 'package:uot_transport_driver_flutter/core/app_colors.dart';
// import 'package:uot_transport_driver_flutter/core/core_widgets/back_header.dart';
// import 'package:uot_transport_driver_flutter/home_feature/model/repository/trip_details_repository.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view/screens/main_screen.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view/widgets/google_map_widget.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view/widgets/departure_arrival_widget.dart';
// import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
// import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view/widgets/qr_widget.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view/widgets/trips_dialog_widget.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/active_trips_cubit.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/active_trips_state.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/trip_details_cubit.dart';
// import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/trip_details_state.dart';

// class TripDetailsScreen extends StatefulWidget {
//   final int tripId;
//   TripDetailsScreen({super.key, required this.tripId});
//   final Logger logger = Logger();

//   @override
//   State<TripDetailsScreen> createState() => _TripDetailsScreenState();
// }

// class _TripDetailsScreenState extends State<TripDetailsScreen> {
//   late TripDetailsCubit _tripDetailsCubit;
//   bool _hasDeparted = false; // لتتبع ما إذا تم تنفيذ زر "غادرت المحطة"

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
//                 // جلب بيانات "tripRoute" من الاستجابة
//                 final Map<String, dynamic> tripRoute = data['tripRoute'] ?? {};
//                 // debugPrint(
//                 //     "Trip State: ${tripRoute['tripState']}"); // طباعة الحالة في الديبق كونسل
//                 final String tripState = data['tripState']?.toString() ?? '';
//                 debugPrint("Trip State: $tripState");
//                 final Map<String, dynamic> nextTripRoute =
//                     data['nextTripRoute'] ?? {};

//                 // تعريف المتغيرات النهائية مع قيم افتراضية
//                 Map<String, dynamic> FirstTripRoute = tripRoute;
//                 Map<String, dynamic> LastTripRoute = {};

//                 // جلب بيانات ActiveTripsCubit إن كانت الحالة ناجحة واستخدامها في حال توفرها
//                 final activeTripsState =
//                     context.watch<ActiveTripsCubit>().state;
//                 if (activeTripsState is ActiveTripsSuccess) {
//                   final currentTrip = activeTripsState.trips.firstWhere(
//                     (trip) =>
//                         trip['tripId'].toString() == widget.tripId.toString(),
//                     orElse: () => {},
//                   );
//                   if (currentTrip.isNotEmpty) {
//                    FirstTripRoute = Map<String, dynamic>.from(
//                         currentTrip['firstTripRoute'] ?? {});
//                     LastTripRoute = Map<String, dynamic>.from(
//                         currentTrip['lastTripRoute'] ?? {});
//                   }
//                 }

//                 return RefreshIndicator(
//                   onRefresh: () async {
//                     _tripDetailsCubit.fetchTripDetails(widget.tripId);
//                   },
//                   // AlwaysScrollableScrollPhysics ensures إمكانية التحديث حتى وإن لم يكن المحتوى ممتلئ.
//                   child: SingleChildScrollView(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           // عرض اسم المحطة (من tripRoute)
//                           AppText(lbl:'رقم الرحلة: ${widget.tripId.toString()}',
//                             style: const TextStyle(
//                               fontSize: 24,
//                               color: AppColors.primaryColor,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               // AppText(
//                               //   lbl: 'الرحلة:',
//                               //   style: const TextStyle(
//                               //     fontSize: 24,
//                               //     color: AppColors.primaryColor,
//                               //     fontWeight: FontWeight.bold,
//                               //   ),
//                               //   overflow: TextOverflow.ellipsis,
//                               // ),
//                               const SizedBox(width: 10),
//                               Flexible(
//                                 child: AppText(
//                                   lbl:
//                                       '${FirstTripRoute['stationName'] ?? 'غير متوفر' } \n ${FirstTripRoute['id'] ?? 'غير متوفر'}' ,
//                                   style: const TextStyle(
//                                     fontSize: 22,
//                                     color: AppColors.primaryColor,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   // overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               const SizedBox(width: 5),
//                               SvgPicture.asset(
//                                 'assets/icons/arrow-right-circle.svg',
//                                 width: 30,
//                                 height: 30,
//                               ),
//                               const SizedBox(width: 5),
//                               AppText(
//                                 lbl:
//                                     '${LastTripRoute['stationName'] ?? 'غير متوفر' } \n ${LastTripRoute['id'] ?? 'غير متوفر'}',
//                                 style: const TextStyle(
//                                   fontSize: 22,
//                                   color: AppColors.primaryColor,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           // عرض QR واستخدام بيانات tripRoute
//                           QRWidget(
//                             tripId: widget.tripId.toString(),
//                             tripRouteId: tripRoute['id']?.toString() ?? '',
//                           ),
//                           const SizedBox(height: 10),
//                           AppText(
//                             lbl: tripState.trim().toLowerCase() == 'completed'
//                                 ? 'وصلت محطة: ${tripRoute['stationName'] ?? 'غير متوفر'}'
//                                 : (tripRoute['state'] == 'InTransit'
//                                     ? 'وصلت محطة : ${tripRoute['stationName'] ?? 'غير متوفر'}'
//                                     : 'المحطة القادمة : ${nextTripRoute['stationName'] ?? 'غير متوفر'}'),
//                             style: const TextStyle(
//                               fontSize: 20,
//                               color: AppColors.primaryColor,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           // تمرير بيانات tripRoute إلى DepartureArrivalWidget
//                           DepartureArrivalWidget(
//                             tripRoute: tripRoute,
//                             nextTripRoute:
//                                 nextTripRoute, // تمرير بيانات nextTripRoute
//                           ),
//                           const SizedBox(height: 20),
//                           // عرض الخريطة باستخدام الموقع من tripRoute
//                           GoogleMapWidget(
//                             startLocation: tripRoute['location'] ?? '',
//                             endLocation: nextTripRoute['location'] ?? '',
//                           ),
//                           const SizedBox(height: 20),

//                           //^ زر "انتهت الرحلة" إذا كانت حالة الرحلة مكتملة
//                           if (tripState.trim().toLowerCase() == 'completed')
//                             AppButton(
//                               lbl: 'انتهت الرحلة',
//                               color: AppColors.secondaryColor,
//                               textColor: AppColors.primaryColor,
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => MainScreen()),
//                                 );
//                               },
//                             )
//                           else
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                  if (tripState.trim().toLowerCase() == 'intransit' && _hasDeparted)
//                                     //! زر "وصلت المحطة"
//                                      AppButton(
//                                         onPressed: () {
//                                           showDialog(
//                                             context: context,
//                                             barrierDismissible: true,
//                                             builder: (BuildContext context) {
//                                               return TripsDialog(
//                                                 title: const AppText(
//                                                   lbl: 'هل وصلت محطة: الفرناج؟',
//                                                   style: TextStyle(
//                                                     fontSize: 24,
//                                                     fontWeight: FontWeight.bold,
//                                                     color:
//                                                         AppColors.primaryColor,
//                                                   ),
//                                                 ),
//                                                 content: const AppText(
//                                                   lbl:
//                                                       'سوف تقوم بتحديث حالة الرحلة , الوصول لمحطة: الفرناج.',
//                                                   style: TextStyle(
//                                                     fontSize: 14,
//                                                     color: AppColors.textColor,
//                                                   ),
//                                                 ),
//                                                 actions: [
//                                                   //& زر وصلت المحطة
//                                                   AppButton(
//                                                     onPressed: () async {
//                                                       final int? routeId =
//                                                           nextTripRoute['id'];
//                                                       if (routeId != null) {
//                                                         try {
//                                                           await TripDetailsRepository()
//                                                               .updateTripRouteStatus(
//                                                                   routeId,
//                                                                   'Reached');
//                                                           ScaffoldMessenger.of(
//                                                                   context)
//                                                               .showSnackBar(
//                                                                   const SnackBar(
//                                                             content: Text(
//                                                                 'تم تحديث الحالة إلى Reached'),
//                                                           ));
//                                                           Navigator.pop(
//                                                               context);
//                                                           _tripDetailsCubit
//                                                               .fetchTripDetails(
//                                                                   widget
//                                                                       .tripId);
//                                                           setState(() {
//                                                             _hasDeparted =
//                                                                 false;
//                                                           });
//                                                         } catch (e) {
//                                                           ScaffoldMessenger.of(
//                                                                   context)
//                                                               .showSnackBar(
//                                                                   const SnackBar(
//                                                             content: Text(
//                                                                 'فشل تحديث الحالة'),
//                                                           ));
//                                                         }
//                                                       } else {
//                                                         ScaffoldMessenger.of(
//                                                                 context)
//                                                             .showSnackBar(
//                                                                 const SnackBar(
//                                                           content: Text(
//                                                               'بيانات المحطة غير متوفرة'),
//                                                         ));
//                                                       }
//                                                     },
//                                                     lbl: 'وصلت',
//                                                     height: 50,
//                                                     width: 400,
//                                                   ),
//                                                   const SizedBox(height: 10),
//                                                   const AppButton(
//                                                     onPressed: null,
//                                                     lbl: 'إلغاء',
//                                                     height: 50,
//                                                     width: 400,
//                                                     color: AppColors
//                                                         .secondaryColor,
//                                                     textColor:
//                                                         AppColors.primaryColor,
//                                                   ),
//                                                 ],
//                                               );
//                                             },
//                                           );
//                                         },
//                                         lbl: 'وصلت المحطة',
//                                         color: AppColors.primaryColor,
//                                       )
//                                     //& زر "غادرت المحطة"
//                                     else if  (tripState.trim() == 'NotReached' && _hasDeparted)
//                                       //! زر "غادرت المحطة"
//                                      AppButton(
//                                         onPressed: () {
//                                           showDialog(
//                                             context: context,
//                                             barrierDismissible: true,
//                                             builder: (BuildContext context) {
//                                               return TripsDialog(
//                                                 title: const AppText(
//                                                   lbl: 'هل تريد اكمال الرحلة ؟',
//                                                   style: TextStyle(
//                                                     fontSize: 24,
//                                                     fontWeight: FontWeight.bold,
//                                                     color:
//                                                         AppColors.primaryColor,
//                                                   ),
//                                                 ),
//                                                 content: AppText(
//                                                   lbl:
//                                                       'سوف تقوم بمغادرة المحطة والإنطلاق للمحطة القادمة: الفرناج.',
//                                                   style: TextStyle(
//                                                     fontSize: 14,
//                                                     color: AppColors.textColor,
//                                                   ),
//                                                 ),
//                                                 actions: [
//                                                   //! زر غادرت المحطة
//                                                   AppButton(
//                                                     onPressed: () async {
//                                                       final int?
//                                                           nextTripRouteid =
//                                                           nextTripRoute['id'];
//                                                       if (nextTripRouteid !=
//                                                           null) {
//                                                         try {
//                                                           await TripDetailsRepository()
//                                                               .updateTripRouteStatus(
//                                                                   nextTripRouteid,
//                                                                   'InTransit');
//                                                           ScaffoldMessenger.of(
//                                                                   context)
//                                                               .showSnackBar(
//                                                                   const SnackBar(
//                                                             content: Text(
//                                                                 'تم تحديث الحالة إلى InTransit'),
//                                                           ));
//                                                           Navigator.pop(
//                                                               context);
//                                                           _tripDetailsCubit
//                                                               .fetchTripDetails(
//                                                                   widget
//                                                                       .tripId);
//                                                           setState(() {
//                                                             _hasDeparted = true;
//                                                           });
//                                                         } on DioError catch (e) {
//                                                           // إذا حدث خطأ ولم يتم التعامل معه في الدالة، يمكنك عرض رسالة خطأ هنا
//                                                           ScaffoldMessenger.of(
//                                                                   context)
//                                                               .showSnackBar(
//                                                             const SnackBar(
//                                                                 content: Text(
//                                                                     'فشل تحديث الحالة')),
//                                                           );
//                                                         }
//                                                       } else {
//                                                         ScaffoldMessenger.of(
//                                                                 context)
//                                                             .showSnackBar(
//                                                                 const SnackBar(
//                                                           content: Text(
//                                                               'بيانات المحطة غير متوفرة'),
//                                                         ));
//                                                       }
//                                                     },
//                                                     lbl: 'إنطلق',
//                                                     height: 50,
//                                                     width: 400,
//                                                   ),
//                                                   const SizedBox(height: 10),
//                                                   const AppButton(
//                                                     onPressed: null,
//                                                     lbl: 'إلغاء',
//                                                     height: 50,
//                                                     width: 400,
//                                                     color: AppColors
//                                                         .secondaryColor,
//                                                     textColor:
//                                                         AppColors.primaryColor,
//                                                   ),
//                                                 ],
//                                               );
//                                             },
//                                           );
//                                         },
//                                         //   onPressed: () async {
//                                         //     final int? nextTripRouteid =
//                                         //         nextTripRoute['id'];
//                                         //     if (nextTripRouteid != null) {
//                                         //       try {
//                                         //         await TripDetailsRepository()
//                                         //             .updateTripRouteStatus(
//                                         //                 nextTripRouteid,
//                                         //                 'InTransit');
//                                         //         ScaffoldMessenger.of(context)
//                                         //             .showSnackBar(const SnackBar(
//                                         //           content: Text(
//                                         //               'تم تحديث الحالة إلى InTransit'),
//                                         //         ));
//                                         //         _tripDetailsCubit
//                                         //             .fetchTripDetails(
//                                         //                 widget.tripId);
//                                         //         setState(() {
//                                         //           _hasDeparted = true;
//                                         //         });
//                                         //       } catch (e) {
//                                         //         ScaffoldMessenger.of(context)
//                                         //             .showSnackBar(const SnackBar(
//                                         //           content:
//                                         //               Text('فشل تحديث الحالة'),
//                                         //         ));
//                                         //       }
//                                         //     } else {
//                                         //       ScaffoldMessenger.of(context)
//                                         //           .showSnackBar(const SnackBar(
//                                         //         content: Text(
//                                         //             'بيانات المحطة غير متوفرة'),
//                                         //       ));
//                                         //     }
//                                         //   },
//                                         lbl: 'غادرت المحطة',
//                                         color: Colors.green,
//                                       ),
//                                 const SizedBox(height: 20),
//                                 AppButton(
//                                   lbl: 'تأخرت الرحلة',
//                                   color: AppColors.btnColor,
//                                   onPressed: () {
//                                     // منطق تأخر الرحلة
//                                   },
//                                 ),
//                               ],
//                             ),
//                         ],
//                       ),
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

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/core/core_widgets/back_header.dart';
import 'package:uot_transport_driver_flutter/home_feature/model/repository/trip_details_repository.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/screens/main_screen.dart';
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
  // bool _hasDeparted = false;

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
              }
              if (state is TripDetailsFailure) {
                return Center(
                  child: Text('فشل جلب بيانات الرحلة: ${state.error}'),
                );
              }
              if (state is TripDetailsSuccess) {
                final data = state.tripDetails;
                final String tripState = data['tripState']?.toString() ?? '';
                final Map<String, dynamic> tripRoute = data['tripRoute'] ?? {};
                final Map<String, dynamic> nextTripRoute =
                    data['nextTripRoute'] ?? {};

                // Optional override first/last from ActiveTripsCubit
                Map<String, dynamic> firstTripRoute = tripRoute;
                Map<String, dynamic> lastTripRoute = {};
                final activeState = context.watch<ActiveTripsCubit>().state;
                if (activeState is ActiveTripsSuccess) {
                  final current = activeState.trips.firstWhere(
                    (t) => t['tripId'].toString() == widget.tripId.toString(),
                    orElse: () => {},
                  );
                  if (current.isNotEmpty) {
                    firstTripRoute = Map.from(current['firstTripRoute'] ?? {});
                    lastTripRoute = Map.from(current['lastTripRoute'] ?? {});
                  }
                }

                debugPrint('▶ tripState raw: "$tripRoute"');
                debugPrint(
                    '▶ tripState.toLower: "${tripState.trim().toLowerCase()}"');
                debugPrint(
                    '▶ tripRoute[\'state\']وسن: "${tripRoute['state']}"');
                debugPrint('▶ nextTripRoute id: ${nextTripRoute['id']}');

                return RefreshIndicator(
                  onRefresh: () async {
                    _tripDetailsCubit.fetchTripDetails(widget.tripId);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppText(
                            lbl: 'رقم الرحلة: ${widget.tripId}',
                            style: const TextStyle(
                              fontSize: 24,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Flexible(
                                child: AppText(
                                  lbl:
                                      '${firstTripRoute['stationName'] ?? 'غير متوفر'} \n${firstTripRoute['id'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              SvgPicture.asset(
                                'assets/icons/arrow-right-circle.svg',
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: AppText(
                                  lbl:
                                      '${lastTripRoute['stationName'] ?? 'غير متوفر'} \n${lastTripRoute['id'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          QRWidget(
                            tripId: widget.tripId.toString(),
                            tripRouteId: tripRoute['id']?.toString() ?? '',
                          ),
                          const SizedBox(height: 10),
                          AppText(
                            lbl:
                                'وصلت محطة ${tripRoute['stationName'] ?? ''} # ${tripRoute['id'] ?? ''}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xFF4A90E2),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),
                          AppText(
                            lbl:
                               'المحطة القادمة: ${nextTripRoute['stationName'] ?? ''} # ${nextTripRoute['id'] ?? ''}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xFF4A90E2),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),

                          AppText(
                            lbl: tripState.trim().toLowerCase() == 'completed'
                                ? 'وصلت محطة: ${tripRoute['stationName'] ?? ''} # ${tripRoute['id'] ?? ''}'
                                : (nextTripRoute['state'] == 'InTransit'
                                    ? 'المحطة القادمة: ${nextTripRoute['stationName'] ?? ''} # ${nextTripRoute['id'] ?? ''}'
                                    : 'وصلت محطة: ${tripRoute['stationName'] ?? ''} # ${tripRoute['id'] ?? ''}'),
                            style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          DepartureArrivalWidget(
                            tripRoute: tripRoute,
                            nextTripRoute: nextTripRoute,
                          ),
                          const SizedBox(height: 20),
                          GoogleMapWidget(
                            startLocation: tripRoute['location'] ?? '',
                            endLocation: nextTripRoute['location'] ?? '',
                          ),
                          const SizedBox(height: 20),
                          // AppText(
                          //   lbl:
                          //       'الحالية: ${tripRoute['state'].trim()} \n التالية ${nextTripRoute['state'].trim()!}',
                          //   style: const TextStyle(
                          //       fontSize: 20,
                          //       color: AppColors.primaryColor,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          const SizedBox(height: 10),
                          if (tripState.trim().toLowerCase() == 'completed')
                            AppButton(
                              lbl: 'انتهت الرحلة',
                              color: AppColors.secondaryColor,
                              textColor: AppColors.primaryColor,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MainScreen()),
                                );
                              },
                            )
                          else
                            buildActionButtons(nextTripRoute, tripRoute),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget buildActionButtons(
      Map<String, dynamic> nextTripRoute, Map<String, dynamic> tripRoute) {
    final rawState = nextTripRoute['state']?.toString() ?? '';
    final state = rawState.trim().toLowerCase();

    debugPrint('▶ nextTripRoute.state = $state');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state == 'intransit')
          AppButton(
            lbl: 'وصلت المحطة',
            color: AppColors.primaryColor,
            onPressed: () => _onReachedStation(nextTripRoute, tripRoute),
          )
        else if (state == 'notreached')
          AppButton(
            lbl: 'غادرت المحطة',
            color: Colors.green,
            onPressed: () => _onDepartStation(nextTripRoute),
          ),
        const SizedBox(height: 20),
        AppButton(
          lbl: 'تأخرت الرحلة',
          color: AppColors.btnColor,
          onPressed: () {
            _onDelayedStation(nextTripRoute);
          },
        ),
      ],
    );
  }

  void _onReachedStation(
      Map<String, dynamic> nextTripRoute, Map<String, dynamic> tripRoute) {
    final stationName = nextTripRoute['stationName'] ?? 'غير متوفر';
    final int? routeId = nextTripRoute['id'] as int?;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogCtx) {
        return TripsDialog(
          title: const AppText(
            lbl: 'هل وصلت محطة؟',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          content: AppText(
            lbl: 'سوف تقوم بتحديث حالة الرحلة ، الوصول لمحطة: $stationName.',
            style: const TextStyle(fontSize: 14, color: AppColors.textColor),
          ),
          actions: [
            AppButton(
              onPressed: () async {
                if (routeId != null) {
                  try {
                    await TripDetailsRepository()
                        .updateTripRouteStatus(routeId, 'Reached');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم التحديث إلى Reached')),
                    );
                    Navigator.pop(dialogCtx);
                    _tripDetailsCubit.fetchTripDetails(widget.tripId);
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('فشل التحديث')),
                    );
                  }
                }
              },
              lbl: 'وصلت',
              height: 50,
              width: 400,
            ),
            const SizedBox(height: 10),
            AppButton(
              onPressed: () => Navigator.pop(dialogCtx),
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
  }

  void _onDepartStation(Map<String, dynamic> nextTripRoute) {
    final stationName = nextTripRoute['stationName'] ?? 'غير متوفر';
    final int? routeId = nextTripRoute['id'] as int?;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogCtx) {
        return TripsDialog(
          title: const AppText(
            lbl: 'هل تريد اكمال الرحلة ؟',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          content: AppText(
            lbl:
                'سوف تقوم بمغادرة المحطة والإنطلاق للمحطة القادمة: $stationName',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textColor,
            ),
          ),
          actions: [
            AppButton(
              onPressed: () async {
                if (routeId != null) {
                  try {
                    await TripDetailsRepository()
                        .updateTripRouteStatus(routeId, 'InTransit');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تحديث إلى InTransit')),
                    );
                    Navigator.pop(dialogCtx);
                    _tripDetailsCubit.fetchTripDetails(widget.tripId);
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('فشل التحديث')),
                    );
                  }
                }
              },
              lbl: 'إنطلق',
              height: 50,
              width: 400,
            ),
            const SizedBox(height: 10),
            AppButton(
              onPressed: () => Navigator.pop(dialogCtx),
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
  }

  void _onDelayedStation(Map<String, dynamic> nextTripRoute) {
    final stationName = nextTripRoute['stationName'] ?? 'غير متوفر';
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogCtx) {
        return TripsDialog(
          title: const AppText(
            lbl: 'هل تأخرت ؟',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          content: AppText(
            lbl:
                'سوف تقوم بإضافة وقت لزمن الوصول للمحطة القادمة : $stationName',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textColor,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: AppButton(
                    icon: Icons.add,
                    onPressed: () {/* زيادة الوقت */},
                    height: 60,
                    width: 80,
                    textColor: AppColors.backgroundColor,
                  ),
                ),
                const SizedBox(width: 10),
                const AppText(
                  lbl: '00:دقيقة',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: AppButton(
                    icon: Icons.remove,
                    onPressed: () {/* نقصان الوقت */},
                    height: 60,
                    width: 80,
                    color: AppColors.secondaryColor,
                    textColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AppButton(
              onPressed: () {
                // تأكيد وإرسال الوقت المضاف
              },
              lbl: 'تأكيد',
              height: 50,
              width: 400,
            ),
            const SizedBox(height: 10),
            AppButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
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
  }
}
