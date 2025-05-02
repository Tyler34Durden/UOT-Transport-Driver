import 'package:flutter/material.dart';

class TripsDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget>? actions;
  final double? width;
  final double? height;

  // يمكن تخصيص إمكانية إغلاق الديالوق بالنقر خارجها
  final bool barrierDismissible;

  const TripsDialog({
    Key? key,
    required this.title,
    required this.content,
    this.actions,
    this.width,
    this.height,
    this.barrierDismissible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: title,
        content: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(8),
          child: content,
        ),
        actions: actions,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      ),
    );
  }
}