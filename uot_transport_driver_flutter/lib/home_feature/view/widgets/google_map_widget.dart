// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class GoogleMapWidget extends StatefulWidget {
//   final String location;
//   const GoogleMapWidget({
//     super.key,
//     required this.location,
//   });

//   @override
//   _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
// }

// class _GoogleMapWidgetState extends State<GoogleMapWidget> {
//   late GoogleMapController mapController;

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   // دالة لتحليل الإحداثيات من قيمة الموقع المفردة
//   LatLng _parseLocation(String location) {
//     if (location.contains(',')) {
//       final parts = location.split(',');
//       if (parts.length >= 2) {
//         try {
//           double lat = double.parse(parts[0].trim());
//           double lng = double.parse(parts[1].trim());
//           return LatLng(lat, lng);
//         } catch (e) {
//           // في حال فشل التحليل، نعود بنقاط افتراضية
//         }
//       }
//     }
//     // في حال عدم توفر إحداثيات صالحة، يتم إرجاع (0,0)
//     return const LatLng(0.0, 0.0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final LatLng stationLatLng = _parseLocation(widget.location);
//     return Container(
//       height: 200, // يمكن تعديل الارتفاع حسب الحاجة
//       width: double.infinity,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.grey,
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: GoogleMap(
//           onMapCreated: _onMapCreated,
//           initialCameraPosition: CameraPosition(
//             target: stationLatLng,
//             zoom: 16.0,
//           ),
//           markers: {
//             Marker(
//               markerId: const MarkerId('station_location'),
//               position: stationLatLng,
//             ),
//           },
//           myLocationButtonEnabled: false,
//           zoomControlsEnabled: false,
//         ),
//       ),
//     );
//   }
// }


import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  final String startLocation;
  final String endLocation;

  const GoogleMapWidget({
    super.key,
    required this.startLocation,
    required this.endLocation,
  });

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController _controller;
  // قيم افتراضية لتجنّب LateInitializationError
  LatLng _p1 = const LatLng(0, 0);
  LatLng _p2 = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _p1 = _parseLocation(widget.startLocation);
    _p2 = _parseLocation(widget.endLocation);
  }

  @override
  void didUpdateWidget(covariant GoogleMapWidget old) {
    super.didUpdateWidget(old);
    if (old.startLocation != widget.startLocation ||
        old.endLocation   != widget.endLocation) {
      _p1 = _parseLocation(widget.startLocation);
      _p2 = _parseLocation(widget.endLocation);
      final bounds = LatLngBounds(
        southwest: LatLng(min(_p1.latitude, _p2.latitude), min(_p1.longitude, _p2.longitude)),
        northeast: LatLng(max(_p1.latitude, _p2.latitude), max(_p1.longitude, _p2.longitude)),
      );
      _controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    final bounds = LatLngBounds(
      southwest: LatLng(min(_p1.latitude, _p2.latitude), min(_p1.longitude, _p2.longitude)),
      northeast: LatLng(max(_p1.latitude, _p2.latitude), max(_p1.longitude, _p2.longitude)),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    });
  }

  LatLng _parseLocation(String loc) {
    // صيغة decimal degrees "lat, lng"
    if (loc.contains(',') && !loc.contains('°')) {
      final parts = loc.split(',');
      return LatLng(double.parse(parts[0].trim()), double.parse(parts[1].trim()));
    }
    // صيغة DMS "32°51'22.7"N 13°13'21.1"E"
    final regex = RegExp(r"""(\d+)°(\d+)'([\d.]+)"([NSEW])""");
    final matches = regex.allMatches(loc);
    if (matches.length == 2) {
      double toDec(Match m) {
        double d = double.parse(m[1]!);
        double mnt = double.parse(m[2]!);
        double s = double.parse(m[3]!);
        double val = d + mnt / 60 + s / 3600;
        return (m[4] == 'S' || m[4] == 'W') ? -val : val;
      }
      return LatLng(toDec(matches.elementAt(0)), toDec(matches.elementAt(1)));
    }
    return const LatLng(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: _p1, zoom: 20.0),
          minMaxZoomPreference: const MinMaxZoomPreference(10, 20),
          markers: {
            Marker(
              markerId: const MarkerId('start'),
              position: _p1,
              infoWindow: const InfoWindow(title: 'محطة 1'),
            ),
            Marker(
              markerId: const MarkerId('end'),
              position: _p2,
              infoWindow: const InfoWindow(title: 'محطة 2'),
            ),
          },
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),
      ),
    );
  }
}