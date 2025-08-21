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
  final Function()? onPressed;
  final IconData? icon;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 157,
      height: height ?? 57,
      decoration: BoxDecoration(
        color: color ?? AppColors.primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(horizontal: 8), // Add horizontal padding
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Uncommented to constrain row width
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: textColor ?? AppColors.accentColor,
                size: 24, // Slightly smaller icon
              ),
              const SizedBox(width: 6), // Add spacing between icon and text
            ],
            Flexible(
              child: AppText(
                lbl: lbl,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? AppColors.backgroundColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center, // Center the text
              ),
            ),
          ],
        ),
      ),
    );
  }
}