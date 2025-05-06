// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class QRWidget extends StatelessWidget {
//   final String tripId;
//   // 
//   final String tripName; // تفاصيل إضافية مثل اسم الرحلة
//   final String instructions;
//   final Logger logger = Logger();

//    QRWidget({
//     super.key,
//     required this.tripId,
//     this.tripName = '',
//     this.instructions = 'يرجى من الطلاب مسح هذا الرمز عند الصعود.',
//   });

//   @override
//   Widget build(BuildContext context) {
//     // بناء البينات الخاصة بال QR. يمكنك تعديل البنية حسب الحاجة.
//     final qrData = 'tripid:$tripId';
//     logger.i('QRWidget: بناء QR data: $qrData');

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         if (tripName.isNotEmpty)
//           Text(
//             tripName,
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         const SizedBox(height: 10),
//         QrImageView(
//           data: qrData,
//           version: QrVersions.auto,
//           size: 180.0,
//           gapless: false,
//         ),
//         const SizedBox(height: 10),
//         Text(
//           instructions,
//           style: const TextStyle(fontSize: 14),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRWidget extends StatelessWidget {
  final String tripId;
  final String tripRouteId; // قيمة tripRouteid الجديدة
  final String tripName; // تفاصيل إضافية مثل اسم الرحلة
  // final String instructions;
  final Logger logger = Logger();

  QRWidget({
    super.key,
    required this.tripId,
    required this.tripRouteId,
    this.tripName = '',
    // this.instructions = 'يرجى من الطلاب مسح هذا الرمز عند الصعود.',
  });

  @override
  Widget build(BuildContext context) {
    // إضافة tripRouteId إلى بيانات الـ QR
    final qrData = 'tripid:$tripId, tripRouteid:$tripRouteId';
    logger.i('QRWidget: بناء QR data: $qrData');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (tripName.isNotEmpty)
          Text(
            tripName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 10),
        QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 180.0,
          gapless: false,
        ),
        const SizedBox(height: 10),
        // Text(
        //   instructions,
        //   style: const TextStyle(fontSize: 14),
        //   textAlign: TextAlign.center,
        // ),
      ],
    );
  }
}