import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';

class QRWidget extends StatelessWidget {
  final String tripId;
  final String tripRouteId;
  final Logger logger = Logger();

  QRWidget({
    super.key,
    required this.tripId,
    required this.tripRouteId,
  });

  @override
  Widget build(BuildContext context) {
    final qrData = 'tripId:$tripId, tripRouteId:$tripRouteId';
    logger.i('QRWidget: بناء QR data: $qrData');

    return Center(
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 180.0,
          gapless: false,
        ),
      ),
    );
  }
}