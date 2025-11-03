import 'package:flutter/material.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    this.lbl,
    required this.onPressed,
    this.height,
    this.width,
    this.icon,
    this.color,
    this.textColor,
    super.key,
  });

  final double? width;
  final double? height;
  final String? lbl;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.primaryColor;
    final fg = textColor ?? AppColors.backgroundColor;

    return SizedBox(
      width: width ?? 157,
      height: height ?? 57,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: fg, size: 24),
            if (icon != null) const SizedBox(width: 6),
            Flexible(
              child: AppText(
                lbl: lbl ?? '',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: fg,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}