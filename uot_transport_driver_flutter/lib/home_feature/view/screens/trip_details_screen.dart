import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
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
          // appBar: const BackHeader(),

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
                          const SizedBox(height: 30),
                          AppText(
                            lbl: 'رقم الرحلة : # ${widget.tripId}',
                            style: const TextStyle(
                              fontSize: 20,
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
                                  // overflow: TextOverflow.visible,
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
                            lbl: tripState.trim().toLowerCase() == 'completed'
                                ? 'وصلت محطة: ${tripRoute['stationName'] ?? ''} \n # ${tripRoute['id'] ?? ''}'
                                : (nextTripRoute['state'] == 'InTransit'
                                    ? 'المحطة القادمة: ${nextTripRoute['stationName'] ?? ''} \n # ${nextTripRoute['id'] ?? ''}'
                                    : 'وصلت محطة: ${tripRoute['stationName'] ?? ''} \n # ${tripRoute['id'] ?? ''}'),
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
                          const SizedBox(height: 10),
                          GoogleMapWidget(
                            startLocation: tripRoute['location'] ?? '',
                            endLocation: nextTripRoute['location'] ?? '',
                          ),
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
        const SizedBox(height: 10),
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

  // void _onReachedStation(
  //     Map<String, dynamic> nextTripRoute, Map<String, dynamic> tripRoute) {
  //   final stationName = nextTripRoute['stationName'] ?? 'غير متوفر';
  //   final int? routeId = nextTripRoute['id'] as int?;

  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext dialogCtx) {
  //       return TripsDialog(
  //         title: const AppText(
  //           lbl: 'هل وصلت محطة؟',
  //           style: TextStyle(
  //             fontSize: 24,
  //             fontWeight: FontWeight.bold,
  //             color: AppColors.primaryColor,
  //           ),
  //         ),
  //         content: AppText(
  //           lbl: 'سوف تقوم بتحديث حالة الرحلة ، الوصول لمحطة: $stationName.',
  //           style: const TextStyle(fontSize: 20, color: AppColors.textColor),
  //         ),
  //         actions: [
  //           AppButton(
  //             onPressed: () async {
  //               if (routeId != null) {
  //                 try {
  //                   await TripDetailsRepository()
  //                       .updateTripRouteStatus(routeId, 'Reached');
  //                   // ScaffoldMessenger.of(context).showSnackBar(
  //                   //   const SnackBar(content: Text('تم التحديث إلى Reached')),
  //                   // );
  //                   Navigator.pop(dialogCtx);
  //                   _tripDetailsCubit.fetchTripDetails(widget.tripId);

  //                 } catch (_) {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(content: Text('فشل التحديث')),
  //                   );
  //                 }
  //               }
  //             },
  //             lbl: 'وصلت',
  //             height: 50,
  //             width: 400,
  //           ),
  //           const SizedBox(height: 10),
  //           AppButton(
  //             onPressed: () => Navigator.pop(dialogCtx),
  //             lbl: 'إلغاء',
  //             height: 50,
  //             width: 400,
  //             color: AppColors.secondaryColor,
  //             textColor: AppColors.primaryColor,
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _onReachedStation(
    Map<String, dynamic> nextTripRoute,
    Map<String, dynamic> tripRoute,
  ) {
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
            style: const TextStyle(fontSize: 20, color: AppColors.textColor),
          ),
          actions: [
            AppButton(
              onPressed: () async {
                if (routeId != null) {
                  try {
                    await TripDetailsRepository()
                        .updateTripRouteStatus(routeId, 'Reached');

                    // اغلاق الديالوج الحالي
                    Navigator.pop(dialogCtx);

                    // إعادة جلب البيانات
                    _tripDetailsCubit.fetchTripDetails(widget.tripId);

                    // عرض ديالوج النجاح
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext successCtx) {
                        return TripsDialog(
                          title: SvgPicture.asset("assets/icons/check.svg"),
                          content: const AppText(
                            textAlign: TextAlign.center,
                            lbl: 'تم تحديث الحالة إلى Reached بنجاح.',
                            style: TextStyle(
                                fontSize: 20, color: AppColors.textColor),
                          ),
                        );
                      },
                    );

                    // انتظر ثانيتين ثم اغلق ديالوج النجاح
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.pop(context);
                  } catch (_) {
                    // في حالة الخطأ نعيد عرض رسالة بسيطة
                    showDialog(
                      context: context,
                      builder: (_) => TripsDialog(
                        title: Icon(
                          Icons.error,
                          color: AppColors.btnColor,
                        ),
                        content: const AppText(
                          textAlign: TextAlign.center,
                          lbl: 'فشل تحديث الحالة.',
                          style: TextStyle(
                              fontSize: 16, color: AppColors.textColor),
                        ),
                        actions: [
                          AppButton(
                            onPressed: () => Navigator.pop(context),
                            lbl: 'حسناً',
                            height: 50,
                            width: 200,
                          )
                        ],
                      ),
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

  // void _onDepartStation(Map<String, dynamic> nextTripRoute) {
  //   final stationName = nextTripRoute['stationName'] ?? 'غير متوفر';
  //   final int? routeId = nextTripRoute['id'] as int?;

  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext dialogCtx) {
  //       return TripsDialog(
  //         title: const AppText(
  //           lbl: 'هل تريد اكمال الرحلة ؟',
  //           style: TextStyle(
  //             fontSize: 24,
  //             fontWeight: FontWeight.bold,
  //             color: AppColors.primaryColor,
  //           ),
  //         ),
  //         content: AppText(
  //           lbl:
  //               'سوف تقوم بمغادرة المحطة والإنطلاق للمحطة القادمة: $stationName',
  //           style: const TextStyle(
  //             fontSize: 20,
  //             color: AppColors.textColor,
  //           ),
  //         ),
  //         actions: [
  //           AppButton(
  //             onPressed: () async {
  //               if (routeId != null) {
  //                 try {
  //                   await TripDetailsRepository()
  //                       .updateTripRouteStatus(routeId, 'InTransit');
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(content: Text('تم تحديث إلى InTransit')),
  //                   );
  //                   Navigator.pop(dialogCtx);
  //                   _tripDetailsCubit.fetchTripDetails(widget.tripId);
  //                 } catch (_) {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(content: Text('فشل التحديث')),
  //                   );
  //                 }
  //               }
  //             },
  //             lbl: 'إنطلق',
  //             height: 50,
  //             width: 400,
  //           ),
  //           const SizedBox(height: 10),
  //           AppButton(
  //             onPressed: () => Navigator.pop(dialogCtx),
  //             lbl: 'إلغاء',
  //             height: 50,
  //             width: 400,
  //             color: AppColors.secondaryColor,
  //             textColor: AppColors.primaryColor,
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
            style: const TextStyle(fontSize: 20, color: AppColors.textColor),
          ),
          actions: [
            AppButton(
              lbl: 'إنطلق',
              height: 50,
              width: 400,
              onPressed: () async {
                if (routeId != null) {
                  try {
                    await TripDetailsRepository()
                        .updateTripRouteStatus(routeId, 'InTransit');
                    // اغلاق حوار التأكيد
                    Navigator.pop(dialogCtx);
                    // تحديث البيانات
                    _tripDetailsCubit.fetchTripDetails(widget.tripId);
                    // عرض حوار النجاح
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext successCtx) {
                        return TripsDialog(
                          title: SvgPicture.asset("assets/icons/check.svg"),
                          content: const AppText(
                            textAlign: TextAlign.center,
                            lbl: 'تم تحديث الحالة إلى InTransit بنجاح.',
                            style: TextStyle(
                                fontSize: 20, color: AppColors.textColor),
                          ),
                        );
                      },
                    );
                    // إغلاق حوار النجاح بعد ثانيتين
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.pop(context);
                  } catch (_) {
                    // عرض حوار الخطأ
                    showDialog(
                      context: context,
                      builder: (_) => TripsDialog(
                        title: Icon(
                          Icons.error,
                          color: AppColors.btnColor,
                        ),
                        content: const AppText(
                          textAlign: TextAlign.center,
                          lbl: 'فشل تحديث الحالة.',
                          style: TextStyle(
                              fontSize: 16, color: AppColors.textColor),
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
              },
            ),
            const SizedBox(height: 10),
            AppButton(
              lbl: 'إلغاء',
              height: 50,
              width: 400,
              color: AppColors.secondaryColor,
              textColor: AppColors.primaryColor,
              onPressed: () => Navigator.pop(dialogCtx),
            ),
          ],
        );
      },
    );
  }

  // void _onDelayedStation(Map<String, dynamic> nextTripRoute) {
  //   final stationName = nextTripRoute['stationName'] ?? 'غير متوفر';
  //   final int? routeId = nextTripRoute['id'] as int?;
  //   if (routeId == null) return;

  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (ctx) {
  //       int delay = 0;
  //       return StatefulBuilder(
  //         builder: (ctx2, setState) {
  //           return TripsDialog(
  //             title: const AppText(
  //               lbl: 'هل تأخرت ؟',
  //               style: TextStyle(
  //                 fontSize: 24,
  //                 fontWeight: FontWeight.bold,
  //                 color: AppColors.primaryColor,
  //               ),
  //             ),
  //             content: AppText(
  //               lbl: 'أدخل دقائق التأخير للمحطة القادمة: $stationName',
  //               style:
  //                   const TextStyle(fontSize: 20, color: AppColors.textColor),
  //             ),
  //             actions: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   AppButton(
  //                     icon: Icons.add,
  //                     onPressed: () => setState(() => delay++),
  //                     height: 60,
  //                     width: 80,
  //                     textColor: AppColors.backgroundColor,
  //                   ),
  //                   const SizedBox(width: 10),
  //                   AppText(
  //                     lbl: '$delay دقيقة',
  //                     style: const TextStyle(
  //                         fontSize: 24, fontWeight: FontWeight.bold),
  //                   ),
  //                   const SizedBox(width: 10),
  //                   AppButton(
  //                     icon: Icons.remove,
  //                     onPressed: () => setState(() {
  //                       if (delay > 0) delay--;
  //                     }),
  //                     height: 60,
  //                     width: 80,
  //                     color: AppColors.secondaryColor,
  //                     textColor: AppColors.primaryColor,
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 10),
  //               AppButton(
  //                 lbl: 'تأكيد',
  //                 onPressed: () async {
  //                   try {
  //                     await TripDetailsRepository().addDelay(routeId, delay);
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(content: Text('تم إضافة تأخير $delay د')),
  //                     );
  //                     Navigator.pop(ctx2);
  //                     _tripDetailsCubit.fetchTripDetails(widget.tripId);
  //                   } catch (_) {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(content: Text('فشل إضافة التأخير')),
  //                     );
  //                   }
  //                 },
  //                 height: 50,
  //                 width: 400,
  //               ),
  //               const SizedBox(height: 10),
  //               AppButton(
  //                 lbl: 'إلغاء',
  //                 onPressed: () => Navigator.pop(ctx2),
  //                 height: 50,
  //                 width: 400,
  //                 color: AppColors.secondaryColor,
  //                 textColor: AppColors.primaryColor,
  //               ),
  //             ],
  //           );

  void _onDelayedStation(Map<String, dynamic> nextTripRoute) {
    final stationName = nextTripRoute['stationName'] ?? 'غير متوفر';
    final int? routeId = nextTripRoute['id'] as int?;
    if (routeId == null) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogCtx) {
        int delay = 0;
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setState) {
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
                lbl: 'أدخل دقائق التأخير للمحطة القادمة: $stationName',
                style:
                    const TextStyle(fontSize: 20, color: AppColors.textColor),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                      icon: Icons.add,
                      onPressed: () => setState(() => delay++),
                      height: 60,
                      width: 80,
                      textColor: AppColors.backgroundColor,
                    ),
                    const SizedBox(width: 10),
                    AppText(
                      lbl: '$delay دقيقة',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    AppButton(
                      icon: Icons.remove,
                      onPressed: () => setState(() {
                        if (delay > 0) delay--;
                      }),
                      height: 60,
                      width: 80,
                      color: AppColors.secondaryColor,
                      textColor: AppColors.primaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                AppButton(
                  lbl: 'تأكيد',
                  height: 50,
                  width: 400,
                  onPressed: () async {
                    try {
                      await TripDetailsRepository().addDelay(routeId, delay);
                      Navigator.pop(dialogCtx);
                      _tripDetailsCubit.fetchTripDetails(widget.tripId);

                      // عرض حوار النجاح
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => TripsDialog(
                          title: SvgPicture.asset("assets/icons/check.svg"),
                          content: AppText(
                            textAlign: TextAlign.center,
                            lbl: 'تم إضافة تأخير $delay دقيقة بنجاح.',
                            style: const TextStyle(
                                fontSize: 18, color: AppColors.textColor),
                          ),
                        ),
                      );
                      await Future.delayed(const Duration(seconds: 2));
                      Navigator.pop(context);
                    } catch (_) {
                      Navigator.pop(dialogCtx);
                      // عرض حوار الخطأ
                      showDialog(
                        context: context,
                        builder: (_) => TripsDialog(
                          title: Icon(
                            Icons.error,
                            color: AppColors.btnColor,
                          ),
                          content: const AppText(
                            textAlign: TextAlign.center,
                            lbl: 'فشل إضافة التأخير.',
                            style: TextStyle(
                                fontSize: 16, color: AppColors.textColor),
                          ),
                          actions: [
                            AppButton(
                              lbl: 'حسناً',
                              height: 50,
                              width: 200,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                AppButton(
                  lbl: 'إلغاء',
                  height: 50,
                  width: 400,
                  color: AppColors.secondaryColor,
                  textColor: AppColors.primaryColor,
                  onPressed: () => Navigator.pop(dialogCtx),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
